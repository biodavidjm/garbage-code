#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBI;

my $command = "testing_dbi.pl";

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
my $dbh = DBI->connect( "dbi:Oracle:host=$host;sid=orcl;port=1521",
    $options{user}, $options{passwd},
    { RaiseError => 1, LongReadLen => 2**20 } );

# First test: Let's counting the number of organisms

my @result = $dbh->selectrow_array("SELECT count(*) FROM organism");
say "\tNumber of organisms at dicty: " . $result[0];

my $results = $dbh->prepare(
    "SELECT organism_id, common_name, genus, species FROM organism");
$results->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
print "\n\tThese organisms are: \n";
my %testhash = ();
while ( my @rows = $results->fetchrow_array() ) {
    my ( $oid, $specie_name, $genus, $species ) = @rows;
    $testhash{$oid} = [@rows];
    print "\t\t"
        . $oid . " "
        . $specie_name . " = "
        . $genus . " "
        . $species . "\n";
}

my $oresults = $dbh->prepare(
    "SELECT organism_id, common_name, genus, species  FROM organism");
$oresults->execute()
    or die "\n\nOh no! I could not execute: " . DBI->errstr . "\n\n";
while ( my @rows = $oresults->fetchrow_array() ) {

    foreach my $element (@rows) {
        print $element. " ";
    }
    print "\n";
}

print "\n\tNow print from the hash:\n";
foreach my $id ( sort { $a <=> $b } keys %testhash ) {
    print "\t\tSpecie_ID: $id - $testhash{$id}[1] ("
        . $testhash{$id}[2] . " "
        . $testhash{$id}[3] . "\n";
}

my @result2 = $dbh->selectrow_array(
    "SELECT COUNT(fcvt.feature_cvterm_id) annotations
FROM cgm_chado.feature_cvterm fcvt 
JOIN cgm_chado.feature gene ON gene.feature_id = fcvt.feature_id 
JOIN cgm_chado.cvterm type ON type.cvterm_id = gene.TYPE_ID 
JOIN cgm_chado.cvterm GO ON GO.cvterm_id = fcvt.cvterm_id 
JOIN cgm_chado.cv ON cv.cv_id = GO.cv_id
JOIN cgm_chado.organism ON organism.organism_id = gene.organism_id
WHERE  type.name = 'gene'
AND gene.is_deleted = 0
AND 
cv.name IN('molecular_function',   'biological_process',   'cellular_component')
AND GO.is_obsolete = 0
AND organism.common_name = 'dicty'"
);

say "\n\tCannonical query: " . $result2[0];

my @goann = $dbh->selectrow_array(
    "SELECT COUNT (DISTINCT fcvt.feature_id) gene_with_annotations
FROM CGM_CHADO.feature_cvterm fcvt
JOIN CGM_CHADO.feature_cvtermprop fcvt_prop ON fcvt_prop.feature_cvterm_id = fcvt.feature_cvterm_id
JOIN CGM_CHADO.cvterm evterm ON evterm.cvterm_id=fcvt_prop.type_id
JOIN CGM_CHADO.cv ev ON ev.cv_id=evterm.cv_id
JOIN CGM_CHADO.cvtermsynonym evsyn ON evterm.cvterm_id=evsyn.cvterm_id
JOIN CGM_CHADO.cvterm syn_type ON syn_type.cvterm_id = evsyn.type_id
JOIN CGM_CHADO.cv syn_cv ON syn_cv.cv_id = syn_type.cv_id
JOIN CGM_CHADO.feature gene ON gene.feature_id = fcvt.feature_id
JOIN CGM_CHADO.cvterm type ON type.cvterm_id = gene.type_id
JOIN organism organism ON organism.organism_id = gene.organism_id
WHERE gene.is_deleted = 0
AND type.name = 'gene'
AND ev.name like 'evidence_code%'
AND syn_type.name IN ('EXACT', 'RELATED', 'BROAD')
AND syn_cv.name = 'synonym_type'
AND organism.common_name = 'dicty'"
);

say "\tNumber of GO annotations: " . $goann[0];

say "\nGenerating GPI file\n";

$dbh->disconnect();
say "\nWe are done (and disconnected from DB). Bye bye!\n";

exit;
