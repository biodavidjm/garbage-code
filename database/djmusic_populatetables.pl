#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;
use Text::CSV;

# system('clear');

my $script_name = "djmusic_populatetables.pl";

# Validation section
my %options;
GetOptions( \%options, 'f=s' );
for my $arg (qw/f/) {
    die "\tERROR!!\n\tperl $script_name -f=FILE\n\n"
        if not defined $options{$arg};
}

my $filename = $options{f};
say "Ready to open " . $filename;
my $FILE1 = get_file($filename);

my $flag     = 0;
my $c_dict   = 0;
my $flag_end = 0;

my ( $name, $band, $album, $year, $duration) = '';

# STATS
my $c_total = 0;
my $c_podcasts = 0;
my $c_itunesu = 0;
my $c_movie = 0;
my $c_tvshow = 0;

my $c_name = 0;
my $c_year = 0;
my $c_artist = 0;
my $c_duration = 0;

foreach my $line (<$FILE1>) {
    chomp($line);
    if ( ( $line =~ /<dict>/ ) & ( $c_dict != 3 ) ) {
        $c_dict++;
        if ( $c_dict == 3 ) {
            say "yeeeep";
            $flag = 1;
            next;
        }
    }

    if ( ( $line =~ /<dict>/ ) & ( $c_dict == 3 ) ) {
        $flag = 1;
        next;
    }

    if ( $flag == 1 ) {
        if ( $line =~ /<key>Name<\/key><string>(.*)<\/string>/ ) {
            $name = $1;
            $c_name++;
            next;
        }
        if ( $line =~ /<key>Artist<\/key><string>(.*)<\/string>/ ) {
            $band = $1;
            $c_artist++;
            next;
        }
        if ( $line =~ /<key>Album<\/key><string>(.*)<\/string>/ ) {
            $album = $1;
            next;
        }
        if ( $line =~ /<key>Year<\/key><integer>(.*)<\/integer>/ ) {
            $year = $1;
            $c_year++;
            next;
        }
        if ( $line =~ /<key>Total Time<\/key><integer>(.*)<\/integer>/ ) {
            $duration = $1;
            $c_duration++;
            next;
        }


        # DO NOT PROCESS:
        # PODCASTS -
        if ($line =~ /<key>Podcast<\/key><true\/>/)
        {
            $flag = 0;
            ($name,$band,$album,$year ) = '';
            $c_podcasts++;
        }
        # ITUNESU -
        if ($line =~ /<key>iTunesU<\/key><true\/>/)
        {
            $flag = 0;
            ($name,$band,$album,$year ) = '';
            $c_itunesu++;
        }
        # MOVIES -
        if ($line =~ /<key>Movie<\/key><true\/>/)
        {
            $flag = 0;
            ($name,$band,$album,$year ) = '';
            $c_movie++;
        }
        # TV show -
        if ($line =~ /<key>TV Show<\/key><true\/>/)
        {
            $flag = 0;
            ($name,$band,$album,$year ) = '';
            $c_tvshow++;
        }
    }
    if ( ( $line =~ /<\/dict>/ ) & ( $flag == 1 ) ) {
        $flag = 0;
        if ($name) {
            if ($band) {
                if ($album) {
                    my $album_year = '';
                    $album_year = check_empty($year);
                    my $song_duration = '';
                    $song_duration = check_empty($duration);

                        say "Artist: "
                            . $band
                            . ";\tAlbum: "
                            . $album
                            . ";\tSong name: "
                            . $name
                            . ";\tYear: "
                            . $album_year
                            . ";\tDuration: "
                            . $song_duration;

                            $c_total++;
                            
                }
            }
        }
        ( $name,$band,$album,$year ) = '';
    }
}


