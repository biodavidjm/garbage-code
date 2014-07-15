package Album;

use Moose;
use Method::Signatures;
use feature qw/say/;

extends 'Band';

has 'album_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    reader   => 'get_album_name'
);

has 'album_year' => (
    is      => 'rw',
    isa     => 'Int',
    default => "NULL",
    reader  => 'get_year'
);

method set_album_name (Str $key){
	return $self->album_name($key);
}

method set_album_year (Int $key) {
	return $self->album_year($key);
}

1;

