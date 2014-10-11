package PlGit::Diff::File;

use Moose;
use PlGit::Types;
use PlGit::Diff::File::Section;

# has 'command' => (
#     is => 'ro',
#     isa => 'PlGit::Diff::File::Command'
# );

# has 'file' => (
#     is => 'ro',
#     isa => 'PlGit::Diff::File::Name',
#     required => 1,
# );

# has ['preindex', 'postindex', 'index'] => (
#     is => 'ro',
#     isa => 'PlGit::Diff::File::Index',
#     required => 1,
# );

has 'section' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Section',
    coerce => 1,
    required => 1,
);

1;
