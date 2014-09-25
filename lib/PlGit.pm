package PlGit;

use Moose;

has 'repositories' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    required => 1,
);

1;
