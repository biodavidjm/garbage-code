package CheckingAccount;

use Moose;
use Method::Signatures;

use feature qw/say/;
 
extends 'BankAccount';
 
has 'overdraft_account' => ( isa => 'BankAccount', is => 'rw' );
 
before 'withdraw' => sub {
    my ( $self, $amount ) = @_;
    my $overdraft_amount = $amount - $self->balance();
    if ( $self->overdraft_account && $overdraft_amount > 0 ) {
        $self->overdraft_account->withdraw($overdraft_amount);
        $self->deposit($overdraft_amount);
    }
};

1;