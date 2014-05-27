#!/usr/bin/perl

use strict;
use warnings;
use Artist1;

# Initialize the object without arguments
# my $group = Artist->new();

my $object = Artist->new (
	band  => "Radiohead",
	album => "OK Computer",
	year  => "1997",
	style => "Alternative Pop-Rock"
);

print "The band's name is ", $object->get_name, "\n";

print "the band's title is ", $object->album(), "\n";
$object->album("It might be wrong");
print "the band's title is ", $object->album(), "\n";
print "year = ", $object->year(),"\n";
print "and the style ", $object->style(),"\n";
$object->style("Alternative Electronic-Pop-Rock");
print "and the style ", $object->style(),"\n";

