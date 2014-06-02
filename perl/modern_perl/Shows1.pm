package Shows;

# Testing inheritance
use Artist1;

use strict;
use warnings; 
use Carp;

our @ISA = qw(Artist);

# Or a minuature get-set method
sub city {
	$_[0]->{city}=$_[1] if defined $_[1]; $_[0]->{city}
}
sub country {
	$_[0]->{country}=$_[1] if defined $_[1]; $_[0]->{country}
}
sub show_date {
	$_[0]->{show_date}=$_[1] if defined $_[1]; $_[0]->{show_date}	
}
sub tickets {
	$_[0]->{tickets}=$_[1] if defined $_[1]; $_[0]->{tickets}	
}

sub increase_price {
	my $self = shift;
	my $new_price = $self->tickets + 20;
	$self->tickets($new_price);
	return $self;
}

