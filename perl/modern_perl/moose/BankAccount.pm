package BankAccount;

use Moose;
use Method::Signatures;

use feature qw/say/;


has 'balance' => ( isa => 'Int', is => 'rw', default => 0 );
 
# before 'withdraw' => sub {
# 	my ( $self, $amount ) = @_;
# 	if ($self->balance() < $amount) {
# 		die "\tSir, you don't have enough funds. Operation aborted\n";
# 	}
# };

method deposit ($amount) {
	$self->balance($self->balance + $amount);
}

# method withdraw ($amount) {
# 	my $current_balance = $self->balance();
# 	$self->balance($current_balance - $amount );	
# }

# sub deposit {
#     my ( $self, $amount ) = @_;
#     $self->balance( $self->balance + $amount );
# }

sub withdraw {
    my ( $self, $amount ) = @_;
    my $current_balance = $self->balance();
    ( $current_balance >= $amount )
        || confess "Account overdrawn";
    $self->balance( $current_balance - $amount );
}

1;