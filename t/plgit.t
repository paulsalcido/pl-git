use strict;
use warnings;

use Test::More tests => 2;

use File::Temp;
use File::Spec;

BEGIN {
    use_ok('PlGit');
}

my $basic_git_dir = File::Temp->newdir('plgit_test_XXXX', CLEANUP => 1);
my $git_dir = File::Spec->catfile($basic_git_dir, 'bare');
system(sprintf('(mkdir %s && cd %s && git init --bare)', $git_dir, $git_dir));

my $plgit = PlGit->new(repositories => [ $git_dir ]);

is_deeply($plgit->repositories, [ $git_dir ]);
