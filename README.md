biodavidjm garbage-code collection
============

And here it is my collection of junk code, which helps me understand many useful things, most of them related directly or indirectly with the dictyBase. 

The main languages are:


## Perl
***

### DBI
Check the folder to see all the scripts.

##### `postgres` folder contains examples of Perl scripts working with PostgreSQL

* ``testing_pg.pl``: basic operations using DBI::pg

* ``transactions_pg.pl``: Many databases support **transactions**. This means that you can make a whole bunch of queries which would modify the databases, but none of the changes are actually made. Then at the end you issue the special SQL query **COMMIT**, and all the changes are made simultaneously. Alternatively, you can issue the query **ROLLBACK**, in which case all the queries are thrown away.


### Modern Perl
Learning to run Modern Perl, i.e., the way the world's most effective Perl programmers work, i.e., the way the world's most effective Perl programmers work. [Here is the link](http://modernperlbooks.com/books/modern_perl_2014/) to the last version (2014) of the book.

- Personal Goals

	[ ] Learn Perl Object Oriented language from the Perl's professional perspective.

	[ ] Learn Modern Perl.

### Moose
* Class, from its own definition: A role is something that classes do. Usually, a role encapsulates some piece of behavior or state that can be shared between classes. It is important to understand that roles are not classes. You cannot inherit from a role, and a role cannot be instantiated. We sometimes say that ***roles are consumed, either by classes or other roles***


## SQL
***
- List of SQL statements I have tried so far (see the readme file in the `sql` directory)


## HTML-CSS
***
See the list of pages in the folder.