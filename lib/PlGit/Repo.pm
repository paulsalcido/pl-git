package PlGit::Repo;

# ABSTRACT: Object representing an entire repo

=head1 SYNOPSIS

    my $repo = PlGit::Repo->new(
        location => ... # string representing local dir
    );

    $repo->location; # passed location
    $repo->branches; # list of branches

=cut

use Moose;
use Moose::Util::TypeConstraints;

use MooseX::Method::Signatures;

use PlGit::Repo::Branch;

use PlGit::Types;

with 'PlGit::Role::Git';

subtype 'PlGit::Repo::RepositoryLocation',
    as 'Str',
    where {
        my $location = $_;
        ( -d $location ); # TODO: Make more complete
    };

coerce __PACKAGE__,
    from 'Str',
    via {
        __PACKAGE__->new(location => $_);
    };

subtype 'PlGit::RepoList',
    as 'ArrayRef[PlGit::Repo]';

coerce 'PlGit::RepoList',
    from 'ArrayRef[Str]',
    via {
        [
            map {
                __PACKAGE__->new(location => $_);
            } @$_
        ]
    };

has 'location' => (
    is => 'ro',
    isa => 'PlGit::Repo::RepositoryLocation',
    required => 1,
);

has 'branches' => (
    is => 'ro',
    isa => 'PlGit::Repo::BranchList',
    builder => '_build_branches',
    lazy => 1,
);

method _build_branches {
    [
        map {
            PlGit::Repo::Branch->from_string($self, $_);
        } @{$self->git($self, qw/branch/)}
    ];
}

method self_git(@info) {
    $self->git($self, @info);
}

method get_branch(Str $name!) {
    return [ grep { $_->name eq $name } @{$self->branches} ]->[0];
}

1;
