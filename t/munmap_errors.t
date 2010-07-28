#!perl

use strict;
use warnings;
use Test::More tests => 2;

use Sys::Mmap;

{ 
    my $foo;
    eval {munmap($foo)};
    like($@, qr/^map pointer is not a string/, "munmap detects undef strings");
}

{ 
    my $foo = "";
    eval {munmap($foo)};
    is($@, "munmap failed! errno 22 Invalid argument\n", "Unmapped strings die");
}
