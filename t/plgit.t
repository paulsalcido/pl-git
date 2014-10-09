use strict;
use warnings;

use lib qw(t/lib);
use Test::More tests => 3;

use PlGit::Test;

BEGIN {
    use_ok('PlGit');
}

my $test = PlGit::Test::Repo->new;

$test->initialize;

my $plgit = PlGit->new(repositories => [ $test->bare_location ]);

is_deeply([ map { $_->location } @{$plgit->repositories} ], [ $test->bare_location ], "repositories are properly coerced.");
is_deeply($plgit->git($plgit->repositories->[0],'branch'), [ '* master' ], "git command shows bare repo only has master branch.");
