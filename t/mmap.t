#! perl -T

BEGIN {
    use strict;
    use warnings;
    use Test::More tests => 6;

    use_ok('Sys::Mmap');
}

use FileHandle;

$temp_file = "mmap.tmp";

sysopen(FOO, $temp_file, O_WRONLY|O_CREAT|O_TRUNC) or die "$temp_file: $!\n";
print FOO "ABCD1234";
close FOO;

my $foo;
sysopen(FOO, $temp_file, O_RDONLY) or die "$temp_file: $!\n";
# Test negative offsets fail.
is(eval { mmap($foo, 0, PROT_READ, MAP_SHARED, FOO, -100); 1}, undef, "Negative seek fails.");
like($@, qr/^\Qmmap: Cannot operate on a negative offset (-100)\E/, "croaks when negative offset is passed in"); 
# Now map the file for real
mmap($foo, 0, PROT_READ, MAP_SHARED, FOO);
close FOO;

is($foo, 'ABCD1234', "RO access to the file produces valid data");
munmap($foo);

sysopen(FOO, $temp_file, O_RDWR) or die "$temp_file: $!\n";
mmap($foo, 0, PROT_READ|PROT_WRITE, MAP_SHARED, FOO);
close FOO;

substr($foo, 3, 1) = "Z";
is($foo, 'ABCZ1234', 'Foo can be altered in RW mode');
munmap($foo);

sysopen(FOO, $temp_file, O_RDONLY) or die "$temp_file: $!\n";
my $bar = <FOO>;
is($bar, 'ABCZ1234', 'Altered foo reflects on disk');

unlink($temp_file);
