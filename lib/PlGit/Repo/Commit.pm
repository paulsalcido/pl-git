package PlGit::Repo::Commit;

use Moose;
use Moose::Util::TypeConstraints;

use MooseX::Method::Signatures;

subtype 'PlGit::Repo::CommitList',
    as 'ArrayRef[PlGit::Repo::Commit]';

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
