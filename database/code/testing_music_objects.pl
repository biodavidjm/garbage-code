#!/usr/bin/perl -w

use strict;
use feature qw/say/;
use autodie qw/open close/;

use Song;

# system('clear');

# # # # # # # # #
#
# To Do
#
# - - - - - - -
#
# # # # # # # # #

my $script_name = "testing_music_objects.pl";

my $music_object = Album->new(
    band_name  => 'Radiohead',
    album_name => 'Todo lo que vendrá después',
    album_year => '1995',
);

my $song_object = Song->new(
    band_name  => 'Radiohead',
    album_name => 'Todo lo que vendrá después',
    album_year => '1995',
    song_name  => 'Cielo color vino',
    itunes_id  => '897689',
);

# say "The band is ", $music_object->band_name;

# $music_object->set_band_name("The Cure");

# say "The band is ", $music_object->band_name;

say "Band name: ", $music_object->band_name;

say "song name: ", $song_object->song_name;



exit;

=head1 NAME

testing_music_objects.pl - Testing the Music classes 

=head1 SYNOPSIS

perl djmusic_parser01.pl


=head1 DESCRIPTION

The script to test the Music classes.
