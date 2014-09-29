use strict;
use warnings;

use lib qw(t/lib);
use Test::More tests => 6;

use PlGit::Test;

BEGIN {
    use_ok('PlGit::Repo');
}

my $test = PlGit::Test::Repo->new;

$test->initialize;

is(PlGit::Repo->new(location => $test->bare_location)->location, $test->bare_location);

is_deeply(
    [
        map
        {
            {
                name => $_->name,
                selected => $_->selected
            }
        } @{PlGit::Repo->new(location => $test->bare_location)->branches}
    ],
    [
        {
            name => 'master',
            selected => 1,
        },
    ],
    "Originally, bare repo has only one branch",
);

$test->add_branch('test');

is_deeply(
    [
        map
        {
            {
                name => $_->name,
                selected => $_->selected
            }
        } @{PlGit::Repo->new(location => $test->bare_location)->branches}
    ],
    [
        {
            name => 'master',
            selected => 1,
        },
        {
            name => 'test',
            selected => 0,
        },
    ],
    "With a second branch, bare repo has proper branches",
);

my $log = PlGit::Repo->new(location => $test->bare_location)->branches->[0]->log;

ok(
    scalar(@$log) == 1,
    "Repo has only one commit.",
);

isa_ok($_, 'PlGit::Repo::Commit') foreach @$log;
