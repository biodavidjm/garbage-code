package Band;

use Moose;
use Method::Signatures;
use feature qw/say/;

# Attributes
has 'band_name' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	reader => 'get_band_name'
);

has 'country' => (
	is => 'rw',
	isa => 'Str',
	default => 'NULL',
	reader => 'get_country'
);

has 'bands' => (

	is => 'rw',
	isa => 'ArrayRef'
);


has '_thebands' => (
      is  => 'ro',
      isa => 'HashRef'
);


method set_band_name (Str $key) {
	return $self->band_name($key);
}

method set_country (Str $key) {
	return $self->country($key);
}


1;