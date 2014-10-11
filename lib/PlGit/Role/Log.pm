package PlGit::Role::Log;

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
