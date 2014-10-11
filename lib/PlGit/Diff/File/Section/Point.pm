package PlGit::Diff::File::Section::Point;

use Moose;
use Moose::Util::TypeConstraints;

has ['start', 'lines'] => (
    is => 'ro',
    isa => 'Num',
    required => 1,
);

coerce __PACKAGE__,
    from 'ArrayRef[Num]',
    via {
        __PACKAGE__->new(
            start => $_->[0],
            lines => $_->[1],
        );
    };

1;
