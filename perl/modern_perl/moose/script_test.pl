#!/usr/bin/perl -w

use Modern::Perl;
use feature qw/say/;
use autodie qw/open close/;

use feature qw/say/;

# BANK CLASSES
# use BankAccount;
use CheckingAccount;

my $money = CheckingAccount->new();

# my $money = BankAccount->new();

say "First Checking Account balance: " . $money->balance();

say "\tNow I am gonna transfer 10 dollars";
$money->deposit(10);
say "\tYour balance: " . $money->balance();

say "Let's withdraw 15 bucks";

$money->withdraw(10);
say "\tYour balance: " . $money->balance();


# BINARYTREE CLASSES
use BinaryTree;

say "Let's start a binary tree";

my $object_binarytree = BinaryTree->new(
	parent	=>	'Pepe',
	left	=>	'Paco',
	right	=>	'Pedro',
	);
