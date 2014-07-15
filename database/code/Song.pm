package Song;

use Moose;
use Method::Signatures;
use feature qw/say/;

extends 'Album';

has 'song_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    reader   => 'get_song_name'
);

has 'itunes_id' => (

    is       => "rw",
    isa      => 'Int',
    required => 1,
    reader   => 'get_itunes_id'
);

has 'duration' => (
    is     => 'rw',
    isa    => 'Int',
    reader => 'get_duration'
);

has 'track_number' => (
    is     => 'rw',
    isa    => 'Int',
    reader => 'get_track_number'
);

has 'style' => (
	is => 'rw',
	isa => 'Str',
	reader => 'get_style'
);

# A song can be in many different playlist, and a playlist can have multiple songs
has 'playlist' => (
	is => 'rw',
	isa => 'Str',
	reader => 'get_playlist'
);


method set_song_name (Str $key){

	return $self->song_name($key);

}

method set_itunes_id (Int $key){

	return $self->itunes_id($key);

}

method set_duration (Int $key){

	return $self->duration($key);

}

method set_track_number (Int $key){

	return $self->track_number($key);

}

method set_song_style (Str $key){

	return $self->style($key);

}


1;