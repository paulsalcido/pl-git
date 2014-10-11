use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('PlGit::Diff::File');
}

{
    my $file = PlGit::Diff::File->new(
        sections => [
            '@@ -1 +1,1 @@',
            '-Initial Commit',
            '+Test Data',
        ],
    );

    isa_ok($file, 'PlGit::Diff::File');
    is($file->sections->[0]->pointset->start->start, 1);
    is($file->sections->[0]->pointset->start->lines, undef);
    is($file->sections->[0]->pointset->finish->start, 1);
    is($file->sections->[0]->pointset->finish->lines, 1);
    is_deeply($file->sections->[0]->contents, [
        '-Initial Commit',
        '+Test Data',
    ]);
}

done_testing();
