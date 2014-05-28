#!/usr/bin/perl

use strict;
use warnings;
# use Artist1;
use Shows1;
use feature qw/say/;

# Initialize the object without arguments
# my $group = Artist->new();

my $object = Artist->new (
	name  => "Radiohead",
	album => "OK Computer",
	year  => "1997",
	style => "Alternative Pop-Rock"
);



print "the band's name is ", $object->name(), "\n";

# Set a new album
# $object->album("It might be wrong");

print "the band's album title is ", $object->album(), "\n";
print "in ", $object->year(),"\n";
print "and the style ", $object->style(),"\n";

print "and this has been accessed ", $object->counting()," time(s)\n";
print "or we can say again with a differen method ", $object->counting_a()," times\n";

$object = Artist->new (
	name  => "The Cure",
	album => "Bloodflowers",
	year  => "2000",
	style => "Alternative Pop-Rock"
);

say "Band: ",$object->name();
say "Album: ",$object->album();
say "Year: ",$object->year();
say "Style: ",$object->style();

say "Number of time accessed: ", $object->counting;
say "It should get as well the same number ", $object->counting_a();

say "And now let's print all them out:";
for my $bands(Artist->all_names) {
	print $bands->name, " ", $bands->album, " ", $bands->year,"\n";
}

my $band_object = Shows->new (
	name  => "Coldplay",
	album => "Viva la Vida",
	year  => "2006",
	style => "Pop-Rock",
	city => "London",
	country => "England",
	show_date => "06/23/2014",
	tickets => "50"
);

say "The new band is:";
say "Band: ",$band_object->name();
say "Album: ",$band_object->album();
say "Year: ",$band_object->year();
say "Style: ",$band_object->style();

say "and they have a show in ",$band_object->city()," (",$band_object->country(),") on ",
$band_object->show_date(), " and the price of the ticket is ", $band_object->tickets();
say "although, wait a second:  it has been increased. The new price is: ", $band_object->increase_price->tickets, "\n";


