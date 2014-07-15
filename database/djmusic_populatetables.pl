#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use Getopt::Long;
use IO::File;
use autodie qw/open close/;
use Text::CSV;

# system('clear');

# # # # # # # # #
#
# To Do
#
# - - - - - - -
#
# # # # # # # # # 

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

# playlist flag
my $flag_playlist = 0;
my $flag_array = 0;

# SCALARS FOR THE DATA.
my ( $track_id, $track_number, $duration, $name, $band, $album, $year, $genre, $fan ) = '';

# BAND TABLE
# Using hash to easily avoid redundancy
my %band_table = ();

# ALBUM TABLE
# they Key has to be the band name, since one album could have two different bands.
my %album_table = ();
# $album_table{$band}{$album} = $album_year;

# Song
# it contains all the information, although when filling up the table in the database, it needs to check album and band
# my @temp = ( $band, $album, $name, $song_duration, $song_number, $style);
# $song_table{$track_id} = [@temp];
my %song_table = ();

# Playlist
my %playlist_table = ();
my $playlist_name = '';
my $playlist_song_id = '';

# Styles
my %style_table = ();

# Fan
# It uses the "grouping": Nieves, Sara if specified, David otherwise.
my %fan_table = ();
#$fan_table{$fan}{$band} = 1;


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
    if ( ( $line =~ /<dict>/ ) & ( $c_dict < 3 ) ) {
        $c_dict++;
    }

    if ( ( $line =~ /<dict>/ ) & ( $c_dict == 3 ) ) {
        $flag = 1;
    }

    if ( $flag == 1 ) {

        if ( $line =~ /<key>Track ID<\/key><integer>(.*)<\/integer>/ ) {
            $track_id = $1;
            next;
        }
        if ( $line =~ /<key>Name<\/key><string>(.*)<\/string>/ ) {
            $name = $1;
            $name =~ s/\'//g;
            next;
        }
        if ( $line =~ /<key>Artist<\/key><string>(.*)<\/string>/ ) {
            $band = $1;
            $band =~ s/\'//g;
            next;
        }
        if ( $line =~ /<key>Album<\/key><string>(.*)<\/string>/ ) {
            $album = $1;
            $album =~ s/\'//g;
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
            $genre =~ s/\'//g;
            if ( !$style_table{$genre} )
            {
                $style_table{$genre} = 1;
            }
            next;
        }
        if ($line =~ /<key>Grouping<\/key><string>(.*)<\/string>/)
        {
            $fan = $1;
            if ($fan !~ /(Sara|Nieves)/)
            {
                $fan = "David";
                # print $band. " = ". $fan."\n";
            }
            next;
        }

        # DO NOT PROCESS:
        # PODCASTS -
        if ( $line =~ /<key>Podcast<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre, $fan
            ) = '';
            $c_podcasts++;
        }

        # ITUNESU -
        if ( $line =~ /<key>iTunesU<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre, $fan
            ) = '';
            $c_itunesu++;
        }

        # MOVIES -
        if ( $line =~ /<key>Movie<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre, $fan
            ) = '';
            $c_movie++;
        }

        # TV show -
        if ( $line =~ /<key>TV Show<\/key><true\/>/ ) {
            $flag = 0;
            (   $track_id, $track_number, $duration, $name, $band, $album,
                $year, $genre, $fan
            ) = '';
            $c_tvshow++;
        }
    } #if ( $flag == 1 ) {

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
                        my $fan_name = '';
                        $fan_name = check_empty_fan($fan);


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

                        # FAN
                        # And the fan, which it has a value for sure (Nieves, David or Sara)
                        if ( !$fan_table{$fan_name}{$band} )
                        {
                            $fan_table{$fan_name}{$band} = 1;    
                        }
                        $c_total++;

                    }
                }
            }
        }

        # And reset before leaving
        (   $track_id, $track_number, $duration, $name, $band, $album, $year,
            $genre, $fan
        ) = '';
    } # if ( ( $line =~ /<\/dict>/ ) & ( $flag == 1 ) )

    # PLAYLIST TIME
    if ($line =~ /<key>Playlists<\/key>/) {
        $flag_playlist = 1;
        $c_dict++; # This will prevent getting into the previous loops.
        next;
    }
    
    if ($flag_playlist) {
        if ($line =~ /<key>Name<\/key><string>(.*)<\/string>/) {
            $playlist_name = $1;
            $playlist_name =~ s/\'//g;
            if ($playlist_name !~ /(Library|Music|Movies|TV Shows|Podcast|iTunes U|Audiobooks|Purchased|iTunes Artwork Screen Saver|On-The-Go|Voice Memos|trt1)/ )
            {
                $flag_array = 1;
            }
        }

        if ( ($flag_array == 1) & ($line =~ /<key>Track ID<\/key><integer>(.*)<\/integer>/) ) {
            $playlist_song_id = $1;
            if ( !$playlist_table{$playlist_name}{$playlist_song_id} )
            {
                $playlist_table{$playlist_name}{$playlist_song_id} = 1;  
            }
        }
        
        if ($line =~ /<\/array>/) {
            $flag_array = 0;
            $playlist_name = '';
            $playlist_song_id = '';
        }
    }

} # End of main foreach my $line (<$FILE1>)

my $c_bands = keys %band_table;
my $c_songs = keys %song_table;

say "---- Stats --------------";
say "Printed:     " . $c_total;
say "  - Artist:    " . $c_bands;
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

my $head_band = "\n\n-- Band\n\n";

print {$out} $head_band;

for my $artist ( sort keys %band_table ) {
    say {$out} "INSERT INTO band (band_name) VALUES ('" . $artist . "');";
}

