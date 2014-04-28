#!/usr/bin/perl -w

use POSIX;
use strict;
use feature qw/say/;
use warnings;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;

my $command = "sql-get-columns-in-table.pl";

# Validation section
my %options;
GetOptions( \%options, 'dsn=s', 'user=s', 'passwd=s', 'table=s' );
for my $arg (qw/dsn user passwd/) {

    # print "\n\tError: Arguments required! Example:\n";
    die
        "\tperl $command -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD -table=TABLE_NAME\n\n"
        if not defined $options{$arg};
}

my $host  = $options{dsn};
my $user  = $options{user};
my $pass  = $options{passwd};
my $table = $options{table};

# Connecting to the Database
print "Connect to the database, ";
my $dbhchado = DBI->connect( "dbi:Oracle:host=$host;sid=orcl;port=1521",
    $options{user}, $options{passwd},
    { RaiseError => 1, LongReadLen => 2**20 } );

# Database setup
my $statement = "
select   t.table_name
         , t.column_name
         , t.data_type
    from user_tab_columns t
    left join user_cons_columns cc
       on (cc.table_name = t.table_name and
           cc.column_name = t.column_name)
     where t.table_name in (\'$table\')
";

# my $statement = '
# select   t.table_name
#          , t.column_name
#          , t.data_type
#     from user_tab_columns t
#     left join user_cons_columns cc
#        on (cc.table_name = t.table_name and
#            cc.column_name = t.column_name)
# ';

print "execute statement ";
my $results = $dbhchado->prepare($statement);
$results->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print "...done\n";

print "Searching $table on CGM_CHADO:\n";
my @row;

# ADD all the info to a hash
my %hashtables = ();
my $c          = 0;
while ( @row = $results->fetchrow_array() ) {
    if ( $row[0] ) {
        $hashtables{ $row[0] }{ $row[1] } = $row[2];
        my $column = $row[1];
        print $row[0] . " " . $column . "\t";

        my @howmany = $dbhchado->selectrow_array(
            "SELECT count('$column') FROM $table");
        if ( $howmany[0] ) {
            print $howmany[0] . "\n";
        }
        else {
            print "Count not available\n";
        }
        $c++;
    }
}
warn "Data fetching terminated early by error: $DBI::errstr\n"
    if $DBI::err;

if ( $c == 0 ) {
    print "... This table is not on CGM_CHADO\n";
}

$dbhchado->disconnect();

print "----------------------------------------\n";

# Searching on CGM_DDB
# ---------------------------------------------------------

#Connecting to CGM_DDB Database
print "\nConnect to CGM_DDB, ";
my $dbhddb = DBI->connect(
    "dbi:Oracle:host=dicty-oracle-vm.nubic.northwestern.edu;sid=orcl;port=1521",
    "CGM_DDB", "CGM_DDB", { RaiseError => 1, LongReadLen => 2**20 }
);

print "execute statement ";
my $resultddb = $dbhddb->prepare($statement);
$resultddb->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print "...done\n";

print "Searching $table on CGM_DDB:\n\n";
my @rowddb;

my $cc = 0;
while ( @rowddb = $resultddb->fetchrow_array() ) {
    if ( $rowddb[0] ) {
        $hashtables{ $rowddb[0] }{ $rowddb[1] } = $rowddb[2];
        my $column = $rowddb[1];
        print $rowddb[0] . " " . $column . "\t";

        my @howmany
            = $dbhddb->selectrow_array("SELECT count('$column') FROM $table");
        if ( $howmany[0] ) {
            print $howmany[0] . "\n";
        }
        else {
            print "0\n";
        }
        $cc++;
    }
}
warn "Data fetching terminated early by error: $DBI::errstr\n"
    if $DBI::err;

if ( $cc == 0 ) {
    print "... This table is not on CGM_DDB\n";
    next;
}

$dbhchado->disconnect();

exit;

=head1 NAME

sql-get-columns-in-table.pl - Print all the columns in a given table, in both CHADO and DDB


=head1 SYNOPSIS

perl sql-get-columns-in-table.pl -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD -table=TABLE_NAME

=head1 DESCRIPTION

Get all the columns found in a table, including the number of elements in the table.
