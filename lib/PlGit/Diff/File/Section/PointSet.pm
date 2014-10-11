package PlGit::Diff::File::Section::PointSet;

use Moose;
use Moose::Util::TypeConstraints;

use PlGit::Diff::File::Section::Point;

has ['start', 'finish'] => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Section::Point',
    coerce => 1,
    required => 1,
);

coerce __PACKAGE__,
    from 'Str',
    via {
        my $str = $_;
        ( $str =~ /^\@\@ \-(\d+)\,(\d+) \+(\d+)\,(\d+) \@\@/ ) ?
            __PACKAGE__->new(start => [ $1 , $2 ], finish => [ $3, $4 ]):
            undef;
    };

1;
