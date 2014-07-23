package CheckingAccount;

use Moose;
use Method::Signatures;

use feature qw/say/;
 
extends 'BankAccount';
 
has 'overdraft_account' => ( isa => 'BankAccount', is => 'rw' );
 
# Method Modifier
before 'withdraw' => sub {
	my ( $self, $amount ) = @_;
	if ($self->balance() < $amount) {
		die "\tSir, you don't have enough funds. Operation aborted\n";
	}
};

1;