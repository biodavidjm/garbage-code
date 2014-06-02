#!/usr/bin/env perl

# Testing Modern Perl

use Cat;
use feature qw/say/;

my $name = "Rodrigo";

my $cat = Cat->new(
    name => $name,
    diet => 'queso',
    birth_year  => 2000,

);

$cat->diet("atún");
$cat->print_out_details;

# If we don't provide the age, then it will automatically be assigned
my $newkitty = Cat->new(name=>'Pepito');
say "\nOur new kitty cat ",$newkitty->name," is ",$newkitty->age;

