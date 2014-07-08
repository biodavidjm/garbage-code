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

# FLAGS
my $flag   = 0;
my $c_dict = 0;

# SCALARS FOR THE DATA.
my ( $track_id, $track_number, $duration, $name, $band, $album, $year,
    $genre )
    = '';

# BAND TABLE
# Using hash to easily avoid redundancy
my %band_table = ();

# ALBUM TABLE
# they Key has to be the band name, since one album could have two different bands.
my %album_table = ();

# $album_table{$band}{$album} = $album_year;

# Song
# it contains all the information, although when filling up the table in the database, it needs to check album and band
my %song_table = ();

# my @temp = ($band,$album,$name,$song_duration,$song_number,$style);
# $song_table{$track_id} = [@temp];

# STATS
my $c_total    = 0;
my $c_podcasts = 0;
my $c_itunesu  = 0;
my $c_movie    = 0;
my $c_tvshow   = 0;
my $c_albums   = 0;


foreach my $line (<$FILE1>) {
    chomp($line);
    if ( ( $line =~ /<dict>/ ) & ( $c_dict != 3 ) ) {
        $c_dict++;
        if ( $c_dict == 3 ) {
            say "Ready to record data";
            $flag = 1;
            next;
        }
    }

    if ( ( $line =~ /<dict>/ ) & ( $c_dict == 3 ) ) {
        $flag = 1;
        next;
    }

    if ( $flag == 1 ) {

        if ( $line =~ /<key>Track ID<\/key><integer>(.*)<\/integer>/ ) {
            $track_id = $1;
            next;
        }
        if ( $line =~ /<key>Name<\/key><string>(.*)<\/string>/ ) {
            $name = $1;
            next;
        }
        if ( $line =~ /<key>Artist<\/key><string>(.*)<\/string>/ ) {
            $band = $1;
            $band =~ s/[^a-zA-Z0-9]/ /g;
            next;
        }
        if ( $line =~ /<key>Album<\/key><string>(.*)<\/string>/ ) {
            $album = $1;
            $album =~ s/[^a-zA-Z0-9]/ /g;
            next;
        }
        if ( $line =~ /<key>Year<\/key><integer>(.*)<\/integer>/ ) {
            $year = $1;
            next;
        }
        if ( $line =~ /<key>Total Time<\/key><integer>(.*)<\/integer>/ ) {
            $duration = $1;
            next;
        }
        if ( $line =~ /<key>Track Number<\/key><integer>(.*)<\/integer>/ ) {
            $track_number = $1;
            next;
        }
        if ( $line =~ /<key>Genre<\/key><string>(.*)<\/string>/ ) {
            $genre = $1;

            # Needs to change weird characters by dash...
            $genre =~ s/[^a-zA-Z0-9]/ /g;
            next;
        }

        # DO NOT PROCESS:
        # PODCASTS -
        if ( $line =~ /<key>Podcast<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre
            ) = '';
            $c_podcasts++;
        }

        # ITUNESU -
        if ( $line =~ /<key>iTunesU<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre
            ) = '';
            $c_itunesu++;
        }

        # MOVIES -
        if ( $line =~ /<key>Movie<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre
            ) = '';
            $c_movie++;
        }

        # TV show -
        if ( $line =~ /<key>TV Show<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre
            ) = '';
            $c_tvshow++;
        }
    }

# Once we have reach the final of the <dict> record... time to store the information
    if ( ( $line =~ /<\/dict>/ ) & ( $flag == 1 ) ) {
        $flag = 0;

        # Any data in the database MUST HAVE song name, band, and album>
        if ($track_id) {
            if ($name) {
                if ($band) {
                    if ($album) {

                        # These are not "required" fields in the database
                        my $album_year = '';
                        $album_year = check_empty($year);
                        my $song_duration = '';
                        $song_duration = check_empty($duration);
                        my $song_number = '';
                        $song_number = check_empty($track_number);
                        my $style = '';
                        $style = check_empty($genre);

                        # FILLING UP DATA STRUCTURE
                        # SONGs
                        my @temp = (
                            $band, $album, $name, $song_duration,
                            $song_number, $style
                        );
                        $song_table{$track_id} = [@temp];

                        # BANDs
                        if ( !$band_table{$band} ) {
                            $band_table{$band} = 1;
                        }

                        # ALBUMs
                        if ( !$album_table{$band}{$album} ) {
                            $album_table{$band}{$album} = $album_year;
                            $c_albums++;
                        }

                        $c_total++;
                    }
                }
            }
        }

        # And reset before leaving
        (   $track_id, $track_number, $duration, $name, $band, $album, $year,
            $genre
        ) = '';
    }
}

my $c_bands = keys %band_table;
my $c_songs = keys %song_table;


say "---- Stats --------------";
say "Printed:     " . $c_total;
say "  - Artist:     " . $c_bands;
say "  - Albums:    " . $c_albums;
say "  - Songs:     " . $c_songs;
say "Podcast:     " . $c_podcasts;
say "iTunesU:     " . $c_itunesu;
say "Movies :     " . $c_movie;
say "TV Show:     " . $c_tvshow;
say "-------------------------";

# OUTPUT FILE
my $outfile = "pop_all_djmusic_tables.sql";

open my $out, '>', $outfile
    or die "Big problem: I can't create '$outfile'";

my $head_band = "
-- Band\n\n
";

print {$out} $head_band;

for my $artist ( sort keys %band_table ) {
    say {$out} "INSERT INTO band (band_name) VALUES ('" . $artist . "');";
}

my $head_album = "
-- Album\n\n
";

print {$out} $head_album;

for my $artist ( sort keys %album_table ) {
    for my $album ( sort keys %{ $album_table{$artist} } ) {
        print {$out}
            "INSERT INTO album (album_name, album_year, band_id) VALUES ('"
            . $album . "',";

        # This can be null, so let's check and print it out correctly:
        my $album_year = $album_table{$artist}{$album};
        if ( $album_year =~ /NULL/ ) {
            print {$out} $album_year. ",";
        }
        else {
            print {$out} "'" . $album_year . "',";
        }

        print {$out} " (SELECT band_id FROM band WHERE band_name='"
            . $artist
            . "'));\n";
    }
}

exit;

for my $trackid ( sort { $a <=> $b } keys %song_table ) {
    say "Track " . $trackid;
    foreach my $i ( 0 .. $#{ $song_table{$trackid} } ) {
        say "\t" . $song_table{$trackid}[$i];
    }
}

#----- THE END

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
    if ($whatever) {
        return $whatever;
    }
    else {
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

