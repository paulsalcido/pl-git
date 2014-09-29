use strict;
use warnings;

use lib qw(t/lib);
use Test::More tests => 4;

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
    ]
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
    ]
);
