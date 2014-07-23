use feature qw/say/;

use CheckingAccount;

my $money = CheckingAccount->new();

say "Checking Account balance: ".$money->balance();

say "Now I am gonna transfer 10 dollars";
$money->deposit(10);
say "New Checking Account balance: ".$money->balance();

exit;