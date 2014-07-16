package Fan;

use Moose;
use Method::Signatures;
use feature qw/say/;


has 'fan_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    reader   => 'get_fan_name',
    writer   => 'set_fan_name'
);


method add_band () {

}

method delete_band () {

}



# method set_song_name (Str $key){

# 	return $self->song_name($key);

# }

# method set_itunes_id (Int $key){

# 	return $self->itunes_id($key);

# }

# method set_duration (Int $key){

# 	return $self->duration($key);

# }

# method set_track_number (Int $key){

# 	return $self->track_number($key);

# }

# method set_song_style (Str $key){

# 	return $self->style($key);

# }


1;