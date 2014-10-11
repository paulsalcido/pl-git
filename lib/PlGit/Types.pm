package PlGit::Types;

use Moose::Util::TypeConstraints;

subtype 'PlGit::Repo::BranchList',
    as 'ArrayRef[PlGit::Repo::Branch]';

subtype 'PlGit::Repo::CommitList',
    as 'ArrayRef[PlGit::Repo::Commit]';

subtype 'PlGit::Diff::File::Command',
    as 'Str';

subtype 'PlGit::Diff::File::Name',
    as 'Str';

subtype 'PlGit::Diff::File::Index',
    as 'Str';

1;
