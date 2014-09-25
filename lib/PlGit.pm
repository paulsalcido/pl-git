package PlGit;

use Moose;

use PlGit::Repo;

has 'repositories' => (
    is => 'ro',
    isa => 'PlGit::RepoList',
    required => 1,
    coerce => 1,
);

__PACKAGE__->meta->make_immutable;

1;
