#!perl

use strict;
use warnings;
use Test::More tests => 12;

use Sys::Mmap;

{
    my $foo;
    eval {munmap($foo)};
    like($@, qr/^map pointer is not a string/, "munmap detects undef perl variables and fails");
}

foreach my $foo ("", "1234", "1.232", "abcdefg" ){
    eval {munmap($foo)};
    is($@, "munmap failed! errno 22 Invalid argument\n", "Unmapped strings die");
}

foreach my $foo (-1283843, -1, 0, 1, 2222131, 2.3451, -1213.12 ){
    eval {munmap($foo)};
    like($@, qr/^map pointer is not a string/, "munmap detects ints and floats and fails");
}
