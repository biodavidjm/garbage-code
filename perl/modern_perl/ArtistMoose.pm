package ArtistMoose;

use Moose;
use Method::Signatures;
use feature qw/say/;

has 'band' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has 'album' =>
(
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'year' =>
(
	is=> 'ro',
	isa=> 'Int',
	required => 1,
);

has 'style' =>
(
	is=>'rw',
	isa=>'Str',
	default => 'Undefined'
);

sub print_details {
	my $object = shift;

	say "Band:  ",$object->band;
	say "Album: ",$object->album;
	say "Year:	",$object->year;
	say "Style: ",$object->style;
}

1;