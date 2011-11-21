#!/usr/bin/perl -w
# prime-pthread, courtesy of Tom Christiansen
    
use strict;

use threads;
use Thread::Queue;

my $stream = new Thread::Queue;
my $kid    = new threads(\&check_num, $stream, 2);

for my $i ( 3 .. 5 ) {
print "\nstreami".$i;
$stream->enqueue($i);
} 

$stream->enqueue(undef);
$kid->join;

sub check_num {
my ($upstream, $cur_prime) = @_;
print "\nupstream".$upstream;
print "\nupcur_prime".$cur_prime;

my $kid;
my $downstream = new Thread::Queue;
while (my $num = $upstream->dequeue) {
	print "\nnum".$num;
	print "\ncur_prime1".$cur_prime;
	 next unless $num % $cur_prime;
	 	print "\ncur_prime2".$cur_prime;
		print "kid".$kid;
	 if ($kid) {
		$downstream->enqueue($num);
			  } else {
		print "Found prime $num\n";
			$kid = new threads(\&check_num, $downstream, $num);
	 }
} 
$downstream->enqueue(undef) if $kid;
$kid->join           if $kid;
}