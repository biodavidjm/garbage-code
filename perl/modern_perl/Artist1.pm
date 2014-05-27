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

# Get and Set method:

sub album {
	my $self = shift;
	unless (ref $self) {
		die "You should call album() with an object, not with a class\n";
	}

	# Receive more data
	my $data = shift;
	# Set the album
	$self->{album} = $data if defined $data;

	return $self->{album} 
}

# Or a minuature get-set method
sub year {
	$_[0]->{year}=$_[1] if defined $_[1]; $_[0]->{year}
}
sub style {
	$_[0]->{style}=$_[1] if defined $_[1]; $_[0]->{style}	
}

1;