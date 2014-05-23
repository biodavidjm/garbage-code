#!/usr/bin/perl

# tutorials/perl-for-newbies/part3/

use strict;
use warnings;

use Foo;
use Bar;

my $foo = Bar->new("MyFoo", 500);

print $foo->get_name()." ";
print $foo->get_number(). "\n";

$foo->assign_name_ext("Shlomi Fish");

$foo->assign_number(400);

print $foo->get_name(), "\n";
print $foo->get_number()."\n";

print $foo->get_num_times_assigned()."\n";
print $foo->get_num_times_assigned()."\n";




# Chapter 7, page 110

