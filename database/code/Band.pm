package Band;

use Moose;
use Method::Signatures;
use feature qw/say/;

# Attributes
has 'band_name' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	reader => 'get_band_name',
	writer => 'set_band_name'
);

has 'country' => (
	is => 'rw',
	isa => 'Str',
	default => 'NULL',
	reader => 'get_country',
	writer => 'set_country'
);


method add_album(){
	# A band can have multiple albums, which
}

method delete_album(){

}

method add_song(){
	# A band can have multiple songs
}

method delete_song(){

}

method add_fan(){

}

method delete_fan(){

}

method add_show(){

}

method delete_show(){

}

method add_source () {

}

method delete_source () {

}

method add_to_playlist () {

}

method delete_from_playlist () {

}



# I don't need this because a moose provide set and get
# method set_band_name (Str $key) {
# 	return $self->band_name($key);
# }

# method set_country (Str $key) {
# 	return $self->country($key);
# }


1;