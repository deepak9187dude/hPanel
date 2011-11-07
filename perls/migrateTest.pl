#!/usr/bin/perl 
use Connect;
$host = "localhost";
$pwd = 'sahilb';
$ssh = 22;
	
my $conn = Connect->new();	
my $ssh_array = $conn->con($host, $pwd, $ssh );
my $login_output = $ssh_array->login();
my $stdout;	
$stdout = $ssh_array->exec('xm migrate  XOneTEstVm localhost');
print '-----'.$stdout;
			
			
		 
			  
				

	
		

				
		
		

