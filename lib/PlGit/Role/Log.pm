package PlGit::Role::Log;

use Moose::Role;

with 'PlGit::Role::Git';

sub simple_log {
    my $self = shift;
    my $repo = shift;
    $self->git(qw/log --format="%C"/);
}

1;
