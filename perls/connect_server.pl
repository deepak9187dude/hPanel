#!/usr/bin/perl
use Expect;
use CGI qw(:standard);
use Connect;
use DBI();

# Connect to the database.
my $dbh = DBI->connect("DBI:mysql:database=vmcomplete_sadmin;host=localhost","root", "sahilb",{'RaiseError' => 1});

$host = @ARGV[0]; 
$pwd = @ARGV[1]; 
$ssh = @ARGV[2]; 


my $conn = Connect->new();
my $ssh_arr = $conn->con($host,"root",$pwd, $ssh);

my $command = "ps -eo pid,stat,pmem,user,command h  | sort -k 1 -nr";
my($stdout, $stderr, $exit) = $ssh_arr->cmd($command);
my @out = split "\n", $stdout;

foreach (@out) {
	my ($id, $stat, $mem, $user, $comm) = split(" ", $_, 5);
	my $dth = $dbh->prepare("INSERT INTO server_processes
								   (process_id, process_server_id, process_stat, process_mem, process_user, process_comm)
							 VALUES($id, 1, '$stat', '$mem', '$user', '$comm')");
	$dth->execute();
}
