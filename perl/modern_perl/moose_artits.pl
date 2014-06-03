#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/say/;

use ShowMoose;

say "\nHello Music fans!";

my $cero = ShowMoose->new(
    band  => '091',
    album => 'Todo lo que vendrá después',
    year  => '1996',
    # style => 'Granaino Puro',
);

$cero->print_details();

say "\nWait, the new style of ",$cero->band," is ", $cero->style("Granaino puro");

$cero->print_details();

$cero->rating(5);
$cero->get_rating();

say "\nPrinting out everything again:";
$cero->print_details();

my $radiohead = ShowMoose->new(
    band  => 'Radiohead',
    album => 'Ok Computer',
    year  => '2000',
    style => 'Alternative Pop-Rock',
    rating => 5
);

$radiohead->print_details();


=head1 DESCRIPTION
Testing Modern Perl by remaking the test_artist.pl package. 

This script is testing

- Moose
- Create arguments
- Create "Attribute constraints" (subtypes, from use Moose::Util::TypeConstraints;)
- Inheritance (ShowMoose inherits from ArtistMoose)


