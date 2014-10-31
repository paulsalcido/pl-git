package PlGit::Role::Diff;

# ABSTRACT: Role that marks an object as being part of a possible diff command.

use Moose::Role;
use MooseX::Method::Signatures;

use PlGit::Diff;

requires 'diff_name';

method diff($ref! where { $_->does('PlGit::Role::Diff') }) {
    return PlGit::Diff->new(start_ref => $self, end_ref => $ref, repo => $self->repo);
}

1;
