#!/usr/bin/perl 

use CGI qw(:standard);
use Connect;
use DBI();

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=vmcomplete_sadmin;host=localhost","root", "sahilb",{'RaiseError' => 1});

$action = @ARGV[0];
$host = @ARGV[1]; 
$pwd = @ARGV[2]; 
$ssh = @ARGV[3]; 
$sid = @ARGV[4];

print "host".$host;
print "pwd".$pwd;
my $conn = Connect->new();

my $ssh_arr = $conn->con($host, $pwd, $ssh);

my $login_output = $ssh_arr->login();


if (rindex($login_output, "denied") < 0) {
#if($ssh_arr->login("root",$pwd)) 
	# to avoid the command you sent in your next read operation.
	$ssh_arr->exec("stty -echo");
	# changed the php script to list processes using ssh2_connect, (on 8.8.09) so following process block is not in use now
	if ($action eq "process") {
		$vid = @ARGV[5];
		if($vid eq "") {
			$vid = 0;
		}

		my $command = "ps -eo pid,stat,pmem,user,command h  | sort -k 1 -nr";
		#my($stdout, $stderr, $exit) = $ssh_arr->cmd($command);
		my $stdout = $ssh_arr->exec($command);
	
		my @out = split "\n", $stdout;
		my $str = "";
		my $cnt = 0;
		foreach (@out) {
			my ($id, $stat, $mem, $user, $comm) = split(" ", $_, 5);
			if ($str eq "") {
				$str .= "($id, $sid, $vid, '$stat', '$mem', '$user', '$comm')";
			}
			else {
				$str .= ", ($id, $sid, $vid, '$stat', '$mem', '$user', '$comm')";
			}
			$cnt = $cnt + 1;
			
		}
		
		my $dth = $dbh->prepare("ALTER TABLE server_processes DISABLE KEYS");
		$dth->execute();
		my $pth = $dbh->prepare("INSERT INTO server_processes
							  (process_id, process_server_id, process_vm_id, process_stat, process_mem, process_user, process_comm)
							  VALUES $str");
		$pth->execute();
	}
	if ($action eq "password") {
		$npwd = @ARGV[5];
		print $npwd;
		$ssh_arr->send("passwd");
		$ssh_arr->waitfor('password:\s*\z', 1) or die "prompt 'New password:' not found";
		$ssh_arr->send($npwd);
		$ssh_arr->waitfor(':\s*\z', 1) or die "prompt 'Confirm new password:' not found";
		$ssh_arr->send($npwd);
		$ssh_arr->waitfor('updated successfully.', 1) or die "prompt 'Change password failed'";
		
		print "UPDATE server_master SET server_root_password = '$npwd'
								 WHERE server_id = $sid";
		my $pth = $dbh->prepare("UPDATE server_master SET server_root_password = '$npwd'
								 WHERE server_id = $sid");

		$pth->execute();
	}

}
$ssh_arr->close();
