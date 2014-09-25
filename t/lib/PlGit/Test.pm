package PlGit::Test;

package PlGit::Test::Repo;

use Moose;
use File::Temp;
use File::Spec;
use File::Path;
use Cwd qw/abs_path/;

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
    system(sprintf('(cd %s && git clone %s %s) >/dev/null 2>&1', $self->temp, $self->bare_location, $self->fill_location)) and die $!;
    system(sprintf('echo "initial commit" >> %s', File::Spec->catfile($self->fill_location, 'README'))) and die $!;
    system(sprintf('(cd %s && git add --all && git commit -m "Initial Commit") >/dev/null 2>&1', $self->fill_location)) and die $!;
    system(sprintf('(cd %s && git push -u origin master:master) >/dev/null 2>&1', $self->fill_location)) and die $!;
}

sub bare_location {
    my $self = shift;
    return File::Spec->catfile($self->temp, 'bare');
}

sub fill_location {
    my $self = shift;
    return File::Spec->catfile($self->temp, 'fill');
}

1;
