#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

print  "Content-Type: text/html\n\n";

use DBI();
use Connect;
use LWP 5.64;
use MIME::Base64;
use constant VM_BACKUP_DIRECTORY => /backup/ ;
#database login details
use constant HOSTNAME => localhost ;
use constant USERNAME => root ;
use constant PASS_WORD => sahilb ;
use constant DATABASE_NAME => vmcomplete_sadmin ;
#site url or name
use constant SITEURL => "http://localhost" ;
# to invoke http request of php page which will update the database
my $browser = LWP::UserAgent->new;

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=".DATABASE_NAME.";host=".HOSTNAME, USERNAME, PASS_WORD,{'RaiseError' => 1});

#while (true){

# Now retrieve synchronous (job_type=0) jobs from table
my $jth = $dbh->prepare("SELECT * 
						 FROM job_queue j, command_master c
						 WHERE (job_server_type = 'Xen' AND j.job_status = 'PENDING' OR (j.job_status = 'PROCESSING' AND c.cmd_type = 'LONG'))
 						 AND c.cmd_id = j.job_cmd_id
						 ORDER BY job_id");			

$jth->execute();

#my $ssh_array = ();

while(my $ref = $jth->fetchrow_hashref()){
	
	if($ref->{'job_status'} ne 'PROCESSING') {							
		update_status('PROCESSING', $ref->{'job_id'}, '','','',$dbh);										
		if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {									
			$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=PROCESSING&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");		
		}							
	} 

	# Set job status as processing
	# Fetch server details from server master for corresponding job_server_id
	my $job_id = $ref->{'job_id'};
	my $sth = $dbh->prepare("SELECT *
							 FROM server_master
							 WHERE server_id = $ref->{'job_server_id'}");
	
	$sth->execute();			
	my $ref1 = $sth->fetchrow_hashref();			
	my $server_id = $ref1->{'server_id'};
	$host = $ref1->{'server_ip'};
	$pwd = $ref1->{'server_root_password'};
	$ssh = $ref1->{'server_ssh'};
	
	# check whether the job is for vm or server
	if($ref->{'system_flag'} ne 0) {
		my $vth = $dbh->prepare("SELECT *
								 FROM vm_master v, ips_master i
								 WHERE i.ips_id = v.vm_ip_id
								 AND vm_id = $ref->{'job_vm_id'}");
								 
		$vth->execute();
		my $vref1 = $vth->fetchrow_hashref();	
		$host = $vref1->{'ips_ip'};
		$pwd = $vref1->{'vm_password'};
		$ssh = $ref1->{'server_ssh'};
	}
	
	#print $host."\n";
	#print	$pwd."\n";
	#print	$ssh."\n";
		
	my $conn = Connect->new();	
	my $ssh_array = $conn->con($host, $pwd, $ssh );
	my $login_output = $ssh_array->login();
	if (rindex($login_output, "denied") >= 0) {
		update_status('ERROR', $ref->{'job_id'},"Login Failed", "Login Failed", 1,$dbh);
	} else {		
		# to avoid the command you sent in your next read operation.
		$ssh_array->exec("stty -echo");
		my $stdout;	
		# Query for Get the vm details.				
		my $jth = $dbh->prepare("SELECT *
								 FROM vm_master
								 WHERE vm_id  = $ref->{'job_vm_id'}");																		 
		$jth->execute();
		my $ref2 = $jth->fetchrow_hashref();
		my $vm_name = $ref2->{'vm_name'};
		my $vm_display_name = $ref2->{'vm_display_name'};
		my $vm_config_file = $ref2->{'vm_config_file'};		
		my $vm_status = $ref2->{'vm_status'};
		my $vm_type = $ref2->{'vm_type'};
		my $vm_template = $ref2->{'vm_template'};	
		my $vmspace = $ref2->{'vm_HDD'};			
		my $spacevalue = substr($vmspace, 0, - 2);			
		#get the os template for creating the vm.
		my $vtempl = $dbh->prepare("SELECT ostemp_name
								    FROM ostemplate_master
								    WHERE ostemp_status = 'ENABLED' AND ostemp_id = '$vm_template'");
																	 
		$vtempl->execute();
		my $vte = $vtempl->fetchrow_hashref();
		my $ostemp_name = $vte->{'ostemp_name'};
		print $ref->{'job_command'};
		
		if (rindex($ref->{'job_command'}, "scp") >= 0) {		
			if($ref->{'job_cmd_id'} eq 107) {		
				$stdout = $ssh_array->exec($ref->{'job_command'});	
				update_status('COMPLETED', $ref->{'job_id'},$stdout, '', $exit, $dbh);
			} else {		 	
				@servers = split("@", $ref->{'job_command'});
				@newServer = split(":", @servers[1]);			
				my $hostName = trim(@newServer[0]);									
				my $sqlPassword = $dbh->prepare("SELECT server_root_password  
												 FROM server_master 
												 WHERE server_hostname = '$hostName' ");												 
				$sqlPassword->execute();
				my $serverPassword = $sqlPassword->fetchrow_hashref();							
				my $spassword = encode_base64($serverPassword->{'server_root_password'});																			
				my $scriptcmd2 = "cd /var/www/cgi-bin/; perl copyPublicKey.pl $hostName $spassword";				
				$stdout = $ssh_array->exec($scriptcmd2);	
				update_status('COMPLETED', $ref->{'job_id'},$stdout, '', 0, $dbh);		
			}	
		}					
		elsif (rindex($ref->{'job_command'}, "passwd") >= 0 and $ref->{'job_cmd_id'} eq 67) {		
			# Reset password of Xen VM
			@newpass = split(" ", $ref->{'job_command'});
			my $command = @newpass[0];
			my $newPassword = trim(@newpass[1]);
			$stdout = $ssh_array->exec($command);			
			my $displayOutput = trim($stdout);
			if (rindex($displayOutput, 'Enter new UNIX password:') >= 0) {			
			    my $stdout2 = $ssh_array->exec($newPassword);			   
			    if(rindex($stdout2, "Retype new UNIX password:") >= 0) {
				   my $stdout3 = $ssh_array->exec($newPassword);
				   if(rindex($stdout3, "passwd: password updated successfully") >= 0) {					  				
					  update_status('COMPLETED', $ref->{'job_id'}, $stdout3, $exit, '', $dbh);
					  $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}&newPassword=$newPassword");
				   } else {
					  update_status('ERROR', $ref->{'job_id'}, $stdout3, $exit, '', $dbh);	
				   } 
			   }  else {
				  update_status('ERROR', $ref->{'job_id'}, $stdout2, $exit, '', $dbh);
			   }
			} else {
			  update_status('ERROR', $ref->{'job_id'}, $stdout, $exit, '', $dbh);	 
			}
		}
		elsif (rindex($ref->{'job_command'}, "service iptables save") >= 0) {
			# block or unblock the ip and update its corresponding staus either blocked or Available.
			$stdout = $ssh_array->exec($ref->{'job_command'}); 
			if (rindex($stdout, $ref->{'job_expected_out'}) >= 0) {
				# if yes update the job status
				update_status('COMPLETED', $ref->{'job_id'},$stdout, '', $exit, $dbh);
				$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
			} else {	
				update_status('ERROR', $ref->{'job_id'},$stdout, '', $exit, $dbh);
			}
			if ($ref->{'job_vm_id'} > 0) {
				# here $ref->{'job_vm_id'} used as ip_block_id to manipullate the record from ip_block table.				
				my $sqlBlockIp = $dbh->prepare("SELECT ip_block_ip_id, ip_block_ip_status  
												FROM ip_block
												WHERE ip_block_id = $ref->{'job_vm_id'} ");	
				$sqlBlockIp->execute();
				my $blockdata = $sqlBlockIp->fetchrow_hashref();
				my $ip_block_ip_id = $blockdata->{'ip_block_ip_id'};				
				my $ip_block_ip_status = $blockdata->{'ip_block_ip_status'};						
				if($ip_block_ip_id > 0) {
				   if($ip_block_ip_status eq 'blocked') {				   
					  my $sqlUpdateStatus = $dbh->prepare("UPDATE ips_master
															SET ips_status = 'blocked'
															WHERE ips_id = $ip_block_ip_id");										
					  $sqlUpdateStatus->execute();					
				   } else {				   
					  my $sqlUpdateStatus = $dbh->prepare("UPDATE ips_master
															SET ips_status = 'Available'
															WHERE ips_id = $ip_block_ip_id");										
					  $sqlUpdateStatus->execute();	
				   }   
				}	
			}						
		}													
		elsif (rindex($ref->{'job_command'}, "xm migrate") >= 0)	{
		    # Check the Xen VM is migrated or not and update the status of corresponding job and VM.			
			
			#First check vm is exist or not.
			my $vm_exist = "xm list ".$vm_display_name;			
			my $out1 = $ssh_array->exec($vm_exist); 						
			my $mig_vm = "xm list";						
			my $migrt = $ssh_array->exec($mig_vm);				
			if(rindex($out1, "Error: Domain "."'$vm_display_name'"." does not exist.")  >= 0) {		
			print "Not yet migrated";							
			   if(rindex($migrt, "migrating-"."$vm_display_name") <= 0) {					
				  update_status('COMPLETED', $ref->{'job_id'},'', '', '', $dbh);				  
				  # invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				  if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
						print SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}";				
						$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
					}
				}								
			} else {
				@servers = split(" ", $ref->{'job_command'});							
				my $hostName = trim(@servers[4]);									
				print "===>".$hostName;
				my $sqlPassword = $dbh->prepare("SELECT server_root_password  
												 FROM server_master 
												 WHERE server_hostname = '$hostName'");	
				print "SELECT server_root_password  
						FROM server_master 
						WHERE server_hostname = '$hostName'";								 											 
				$sqlPassword->execute();
				my $serverPassword = $sqlPassword->fetchrow_hashref();							
				my $spassword = encode_base64($serverPassword->{'server_root_password'});																		
				my $scriptcmd2 = "cd /var/www/cgi-bin/; perl copyConfigFile.pl $hostName $vm_config_file $spassword";				
				$stdout = $ssh_array->exec($scriptcmd2);
				print $stdout."\n";					
			  	print "Started Migration"."\n";	
			 	$stdout = $ssh_array->exec($ref->{'job_command'});			  
			 	print $stdout;			  	
			  
			}		
		}
		elsif (rindex($ref->{'job_command'}, "xm save") >= 0) {			 	
		    # Check the backup of Xen VM is completed or not and update the status of corresponding job and VM.		    	
			$stdout = $ssh_array->exec($ref->{'job_command'});					
			  if(rindex($stdout, "Error") >= 0) { 
				 update_status('ERROR', $ref->{'job_id'}, $stdout, '', '', $dbh);	
			  } else {
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, '', '', $dbh);					
				if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {				   				
				  $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
				}
				#get the filename
				my $sth5 = $dbh->prepare("SELECT backup_filename
						                  FROM  vm_backup
						                  WHERE backup_job_id = $job_id");			
				$sth5->execute();			
				my $ref5 = $sth5->fetchrow_hashref();			
				my $backup_filename = $ref5->{'backup_filename'};				
				my $file = "/backup/".$backup_filename;
				my $command = "du -sh"." ".$file;												
				my $stdsize2;
				$stdsize2 = $ssh_array->exec($command);									
				@vmsize = split(" ", $stdsize2);
				my $vsize = @vmsize[0];											
				my $pth2 = $dbh->prepare("UPDATE vm_backup
										 SET backup_size = '$vsize',
										 backup_status = 'COMPLETED'
										 WHERE backup_job_id = $job_id");										 
				$pth2->execute();
				my $createVm = "xm create /etc/xen/$vm_config_file";				
				my $outCreateVm = $ssh_array->exec($createVm);				
			    if (rindex($outCreateVm, "Started domain $vm_display_name") >= 0) {					
				    my $pth5 = $dbh->prepare("UPDATE vm_master
											SET vm_status = 'Running'
											WHERE vm_id = $ref->{'job_vm_id'}");
				    $pth5->execute();			   
				}  
				
			}		
		}
		elsif (rindex($ref->{'job_command'}, "xm create") >= 0) {	
			#Create the vm for boot action.		
			$stdout = $ssh_array->exec($ref->{'job_command'});				
			if(rindex($stdout, "Started domain $vm_display_name") >= 0 )	{
			   update_status('COMPLETED', $ref->{'job_id'}, $comd, '', '', $dbh); 
			   if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
				   print SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}";				
				  $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
			   }			   							   	
			}  else {
			   update_status('ERROR', $ref->{'job_id'}, $comd, '', '', $dbh);
			}	
		}
		elsif (rindex($ref->{'job_command'}, "xm restore") >= 0) {
			# Check the Xen VM is properly restored and in running mode and update the status of corresponding job and VM.				
			my $vm_shutdown;
			my $vlist = "xm list";
			my $comd = "xm shutdown $vm_display_name";	
			$vm_shutdown = $ssh_array->exec($comd);					
			my $chk_vm = "xm list $vm_display_name";
			my $vmlist = $ssh_array->exec($chk_vm);													
			if(rindex($vmlist, "Error: Domain "."'$vm_display_name'"." does not exist.")  >= 0 or rindex($vmlist, "Error: Usage: xm list [options] [Domain, ...]Domain "."'$vm_display_name'"." does not exist.")  >= 0 ) {												
			   $stdout = $ssh_array->exec($ref->{'job_command'});
			   update_status('COMPLETED', $ref->{'job_id'},$stdout, '', 0, $dbh);
			   my $pth3 = $dbh->prepare("UPDATE vm_restore
										 SET restore_status = 'COMPLETED'
										 WHERE restore_job_id = $job_id");
			   $pth3->execute();							
			   if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
				  print SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}";				
				  $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
				}					 					 									
			} 	
		}
		elsif (rindex($ref->{'job_command'}, "-fnL") >= 0 or rindex($ref->{'job_command'}, "-nL") >= 0) {
			# Update the Xen VM disk quota.							
			#command for getting the logical volume group name.									
			#my $lvgoup = "awk '/dev?/' /etc/xen/".$ostemp_name." | awk -F: '{print \$2}'| awk -F, '{print \$1}' ;";
			my $lvgoup = "awk '/dev?/' /etc/xen/".$vm_config_file." | awk -F: '{print \$2}'| awk -F, '{print \$1}' ;";																
			my $goupname = $ssh_array->exec($lvgoup);					
			my $gname = trim($goupname);			
			#for extending/reducing the diskspace.
			my $finalcmd = $ref->{'job_command'}." ".$gname;									
			$stdout = $ssh_array->exec($finalcmd);		
			my $fsck = "e2fsck -fy ".$gname;
			my $fsckOutput = $ssh_array->exec($fsck);			
			#Cmd to Resizing the VM file system.
			my $resize = "resize2fs ".$gname;			
			my $resizeOutput = $ssh_array->exec($resize);				
			#Create the VM using config file.
			my $createVm = "xm create /etc/xen/".$vm_config_file;												
			$ssh_array->exec($createVm);
			if (rindex($stdout, $ref->{'job_expected_out'}) >= 0) {						
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, '', $exit, $dbh);
				if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {									  			
					$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
				 }
			} else {			
					update_status('ERROR', $ref->{'job_id'}, $stdout, '', $exit, $dbh);
					if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {					  			
						$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=ERROR&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
					 }						
			}
				
		}		
		elsif (rindex($ref->{'job_command'}, "--compress") < 0) {
			# Back up of of the Xen VM.			
			# If not a backup.			
			$stdout = $ssh_array->exec($ref->{'job_command'});			
			if (rindex($stdout, $ref->{'job_expected_out'}) >= 0) {
				# Add a check for null output
				if ($ref->{'job_expected_out'} eq '' and $stdout ne '') {
					# update error
					update_status('ERROR', $ref->{'job_id'},'', $stdout, 0,$dbh);
					# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
					if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
					   $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=ERROR&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
					 }
				 } else {
				   # if yes update the job status
				   update_status('COMPLETED', $ref->{'job_id'},$stdout, '', 0, $dbh);
				   # invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'						
				   if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
					  print SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}";				
					  $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
					}
				 }
			} else {
			  # update error
			  update_status('ERROR', $ref->{'job_id'},'', $stdout, 0,$dbh);
			  # invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
			  if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {
				 $response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=ERROR&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
			   }
			}	
		}
		else {
			# Check the other generalised commands.			
			$ssh_array->send($ref->{'job_command'});   # using send() instead of exec()
			#my $line;
			# returns the next line, removing it from the input stream:
			$stdout = $ssh_array->read_all();			
			my $wait = 0;
			# output of backup command was mixing up with next command so used waitfor
			#while($wait <= 0 ) {
				#$wait = $ssh_array->waitfor('Creating archive', 10); 
			#}
			# if command o/p stored in db matches with command execution o/p
			
			if (rindex($stdout, $ref->{'job_expected_out'}) >= 0) {
				
				# if yes update the job status
				update_status('COMPLETED', $ref->{'job_id'},$stdout, '', $exit, $dbh);	
				# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {										
						$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
					}			
				# check for vps backup and restore commands.
				# backup command - update file size into database
				if (rindex($ref->{'job_command'}, "--compress") >= 0) {
					@words = split(/ /, $ref->{'job_command'});
					my $vmid = pop(@words); 
					# filename "vzdump-"vmid.tgz
					#$file = "/home/backup/vzdump-".$vmid.".tgz";
					$file = VM_BACKUP_DIRECTORY."vzdump-".$vmid.".tgz";
					$command = "ls -lah $file | awk '{ print \$5}'";
					
					$stdsize = $ssh_array->exec($command);
					#my($stdout, $stderr, $exit)  = @out;
					my $pth = $dbh->prepare("UPDATE vm_backup
											 SET backup_size = '$stdsize',
											 backup_status = 'COMPLETED'
											 WHERE backup_job_id = $job_id");
					$pth->execute();
					
			   } 
			}  else {
			   # update error
			   update_status('ERROR', $ref->{'job_id'},$stdout, $stdout, $exit,$dbh);
			   if (rindex($ref->{'job_command'}, "--compress") >= 0) {
			 	   my $pth = $dbh->prepare("UPDATE vm_backup
								 			SET backup_size = '$stdsize',
											backup_status = 'ERROR'
											WHERE backup_job_id = $job_id");
				   $pth->execute();						 
				}
			}
		}
	}
	$ssh_array->close();
	exit 0;
}
#sleep 3;
#}
$dbh->disconnect;
sub update_status {
	my $status = shift;
	my $job_id = shift;
	my $stdout = shift;
	my $stderr = shift;
	my $stdexit = shift;
	my $dbh = shift;	
	my $curr_time = current_time();
	$stdout = $dbh->quote($stdout);
	$stderr = $dbh->quote($stderr);
	my $pth = $dbh->prepare("UPDATE job_queue
							 SET job_status = '$status',
							 job_completed_date = now(),
							 job_out = ".$stdout.",
							 job_error = ".$stderr."							 
							 WHERE job_id = $job_id");							 
	$pth->execute();	
}
sub current_time {
	@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	$year = 1900 + $yearOffset;
	$theTime = "$year-$months[$month]-$dayOfMonth $hour:$minute:$second";
	return $theTime; 
}
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
