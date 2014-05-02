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

# Validation section
my %options;
GetOptions( \%options, 'dsn=s', 'user=s', 'passwd=s' );
for my $arg (qw/dsn user passwd/) {

    # print "\n\tError: Arguments required! Example:\n";
    die
        "\tperl gen_gpi_file.pl -dsn=ORACLE_DNS -user=USERNAME -passwd=PASSWD\n\n"
        if not defined $options{$arg};
}

my $host = $options{dsn};
my $user = $options{user};
my $pass = $options{passwd};

# Connecting to the Database
print "Connecting to the database... ";
my $dbh = DBI->connect( "dbi:Oracle:host=$host;sid=orcl;port=1521",
    $options{user}, $options{passwd},
    { RaiseError => 1, LongReadLen => 2**20 } );

print " done!!\n";

my $statement = <<"STATEMENT";
SELECT DISTINCT dbxref.accession gene_id, gene.feature_id, gene.name
FROM cgm_chado.feature gene
JOIN organism ON organism.organism_id=gene.organism_id
JOIN dbxref on dbxref.dbxref_id=gene.dbxref_id
JOIN cgm_chado.cvterm gtype on gtype.cvterm_id=gene.type_id
JOIN cgm_chado.feature_relationship frel ON frel.object_id=gene.feature_id
JOIN cgm_chado.feature mrna ON frel.subject_id=mrna.feature_id
JOIN cgm_chado.cvterm mtype ON mtype.cvterm_id=mrna.type_id
WHERE gtype.name='gene' 
        AND mtype.name='mRNA' 
        AND organism.common_name = 'dicty' 
        AND gene.is_deleted = 0 
        AND gene.name NOT LIKE '%\\_ps%' ESCAPE '\\'
STATEMENT

print "> Execute statement... ";

my $results = $dbh->prepare($statement);
$results->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";

say " done!!";

my %hash_ddbg2gene_name    = ();
my %ddbg2locus_number = ();
my $count_prot_coding = 0;
my $unique            = 0;
my $duplications      = 0;

while ( my ( $DDB_G, $locus_no, $gene_name ) = $results->fetchrow_array ) {

    if ( !$hash_ddbg2gene_name{$DDB_G} ) {
        $hash_ddbg2gene_name{$DDB_G} = $gene_name;
        $unique++;
    }
    else {
        $duplications++;
    }
    $ddbg2locus_number{$DDB_G} = $locus_no;
    $count_prot_coding++;
}

say "Wiki SQL gets: " . $unique . " ddb_g ids";
say "duplications are : ".$duplications;


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Map DDB_G_ID to Uniprot IDs.
# Load the gp2protein file
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
my $filename = "gp2protein.dictyBase";
open my $FILE, '<', $filename or die "Cannot open '$filename'!\n";

my %hash_gp2protein = ();

# stats
my $c_file  = 0;
my $c_regex = 0;

foreach my $line (<$FILE>) {
    chomp($line);
    if ( $line =~ /dictyBase:(\S+)\s+UniProtKB:(\w{6})/ ) {
        my $ddb = $1;
        my $uni = $2;

        # say $ddb. "--->" . $uni;
        if ( !$hash_gp2protein{$ddb} ) {    
            $hash_gp2protein{$ddb} = $uni;
            $c_regex++;
        }
        else {
            die "\n\nOooops " . $line . " is repeated!!\n";
        }
    }
}
my $numberdeloscojones = keys %hash_gp2protein;
say "gp2protein.dictyBase gets: " . $c_regex . " DDB_G ids";
say "gp2protein.dictyBase gets: " . $numberdeloscojones . " DDB_G ids";

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Map DDB_G_ID to Uniprot IDs.
# Approach all first.
# - Get all the ddb_g -> uniprots id from the dictybase
# - Map the ddb_g ids from coding genes previously obtained
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

my $statement_ddb2uniprot = <<"STATEMENT";
SELECT gxref.accession geneid, dbxref.accession uniprot
FROM dbxref
    JOIN db ON db.db_id = dbxref.db_id
    JOIN feature_dbxref fxref ON fxref.dbxref_id = dbxref.dbxref_id
    JOIN feature polypeptide ON polypeptide.feature_id = fxref.feature_id
    JOIN feature_relationship frel ON polypeptide.feature_id = frel.subject_id
    JOIN feature transcript ON transcript.feature_id = frel.object_id
    JOIN feature_dbxref fxref2 ON fxref2.feature_id = transcript.feature_id
    JOIN dbxref dbxref2 ON fxref2.dbxref_id = dbxref2.dbxref_id
    JOIN db db2 ON db2.db_id = dbxref2.db_id
    JOIN feature_relationship frel2 ON frel2.subject_id = transcript.feature_id
    JOIN feature gene ON frel2.object_id = gene.feature_id
    JOIN cvterm ptype ON ptype.cvterm_id = polypeptide.type_id
    JOIN cvterm mtype ON mtype.cvterm_id = transcript.type_id
    JOIN cvterm gtype ON gtype.cvterm_id = gene.type_id
    JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE 
    ptype.name = 'polypeptide'
    AND mtype.name = 'mRNA'
    AND gtype.name = 'gene'
    AND db2.name = 'GFF_source'
    AND db.name = 'DB:SwissProt'
    AND dbxref2.accession = 'dictyBase Curator'
    AND transcript.is_deleted = 0
STATEMENT

