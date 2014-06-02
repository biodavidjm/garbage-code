#!/usr/bin/env perl

use User;
use feature qw/say/;

# Testing Moose tutorial (Person and User packages)
my $user = User->new(
    first_name => 'Example',
    last_name  => 'User',
    password   => 'letmein',
);

$user->login('letmein');

say $user->date_of_last_login;
