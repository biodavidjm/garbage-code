#!/usr/bin/env perl

use Modern::Perl;
use autodie;

# I need to install the last version of Perl
say "Hello!";

  say "#$_" for 1 .. 10;

for (1 .. 10)
{
    say "#$_";
}

my @squares = map { $_ * $_ } 1 .. 10;
say for @squares;