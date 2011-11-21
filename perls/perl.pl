print "Content-Type: text/html\n\n";

print "OK";

# Execute command on the host
sub exec_command {
	my $self = shift;
	my $ssh = shift;
	if (@_) { $self->{COMMAND} = shift }
	my($stdout, $stderr, $exit) = $ssh->cmd("$self->{COMMAND}");
	return $stdout;
}