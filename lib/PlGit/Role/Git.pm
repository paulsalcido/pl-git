package PlGit::Role::Git;

# ABSTRACT: Role that allows for git to be called on a repo via system call.

use Moose::Role;
use File::chdir;

sub git {
    my $self = shift;
    my $repo = shift;
    my @args = @_;
    local $CWD = $repo->location;
    # TODO: Improve this to capture errors, etc.
    open(my $fh, '-|', 'git', @args) or Carp::confess "Failed to execute command git @args: $!";
    my @data = <$fh>;
    close($fh);
    chomp(@data);
    return \@data;
}

1;
