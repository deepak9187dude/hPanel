#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

print  "Content-Type: text/html\n\n";

use Connect;

my $conn = Connect->new();

# Store ssh session in array
my $ssh_array = $conn->con("localhost", 22);
if($ssh_array->login("root",'sahilbb')) {
	my @out = $ssh_array->cmd("ls");
	my($stdout, $stderr, $exit)  = @out;
	print $stdout." ".$stderr." ".$exit;
}
else {
    print "failure";
}
