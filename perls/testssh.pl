#!/usr/bin/perl
use Net::SSH::Perl;
$srchost = 'localhost';
$dsthost = '122.176.89.86';
$user = 'sahil';
$pass = 'sahilb';

my $sshsrc = Net::SSH::Perl->new($srchost, debug => 1, protocol => 2,+ interactive => 1, use_pty => 1 );
my $sshdst = Net::SSH::Perl->new($dsthost, debug => 0, protocol => 2,+ interactive => 1, use_pty => 1 );
#my $ssh = Net::SSH::Perl->new($host,debug=>1);
$sshsrc->login($user, $pass);
$sshdst->login($user, $pass);


print "success!"
# print 'Initialization Migration'." \n\n";
# my($stdout, $stderr, $exit) = $sshsrc->cmd('xm migrate XMyTestVn 64.22.75.9','\n');
# print $stdout.'|'.$stderr.'|'.$exit;


