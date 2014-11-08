package PlGit;

# ABSTRACT: Object oriented view into a git repository

use Moose;
use MooseX::Method::Signatures;

use PlGit::Repo;

with 'PlGit::Role::Git';

=head1 METHODS

=method repositories

Can be set at the beginning with the 'repositories' option.

This will coerce items from strings into PlGit::Repo objects.

=cut

has 'repositories' => (
    is => 'ro',
    isa => 'PlGit::RepoList',
    required => 1,
    coerce => 1,
);

__PACKAGE__->meta->make_immutable;

1;
