package PlGit::Repo::Branch;

# ABSTRACT: Object representing a branch for a repo.

use Moose;
use Moose::Util::TypeConstraints;

use PlGit::Repo::Commit;

use PlGit::Types;

with 'PlGit::Role::Log'  => { },
     'PlGit::Role::Diff' => { };

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

sub diff_name {
    return $_[0]->name;
}

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
    return $self->simple_log($self->name);
}

1;
