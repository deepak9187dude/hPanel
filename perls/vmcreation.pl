#!/usr/bin/perl 

# FOr migrate, rebuild

#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

use DBI;
use Connect;
use LWP 5.64;
# to invoke http request of php page which will update the database
my $browser = LWP::UserAgent->new;

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=vmcomplete_sadmin;host=localhost","root", "sahilb",{'RaiseError' => 1});

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
				$response = $browser->get("http://localhost/vmcomplete_sadmin/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=PROCESSING&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}");
			}
			
			
			$command = $ref1->{'queue_long_command'};
			
						
			# to avoid the command you sent in your next read operation.
			$ssh_array->exec("stty -echo");

			$stdout = $ssh_array->exec($command);
			if($ref1->{'queue_command_id'} eq 51) {
				#get the kernel
				my $kernel = $stdout;
				#set the kernel in the config file, fire the below command 
				my $setkercmd = "echo \"kernel = \"/boot/vmlinuz-".$kernel."\"\" >> /etc/xen/".$ref->{'vm_config_file'};
				$ssh_array->exec($setkercmd);			
			}
			
			if($ref1->{'queue_command_id'} eq 52) {
				#include the unix module. 
				use Unix::PasswdFile;
				
				$pw = new Unix::PasswdFile "/mnt/".$lvg."/etc/passwd";
				$pw->passwd("root", $pw->encpass(".$ref->{'vm_password'}.")); 
				$pw->commit();
				undef $pw;	
			}
			
			# check VM Creation command
			if($ref1->{'queue_command_id'} eq 48) {
				my $lvg = $ref->{'vm_lvg'};
				if(rindex($stdout, "Started domain") >= 0)
				{
					 #update the vm status as running mode
					 my $vth1 = $dbh->prepare("UPDATE vm_master
		 						  SET vm_status = 'Running'
								  WHERE vm_id = $ref->{'long_vm_id'}");
					 $vth1->execute();	
					 
					 #update the invoice status
					 my $vth2 = $dbh->prepare("UPDATE tbl_invoicedetails
		 						  SET vm_creation_status = '1'
								  WHERE InvoiceID = $ref->{'vm_invoice_id'}");
					 $vth2->execute();	
				}
			}
			
			
			my $status = "";
			# if command o/p stored in db matches with command execution o/p
			if (rindex($stdout, $ref1->{'queue_expected_out'}) >= 0)
			{
				$status = "COMPLETED";
				$status_flag = 2;
				$stderr = "";
				# update the job status in db
				update_status($status , $ref1->{'queue_id'}, $stdout, $stderr, 0,$dbh);		
				
				# if restore command - stop vm , destroy vm, update this into database
				
				# invoke http request to update the status of vm into database thr php if 'cmd_call_update' is 'YES'
				if(rindex($ref1->{'cmd_call_update'}, "YES") >= 0) {
					$response = $browser->get("http://localhost/vmcomplete_sadmin/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=COMPLETED&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}");
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
					$response = $browser->get("http://localhost/vmcomplete_sadmin/admin/process_long_action.php?job_id=$ref1->{'queue_id'}&job_status=ERROR&job_server_id=$ref1->{'queue_server_id'}&job_comm=$ref1->{'queue_long_command'}");
				}
			}
			
		}
		
		
		
	}
	
	if ($status_flag == 1) {
	     $status = "ERROR";
	}
	elsif ($status_flag == 2) { 
	     $status = "COMPLETED";	
	}
	
	my $pth = $dbh->prepare("UPDATE job_long_queue
							 SET long_status = '$status'
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
