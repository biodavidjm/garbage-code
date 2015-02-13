#!/usr/bin/env perl

use strict;
use feature qw/say/;

use DBI;
use Moose;
use Bio::Chado::Schema;


use Getopt::Long;
use warnings;

# Validation section
my %options;
GetOptions( \%options, 'host=s', 'user=s', 'passwd=s' );
for my $arg (qw/host user passwd/) {
    die
        "\tperl a-modware-test.pl -host=ORACLE_DNS -user=USERNAME -passwd=PASSWD\n\n"
        if not defined $options{$arg};
}

my $host = $options{host};
my $user = $options{user};
my $pass = $options{passwd};
my $dsn = "dbi:Oracle:host=$host;sid=orcl;port=1521";

print "Connecting to the database... ";
my $dbh = DBI->connect( $dsn, $user, $pass );
say " success!!\n";

my $sth = $dbh->prepare('
	SELECT sorder.stock_order_id order_id, sc.id id, sc.systematic_name stock_name, colleague.first_name, colleague.last_name, colleague.colleague_no,
	sorder.order_date FROM cgm_ddb.stock_center sc
	JOIN cgm_ddb.stock_item_order sitem ON sc.id=sitem.item_id
	JOIN cgm_ddb.stock_order sorder ON sorder.stock_order_id=sitem.order_id
	JOIN cgm_ddb.colleague ON colleague.colleague_no = sorder.colleague_id
');

$sth->execute();

while (my ($OrderID,$ID,$StockName) = $sth->fetchrow() ){
	say $OrderID." ".$ID. " ". $StockName;
}


# Testing simple stuff
# my $ini = 'PF';
# $sth = $dbh->prepare('
# 	SELECT name FROM curator WHERE initials=?
# 	');

# $sth->execute($ini);

# while (my ($name) = $sth->fetchrow() ){
# 	print $name."\n";
# }

# $sth->finish();

# # Second test
# my $names = 
# 	$dbh->selectall_arrayref("
# 		SELECT name FROM curator
# 		");

# foreach my $row (@$names) {
# 	print "The name is $row->[0] \n";
# }

$sth->finish();


$dbh->disconnect();

exit;


# Loading the chado schema
my $chado = Bio::Chado::Schema->connect( $dsn, $user, $pass );

# and testing that it works
print "number of rows in feature table: ",
    $chado->resultset('Sequence::Feature')->count,
    "\n";

