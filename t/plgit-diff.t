use strict;
use warnings;

use Test::More tests => 11;

use PlGit::Test;
use Data::Dumper;

BEGIN {
    use_ok('PlGit::Repo');
}

my $test = PlGit::Test::Repo->new;

$test->initialize;

$test->add_branch($test->fill_location, 'test');
$test->switch_branch($test->fill_location, 'test');
$test->quick_commit($test->fill_location, 'Test Commit 1');

my $branches = ( my $plgit = PlGit::Repo->new(location => $test->fill_location))->branches;

foreach my $branch ( @$branches ) {
    can_ok($branch, 'diff');
    ok($branch->does('PlGit::Role::Diff'));
}

my $diff = $plgit->get_branch('master')->diff($plgit->get_branch('test'));

isa_ok($diff, 'PlGit::Diff');
is_deeply($diff->start_ref, $plgit->get_branch('master'));
is_deeply($diff->end_ref, $plgit->get_branch('test'));

ok((@{$diff->commits} == 1), "Only one commit in diff");
is_deeply($diff->commits->[0], $diff->end_ref->log->[0]);

my @diff_items = @{$diff->raw_diff};

splice @diff_items, 1, 1;

is_deeply(\@diff_items,
    [
        'diff --git a/README b/README',
        '--- a/README',
        '+++ b/README',
        '@@ -1 +1,2 @@',
        ' Initial commit',
        '~',
        '+Test Commit 1',
        '~'
    ],
);


done_testing();
