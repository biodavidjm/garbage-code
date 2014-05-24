#!/usr/bin/perl

# tutorials/perl-for-newbies/part3/

use strict;
use warnings;

use Foo;
use Bar;

# Initialize an object
# 1. With parameters
my $foo = Bar->new();

# 2. Withoug parameters:
# my $foo = Bar->new("MyFoo", 500);

$foo->assign_name_ext("Shlomi Fish");
$foo->assign_number(400);

print $foo->get_name(), " ";
print $foo->get_number()."\n";

print "how many times: ";
print $foo->get_num_times_assigned()."\n";

$foo->assign_name_ext("Pepito");
$foo->assign_number(1000);

print $foo->get_name(), " ";
print $foo->get_number()."\n";

print "how many times: ";
print $foo->get_num_times_assigned()."\n";







# Chapter 7, page 110

