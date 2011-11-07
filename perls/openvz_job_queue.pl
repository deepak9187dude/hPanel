#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

print  "Content-Type: text/html\n\n";

use DBI();
use Connect;
use LWP 5.64;
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
						 WHERE (job_server_type = 'openVZ' AND j.job_status = 'PENDING' OR (j.job_status = 'PROCESSING' AND c.cmd_type = 'LONG'))
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
		if (rindex($ref->{'job_command'}, "vzctl create") >= 0) {					
			# Check the OpenVZ VPS is created or not and update the status of corresponding job and VPS.			
			$stdout = $ssh_array->exec($ref->{'job_command'});			
			$stdoutVpslist = $ssh_array->exec("vzlist -a");									
			#command check status of vps on server.
			my $vps_status = "vzlist -a| grep ".$vm_name." | awk \'{print \$3}\'";						
			my $vps_output = $ssh_array->exec($vps_status);				
			my $finalstatus = trim($vps_output);																														
			if (rindex($finalstatus, "running") >= 0 ) {									
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);	
				if(rindex($ref->{'cmd_call_update'}, "YES") >= 0) {									
					$response = $browser->get(SITEURL."/admin/process_action.php?job_id=$ref->{'job_id'}&job_status=COMPLETED&job_server_id=$ref->{'job_server_id'}&job_vm_id=$ref->{'job_vm_id'}&job_comm=$ref->{'job_command'}&job_descr=$ref->{'job_descr'}");
				}										    
			} else {
				update_status('ERROR', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
			}		
		}	
		elsif (rindex($ref->{'job_command'}, "vzlist -a| grep") >= 0) {	
			#check the status of Migrated OpenVZ VPS and make the corresponding changes in the database schema i.e. either running or stop.
			$stdout = $ssh_array->exec($ref->{'job_command'});
			my $vpsStatus = trim($stdout);																					
			if (rindex($vpsStatus, "stopped") >= 0) {						
			    #start vps forcefully.										    
				my $startVps = "vzctl start $vm_name";	
				my $vpsStatus2 = $ssh_array->exec($startVps);														
				my $stdoutVpsStatus = $ssh_array->exec($ref->{'job_command'});
				if (rindex($stdoutVpsStatus, "running") >= 0) {										
					update_status('COMPLETED', $ref->{'job_id'},$stdout, $stdout, $exit,$dbh);	
					#update the vm status				
					my $pth6 = $dbh->prepare("UPDATE vm_master
										  	  SET vm_status = 'Running',
										  	  vm_server_id  = ".$ref->{'job_server_id'}."
										  	  WHERE vm_id = $ref->{'job_vm_id'}");
					$pth6->execute();
				}
			}
		}						
		elsif (rindex($ref->{'job_command'}, "--hostname") >= 0 and ($vm_type ne 'ENABLED' or  $vm_type ne 'DISABLED' or  $vm_type ne 'DELETED' or  $vm_type ne 'REBUILD' or $vm_type ne 'On Hold')) {
			# To set the OpenVZ VPS Host Name.
			$stdout = $ssh_array->exec($ref->{'job_command'});
			if (rindex($stdout, "Saved parameters for CT") >= 0) {	
				my @hostName = split(" ", $ref->{'job_command'});								
				my $newHostName = trim(@hostName[4]);								
				my $hostNameQuery = $dbh->prepare("UPDATE vm_master
											  		   SET vm_host_name = '$newHostName'
											  		   WHERE vm_id = $ref->{'job_vm_id'}");
			  	$hostNameQuery->execute();
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
			} else {
				update_status('ERROR', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
			}
		}
		elsif (rindex($ref->{'job_command'}, "--vmguarpages") >= 0) {
			# To set the OpenVZ VPS RAM.
			$stdout = $ssh_array->exec($ref->{'job_command'});
			if (rindex($stdout, "Saved parameters for CT") >= 0) {			
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
				# get the vm quota detail.
				my $ovz = $dbh->prepare("SELECT *
								     	 FROM vm_quota 
								     	 WHERE vm_ramsize_job_id = $job_id");						 
				$ovz->execute();
				my $ovzf = $ovz->fetchrow_hashref();	
				my $vm_ram_size = $ovzf->{'vm_ram_size'};					
				my $vm_ram_blocks = $ovzf->{'vm_ram_blocks'};
				my $newRamSpace = $vm_ram_size.$vm_ram_blocks;										
				my $openvzVpsRAMQuery = $dbh->prepare("UPDATE vm_master
											  		   SET vm_RAM = '$newRamSpace'
											  		   WHERE vm_id = $ref->{'job_vm_id'}");
			  	$openvzVpsRAMQuery->execute();
			} else {
				update_status('ERROR', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
			}
		}
		elsif (rindex($ref->{'job_command'}, "--diskspace") >= 0) {
			# To set the OpenVZ VPS Disk Space.
			$stdout = $ssh_array->exec($ref->{'job_command'});
			if (rindex($stdout, "Saved parameters for CT") >= 0) {			
				update_status('COMPLETED', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
				# get the vm quota detail.
				my $ovz = $dbh->prepare("SELECT *
								     	 FROM vm_quota 
								     	 WHERE vm_diskspace_job_id = $job_id");						 
				$ovz->execute();
				my $ovzf = $ovz->fetchrow_hashref();	
				my $vm_diskspace = $ovzf->{'vm_diskspace'};					
				my $vm_disk_blocks = $ovzf->{'vm_disk_blocks'};
				my $newspace = $vm_diskspace.$vm_disk_blocks;						
				my $openvzVpsdiskspce = $dbh->prepare("UPDATE vm_master
											  		   SET vm_HDD = '$newspace'
											  		   WHERE vm_id = $ref->{'job_vm_id'}");
			  	$openvzVpsdiskspce->execute();
			} else {
				update_status('ERROR', $ref->{'job_id'}, $stdout, $stdout, $exit, $dbh);
			}
		}
		elsif (rindex($ref->{'job_command'}, "service iptables save") >= 0) {
			# block or unblock the ip and update its corresponding staus either blocked or Available.
			$stdout = $ssh_array->exec($ref->{'job_command'}); 
			if (rindex($stdout, $ref->{'job_expected_out'}) >= 0) {
				# if yes update the job status
				update_status('COMPLETED', $ref->{'job_id'},$stdout, '', $exit, $dbh);
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
				
			}  else {
			   # update error
			   update_status('ERROR', $ref->{'job_id'},$stdout, $stdout, $exit,$dbh);			   
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
