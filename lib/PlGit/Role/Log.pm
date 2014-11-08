package PlGit::Role::Log;

# ABSTRACT: Role that allows for the log command to be called on a specified object.

use Moose::Role;

with 'PlGit::Role::Git';

use PlGit::Repo::Commit;

sub simple_log {
    my $self = shift;
    my @args = @_;
    return [
        map {
            PlGit::Repo::Commit->create(
                id => $_,
                repo => $self->repo,
            );
        } @{$self->git($self->repo, qw/log --format=%H/, @args)}
    ];
}

1;