say "Printed:     ".$c_total;
say "Artist:      ".$c_artist;
say "Song name:   ".$c_name;
say "Album year:  ".$c_year;
say "Track time:  ".$c_duration;
say "Podcast:     ".$c_podcasts;
say "iTunesU:     ".$c_itunesu;
say "Movies :     ".$c_movie;
say "TV Show:     ".$c_tvshow;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# OUTPUT FILE
# Output file name (uses date & time)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# my $outfile = "../data/$ymd.gp2protein.gpi_dicty";

# open my $out, '>', $outfile
#     or die "Big problem: I can't create '$outfile'";

# my $localtime = localtime();

# # Head info to the GPI FILE
# my $headinfo = "!
# ! gpi-version: 1.1
# ! namespace: dictyBase
# !
# ! This file contains additional information for genes in the dictyBase.
# ! Gene accessions are represented in this file even if there is no associated GO annotation.
# !
# ! Columns:
# !
# !   name                   required? cardinality   GAF column #
# !   DB_Object_ID           required  1             2/17
# !   DB_Object_Symbol       required  1             3
# !   DB_Object_Name         optional  0 or greater  10
# !   DB_Object_Synonym(s)   optional  0 or greater  11
# !   DB_Object_Type         required  1             12
# !   Taxon                  required  1             13
# !   Parent_Object_ID       optional  0 or 1        -
# !   DB_Xref(s)             optional  0 or greater  -
# !   Properties             optional  0 or greater  -
# !
# ! Generated on $localtime
# !
# ";

# print {$out} $headinfo;

# my $c_genes    = 0;
# my $c_products = 0;
# my $c_syn      = 0;

# print {$out}
#     "DDB_G_ID\tGene_Name\tGene_Product\tAlternative_gene_name\tObject_type\tTaxon\tParent_Object\tUniprot_ID\n";
# for my $ddbg ( sort keys %hash_gp2protein ) {

#     # ddbg
#     print {$out} $ddbg . "\t";

#     # Gene name
#     print {$out} $hash_ddbg2gene_name{$ddbg} . "\t";

#     # Gene product
#     my $is_product = $hash_geneproduct{$ddbg};
#     if ( !$is_product ) {
#         print {$out} " \t";
#     }
#     else {
#         print {$out} $hash_geneproduct{$ddbg} . "\t";
#         $c_products++;
#     }

#     # gene synonyms
#     my $is_syn = $hash_gene_synonym{$ddbg};
#     if ( !$is_syn ) {
#         print {$out} " \t";
#     }
#     else {
#         print {$out} $is_syn . "\t";
#         $c_syn++;
#     }

#     # Object type, taxon
#     print {$out} "gene\ttaxon:44689\t \t";

#     # Uniprot ID
#     print {$out} $hash_gp2protein{$ddbg} . "\n";

#     $c_genes++;
# }

# say "\nDouble checking numbers ";
# say "\t- Has products: " . $c_products;
# say "\t- Has synonyms: " . $c_syn;

# $dbh->disconnect();

exit;

sub get_file {

    my ($filename) = @_;

    open my $FILE, '<', $filename or die "Cannot open '$filename'!\n";

    # To parse it:
    # foreach my $line (<$FILE>) {
    # }

    return ($FILE);

    # my $FILE1 = get_file($filename);
}

sub check_empty {
    my ($whatever) = @_;
    if ($whatever)
    {
        return $whatever;
    }
    else
    {
        my $nulo = "NULL";
        return $nulo;
    }
}


=head1 NAME

djmusic_populatetables.pl - Extract music info from iTunes XML file

=head1 SYNOPSIS

perl djmusic_populatetables.pl

=head1 OUTPUT

YYYYMMDD_HHMMSS.gp2protein.gpi_dicty

=head1 DESCRIPTION

It parses the iTunes xml file and creates a sql file which will insert all the
values in the database. Things to take into account:  

1. It should start by the tables providing foreing keys to other tables,
because then you will need the identifer to related them to other tables.

2. The only special character that I need to be worry about is ', which should
be replace by ''

