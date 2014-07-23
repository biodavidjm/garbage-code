#!/usr/bin/perl -w

use Modern::Perl;
use feature qw/say/;
use autodie qw/open close/;

use feature qw/say/;

# BANK CLASSES
# use BankAccount;
# use CheckingAccount;

# my $money = CheckingAccount->new();

# # my $money = BankAccount->new();

# say "First Checking Account balance: " . $money->balance();

# say "\tNow I am gonna transfer 10 dollars";
# $money->deposit(10);
# say "\tYour balance: " . $money->balance();

# say "Let's withdraw 15 bucks";

# $money->withdraw(10);
# say "\tYour balance: " . $money->balance();

# -__--___---___---___---___---___---___---___---___

# Testing the Locale::US package
# It requires perl-5.18.2@cookbooks from here

# use Locale::US;

# my $u = Locale::US->new;

# my $dcode = "IL";
# my $state = $u->{code2state}{$dcode};
# my $code  = $u->{state2code}{'CALIFORNIA'};

# say $state." is for IL and for CALIFORNIA is ".$code;
# my @state = $u->all_state_names;
# my @code  = $u->all_state_codes;

# foreach my $each (@state)
# {
# 	say $u->{state2code}{$each}." -> ".$each;
# }

# -__--___---___---___---___---___---___---___---___

# Testing Moose::Cookbook::Basics::Company_Subtypes - Demonstrates the use of
# subtypes and how to model classes related to companies, people, employees,
# etc.
# It requires perl-5.18.2@cookbooks

use Address;
use Company;

my $address = Address->new(
    street   => '200 N Wolcott Ave',
    city     => 'Chicago',
    state    => 'IL',
    zip_code => '60622',
);

say "My address is: " . $address->street();
say $address->city();
say $address->state();
$address->city('Oak Park');
say "Wait a minute, my city is " . $address->city();

say "\nCompany time-----";
my $company = Company->new( name => 'McDonnald', address => $address);

# city     => 'Chicago',
#         state    => 'IL',
#         zip_code => '60622',));


say "Corporation: ", $company->name();
say $company->address->zip_code;

$company->address();


