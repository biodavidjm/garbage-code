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
SELECT dbxref.accession gene_id, gene.feature_id, gene.name
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

my %ddbg2gene_name    = ();
my %ddbg2locus_number = ();
my $count_prot_coding = 0;
my $unique            = 0;
my $duplications      = 0;

while ( my ( $DDB_G, $locus_no, $gene_name ) = $results->fetchrow_array ) {

    if ( !$ddbg2gene_name{$DDB_G} ) {
        $ddbg2gene_name{$DDB_G} = $gene_name;
        $unique++;
    }
    else {
        $duplications++;
    }
    $ddbg2locus_number{$DDB_G} = $locus_no;
    $count_prot_coding++;
}

say "Total number of DDB_G_ID: " . $unique;

# # ---------------------------------------------------
# # NUMBER OF CURATED MODELS
# # Just in case need to know the number of curated genes
# my $statement_curated = <<"STATEMENT";
# SELECT gene.name cgene_name, gacc.accession cgene_id
#    FROM cgm_chado.feature 
# 	   JOIN feature_dbxref fxref ON fxref.feature_id = feature.feature_id 
# 	   JOIN cgm_chado.dbxref ON dbxref.dbxref_id = fxref.dbxref_id 
# 	   JOIN cgm_chado.db ON db.db_id = dbxref.db_id 
# 	   JOIN cgm_chado.cvterm ON cvterm.cvterm_id = feature.TYPE_ID 
# 	   JOIN cgm_chado.feature_relationship frel ON frel.subject_id = feature.feature_id 
# 	   JOIN cgm_chado.feature gene ON gene.feature_id = frel.object_id
# 	   JOIN cgm_chado.dbxref gacc ON gene.dbxref_id=gacc.dbxref_id 
# 	   JOIN cgm_chado.cvterm gtype ON gtype.cvterm_id = gene.TYPE_ID 
# 	   JOIN cgm_chado.feature_relationship frel2 ON frel2.object_id = feature.feature_id 
# 	   JOIN cgm_chado.feature poly ON poly.feature_id = frel2.subject_id 
# 	   JOIN cgm_chado.cvterm ptype ON ptype.cvterm_id = poly.TYPE_ID
#    WHERE cvterm.name = 'mRNA'
# 	   AND ptype.name = 'polypeptide'
# 	   AND dbxref.accession = 'dictyBase Curator'
# 	   AND gtype.name = 'gene'
# 	   AND db.name = 'GFF_source'
# 	   AND feature.is_deleted = 0
# STATEMENT

# # database handle
# my $results_genescurated = $dbh->prepare($statement_curated);

# print ">Execute statement_ddb2uniprot ";
# $results_genescurated->execute()
#     or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
# print " done!!\n\n";

# my $curation = $results_genescurated->fetchall_arrayref();

# # ---------------------------------------------------



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Map DDB_G_ID to Uniprot IDs.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
my $statement_ddb2uniprot = <<"STATEMENT";
SELECT gxref.accession geneid, dbxref.accession uniprot
FROM dbxref
	JOIN db ON db.db_id = dbxref.db_id
	JOIN feature_dbxref fxref ON fxref.dbxref_id = dbxref.dbxref_id
	JOIN feature polypeptide ON polypeptide.feature_id = fxref.feature_id
	JOIN feature_relationship frel ON polypeptide.feature_id = frel.subject_id
	JOIN feature transcript ON transcript.feature_id = frel.object_id
	JOIN feature_relationship frel2 ON frel2.subject_id = transcript.feature_id
	JOIN feature gene ON frel2.object_id = gene.feature_id
	JOIN cvterm ptype ON ptype.cvterm_id = polypeptide.type_id
	JOIN cvterm mtype ON mtype.cvterm_id = transcript.type_id
	JOIN cvterm gtype ON gtype.cvterm_id = gene.type_id
	JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE 
	ptype.name = 'polypeptide'
	AND	mtype.name = 'mRNA'
	AND	gtype.name = 'gene'
	AND	db.name = 'DB:SwissProt'
STATEMENT

# database handle
my $results_ddb2uniprot = $dbh->prepare($statement_ddb2uniprot);

print ">Execute statement_ddb2uniprot ";
$results_ddb2uniprot->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print " done!!\n\n";

my $rowddb2uniprot = $results_ddb2uniprot->fetchall_arrayref();

# hash to store
my %hash_ddb2uniprot = ();
my %hash_uniprot2ddb = ();

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
}

my $number_ddb2uniprot = keys %hash_ddb2uniprot;
my $number_uniprot2ddb = keys %hash_uniprot2ddb;

print "\t-DDB_G ids with Uniprot IDS: " . $number_ddb2uniprot . "\n";
print "\t-Uniprots ids with DDB_Gs  : " . $number_uniprot2ddb . "\n";

my $incremental = 0;
for my $ddb ( keys %hash_ddb2uniprot ) {
	
	my $number = keys %{$hash_ddb2uniprot{$ddb}};
	if ($number > 1)
	{
		print $ddb." --> ". $number." ";
		# for my $uni (sort keys %{$hash_ddb2uniprot{$ddb}})
		for my $uni (sort keys %{$hash_ddb2uniprot{$ddb}} )
		{
			print $uni." (". $hash_ddb2uniprot{$ddb}{$uni}."), " ;
		}
		print "\n";
		
	}
	$incremental += $number;

}

print "DDB_Gs are: ".$number_ddb2uniprot." with a total of ".$incremental."\n";

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



