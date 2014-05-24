#!/usr/bin/perl
package Artist;

# Class for storing data about an Artist

use strict;
use warnings; 

sub new {
	my $class = shift; 
	my $self = {@_};
	bless ($self, $class);
	return $self;
}

sub get_name {
	my $self = shift;
	return $self->{band}
}

1;
