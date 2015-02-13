package DavidFirstApp;

use Moose;
extends qw(MooseX::App::Cmd);

use Method::Signatures;
use feature qw/say/;

has data => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {
        [   qw/this and that/
        ];
    },
    documentation =>
        'what is the default and what it isnt'
);

# sub execute {
# 	my ($self, $opt, $args) = @_;
# 	print "Everything has been initialized.  (Not really.)\n";
# }

sub usage_desc { "appcmd.pl %o [dbfile ...]" }

sub opt_spec {
	return (
	  [ "skip-refs|R",  "skip reference checks during init", ],
	  [ "values|v=s@",  "starting values", { default => [ 0, 1, 3 ] } ],
	);
}

sub validate_args {
	my ($self, $opt, $args) = @_;

	# we need at least one argumentsment beyond the options; die with that message
	# and the complete "usage" text describing switches, etc
	$self->usage_error("too few arguments") unless @$args;
}


1;    # Magic true value required at end of module

__END__

=head1 initialize
this is what it looks like
=cut