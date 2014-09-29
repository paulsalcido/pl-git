package PlGit::Repo::Branch;

use Moose;
use Moose::Util::TypeConstraints;

coerce 'PlGit::Repo::Branch',
    from 'Str',
    via {
        __PACKAGE__->coerce_from_string($_);
    };

subtype 'PlGit::Repo::BranchList',
    as 'ArrayRef[PlGit::Repo::Branch]';

coerce 'PlGit::Repo::BranchList',
    from 'ArrayRef[Str]',
    via {
        [
            map
            {
                __PACKAGE__->coerce_from_string($_);
            } @$_
        ]
    };

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'selected' => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

sub coerce_from_string {
    my $this = shift;
    my $description = $_;
    my $selected = (substr($description,0,1) eq '*')? 1 : 0;
    my $clean_name = $description;
    $clean_name =~ s/^\*?\s*//;
    $this->new(
        selected => $selected,
        name => $clean_name,
    );
}

1;
