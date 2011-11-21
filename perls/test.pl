#!/usr/bin/perl 
#use strict;
use Connect;
#To check the command execution on destination server
		my $host = @ARGV[0];;
		my $pwd  = @ARGV[1];
		my $ssh  = @ARGV[2]; 
		my $stdout;
		my $conn = Connect->new();
		my $ssh_array = $conn->con($host, $pwd, $ssh);
		my $login_output = $ssh_array->login();
		if (rindex($login_output, "denied") >= 0) {
			print "Connection Failed";
		} else {
			print "\nConnection Successfule to execute the commands";
			$stdout = $ssh_array->exec("vzlist -a");
			print "\n".$stdout;
		}	