#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;

system('clear');
say "\nHello and welcome to this testing script\n";
# Connect to the localhost
# my $dbname = "dicty_chado";
my $dbname = "bpsimple";

my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname", "djt469", "" )
    or die "Couldn't connect to database: " . DBI->errstr;

# Querying the database

# Let's just count:
my @result = $dbh->selectrow_array("SELECT count(*) FROM customer");
say "\tNumber of customers at the database '$dbname': " . $result[0];

my $results = $dbh->prepare("SELECT * FROM customer");
$results->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";

print "\n\tAnd this is the full list of customers: \n";

while ( my @rows = $results->fetchrow_array() ) {
    my ( $oid, $ab, $fname, $lname ) = @rows;
    print "\t\t" . $oid . " -> " . $ab . " " . $fname . " " . $lname . "\n";
}

my $sth = $dbh->prepare('SELECT * FROM customer WHERE fname = ?')
    or die "Couldn't prepare statement: " . $dbh->errstr;

print "\n\tPlease, enter a First Name (warning: case sensitive!)> ";
while (my $userinput = <> ) {
    my @data;
    chomp $userinput;

    if (!$userinput) {
    	print "\n\t\tWhy an empty line??? Try again please\n";
    }
    else {

	    if ($userinput eq 'q') {
	    	die "\n\tBYE BYE, dear user, have a good day!\n\n";
	    }

	    $sth->execute($userinput)
	        or die "Couldn't execute statement: " . $sth->errstr;

	    # Read the matching records and print them out
	    while ( @data = $sth->fetchrow_array() ) {
	        my $customer_id = $data[0];
	        my $title = $data[1];
	        my $firstname = $data[2];
	        my $lname = $data[3];
	        my $town = $data[5];
	        print "\tCustomer:$customer_id:\t $title $firstname $lname from $town\n";
	    }

	    if ( $sth->rows == 0 ) {
	        print "\n\tHey! there is no `$userinput' in our database.\n\t(please, notice the search is case sensitive)\n";
	    }

	    $sth->finish;
	}
    print "\n";
    print "\tEnter name (or 'q' for exit)> ";
}

$dbh->disconnect;

