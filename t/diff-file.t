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
        start_file => '--- /dev/null',
        end_file => '+++ b/README.md',
    );

    isa_ok($file, 'PlGit::Diff::File');
    is($file->start_file, '--- /dev/null');
    is($file->end_file, '+++ b/README.md');
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
    is($file->start_file, '--- a/README.md');
    is($file->end_file, '+++ b/README.md');
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

{
    # Mode Handling.
    my $file = PlGit::Diff::File->from_arrayref(
        [
            'diff --git a/README b/README',
            'old mode 100755',
            'new mode 100644',
            'index 345e6ae..f368db0',
            '--- a/README',
            '+++ b/README',
            '@@ -1 +1,3 @@',
            ' Test',
            '+',
            '+Testing more',
        ]
    );

    ok($file->old_mode eq 'old mode 100755');
    ok($file->new_mode eq 'new mode 100644');
    ok(@{$file->sections} == 1);
    is($file->start_file, '--- a/README');
    is($file->end_file, '+++ b/README');
    is($file->sections->[0]->pointset->start->start, 1);
    is($file->sections->[0]->pointset->start->lines, undef);
    is($file->sections->[0]->pointset->finish->start, 1);
    is($file->sections->[0]->pointset->finish->lines, 3);
}

{
    # Mode only (happens!)
    my $file = PlGit::Diff::File->from_arrayref(
        [
            'diff --git a/README b/README',
            'old mode 100644',
            'new mode 100755',
        ],
    );

    ok($file->old_mode eq 'old mode 100644');
    ok($file->new_mode eq 'new mode 100755');
    ok(@{$file->sections} == 0);
}

done_testing();
