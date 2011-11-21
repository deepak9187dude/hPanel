#!/usr/bin/perl 
use CGI qw(:standard);
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 


#print  "Content-Type: text/html\n\n";

use DBI();
use Connect;


# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=vmcomplete_sadmin;host=localhost","root", "sahilb",{'RaiseError' => 1});

$sid = @ARGV[0]; 
$bid = @ARGV[1]; 

# Fetch server details from server master for corresponding job_server_id
# my $sth = $dbh->prepare("SELECT * FROM server_master WHERE server_id = ".$sid);
my $sth = $dbh->prepare("SELECT * FROM user_master");
$sth->execute();			
my $ref1 = $sth->fetchrow_hashref();			

my $conn = Connect->new();
my $ssh_arr = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});
my $login_output = $ssh_arr->login();
	$ssh_arr->exec("stty -echo");	
									   
	      my $sth2 = $dbh->prepare("SELECT * FROM ip_block WHERE ip_block_id = $bid");
		  $sth2->execute();			
		  my $ref2        	= $sth2->fetchrow_hashref();
		  my $ip_id       	= $ref2->{'ip_block_ip_id'};
		  my $ip_address  	= $ref2->{'ip_block_ip_address'};
		  my $ip_status   	= $ref2->{'ip_block_ip_status'};
		  my $system_status = $ref2->{'ip_block_system_status'};
		  if($ip_status eq "blocked")	{		  
		  	#block the ip_address.
			if($ip_id eq 0) {
				my $block_cmd    = "iptables -I INPUT -s ".$ip_address." -j DROP";
				my $saveip_table =  "service iptables save";				
				   $ssh_arr->exec($block_cmd);
				   $ssh_arr->exec($saveip_table);				
			}else {
				#get the ip address using ip_id FROM ips_master
				my $sth3 = $dbh->prepare("SELECT ips_ip 
  								   FROM ips_master
								   WHERE ips_id  = ".$ip_id);

			   $sth3->execute();			
			   my $ref3        	= $sth3->fetchrow_hashref();
			   my $ips_ip      	= $ref3->{'ips_ip'};
			   my $block_cmd    = "iptables -I INPUT -s ".$ips_ip." -j DROP";
			   my $saveip_table =  "service iptables save";
				  $ssh_arr->exec($block_cmd);
				  $ssh_arr->exec($saveip_table);
				  update_status($ip_id, "Blocked", $dbh);
				
			}	
		  }	else {
		  #unblock the ip_address.
		  if($ip_id eq 0) {
				my $unblock_cmd    = "iptables -I INPUT -s ".$ip_address." -j ACCEPT";
				my $saveip_table =  "service iptables save";
				   $ssh_arr->exec($unblock_cmd);
				   $ssh_arr->exec($saveip_table);								 
			}else {
				#get the ip address using ip_id FROM ips_master
				my $sth3 = $dbh->prepare("SELECT ips_ip 
  								   FROM ips_master
								   WHERE ips_id  = ".$ip_id);

			   $sth3->execute();			
			   my $ref3        	= $sth3->fetchrow_hashref();
			   my $ips_ip      	= $ref3->{'ips_ip'};
			   my $unblock_cmd    = "iptables -I INPUT -s ".$ips_ip." -j ACCEPT";
			   my $saveip_table =  "service iptables save";
				  $ssh_arr->exec($unblock_cmd);
				  $ssh_arr->exec($saveip_table);
				  update_status($ip_id, "Available", $dbh);
				
			}
		  }	
		  
	
$ssh_arr->close();

sub update_status {
	my $ip_id  = shift;	
	my $status = shift;
    my $dbh = shift; 
	my $pth = $dbh->prepare("UPDATE ips_master
							 SET ips_status = '$status'
						     WHERE ips_id = $ip_id");

	$pth->execute();
}
