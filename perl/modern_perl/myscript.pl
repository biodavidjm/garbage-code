#!/usr/bin/perl -w

use strict;

# you may need to set @INC here (see below)

my @list = qw (O h ~ n o ~ w h a t ~ i s ~ t h i s !);

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
use MyModule qw(:Both);
print func1(@list),"\n";
print func2(@list),"\n";