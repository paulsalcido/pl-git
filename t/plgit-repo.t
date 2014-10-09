use strict;
use warnings;

use lib qw(t/lib);
use Test::More tests => 32;

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

$test->add_branch($test->bare_location, 'test');

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
foreach my $field ( qw/
    tree_hash
    abbrev_tree_hash
    parents
    abbrev_parents
    author_name
    author_email
    author_timestamp
    committer_name
    committer_email
    committer_timestamp
    subject
    body
/) {
    can_ok($log->[0], $field);
    ok(defined($log->[0]->$field), 'PlGit::Repo::Log has defined ' . $field);
}

is($log->[0]->author_name, PlGit::Repo->new(location => $test->bare_location)->self_git('config', '--get', 'user.name')->[0], 'commit user name matches');
is($log->[0]->author_email, PlGit::Repo->new(location => $test->bare_location)->self_git('config', '--get', 'user.email')->[0], 'commit user email matches');
