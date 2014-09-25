package PlGit::Repo;

use Moose;
use Moose::Util::TypeConstraints;

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

1;
