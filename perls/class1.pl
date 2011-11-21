#!/usr/bin/perl
package Person;
use strict;

##################################################
## the object constructor (simplistic version)  ##
##################################################
sub new {
	my $self  = {};
	$self->{NAME}   = "sonali";
	$self->{AGE}    = undef;
	$self->{PEERS}  = [];
	bless($self);           # but see below
	return $self;
}

sub name {
	my $self = shift;
	if (@_) { $self->{NAME} = shift }
	return $self->{NAME};
}

sub age {
	my $self = shift;
	if (@_) { $self->{AGE} = shift }
	return $self->{AGE};
}

sub peers {
	my $self = shift;
	if (@_) { @{ $self->{PEERS} } = @_ }
	return @{ $self->{PEERS} };
}

my $me  = Person->new();
my $him = $me->new();
printf "Name: %s", $me->{NAME};
