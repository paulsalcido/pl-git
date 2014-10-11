use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('PlGit::Diff::File');
}

{
    my $file = PlGit::Diff::File->new(
        command => 'diff --git a/README.md b/README.md',
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

{
    my $file = PlGit::Diff::File->from_arrayref(
        [
            'diff --git a/README.md b/README.md',
            'index 123456a..1b35b6f 100644',
            '--- a/README.md',
            '+++ b/README.md',
            '@@ -1 +1,1 @@',
            '-Initial Commit',
            '+Test Data',
            '@@ -10 +10,1 @@',
            '-Why?',
            '+Not'
        ],
    );
    isa_ok($file, 'PlGit::Diff::File');
    ok(@{$file->sections} == 2);
    is($file->command, 'diff --git a/README.md b/README.md');
    is($file->sections->[1]->pointset->start->start, 10);
    is($file->sections->[1]->pointset->start->lines, undef);
    is($file->sections->[1]->pointset->finish->start, 10);
    is($file->sections->[1]->pointset->finish->lines, 1);
    is_deeply($file->sections->[1]->contents,
        [
            '-Why?',
            '+Not',
        ],
    );
}

done_testing();
