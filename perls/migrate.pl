#!/usr/bin/perl 

# FOr migrate, rebuild

#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

use DBI();
use Connect;
use LWP 5.64;
use MIME::Base64;
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

# Now retrieve requests pending commands
my $jth = $dbh->prepare("SELECT * 
						 FROM job_long_queue j, vm_master v
						 WHERE long_status = 'PENDING'
						 AND j.long_vm_id = v.vm_id
						 ORDER BY long_id");
						 
$jth->execute();
my $loop = 0;
my $long_id = 0;
my $ssh_array;
while(my $ref = $jth->fetchrow_hashref()){
	$status_flag = 0;	
	$loop = $loop + 1;	
	my $pth = $dbh->prepare("UPDATE job_long_queue
							 SET long_status = 'PROCESSING'
							 WHERE long_id = $ref->{'long_id'}");
	$pth->execute();	
	my $qth = $dbh->prepare("SELECT * 
							 FROM job_long_queue_command q, command_master c, server_master s
							 WHERE s.server_id = q.queue_server_id
							 AND c.cmd_id = q.queue_command_id
							 AND q.queue_status = 'PENDING'
							 AND q.queue_long_id = $ref->{'long_id'}
							 ORDER BY q.queue_id");
	$qth->execute();
	my $server_id = 0;
	my $exit = 1;
	while(my $ref1 = $qth->fetchrow_hashref()){
		my $stdout = "";
		my $stderr = "";
		$exit = 0;
		my $conn = Connect->new();		
		if($loop eq 1) {
		    if($long_id ne $ref->{'long_id'}) {
				$long_id = $ref->{'long_id'};
				$server_id = $ref1->{'server_id'};
				$ssh_array = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});				
				my $login_output = $ssh_array->login();		
			}
			elsif($long_id eq $ref->{'long_id'} and $server_id ne $ref1->{'queue_server_id'}) {
				$ssh_array->close();
				$server_id = $ref1->{'queue_server_id'};
				$ssh_array = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});	
				my $login_output = $ssh_array->login();			
			}
		}
		elsif($loop ne 1) {
			if($long_id ne $ref->{'long_id'}) {
				$ssh_array->close();
				$long_id = $ref->{'long_id'};
				$server_id = $ref1->{'server_id'};				
				$ssh_array = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});			
				my $login_output = $ssh_array->login();	
			}
			elsif($long_id eq $ref->{'long_id'} and $server_id ne $ref1->{'queue_server_id'}) {
				$ssh_array->close();
				$server_id = $ref1->{'queue_server_id'};
				$ssh_array = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});
				my $login_output = $ssh_array->login();
			}		
		}
		if (rindex($login_output, "denied") >= 0) {
			update_status('ERROR', $ref->{'job_id'},"Login Failed", "Login Failed", 1,$dbh);
		}
		else {				
			# Set job status as processing
			update_status('PROCESSING', $ref1->{'queue_id'}, $stdout,$stderr,$exit, $dbh);
			if(rindex($ref1->{'cmd_call_update'}, "YES") >= 0) {
				$response = $browser->get(SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=PROCESSING&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}");
			}
			$command = $ref1->{'queue_long_command'};
			# to avoid the command you sent in your next read operation.
			$ssh_array->exec("stty -echo");			
			if($ref1->{'queue_command_id'} eq 25) {				
				@servers = split("to", $ref->{'long_descr'});
				my $hostName = trim(@servers[1]);				
				my $sqlPassword = $dbh->prepare("SELECT server_root_password  
										 		 FROM server_master 
										 		 WHERE server_hostname = '$hostName' ");
				$sqlPassword->execute();
				my $serverPassword = $sqlPassword->fetchrow_hashref();				
				my $spassword = encode_base64($serverPassword->{'server_root_password'});																			
				my $scriptcmd2 = "cd /var/www/cgi-bin/; perl copyPublicKey.pl $hostName $spassword";								
				$ssh_array->exec($scriptcmd2);													
			}
			elsif ($ref1->{'queue_command_id'} eq 112) {
				#In xen vm migration process transfer the vm config file from source to destination server.				
				if(rindex($ref->{'long_descr'}, "Migrating Xen VPS") >= 0) {
				#execute the following command on source server.					
					$stdout = $ssh_array->exec($command);					
					@servers = split("to", $ref->{'long_descr'});							
					my $hostName = trim(@servers[1]);																	
					my $sqlPassword = $dbh->prepare("SELECT server_root_password  
													 FROM server_master 
													 WHERE server_hostname = '$hostName'");	
					$sqlPassword->execute();
					my $serverPassword = $sqlPassword->fetchrow_hashref();							
					my $spassword = encode_base64($serverPassword->{'server_root_password'});
					my $vm_config_file = $ref->{'vm_config_file'};																		
					my $scriptcmd2 = "cd /var/www/cgi-bin/; perl copyConfigFile.pl $hostName $vm_config_file $spassword";														
					$stdout = $ssh_array->exec($scriptcmd2);	
					my $snapshotfile = $ref->{'vm_lvg'}."_s.dd";																					
					my $scriptcmd3 = "cd /var/www/cgi-bin/; perl copySnapShotsfile.pl $hostName $snapshotfile $spassword";					
					$stdout = $ssh_array->exec($scriptcmd3);
				} else {
					$stdout = $ssh_array->exec($command);
				}			
				
			}			
			else {
			    $stdout = $ssh_array->exec($command);
			}
			
			if(rindex($stdout, "Overwrite (y/n)") >= 0) {
				$stdout = $ssh_array->exec("y");
			}				
			
			
			
			# start of vm creation conditions block
			my $lvg = $ref->{'vm_lvg'};
			my $vcf = $ref->{'vm_config_file'};
			$newpassword = $ref->{'vm_password'};		  
			if($ref1->{'queue_command_id'} eq 51 or rindex($ref1->{'queue_long_command'}, "#kernel") >= 0 ) {
				#get the kernel of xen server.
				my $kernelcmd = "uname -r";				
				my $kernelout = $ssh_array->exec($kernelcmd);				
				#set the kernel in the config file.
				my $trimkernel = trim($kernelout);
				my $setkercmd = "echo \'kernel = \"/boot/vmlinuz-".$trimkernel."\"\' >> /etc/xen/".$vcf.";";										
					$ssh_array->exec($setkercmd);			
				if(rindex($ref1->{'queue_long_command'}, "#kernel") <= 0) {
					#set the ram disk												
					$ramdskcmd = "echo \'ramdisk = \"/boot/xen-guest-".$lvg."-initrd\"\' >> /etc/xen/".$vcf.";";				
					$ssh_array->exec($ramdskcmd);	
				}	
			}
						
			if($ref1->{'queue_command_id'} eq 50) {
				$scriptcmd = "cd /var/www/cgi-bin/";				
				$ssh_array->exec($scriptcmd);		
				my $execute_script = "perl changepasswd.pl ".$newpassword." ".$lvg;
			
				$ssh_array->exec($execute_script);
				#login to vm using command
				#convert the password into shadow format
				my $shadowpassword = "pwconv";
				my $vmlogincmd = "chroot /mnt/".$lvg." ".$shadowpassword;		
				$ssh_array->exec($vmlogincmd);
			    #back to root
				$scriptcmd2 = "cd -";
				$ssh_array->exec($scriptcmd2);	
			} 			
						
			
			# check VM Creation command
			if($ref1->{'queue_command_id'} eq 48) {
				my $lvg = $ref->{'vm_lvg'};
				#if(rindex($stdout, "Started domain") >= 0) {
					print SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=COMPLETED&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}";
					
					$response = $browser->get(SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=COMPLETED&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}");
				#}
			}					
			#end of vm creations conditions block 		
			my $status = "";
			# if command o/p stored in db matches with command execution o/p
			if (rindex($stdout, "Error") >= 0  or rindex($stdout, "error") >= 0 ) {			
				$status = "ERROR";
				$status_flag = 1;
				$stderr = $stdout;
				# update the job status in db
				if($ref1->{'queue_command_id'} == 105) {
					update_status("COMPLETED" , $ref1->{'queue_id'}, $stdout, $stderr, 0,$dbh);		
				} else {
					update_status($status , $ref1->{'queue_id'}, $stdout, $stderr, 0,$dbh);
				}
				
				# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				if(rindex($ref1->{'cmd_call_update'}, "YES") >= 0) {				
					$response = $browser->get(SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=ERROR&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}");
				}			
			}
			elsif (rindex($stdout, $ref1->{'queue_expected_out'}) >= 0) {
				$status = "COMPLETED";
				$status_flag = 2;
				$stderr = "";
				# update the job status in db
				update_status($status , $ref1->{'queue_id'}, $stdout, $stderr, 0,$dbh);		
				
				# if restore command - stop vm , destroy vm, update this into database
				
				# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				if(rindex($ref1->{'cmd_call_update'}, "YES") >= 0) {				
					$response = $browser->get(SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=COMPLETED&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}");
				}
			}
			else {
				$status = "ERROR";
				$status_flag = 1;
				$stderr = $stdout;
				# update the job status in db
				update_status($status , $ref1->{'queue_id'}, $stdout, $stderr, 0,$dbh);		
				
				# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				if(rindex($ref1->{'cmd_call_update'}, "YES") >= 0) {				
					$response = $browser->get(SITEURL."/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=ERROR&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}&jobDescription=$ref1->{'queue_descr'}&long_vm_id=$ref->{'long_vm_id'}&queue_long_id=$ref1->{'queue_long_id'}&queue_command_id=$ref1->{'queue_command_id'}");
				}
			}
			
		}		
	}
	
	if ($status_flag == 1) {
	     $status = "ERROR";
	}
	elsif ($status_flag == 2)
	{ 
	     $status = "COMPLETED";
		 # set vm status as ENABLED
		 # need to check why this query is used
		 my $vth = $dbh->prepare("UPDATE vm_master
		 						  SET vm_type = 'ENABLED'
								  WHERE vm_id = $ref->{'long_vm_id'}");
								  
	}
	
	# if restore command update the status in vm_restore table
	if (rindex($ref->{'long_descr'}, "Restoring") >= 0) {
		my $pth = $dbh->prepare("UPDATE vm_restore
							 SET restore_status = '$status'
							 WHERE restore_job_id = $ref->{'long_id'}");
		$pth->execute();
	}
	
	my $pth = $dbh->prepare("UPDATE job_long_queue
							 SET long_status = '$status',
							 long_completed_date = now()
							 WHERE long_id = $ref->{'long_id'}");
	$pth->execute();
	if ($exit eq 0) {
		$ssh_array->close();
	}
	exit 0;
}

sub update_status {
	my $status = shift;
	my $queue_id = shift;
	my $stdout = shift;
	my $stderr = shift;
	my $stdexit = shift;
	my $dbh = shift;
	my $pth = $dbh->prepare("UPDATE job_long_queue_command
							 SET queue_status = ?,
							 queue_out = ?,
							 queue_error = ?,
							 queue_exit = ?
							 WHERE queue_id = ?");

	$pth->execute($status,$stdout,$stderr,$stdexit,$queue_id);							
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
