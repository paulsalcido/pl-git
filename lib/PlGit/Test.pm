package PlGit::Test;

# ABSTRACT: Testing utils for PlGit

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
    $self->commit($self->fill_location, 'Initial Commit');
}

sub commit {
    my $self = shift;
    my $repo = shift;
    my $message = shift;
    {
        local $CWD = $repo;
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
    my $repo = shift || $self->bare_location;
    my $name = shift;
    system(sprintf('(cd %s && git branch %s) >/dev/null 2>&1', $repo, $name));
}

sub quick_commit {
    my $self = shift;
    my $repo = shift;
    my $data = shift;
    open(my $fh, '>>', File::Spec->catfile($self->fill_location, 'README')) or die $!;
    print $fh $data . "\n";
    close($fh);
    $self->commit($repo, $data);
}

sub push {
    my $self = shift;
    my $repo = shift;
    my $branch = shift;
    system(sprintf('(cd %s && git push origin %s) >/dev/null 2>&1', $repo, $branch));
}

sub switch_branch {
    my $self = shift;
    my $repo = shift;
    my $name = shift;
    system(sprintf('(cd %s && git checkout %s) >/dev/null 2>&1', $repo, $name));
}

1;
