package Artist;

# Class for storing data about an Artist

use strict;
use warnings; 
use Carp;

my $count_bands = 0;
my @allbands;

sub new {
	my $class = shift; 
	my $self = {@_};
	bless ($self, $class);
	$count_bands++;
	$self->init;
	return $self;
}

sub init {
	my $self = shift;
	push @allbands, $self;
}

# Get and Set method:
sub album {
	my $self = shift;
	unless (ref $self) {
		croak "You should call album() with an object, not with a class\n";
	}

	# Receive more data
	my $data = shift;
	# Set the album
	$self->{album} = $data if defined $data;

	return $self->{album} 
}

# Or a minuature get-set method
sub name {
	$_[0]->{name}=$_[1] if defined $_[1]; $_[0]->{name}
}
sub year {
	$_[0]->{year}=$_[1] if defined $_[1]; $_[0]->{year}
}
sub style {
	$_[0]->{style}=$_[1] if defined $_[1]; $_[0]->{style}	
}

sub counting { $count_bands }

sub counting_a { scalar @allbands }
sub all_names { @allbands }

1;

# Old learning code:

# To just access the method
# sub get_name {
# 	my $self = shift;
# 	return $self->{band}
# }

# in the script
# print "The band's name is ", $object->get_name, "\n";