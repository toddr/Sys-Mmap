#! perl

BEGIN {
    use strict;
    use warnings;
    use Test::More tests => 1;

    use_ok('Sys::Mmap');
}

use FileHandle;

my $temp_file = "mmap.tmp";

my $temp_file_contents = "0" x 1000; 
sysopen(FOO, $temp_file, O_WRONLY|O_CREAT|O_TRUNC) or die "$temp_file: $!\n";
print FOO $temp_file_contents;
close FOO;

# Perl was segfaulting when exiting after using a non zero offset
# The key here is that munmap was not done before exiting
my $foo;
sysopen(FOO, $temp_file, O_RDWR) or die "$temp_file: $!\n";
mmap($foo, 0, PROT_READ, MAP_SHARED, FOO, 256);

unlink($temp_file);
