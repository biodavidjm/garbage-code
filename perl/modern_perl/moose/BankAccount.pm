package BankAccount;

use Moose;
use Method::Signatures;

use feature qw/say/;


has 'balance' => ( isa => 'Int', is => 'rw', default => 0 );
 
sub deposit {
    my ( $self, $amount ) = @_;
    $self->balance( $self->balance + $amount );
}

# method deposit ($amount) {
# 	$self->balance ($self->balance + $amount);
# }
 
sub withdraw {
    my ( $self, $amount ) = @_;
    my $current_balance = $self->balance();
    ( $current_balance >= $amount )
        || confess "Account overdrawn";
    $self->balance( $current_balance - $amount );
}

1;