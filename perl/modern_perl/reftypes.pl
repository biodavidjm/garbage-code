#!/usr/bin/perl


# Let's find out the type of reference that we have

use warnings;
use strict;

my $a = [];
my $b = {};
my $c = \1;
my $d = \$c;

print '$a is a ', ref $a, " reference\n";
print '$b is a ', ref $b, " reference\n";
print '$c is a ', ref $c, " reference\n";
print '$d is a ', ref $d, " reference\n";

=head1 NAME

reftypes.pl -> Print the type of reference, please.

=head1 DESCRIPTION

Do you want to know the type of references? use the "ref" operator.

=head1 AUTHOR

@biodavidjm