# database handle
my $results_ddb2uniprot = $dbh->prepare($statement_ddb2uniprot);

print "\n>Execute statement_ddb2uniprot ";
$results_ddb2uniprot->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print " done!!\n";

my $rowddb2uniprot = $results_ddb2uniprot->fetchall_arrayref();

# hash to store
my %hash_ddb2uniprot = ();
my %hash_uniprot2ddb = ();
my %hash_siddOnlyddbs = ();

# check point charlie
my %noredundancies = ();
my $cred           = 1;

# Transverse
foreach my $lineddb (@$rowddb2uniprot) {
    my ( $ddb_g, $uniprot_id ) = @$lineddb;
    chomp($ddb_g);
    chomp($uniprot_id);

    if ( !$hash_ddb2uniprot{$ddb_g}{$uniprot_id} ) {

        $hash_ddb2uniprot{$ddb_g}{$uniprot_id} = 1;

    }

    if ( !$hash_uniprot2ddb{$uniprot_id}{$ddb_g} ) {

        $hash_uniprot2ddb{$uniprot_id}{$ddb_g} = 1;
    }

    if ( !$hash_siddOnlyddbs{$ddb_g} ) {
        $hash_siddOnlyddbs{$ddb_g} = $uniprot_id;
    }
}

my $number_siddsql = keys %hash_siddOnlyddbs;
say "SQL by Sidd gets: ".$number_siddsql;

my $c_similar = 0;
my $c_different = 0;
my $total = 0;

say "\n>Different between SiddSQL and dp2protein file: ";
for my $ddb ( keys %hash_ddb2uniprot ) {
    $total++;
    my $number = keys %{ $hash_ddb2uniprot{$ddb} };
    if ( $number > 1 ) {
        print $ddb. " --> ";

        for my $uni ( sort keys %{ $hash_ddb2uniprot{$ddb} } ) {
            print $uni. " ";
        }
        say " --db2protein--picks-----> " . $hash_gp2protein{$ddb};
    }
    elsif ( $number == 1 ) {

        my $uni1 = '';
        for my $uni ( sort keys %{ $hash_ddb2uniprot{$ddb} } ) {
            $uni1 = $uni;
        }

        my $uni2 = '';
        $uni2 = $hash_gp2protein{$ddb};
        if ($uni2) {
            if ( $uni1 ne $uni2 ) {
                print "For "
                    . $ddb
                    . ", SQL gets: "
                    . $uni1
                    . " and gp2protein: "
                    . $uni2 . "\n";
                    $c_different++;
            }
            else
            {
                $c_similar++;
            }
        }
    }
}

say "Similar:   ".$c_similar;
say "Different: ".$c_different;
say "Total:     ".$total;

say "\nChecking again, final assesment";

my $c_aredifferent = 0;
my $c_same = 0;
my $total_aqui = 0;
my $tellmeagain = keys %hash_gp2protein;
say "I am going through a hash of ".$tellmeagain;

for my $line (keys %hash_gp2protein) {
    $total_aqui++;
    if ( !$hash_siddOnlyddbs{$line} ) {
        $c_aredifferent++;
        # print $line." ";
    }
    else {
        $c_same++;
    }
}
say "\n\ngp2protein file has ".$c_same." similar ddb_g ids to Sidd SQL";
say "gp2protein file has an additional ".$c_aredifferent." ddb_g no selected from the Sidd SQL";
say "the total must be ".$total_aqui;

my $co_same = 0;
my $co_nosame = 0;
for my $line ( keys %hash_ddbg2gene_name)
{
    if ( $hash_gp2protein{$line} ) {
        $co_same++;
    }
    else {
        $co_nosame++;
        print $line."\n";
    }
}

say "Wiki SQL has this similar: ".$co_same;
say "but I got these extra ".$co_nosame;


exit;

=head1 NAME

ddbg2uniprot.pl - Digging into the problem of ddb_G ---> uniprot id


=head1 SYNOPSIS

perl ddbg2uniprot.pl  --dsn=<Oracle DSN> --user=<Oracle user> --passwd=<Oracle password>


=head1 OPTIONS

 --dsn           Oracle database DSN
 --user          Database user name
 --passwd        Database password


=head1 DESCRIPTION

Connect to the dictyOracle database and dump to a file
(YYYYMMDD_HHMMSS.gpi_dicty) the following information:

Columns:

name                   required? cardinality   GAF column
DB_Object_ID           required  1             2/17      
DB_Object_Symbol       required  1             3         
DB_Object_Name         optional  0 or greater  10        
DB_Object_Synonym(s)   optional  0 or greater  11        
DB_Object_Type         required  1             12        
Taxon                  required  1             13        
Parent_Object_ID       optional  0 or 1        -         
DB_Xref(s)             optional  0 or greater  -         
Properties             optional  0 or greater  -         

=head1 DETAILS

The script uses four different SQL statements:

Statement 1: Main query. It selects gene name, gene synonym and protein
synonym, DDB_G ID, excluding delete genes

Statement 2: statement_splitgenes. It selects split genes. It was going to be
used as a filter (parsing them out), but it was advised to include them in the
output

Statement 3: statement_gene_product. It selects gene products. For those genes
with several gene products, the newest one is selected.

Statement 4: statement_ddb2uniprot. It maps DDB_G_ID into Uniprot IDs. There
are some problems

=head1 ISSUES

Statement 3 needs to be revised. According to the curation statistics, there
should be ~9,000 gene products. However this script gets less.



