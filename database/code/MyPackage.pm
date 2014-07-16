package MyPackage;

use Moose;
use Email::Valid;
use Moose::Util::TypeConstraints;

subtype 'Email'
   => as 'Str'
   => where { Email::Valid->address($_) }
   => message { "$_ is not a valid email address" };

has 'email' => (
	is =>'ro' , 
	isa => 'Email', 
	required => 1,
	reader => 'get_mail'
);

1;

# In the script:

# my $script_name = "testing_music_objects.pl";

# my $object = MyPackage->new(
# 	email => 'astaaskgmail.com',
# 	);

# say $object->get_mail;