package User;

use DateTime;
use Moose;

extends 'Person';

has 'password' => (
    is  => 'rw',
    isa => 'Str',
);

has 'last_login' => (
    is      => 'rw',
    isa     => 'DateTime',
    handles => { 'date_of_last_login' => 'date' },
);

sub login {
    my $self = shift;
    my $pw   = shift;

    return 0 if $pw ne $self->password;

    $self->last_login( DateTime->now() );

    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable;