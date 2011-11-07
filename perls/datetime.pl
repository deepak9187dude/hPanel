#!/usr/bin/perl 
#use strict;
#use CGI::Carp qw/fatalsToBrowser/; 

print  "Content-Type: text/html\n\n";
print current_time(); 
@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
print $months[$month];
sub current_time {
	@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	$year = 1900 + $yearOffset;
	$theTime = "$year-$months[$month]-$dayOfMonth $hour:$minute:$second";
	return $theTime; 
}