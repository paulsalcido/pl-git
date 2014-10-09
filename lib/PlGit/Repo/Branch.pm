package PlGit::Repo::Branch;

use Moose;
use Moose::Util::TypeConstraints;

use PlGit::Repo::Commit;

with 'PlGit::Role::Log';

subtype 'PlGit::Repo::BranchList',
    as 'ArrayRef[PlGit::Repo::Branch]';

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'selected' => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

has 'log' => (
    is => 'ro',
    isa => 'PlGit::Repo::CommitList',
    builder => '_build_log',
    lazy => 1,
);

has 'repo' => (
    is => 'ro',
    isa => 'PlGit::Repo|Undef',
    required => 0,
    default => undef,
);

sub from_string {
    my $this = shift;
    my $repo = shift;
    my $description = shift;
    my $selected = (substr($description,0,1) eq '*')? 1 : 0;
    my $clean_name = $description;
    $clean_name =~ s/^\*?\s*//;
    $this->new(
        selected => $selected,
        name => $clean_name,
        repo => $repo,
    );
}

sub _build_log {
    my $self = shift;
    return [
        map {
            PlGit::Repo::Commit->create(
                id => $_,
                branch => $self,
                repo => $self->repo,
            );
        } @{$self->git($self->repo, 'log', $self->name, '--format=%H')}
    ];
}

1;
