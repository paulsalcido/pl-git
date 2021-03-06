package PlGit::Diff;

# ABSTRACT: Object representing a diff between two objects.

=head1 SYNOPSIS

    my $diff = PlGit::Diff->new(
        start_ref   => # Something that does PlGit::Role::Diff
        end_ref     => # Something that does PlGit::Role::Diff
    );

    my $commits = $diff->commits; # ArrayRef[PlGit::Repo::Commit]
    my $diff_arr = $diff->raw_diff; # ArrayRef[Str]
    my $files = $diff->files; # ArrayRef[PlGit::Diff::File]

=cut

use Moose;
use MooseX::Method::Signatures;

use PlGit::Types;
use PlGit::Diff::File;

with 'PlGit::Role::Log' => { };

has ['start_ref'] => (
    is => 'ro',
    does => 'PlGit::Role::Diff',
    required => 1,
);

has ['end_ref'] => (
    is => 'ro',
    does => 'PlGit::Role::Diff',
    handles => [ qw/repo/ ],
    required => 1,
);

has 'commits' => (
    is => 'ro',
    isa => 'PlGit::Repo::CommitList',
    builder => '_build_commits',
    lazy => 1,
);

has 'raw_diff' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    builder => '_build_raw_diff',
    lazy => 1,
);

has 'files' => (
    is => 'ro',
    isa => 'PlGit::Diff::FileList',
    builder => '_build_files',
    lazy => 1,
);

method _build_commits {
    return $self->simple_log($self->_diff_ref_string);
}

method _build_raw_diff {
    return $self->git($self->repo, 'diff', $self->_diff_ref_string);
}

method _diff_ref_string {
    return join('..', $self->start_ref->diff_name, $self->end_ref->diff_name);
}

method _build_files {
    return PlGit::Diff::File->filelist_from_arrayref($self->raw_diff);
}

1;
