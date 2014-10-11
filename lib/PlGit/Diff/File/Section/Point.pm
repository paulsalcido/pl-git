package PlGit::Diff::File::Section::Point;

use Moose;
use Moose::Util::TypeConstraints;

has 'start' => (
    is => 'ro',
    isa => 'Num',
    required => 1,
);

has 'lines' => (
    is => 'ro',
    isa => 'Num|Undef',
    required => 1,
);

coerce __PACKAGE__,
    from 'ArrayRef[Num|Undef]',
    via {
        __PACKAGE__->new(
            start => $_->[0],
            lines => $_->[1],
        );
    };

1;
