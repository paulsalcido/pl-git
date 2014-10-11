package PlGit::Diff::File;

use Moose;
use PlGit::Types;
use PlGit::Diff::File::Section;

use Moose::Util::TypeConstraints;

coerce 'PlGit::Diff::File::SectionList',
    from 'ArrayRef[Str]',
    via {
        [
            map {
                    PlGit::Diff::File::Section->from_arrayref($_);
            } @{_split_section_output($_)}
        ];
    };

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

has 'sections' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::SectionList',
    coerce => 1,
    required => 1,
);

sub _split_section_output {
    my $section_data = shift;
    my $sections = [ ];
    foreach my $line ( @$section_data ) {
        if ( $line =~ /^\@\@/ ) {
            push @$sections, [ ];
        }
        push $sections->[-1], $line;
    }
    return $sections;
}

1;
