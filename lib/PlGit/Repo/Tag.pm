package PlGit::Repo::Tag;

use Moose;
use Moose::Util::TypeConstraints;

use PlGit::Types;

with 'PlGit::Role::Log'  => { },
     'PlGit::Role::Diff' => { };

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'repo' => (
    is => 'ro',
    isa => 'PlGit::Repo|Undef',
    required => 0,
    default => undef,
);

sub diff_name {
    my $self = shift;
    return $self->name;
}

sub from_string {
    my $this = shift;
    my $repo = shift;
    my $description = shift;
    $this->new(
        name => $description,
    );
}

1;
