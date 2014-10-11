package PlGit::Diff::File;

use Moose;

use Moose::Util::TypeConstraints;

use PlGit::Types;
use PlGit::Diff::File::Section;
use PlGit::Diff::File::Index;

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

has ['old_mode', 'new_mode'] => (
    is => 'ro',
    isa => 'Str|Undef',
    default => undef,
);

has 'command' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Command',
    required => 1,
);

has ['start_file', 'end_file'] => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Name|Undef',
    default => undef,
);

has 'indices' => (
    is => 'ro',
    isa => 'PlGit::Diff::File::Index|Undef',
    coerce => 1,
    default => undef,
);

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
    my $old_mode = ( $data[0] =~ /^old mode \d+$/ ) ? shift @data : undef;
    my $new_mode = ( $data[0] =~ /^new mode \d+$/ ) ? shift @data : undef;
    my $index = ($data[0] =~ /^index/ ) ? shift @data : undef;
    my $start_file = ($data[0] =~ /^---/ ) ? shift @data : undef;
    my $end_file = ($data[0] =~ /^\+\+\+/ ) ? shift @data : undef;
    $this->new(
        command => $command,
        start_file => $start_file,
        end_file => $end_file,
        indices => $index,
        old_mode => $old_mode,
        new_mode => $new_mode,
        sections => \@data,
    );
}

1;
