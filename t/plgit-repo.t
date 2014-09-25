use strict;
use warnings;

use lib qw(t/lib);
use Test::More tests => 2;

use PlGit::Test;

BEGIN {
    use_ok('PlGit::Repo');
}

my $test = PlGit::Test::Repo->new;

$test->initialize;

my $plgit = PlGit::Repo->new(location => $test->bare_location);

is($plgit->location, $test->bare_location);
