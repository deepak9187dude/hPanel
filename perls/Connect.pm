#!/usr/bin/perl
use CGI::Carp qw/fatalsToBrowser/; 
use Net::SSH::Expect;
#use Net::SSH::Perl::Auth;


package Connect;
# constructor
sub new {
	my $self = shift;
	if (@_)	{ $self->{host} = shift }
	if (@_)	{ $self->{user} = shift }
	if (@_)	{ $self->{password} = shift }
	if (@_)	{ $self->{port} = shift }
	if (@_)	{ $self->{raw_pty} = 1 }	
	if (@_)	{ $self->{timeout} = 30 }	

	return $self;
}

# connect to the host
sub con {
	my $self = shift;
	if (@_)	{ $self->{HOST} = shift }
	if (@_)	{ $self->{PASSWORD} = shift }
	if (@_) { $self->{PORT} = shift }
	my $ssh = Net::SSH::Expect->new (host => "$self->{HOST}", password=> "$self->{PASSWORD}", user => 'root', raw_pty =>1, timeout=>70, port => $self->{PORT}, no_terminal=>1);
	#exp_debug=>1
	return $ssh;
}

sub login {
	my $ssh = shift;
	if (@_)	{ $self->{USERNAME} = shift }
	if (@_)	{ $self->{PASSWORD} = shift }	
	if (!$ssh->login($self->{USERNAME}, $self->{PASSWORD})) {
		return false;
	}
}

# Execute command on the host
sub exec_command {
	my $self = shift;
	my $ssh = shift;
	if (@_) { $self->{COMMAND} = shift }
	my($stdout, $stderr, $exit) = $ssh->cmd($self->{COMMAND});
	my @out = ($stdout, $stderr, $exit);
	
	return @out;
}
1;
