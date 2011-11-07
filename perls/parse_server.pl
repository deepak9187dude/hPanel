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


# Fetch server details from server master for corresponding job_server_id
my $sth = $dbh->prepare("SELECT *
						 FROM server_master
  					     WHERE server_id = ".$sid);
$sth->execute();			
my $ref1 = $sth->fetchrow_hashref();			

my $conn = Connect->new();
my $ssh_arr = $conn->con($ref1->{'server_ip'},$ref1->{'server_root_password'}, $ref1->{'server_ssh'});
my $login_output = $ssh_arr->login();
	$ssh_arr->exec("stty -echo");
	# Fetch RAM details
	my $command = "free -m | awk '{print \$2}' | tr [:space:] ' ' | awk '{print \$2}'";
	my $stdout = $ssh_arr->exec($command);
	$stdout = trim($stdout);
	
	my $type = "RAM";
	insert_result($stdout, $type, $sid, $dbh);
	
	# Fetch HDD details
	$command = "df -h | awk '{print \$2}' | tr [:space:] ' ' | awk '{print \$2}'";
	$stdout = $ssh_arr->exec($command);
	my $type = "HDD";
	insert_result($stdout, $type, $sid, $dbh);
	
	# Fetch NIC details
	$command = "ifconfig | sed 's/ /,/' | cut -d , -f 1";
	$stdout = $ssh_arr->exec($command);
	# strip out the rows without NIC details
	my ($out1, $out2) = split "lo", $stdout;
	my @std = split " ", $out2;
	my $nic_cnt = 0;
	foreach (@std) {
	  if($_ !~ /:/) {
		  $nic_cnt = $nic_cnt + 1;
	  }
	  $command = "cat /etc/sysconfig/network-scripts/ifcfg-".$_;
	  $stdout = $ssh_arr->exec($command);
	  my @std_new = split "\n", $stdout;
	  foreach (@std_new) {
		  my ($type, $value) = split "=", $_;
		  # fetch server device id
		  my $sth = $dbh->prepare("SELECT *
  								   FROM server_devices
								   WHERE server_id = ".$sid."
								   AND device_type = 'NIC'");

		  $sth->execute();			
		  my $ref2 = $sth->fetchrow_hashref();			
		  # insert these values into device details table
	  	  insert_details($ref2->{'server_device_id'}, $type, $value, $dbh);
	  }
    }
	my $type = "NIC";
	insert_result($nic_cnt, $type, $sid, $dbh);


$ssh_arr->close();

sub insert_result {
	my $stdout = shift;
	my $type = shift;
	my $server_id = shift;
	my $dbh = shift;

	my $pth = $dbh->prepare("UPDATE server_devices
							 SET device_value = '$stdout'
						     WHERE server_id = $server_id
							 AND device_type = '$type'");

	$pth->execute();
}

sub insert_details {
	my $device_id = shift;
	my $type = shift;
	my $value = shift;
	my $dbh = shift;

	my $pth = $dbh->prepare("INSERT INTO server_device_details
							 (server_device_id, device_type, device_value)
							 VALUES ($device_id, '$type', '$value')");
							 
	$pth->execute();
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
