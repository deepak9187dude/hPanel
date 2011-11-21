#!/usr/bin/perl 
#use strict;
use Connect;
#To check the command execution on destination server
		my $host = @ARGV[0];
		my $pwd  = 'sahilb';
		my $ssh  = 22; 
		my $stdout;
		my $conn = Connect->new();
		my $ssh_array = $conn->con($host, $pwd, $ssh);
		my $login_output = $ssh_array->login();
		if (rindex($login_output, "denied") >= 0) {
			print "Connection Failed";
		} else {
			print "Connection Successfull to execute the commands";
			$stdout = $ssh_array->exec("vzlist -a");
			print "\n".$stdout;
		}	
