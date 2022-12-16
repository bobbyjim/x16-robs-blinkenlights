
open my $out, '>', "TEST1.BIN";
print $out pack 'xx'; # initial null bytes
print $out pack('C', $_) for 1..256;
close $out;
