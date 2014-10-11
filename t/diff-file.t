use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('PlGit::Diff::File');
}

{
    my $file = PlGit::Diff::File->new(
        section => [
            '@@ -1 +1,1 @@',
            '-Initial Commit',
            '+Test Data',
        ],
    );

    isa_ok($file, 'PlGit::Diff::File');
    is($file->section->pointset->start->start, 1);
    is($file->section->pointset->start->lines, undef);
    is($file->section->pointset->finish->start, 1);
    is($file->section->pointset->finish->lines, 1);
    is_deeply($file->section->contents, [
        '-Initial Commit',
        '+Test Data',
    ]);
}

done_testing();
