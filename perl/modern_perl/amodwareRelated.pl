#!/usr/bin/env perl

use strict;

use DBI;
use Bio::Chado::Schema;

my $host = "dicty-oracle-vm.nubic.northwestern.edu";
my $dsn = "dbi:Oracle:host=$host;sid=orcl;port=1521";
my $user = "CGM_CHADO";
my $password = $user;

my $chado = Bio::Chado::Schema->connect( $dsn, $user, $password );

print "number of rows in feature table: ",
    $chado->resultset('Sequence::Feature')->count,
    "\n";