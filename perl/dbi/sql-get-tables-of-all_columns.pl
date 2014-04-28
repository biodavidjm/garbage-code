#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;

my $command = "sql-get-tables-of-all_columns.pl";

# Validation section
my %options;
GetOptions( \%options, 'dsn=s', 'user=s', 'passwd=s' );
for my $arg (qw/dsn user passwd/) {

    # print "\n\tError: Arguments required! Example:\n";
    die "\tperl $command -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD\n\n"
        if not defined $options{$arg};
}

my $host = $options{dsn};
my $user = $options{user};
my $pass = $options{passwd};

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
";

print "execute statement ";
my $resultschado = $dbhchado->prepare($statement);
$resultschado->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print "...done!\n";

# ADD all the info to a hash
my %hashtables  = ();
my %hashcolumns = ();

my @row;

while ( @row = $resultschado->fetchrow_array() ) {
    if ( $row[0] ) {
        unless ( $row[0] =~ /V_.*/ ) {

            my $table  = $row[0];
            my $column = $row[1];

            # my @howmany;

# @howmany = $dbhchado->selectrow_array("SELECT count('$column') FROM $table");
# my @temp;
# if ($howmany[0])
# {
#   @temp = ($howmany[0],$row[2]);
# }
# else
# {
#   @temp = (0,$row[2]);
# }
            $hashtables{$table}{$column}  = $row[2];
            $hashcolumns{$column}{$table} = $row[2];
        }
    }

}
warn "Data fetching terminated early by error: $DBI::errstr\n"
    if $DBI::err;

# Print tables
my $outfile = "dicty_ddb_chado_info.csv";

open my $out, '>', $outfile
    or die "Big problem: I can't create '$outfile'";

print {$out} "TABLE\tCOLUMN\tDATA_TYPE\tOther_Tables\n";

#pppppppppppppppppppppppppppppppppppppppppppprint
for my $tables ( sort keys %hashtables ) {

    # my $count = keys %{$hashtables{$tables}};
    for my $columns ( sort keys %{ $hashtables{$tables} } ) {
        print {$out} $tables . "\t"
            . $columns . "\t"
            . $hashtables{$tables}{$columns} . "\t";
        for my $tab ( sort keys %{ $hashcolumns{$columns} } ) {
            unless ( $tab eq $tables ) {
                print {$out} "$tab\t";
            }

        }
        print {$out} "\n";
    }
}

#pppppppppppppppppppppppppppppppppppppppppppprint

close {$out};

$dbhchado->disconnect();
print "Done!\n\n";
exit;

=head1 NAME

sql-get-tables-of
-all_columns.pl - Print all tables columns and data type plus
the table(s) where the same column can be found.


=head1 SYNOPSIS


perl sql_get_tables_of_column.pl -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD


=head1 DESCRIPTION

It generates a print out with the info of all the tables, columns (and data type).
It also prints for every column the tables where that same column can be found.

=head1 OUTPUT

The output is the file: dicty_ddb_chado_info.csv

