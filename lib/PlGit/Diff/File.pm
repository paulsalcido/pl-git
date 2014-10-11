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

coerce __PACKAGE__,
    from 'ArrayRef[Str]',
    via {
        __PACKAGE__->from_arrayref($_);
    };

has 'command' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Command',
    required => 1,
);

# has ['start_file', 'end_file] => (
#     is => 'ro',
#     isa => 'PlGit::Diff::File::Name',
#     required => 1,
# );

# TODO: index line is actually pre, post, and file stat
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

sub from_arrayref {
    my $this = shift;
    my $file = shift;
    my @data = @$file;
    my $command = shift @data;
    my $index = shift @data;
    my $start_file = shift @data;
    my $end_file = shift @data;
    $this->new(
        command => $command,
        start_file => $start_file,
        end_file => $end_file,
        index => $index,
        sections => \@data,
    );
}

1;
