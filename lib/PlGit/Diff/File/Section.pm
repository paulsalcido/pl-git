package PlGit::Diff::File::Section;

use Moose;

use PlGit::Diff::File::Section::PointSet;

has 'pointset' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Section::PointSet',
    coerce => 1,
    required => 1,
);

has 'contents' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    required => 1,
);

1;
