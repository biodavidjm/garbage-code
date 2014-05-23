#!/usr/bin/perl -w

use strict;

# EXAMPLE 1. 
# Helps understand when calling functions works and when it doesn't

# my @list = qw (O h ~ n o ~ w h a t ~ i s ~ t h i s !);

# case 1
# use MyModule;
# print func1(@list),"\n";
# print func2(@list),"\n";

# case 2
# use MyModule qw(&func1);
# print func1(@list),"\n";
# print MyModule::func2(@list),"\n";

# case 3
# use MyModule qw(:FIRST);
# print func1(@list),"\n";
# print func2(@list),"\n";

# case 4
# use MyModule qw(:Both);
# print func1(@list),"\n";
# print func2(@list),"\n";

# EXAMPLE 2. 
# Helps understand funcions and closures.  In perl it is possible
# to define dynamic subroutines, inside the code of the current scope. That
# scope can be a function or even another dynamic subroutine. These subroutines,
# which are sometimes referred to as closures, can see all the variables of the
# scope in which they were declared, even after the function that created them
# stopped running.

use strict;
use warnings;

sub create_counter
{
    my $counter = 0;

    my $counter_func = sub {

        print $counter."  ";
        return ($counter++);

    };

    return $counter_func;
}

my @counters = (create_counter(), create_counter());

# Initialize the random number generator to a constant value;
srand(24);

for my $i (1 .. 100)
{
    # This call generates a random number that is either 0 or 1
    my $which_counter = int(rand(2));

    my $value = $counters[$which_counter]->();

    print "$which_counter = $value\n";
}