#!/usr/bin/perl

use strict;
use warnings;
use Artist1;

my $group = Artist->new();

my $object = Artist->new (
	band  => "Radiohead",
	album => "OK Computer",
	year  => "1997"
);

print "The band's name is ", $object->get_name, "\n";

