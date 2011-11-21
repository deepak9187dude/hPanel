#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 
use DBI();
use Connect;
use LWP 5.64;
# to invoke http request of php page which will update the database
my $browser = LWP::UserAgent->new;

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=vmcomplete_sadmin;host=localhost","root", "sahilb",{'RaiseError' => 1});
# Now retrieve synchronous (job_type=0) jobs from table
my $jth = $dbh->prepare("SELECT *
						 FROM vm_master v, ips_master i, server_master s
						 WHERE i.ips_id = v.vm_ip_id
						 AND v.vm_server_id=s.server_id
						 AND (v.vm_status <> 'Creating' OR v.vm_status <> 'Rebuilding')
						 ORDER BY v.vm_id DESC");
# AND v.vm_status <> 'Destroyed'
$jth->execute();
while(my $ref = $jth->fetchrow_hashref()) {												
		my $host = $ref->{'server_ip'};
		my $pwd = $ref->{'server_root_password'};
		my $ssh = $ref->{'server_ssh'}; 
		my $vm_name  = $ref->{'vm_name'};
		my $vm_ip  = $ref->{'ips_ip'};
		my $vm_display_name  = $ref->{'vm_display_name'};	
		my $vm_id  =  $ref->{'vm_id'};	
		my $stdout;
		my $stdoutXen;
		my $conn = Connect->new();
		my $ssh_array = $conn->con($host, $pwd, $ssh );
		my $login_output = $ssh_array->login();
		if (rindex($login_output, "denied") >= 0) {
				print "Connection Failed";
		} else {
			if($ref->{'server_type'} eq "openVZ") {
				my $cmd = "vzlist -a| grep $vm_ip | awk '{print $3}'";				
				$stdout = $ssh_array->exec($cmd);													
				if (rindex($stdout, 'running') >= 0) {																			
					$response = $browser->get("http://localhost/vmcomplete/admin/updatevps_status.php?vm_id=$vm_id&status=Running");					
				}elsif (rindex($stdout, 'stopped') >= 0) {														
					$response = $browser->get("http://localhost/vmcomplete/admin/updatevps_status.php?vm_id=$vm_id&status=Stopped");
				}elsif (rindex($stdout, 'suspended') >= 0) {										
					$response = $browser->get("http://localhost/vmcomplete/admin/updatevps_status.php?vm_id=$vm_id&status=Suspended");
				} 
			}
			elsif ($ref->{'server_type'} eq "Xen") { 					 
				my $cmd2 = "xm list | grep ".$vm_display_name." | awk '{print $5}'";									
				$stdoutXen = $ssh_array->exec($cmd2);						
				if (rindex($stdoutXen, '-b----') >= 0 or rindex($stdoutXen, '-r----') >= 0 or rindex($stdoutXen, 'r-----') >= 0 or rindex($stdoutXen, '------') >= 0) {																		
					print "Hello";
					$response = $browser->get("http://localhost/vmcomplete/admin/updatevps_status.php?vm_id=$vm_id&status=Running");
				} else {
					my $xmList;
					$xmList = $ssh_array->exec("xm list");
					if (rindex($xmList, $vm_display_name) <= 0) {																
						$response = $browser->get("http://localhost/vmcomplete/admin/updatevps_status.php?vm_id=$vm_id&status=Stopped");
					}
				} 
					
			}
	}	
	
 }
$dbh->disconnect;
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
