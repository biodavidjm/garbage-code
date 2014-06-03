package ShowMoose;

use Moose;
use Moose::Util::TypeConstraints;
use feature qw/say/;

extends 'ArtistMoose';

subtype 'Between0and5',
      as 'Int',
      where { 0 <= $_ && $_ <= 5},
      message { "Ratings are between 0 and 5 (yoou provide $_)" };

has '+style' => (
	default => 'Sin especificar'
);

has 'rating' => (
	is => 'rw',
	isa=> 'Between0and5',
);

sub get_style {
	my $object = shift;
	say "Style: ",$object->style;
}

sub get_rating {
	my $object = shift;
	say "Rate: ",$object->rating;
}

sub print_details {
	my $object = shift;

	say "Band:  ",$object->band;
	say "Album: ",$object->album;
	say "Year:	",$object->year;
	say "Style: ",$object->style;
	say "Rate: ",$object->rating,"\n";
}



1;