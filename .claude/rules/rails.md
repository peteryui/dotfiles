---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "**/Gemfile*"
---
# Rails

- Ruby comes from rbenv via `.ruby-version`; `mise` manages nothing on this machine.
- Gates, in order: `bin/brakeman` · `bin/bundle-audit check --update` ·
  `bin/rubocop --parallel` · `bundle exec rails test`. A repo without the `bin/`
  wrappers runs what its CI runs.
- Per-worktree test DB: override `DATABASE_URL` with a `_<branch-slug>` suffix on
  the database name, so parallel worktrees never share one.
- A PR that adds a migration says so in its description; the merge is the
  migration decision.
- `rails credentials:edit`, master keys and anything that deploys are Peter's:
  prepare the change, then hand him the command.
