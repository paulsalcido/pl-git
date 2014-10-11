use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('PlGit::Diff::File::Section');
    use_ok('PlGit::Diff::File::Section::Point');
    use_ok('PlGit::Diff::File::Section::PointSet');
    use_ok('PlGit::Diff::File::Index');
}

{
    my $point = PlGit::Diff::File::Section::Point->new(start => 1, lines => 2);
    isa_ok($point, 'PlGit::Diff::File::Section::Point');
    is($point->start, 1, "point stores starting line correctly");
    is($point->lines, 2, "point stores number of lines correctly");
}

{
    my $point = PlGit::Diff::File::Section::Point->new(start => 1, lines => undef);
    isa_ok($point, 'PlGit::Diff::File::Section::Point');
    is($point->start, 1, "point with undef lines has start");
    is($point->lines, undef, "point with undef lines has undef lines");
}

{
    my $pointset = PlGit::Diff::File::Section::PointSet->new(
        start => [ 1, 3 ],
        finish => [ 2, 5 ],
    );

    isa_ok($pointset, 'PlGit::Diff::File::Section::PointSet');
    isa_ok($pointset->start, 'PlGit::Diff::File::Section::Point');
    isa_ok($pointset->finish, 'PlGit::Diff::File::Section::Point');
    is($pointset->start->start, 1);
    is($pointset->start->lines, 3);
    is($pointset->finish->start, 2);
    is($pointset->finish->lines, 5);
}

{
    my $section = PlGit::Diff::File::Section->new(
        pointset => '@@ -1,3 +2,5 @@',
        contents => [
            '-Initial Commit',
            '-Test Commit',
            '+Initial Commit Test',
            '+Test Commit Test',
            '+Testing',
        ],
    );

    isa_ok($section, 'PlGit::Diff::File::Section');

    my $pointset = $section->pointset;
    isa_ok($pointset, 'PlGit::Diff::File::Section::PointSet');
    isa_ok($pointset->start, 'PlGit::Diff::File::Section::Point');
    isa_ok($pointset->finish, 'PlGit::Diff::File::Section::Point');
    is($pointset->start->start, 1);
    is($pointset->start->lines, 3);
    is($pointset->finish->start, 2);
    is($pointset->finish->lines, 5);
}

{
    my $section = PlGit::Diff::File::Section->new(
        pointset => '@@ -1 +2,5 @@',
        contents => [
            '-Initial Commit',
            '-Test Commit',
            '+Initial Commit Test',
            '+Test Commit Test',
            '+Testing',
        ],
    );

    isa_ok($section, 'PlGit::Diff::File::Section');

    my $pointset = $section->pointset;
    isa_ok($pointset, 'PlGit::Diff::File::Section::PointSet');
    isa_ok($pointset->start, 'PlGit::Diff::File::Section::Point');
    isa_ok($pointset->finish, 'PlGit::Diff::File::Section::Point');
    is($pointset->start->start, 1);
    is($pointset->start->lines, undef);
    is($pointset->finish->start, 2);
    is($pointset->finish->lines, 5);
}

{
    my $index = PlGit::Diff::File::Index->new(
        start => '1111111',
        end => '2222222',
        mode => '100644',
    );

    isa_ok($index, 'PlGit::Diff::File::Index');
    is($index->start, '1111111');
    is($index->end, '2222222');
    is($index->mode, '100644');
}

{
    my $index = PlGit::Diff::File::Index->from_str(
        'index 1111111..2222222 100644',
    );

    isa_ok($index, 'PlGit::Diff::File::Index');
    is($index->start, '1111111');
    is($index->end, '2222222');
    is($index->mode, '100644');
}

{
    my $index = PlGit::Diff::File::Index->from_str(
        'index 1111111..2222222',
    );

    isa_ok($index, 'PlGit::Diff::File::Index');
    is($index->start, '1111111');
    is($index->end, '2222222');
    is($index->mode, undef);
}

done_testing();
