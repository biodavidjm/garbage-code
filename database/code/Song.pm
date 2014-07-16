package Song;

use Moose;
use Method::Signatures;
use feature qw/say/;

use POSIX; # For mathematical functions like ceil and floor


has 'song_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    reader   => 'get_song_name',
    writer   => 'set_song_name'
);

has 'itunes_id' => (

    is       => "rw",
    isa      => 'Int',
    required => 1,
    reader   => 'get_itunes_id',
    writer   => 'set_itunes_id'
);

has 'duration' => (
    is       => 'rw',
    isa      => 'Int',
    reader   => 'get_duration',
    writer   => 'set_duration'
);

has 'track_number' => (
    is     => 'rw',
    isa    => 'Int',
    reader => 'get_track_number',
    writer => 'set_track_number'
);

has 'style' => (
	is => 'rw',
	isa => 'Str',
	reader => 'get_style',
    writer  => 'set_style'
);

method get_duration_seconds{
    my $millisec = $self->get_duration();
    
    # CONVERT TO HH:MM:SS
    my $sec = ($millisec * 0.001);

    my $hours = floor($sec/3600);
    my $remainder_1 = ($sec % 3600);
    my $minutes = floor($remainder_1 / 60);
    my $seconds = ($remainder_1 % 60);

    # PREP THE VALUES
    if(length($hours) == 1) {
        $hours = "0".$hours;
    }

    if(length($minutes) == 1) {
        $minutes = "0".$minutes;
    }

    if(length($seconds) == 1) {
        $seconds = "0".$seconds;
    }

    my $here = $hours.":".$minutes.":".$seconds;

    return $here;

}

method add_to_artist () {

}

method delete_artist () {

}

method add_album () {

}

method delete_album () {
    
}

method add_to_playlist () {

}

method delete_from_playlist () {
    
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