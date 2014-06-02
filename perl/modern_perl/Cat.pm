package Cat;

use Moose;
use feature qw/say/;

# Attributes my have to different notations:

# 1)
# has 'name', is => 'ro', isa => 'Str';

# 2) Using parenthesis

has 'name' => (
    is  => 'ro',
    isa => 'Str'
);

# By making this class rw, we don't need to pass
# this data in the constructor.
has 'diet' => (
	is => 'rw',
	isa => 'Str',
);

# Instead of an attribute...
# has 'age' => (
#     is  => 'ro',
#     isa => 'Int'
# );

# Why not to ask for the birth year...
has 'birth_year' => (
	is  => 'rw',
	isa => 'Int',
	default => sub  { (localtime)[5]+1900 }
);

# Roles!
with 'LivingBeing';

#...and internally calculate the age:
sub age {
	my $self = shift;
	my $year = (localtime)[5]+1900;
	return $year - $self->birth_year;
}

sub print_out_details {
	my $object = shift;

	say "Hi, I am a Cat. My name is ", $object->name;
	say "My age? ", $object->age," years old";
	say "I like to eat ", $object->diet;
}

1;
