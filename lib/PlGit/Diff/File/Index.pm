package PlGit::Diff::File::Index;

# ABSTRACT: Represents the indexes on a file before or after a modification.

use Moose;
use Moose::Util::TypeConstraints;

coerce __PACKAGE__,
    from 'Str',
    via {
        __PACKAGE__->from_str($_);
    };

has ['start', 'end'] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has ['mode'] => (
    is => 'ro',
    isa => 'Str|Undef',
    default => undef,
);

sub from_str {
    my $this = shift;
    my $str = shift;
    return ( $str =~ /^index ([0-9a-f]+)..([0-9a-f]+)(?: (\d+))?$/ ) ?
        $this->new(start => $1, end => $2, mode => $3) : undef;
}

1;
