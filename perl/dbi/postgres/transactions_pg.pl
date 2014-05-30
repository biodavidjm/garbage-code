#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;

system('clear');
say "\nHello and welcome to this testing script\n";

# Connect to the testing dabase at localhost
# my $dbname = "dicty_chado";
my $dbname = "bpsimple";

my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname", "djt469", "" )
    or die "Couldn't connect to database: " . DBI->errstr;

# Querying the database

$dbh->disconnect;

sub new_employee {

    my ( $dbh, $first, $last, $address, $town, $zipcode, $phone ) = @_;
    my ( $insert_handle, $update_handle );
    my $insert_handle
        = $dbh->prepare_cached('INSERT INTO customers VALUES (?,?,?,?,?,?)');
    
  #   my $update_handle = $dbh->prepare_cached (
  #       'UPDATE orderinfo 
		# SET whatever
		# WHERE id = ?'
  #   );
  #   die "Couldn't prepare queries; aborting"
  #       unless defined $insert_handle && defined $update_handle;

    my $success = 1;
    $success &&= $insert_handle->execute( $first, $last, $address, $town, $zipcode, $phone );
    # $success &&= $update_handle->execute($department);

    my $result = ( $success ? $dbh->commit : $dbh->rollback );
    
    unless ($result) {
        die "Couldn't finish transaction: " . $dbh->errstr;
    }
    return $success;
}
