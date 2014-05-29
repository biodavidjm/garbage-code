#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;

# Connect to the localhost
# my $dbname = "dicty_chado";
my $dbname = "bpsimple";

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname", "djt469", "");

# Querying the database
my @result = $dbh->selectrow_array("SELECT count(*) FROM customer");
say "\tNumber of customer at $dbname: " . $result[0];

my $results = $dbh->prepare("SELECT * FROM customer");
$results->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";

print "\n\tThese organisms are: \n";

while ( my @rows = $results->fetchrow_array() ) {
    my ( $oid, $ab, $fname, $lname ) = @rows;

    print "\t\t"
        . $oid . " -> "
        . $ab . " "
        . $fname . " "
        . $lname . "\n";
}

