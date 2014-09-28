package PlGit;

use Moose;
use MooseX::Method::Signatures;
use File::chdir;

use PlGit::Repo;
use Carp;

has 'repositories' => (
    is => 'ro',
    isa => 'PlGit::RepoList',
    required => 1,
    coerce => 1,
);

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

__PACKAGE__->meta->make_immutable;

1;
