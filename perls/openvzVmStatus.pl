#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 
use DBI();
use Connect;
use LWP 5.64;
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
my $jth = $dbh->prepare("SELECT s.server_ip, s.server_root_password, s.server_ssh, s.server_type, v.vm_id, v.vm_name, i.ips_ip
						 FROM vm_master v, ips_master i, server_master s
						 WHERE v.vm_ip_id = i.ips_id
						 AND v.vm_server_id = s.server_id
						 AND s.server_type = 'openVZ'
						 AND (v.vm_status <> 'Creating' OR v.vm_status <> 'Rebuilding' OR v.vm_status <> 'Migrating' OR v.vm_status <> 'Restoring' OR v.vm_status <> 'Destroyed') ORDER BY v.vm_id DESC");
# AND v.vm_status <> 'Destroyed'	
$jth->execute();
while(my $ref = $jth->fetchrow_hashref()) {												
		my $host = $ref->{'server_ip'};
		my $pwd = $ref->{'server_root_password'};
		my $ssh = $ref->{'server_ssh'}; 
		my $vm_name  = $ref->{'vm_name'};
		my $vm_ip  = $ref->{'ips_ip'};				
		my $vm_id  =  $ref->{'vm_id'};			
		my $stdout;		
		my $cmd;		
		my $conn = Connect->new();
		my $ssh_array = $conn->con($host, $pwd, $ssh );
		my $login_output = $ssh_array->login();
		if (rindex($login_output, "denied") >= 0) {
			print "Connection Failed";
		} else {			
			$cmd = "vzlist -a| grep $vm_ip | awk '{print $3}'";							
			$stdout = $ssh_array->exec($cmd);													
			if (rindex($stdout, 'running') >= 0) {																			
				$response = $browser->get(SITEURL."/admin/updatevps_status.php?vm_id=$vm_id&status=Running");	
				print "Running";				
			}elsif (rindex($stdout, 'stopped') >= 0) {														
				$response = $browser->get(SITEURL."/admin/updatevps_status.php?vm_id=$vm_id&status=Stopped");
				print "Stopped";
			}elsif (rindex($stdout, 'suspended') >= 0) {										
				$response = $browser->get(SITEURL."/admin/updatevps_status.php?vm_id=$vm_id&status=Suspended");
				print "Suspended";
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
