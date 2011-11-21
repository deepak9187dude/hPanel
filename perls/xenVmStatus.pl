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
my $jth = $dbh->prepare("SELECT s.server_ip, s.server_root_password, s.server_ssh, s.server_type, v.vm_id, v.vm_display_name, v.vm_config_file 
						 FROM vm_master v, ips_master i, server_master s
						 WHERE i.ips_id = v.vm_ip_id
						 AND v.vm_server_id=s.server_id
						 AND s.server_type = 'Xen'
						 AND (v.vm_status <> 'Creating' OR v.vm_status <> 'Rebuilding' OR v.vm_status <> 'Migrating' OR v.vm_status <> 'Restoring' AND v.vm_status <> 'Destroyed') ORDER BY v.vm_id DESC");
# AND v.vm_status <> 'Destroyed'	
$jth->execute();
while(my $ref = $jth->fetchrow_hashref()) {												
		my $host = $ref->{'server_ip'};
		my $pwd = $ref->{'server_root_password'};
		my $ssh = $ref->{'server_ssh'}; 				
		my $vm_display_name  = $ref->{'vm_display_name'};
		my $vm_config_file  = $ref->{'vm_config_file'};	
		my $vm_id  =  $ref->{'vm_id'};			
		my $stdoutXen;
		my $xmList;
		my $checkConfig;	
		my $cmd2;		
		my $conn = Connect->new();		
		my $ssh_array = $conn->con($host, $pwd, $ssh );
		my $login_output = $ssh_array->login();
		if (rindex($login_output, "denied") >= 0) {
			print "Connection Failed";
		} else {					 					 
			$cmd2 = "xm list | grep ".$vm_display_name." | awk '{print $5}'";									
			$stdoutXen = $ssh_array->exec($cmd2);			
			print $stdoutXen."\n";								
			if (rindex($stdoutXen, '-b----') >= 0 or rindex($stdoutXen, '-r----') >= 0 or rindex($stdoutXen, 'r-----') >= 0 or rindex($stdoutXen, '------') >= 0) {																								
				$response = $browser->get(SITEURL."/vmcomplete/admin/updateXenvps_status.php?vm_id=$vm_id&status=Running");				
				print "Running";
			}
			elsif (rindex($stdoutXen, '--p---') >= 0) {																							
				$response = $browser->get(SITEURL."/vmcomplete/admin/updateXenvps_status.php?vm_id=$vm_id&status=Paused");				
				print "Paused";
			}		
			else {
				$xmList = $ssh_array->exec("xm list");
				if (rindex($xmList, $vm_display_name) <= 0) {					
					$response = $browser->get(SITEURL."/vmcomplete/admin/updateXenvps_status.php?vm_id=$vm_id&status=Stopped");
					print "Stopped";
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
