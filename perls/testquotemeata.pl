#!/usr/bin/perl
use MIME::Base64;

print $password = encode_base64("0$r\@ng3!!")."\n";
#print $serverHostname = encode_base64(@ARGV[1]);
print $decoded = decode_base64($password);
#print $decoded2 = decode_base64($serverHostname);


