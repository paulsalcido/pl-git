package PlGit::Test;

package PlGit::Test::Repo;

use Moose;
use File::Temp;
use File::Spec;
use File::Path;

use File::chdir;

has 'temp' => (
    is => 'ro',
    default => sub { File::Temp::tempdir('plgit-test-XXXX', CLEANUP => 0, DIR => $ENV{TMPDIR} || '/tmp' ) },
);

sub initialize {
    my $self = shift;
    File::Path::mkpath($self->bare_location) or die $!;
    system(sprintf('(cd %s && git init --bare) >/dev/null 2>&1', $self->bare_location)) and die $!;
    $self->fill_bare;
}

sub fill_bare {
    my $self = shift;
    local $CWD = $self->temp;
    system('git', 'clone', $self->bare_location, $self->fill_location) and die $!;
    open(my $fh, '>', File::Spec->catfile($self->fill_location, 'README')) or die $!;
    print $fh "Initial commit\n";
    close($fh);
    {
        local $CWD = $self->fill_location;
        system(qw/git add --all/);
        system(qw/git commit -m/,"Initial Commit");
        system(qw/git push -u origin master:master/);
    }
}

sub bare_location {
    my $self = shift;
    return File::Spec->catfile($self->temp, 'bare');
}

sub fill_location {
    my $self = shift;
    return File::Spec->catfile($self->temp, 'fill');
}

sub add_branch {
    my $self = shift;
    my $name = shift;
    my $repo = shift || $self->bare_location;
    system(sprintf('(cd %s && git branch %s) >/dev/null 2>&1', $repo, $name));
}

1;
