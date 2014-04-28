#!/usr/bin/perl -w

use POSIX;
use strict;
use feature qw/say/;
use warnings;

use DBI;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;
use Text::CSV;

my $command = "run_sqls.pl";

# Validation section
my %options;
GetOptions( \%options, 'dsn=s', 'user=s', 'passwd=s');
for my $arg (qw/dsn user passwd/)
{
	# print "\n\tError: Arguments required! Example:\n";
	die "\tperl run_sqls.pl -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD\n\n" if not defined $options{$arg};
}

my $host = $options{dsn};
my $user = $options{user};
my $pass = $options{passwd};

# Connecting to the Database
print "Connect to the database, ";
my $dbh = DBI -> connect("dbi:Oracle:host=$host;sid=orcl;port=1521", $options{user}, $options{passwd}, 
	{ RaiseError => 1, LongReadLen => 2**20 } );


# Database setup
# Select gene name, gene synonym and protein synonym, DDB_G ID
# Excluding pseudogenes
my $statement = '
select   t.table_name
         , t.column_name
         , t.data_type
    from user_tab_columns t
    left join user_cons_columns cc
       on (cc.table_name = t.table_name and
           cc.column_name = t.column_name)
';

 # SELECT
 #      TABLE_NAME
 #   FROM
 #      ALL_TABLES
 #   WHERE
 #      TABLE_NAME LIKE '%PATTERN_TO_FIND%'
 #   ORDER
 #      BY TABLE_NAME;

print "execute statement ";
my $results = $dbh->prepare($statement);
$results->execute() or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print "...done\n";


# ADD all the info to a hash
my %hashtables = ();
my %hashcolumns = ();
my @row;

while (@row = $results->fetchrow_array() )
{
	# foreach (@row) {$_ = '' unless defined}; # Check point Charlie
	if ($row[0])
	{
		$hashtables{$row[0]}{$row[1]} = $row[2];
		$hashcolumns{$row[1]}{$row[0]} = $row[2];
	}

}
warn "Data fetching terminated early by error: $DBI::errstr\n"
      if $DBI::err;


# OUTPUT FILE
# - - - - - - - - - - - - - - - - -
# Output file name (uses date & time)
# my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
# my $ymd = sprintf("%04d%02d%02d_%02d%02d%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
# my $outfile = "$ymd.name";
# open (FILE, ">".$outfile);


my $p = 0; #I'll use it at the end

# Print tables
#pppppppppppppppppppppppppppppppppppppppppppprint
for my $tables (sort keys %hashtables)
{
   for my $columns ( sort keys %{$hashtables{$tables}}) 
    {
    	print  $tables."\t".$columns."\t".$hashtables{$tables}{$columns}."\n";
    }
}
#pppppppppppppppppppppppppppppppppppppppppppprint

# Print columns
for my $col (sort keys %hashcolumns)
{
	print $col." -> ";
	for my $tab (sort keys %{$hashcolumns{$col}})
	{
		print "$tab\t";
	}
	print "\n";
}

$dbh->disconnect();


=head1 NAME

run_sqls.pl - Testing SQL commands before using them


=head1 SYNOPSIS

perl run_sqls.pl  --dsn=<Oracle DSN> --user=<Oracle user> --passwd=<Oracle password>


=head1 OPTIONS

 --dsn           Oracle database DSN
 --user          Database user name
 --passwd        Database password

=head1 DESCRIPTION

General script just for testing purposes