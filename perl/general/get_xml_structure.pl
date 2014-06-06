#!/usr/bin/perl -w

use strict;
use feature qw/say/;
use XML::Simple;
use Data::Dumper;

my $command = "get_xml_structure.pl";
if (@ARGV != 1)
{
        print "\n\t!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
        print "\tUsage: $command XML_file\n";
        print "\t!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n";
        exit;
}

my $filename = $ARGV[0];
die "Is this a XML file for sure? I cannot see the extension" if ($filename !~ /.*.xml/);

say "Ready to process the file ".$filename;

my $ref = XMLin($filename);


