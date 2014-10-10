package PlGit::Types;

use Moose::Util::TypeConstraints;

subtype 'PlGit::Repo::BranchList',
    as 'ArrayRef[PlGit::Repo::Branch]';

subtype 'PlGit::Repo::CommitList',
    as 'ArrayRef[PlGit::Repo::Commit]';

1;
