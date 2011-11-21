#!/usr/bin/perl
use threads;

$thr = threads->new(\&sub1, "Param 1", "Param 2"); 
$thr->join;

sub sub1 { 
	my @InboundParameters = @_; 
	print "In the thread\n"; 
	print "got parameters >", join("<>", @InboundParameters), "<\n"; 
}