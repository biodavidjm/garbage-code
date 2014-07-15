#!/usr/bin/perl -w

use strict;
use feature qw/say/;

use DBIx::Class::Schema::Loader qw/ make_schema_at /;

make_schema_at(
    'djmusic::Schema',
    { debug => 1,
      dump_directory => './lib',
    },
    [ 'dbi:Pg:dbname="djmusic"', 'djt469', '' ],
);



=head1 NAME

djmusic_schemaloader.pl - Creates a library to load a database schema

=head1 SYNOPSIS

perl djmusic_populatetables.pl

=head1 OUTPUT

pop_all_djmusic_tables.sql

=head1 DESCRIPTION

It parses the iTunes xml file and creates a sql file which will insert all the
values in the database. Things to take into account:  

1. The only special character that I need to be worry about is ', which should
be replace by ''
