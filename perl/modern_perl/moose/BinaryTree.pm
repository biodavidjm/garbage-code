package BinaryTree;

# Demonstrates several attribute features, including types, weak references,
# predicates ("does this object have a foo?"), defaults, laziness, and
# triggers

use Moose; use Method::Signatures;

has 'node' => (
    is  => 'rw',
    isa => 'Any',
    # literally means it can contain anything.
    # We could have left this out, but we included for the benefit of other programmers.
);

has 'parent' => (
    is        => 'rw',
    isa       => 'BinaryTree',
    predicate => 'has_parent'
    , # Creates a method (internally) that can check whether the attribute has been set
    weak_ref => 1
    , # weakening the reference to avoid memory leaks. It should work without this.
);

has 'left' => (
    is        => 'rw',
    isa       => 'BinaryTree',
    predicate => 'has_left',

    # Lazy and default are linked (lazy cannot be set without default)
    lazy    => 1,
    default => sub { BinaryTree->new( parent => $_[0] ) },

# If the default is coming with lazy => 1 means that If the attribute has a
# value when it is read, the default is never executed at all. This is
# important in this case since the binary tree tries to populate the left and
# right branches.
    trigger => \&_set_parent_for_child
);

has 'right' => (
    is        => 'rw',
    isa       => 'BinaryTree',
    predicate => 'has_right',
    lazy      => 1,
    default   => sub { BinaryTree->new( parent => $_[0] ) },
    trigger   => \&_set_parent_for_child
);

sub _set_parent_for_child {
    my ( $self, $child ) = @_;

    confess "You cannot insert a tree which already has a parent"
        if $child->has_parent;

    $child->parent($self);
}

1;