my $head_album = "\n\n-- Album\n\n";

print {$out} $head_album;

for my $artist ( sort keys %album_table ) {
    for my $album ( sort keys %{ $album_table{$artist} } ) {
        print {$out}
            "INSERT INTO album (album_name, album_year, band_id) VALUES ('"
            . $album . "',";

        # This can be null, so let's check and print it out correctly:
        my $album_year = $album_table{$artist}{$album};
        if ( $album_year =~ /NULL/ ) {
            print {$out} $album_year . ",";
        }
        else {
            print {$out} "'" . $album_year . "',";
        }

        print {$out} " (SELECT band_id FROM band WHERE band_name='" . $artist
            . "'));\n";
    }
}

my $head_song = "\n\n-- Song\n\n";

print {$out} $head_song;

# Order in the hash of array:
# my @temp = ($band, $album, $name, $song_duration, $song_number, $style);

for my $trackid ( sort { $a <=> $b } keys %song_table ) {
    print {$out} "INSERT INTO song (song_name, duration, track_number, itunes_id, album_id) VALUES (";
    # song_name
    print {$out} "'".$song_table{$trackid}[2]."',"; 
    # duration
    if ( $song_table{$trackid}[3] =~ /NULL/ ) {
        print {$out} $song_table{$trackid}[3]. ",";
    }
    else {
        print {$out} "'" . $song_table{$trackid}[3] . "',";
    }
    # track number
    if ( $song_table{$trackid}[4] =~ /NULL/ ) {
        print {$out} $song_table{$trackid}[4]. ",";
    }
    else {
        print {$out} "'" . $song_table{$trackid}[4] . "',";
    }
    # itunes_id
    print {$out} "'".$trackid."',"; 
    print {$out} "(SELECT album.album_id FROM album JOIN band ON band.band_id = album.band_id WHERE album.album_name = '".$song_table{$trackid}[1]."' AND band.band_name = '".$song_table{$trackid}[0]."'));\n";
}

my $head_pl = "\n\n-- Playlist\n\n";

print {$out} $head_pl;

for my $playlist_name (sort keys %playlist_table)
{
    say {$out} "INSERT INTO playlist (playlist_name) VALUES ('" .$playlist_name. "');";
}

my $head_song_pl = "\n\n-- Song_Playlist\n\n";

print {$out} $head_song_pl;

for my $playlist_name (sort keys %playlist_table)
{
    for my $playlist_song ( sort keys %{$playlist_table{$playlist_name}} )
    {
        print {$out}  "INSERT INTO song_playlist (song_id, playlist_id) VALUES ( ";
        print {$out}  "(SELECT song_id FROM song WHERE itunes_id = " .$playlist_song. "),";
        print {$out}  "(SELECT playlist_id FROM playlist WHERE playlist_name = '". $playlist_name ."')";
        print {$out}  ");\n";
    }
}

my $head_style = "\n\n-- Style\n\n";

print {$out} $head_style;

for my $style (keys %style_table)
{
    say {$out} "INSERT INTO style (style_name) VALUES ('". $style . "');";
}

# Adding the style "indefinido" solves the problem of the song_style table
# where the style_id is required as not null.
say {$out} "INSERT INTO style (style_name) VALUES ('Indefinido');";


my $head_ss = "\n\n-- Song_Style\n\n";
# my @temp = ($band, $album, $name, $song_duration, $song_number, $style);

print {$out} $head_ss;

for my $trackid ( sort { $a <=> $b } keys %song_table ) {
    print {$out}  "INSERT INTO song_style (song_id, style_id) VALUES (";
    print {$out}  "(SELECT song_id FROM song WHERE itunes_id = '".$trackid."'),";
    if ($song_table{$trackid}[5]=~ /NULL/)
    {
        print {$out}  "(SELECT style_id FROM style WHERE style_name = 'Indefinido')";
    }
    else
    {
        print {$out}  "(SELECT style_id FROM style WHERE style_name = '".$song_table{$trackid}[5]."')";
    }
    print {$out}  ");\n";
}

my $head_fan = "\n\n-- Fan\n\n";

print {$out} $head_fan;

for my $fan (keys %fan_table)
{
    print {$out} "INSERT INTO fan (fan_name) VALUES ('".$fan."');\n";
}

my $head_band_fan = "\n\n-- Band_Fan\n\n";

print {$out} $head_band_fan;

for my $fan (keys %fan_table)
{
    for my $band (keys %{$fan_table{$fan}})
    {
        print {$out} "INSERT INTO band_fan VALUES (";
        print {$out} "(SELECT band_id FROM band WHERE band_name = '".$band."'), ";
        print {$out} "(SELECT fan_id FROM fan WHERE fan_name = '".$fan."'));\n";
    }
}

# This is basically done. The remaining tables should be done by hand once I have the information
# The only one that could potentially be added would be fan and band_fand, since
# I could use the genre as a source (Sara and Nieves, all the others are David)

exit;

#---------------------------------------------------- SUBROUTINES

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

sub check_empty_fan {
    my ($whatever) = @_;
    if ($whatever) {
        return $whatever;
    }
    else {
        my $nulo = "David";
        return $nulo;
    }
}

=head1 NAME

djmusic_populatetables.pl - Extract music info from iTunes XML file

=head1 SYNOPSIS

perl djmusic_populatetables.pl

=head1 OUTPUT

pop_all_djmusic_tables.sql

=head1 DESCRIPTION

It parses the iTunes xml file and creates a sql file which will insert all the
values in the database. Things to take into account:  

1. The only special character that I need to be worry about is ', which should
be replace by ''

