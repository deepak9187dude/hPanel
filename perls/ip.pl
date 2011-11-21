#!/perl/bin/perl
$time = localtime;
$ip = "$ENV{'REMOTE_ADDR'}";

open(OUT, ">>log.htm");
print OUT "Access from: $ip at $time<p>\n";
close(OUT);
