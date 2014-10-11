package PlGit::Diff::File::Section;

use Moose;
use Moose::Util::TypeConstraints;

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

coerce __PACKAGE__,
    from 'ArrayRef[Str]',
    via {
        my @data = @$_;
        my $points = shift @data;
        __PACKAGE__->new(
            pointset => $points,
            contents => \@data,
        );
    };

1;
