package PlGit::Diff::File::Section;

# ABSTRACT: Object representing a section of a file shown in a diff.

use Moose;
use MooseX::Method::Signatures;
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
        __PACKAGE__->from_arrayref($_);
    };

sub from_arrayref {
    my $this = shift;
    my $section = shift;
    my @data = @$section;
    my $points = shift @data;
    __PACKAGE__->new(
        pointset => $points,
        contents => \@data,
    );
}

1;
