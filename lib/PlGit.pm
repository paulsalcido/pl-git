package PlGit;

use Moose;
use MooseX::Method::Signatures;

use PlGit::Repo;

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
    # TODO: Improve this to capture errors, etc.
    open(my $fh, sprintf("(cd %s && git @args) |", $repo->location)) or die $!;
    my @data = <$fh>;
    close($fh);
    chomp(@data);
    return \@data;
}

__PACKAGE__->meta->make_immutable;

1;
