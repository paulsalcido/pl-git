package PlGit::Repo::Commit;

# ABSTRACT: Object representing a commit in a repo.

use Moose;
use Moose::Util::TypeConstraints;

use MooseX::Method::Signatures;

use PlGit::Types;

with 'PlGit::Role::Log'  => { },
     'PlGit::Role::Diff' => { };

has 'id' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'repo' => (
    is => 'ro',
    isa => 'PlGit::Repo|Undef',
    default => undef,
);

sub diff_name {
    return $_[0]->commit;
}

# All String types based on show.
foreach my $item (
    [ 'tree_hash', '%T' ],
    [ 'abbrev_tree_hash', '%t' ],
    [ 'parents', '%P' ],
    [ 'abbrev_parents', '%p' ],
    [ 'author_name', '%an' ],
    [ 'author_email', '%ae' ],
    [ 'author_timestamp', '%at' ],
    [ 'committer_name', '%cn' ],
    [ 'committer_email', '%ce' ],
    [ 'committer_timestamp', '%ct' ],
    [ 'subject', '%s' ],
    [ 'body', '%b' ],
) {
    my $name = $item->[0];
    my $format = $item->[1];
    __PACKAGE__->meta->add_method(
        "_build_$name" => sub {
            my $self = shift;
            return $self->git($self->repo, 'show', '--quiet', "--format=$format", $self->id)->[0];
        }
    );

    has $name => (
        is => 'ro',
        isa => 'Str',
        builder => "_build_$name",
        lazy => 1,
    );
}

# TODO: Create singleton registry for commits.
# Use this create method to register them after the fact,
# and to check for registry on creation.
# Or move that all to the registry.
sub create {
    my $self = shift;
    my %options = @_;
    return $self->new(%options);
}

1;
