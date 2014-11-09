package PlGit::Types;

# ABSTRACT: Types class for PlGit

use Moose::Util::TypeConstraints;

subtype 'PlGit::Repo::BranchList',
    as 'ArrayRef[PlGit::Repo::Branch]';

subtype 'PlGit::Repo::CommitList',
    as 'ArrayRef[PlGit::Repo::Commit]';

subtype 'PlGit::Repo::TagList',
    as 'ArrayRef[PlGit::Repo::Tag]';

subtype 'PlGit::Diff::File::Command',
    as 'Str';

subtype 'PlGit::Diff::File::Name',
    as 'Str';

subtype 'PlGit::Diff::File::SectionList',
    as 'ArrayRef[PlGit::Diff::File::Section]';

subtype 'PlGit::Diff::FileList',
    as 'ArrayRef[PlGit::Diff::File]';

1;
