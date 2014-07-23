package Address;
use Moose;
use Moose::Util::TypeConstraints; 
# This class allows to use the subtype function, which lets you declaratively
# create type constraints without building an entire class.

use Locale::US;
use Regexp::Common 'zip';
 
my $STATES = Locale::US->new;

subtype 'USState'
    => as Str
    => where {
           (    exists $STATES->{code2state}{ uc($_) }
             || exists $STATES->{state2code}{ uc($_) } );
       };
 
subtype 'USZipCode'
    => as Value
    => where {
           /^$RE{zip}{US}{-extended => 'allow'}$/;
       };
 
has 'street'   => ( is => 'rw', isa => 'Str' );
has 'city'     => ( is => 'rw', isa => 'Str' );
has 'state'    => ( is => 'rw', isa => 'USState' );
has 'zip_code' => ( is => 'rw', isa => 'USZipCode' );
 
1;