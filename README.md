# Full Fat Monads

An experimental replacement for DRY monads that attempts to:

  - reduce implementation complexity
  - provide a more idiomatic FP usage experience
  - provide more functionality

## Change log

See [the change log](Changelog.md)

Each branch in the code is listed in the change log.  Branches that
are not merged will have a `TODO` section heading with some points
indicating what I plan to do.  Each item in the `TODO` section is
checked off as I do it.  More items are usually added over time as
I discover what I need to do.

Merged branches will have a section called `DONE` that lists all
of the things I did in that branch.  As much as possible items in the
change log will correspond to commits in git.  If you do a `git blame`
on the Changelog, you will find the commit where that work was done.
I'm not strict about that, so often it doesn't work, but I try to
do it as often as I remember.

## How to do various things

### Tests

To run the tests once
`bundle exec rspec`

To watch the directories and run the tests after changes
`bundle exec guard`

### Lint

To run the rubocop linter
`bundle exec rubocop`

To automatically fix linting warnings (warning: not always safe)
`bundle exec rubocop -A`

### Documentation

To generate the documentation
`yard doc`

To display how bad I am at writing documentation

`yard stats`
