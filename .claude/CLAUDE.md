# Global CLAUDE.md

Peter is a senior developer. Facts (files, git history, `--help`, version files)
are yours to look up; decisions are his. Before acting on any unclear part of a
task, interview him with `mattpocock-skills:grilling`: the whole frontier of open
decisions in one numbered round, each with your recommended answer, then wait.
If nobody is watching the session, write the open questions into the working doc
and stop there.

## Modes

- **Engineering task** → the workflow below.
- **Business / strategy** → conversation, or `/office-hours` and
  `/plan-ceo-review` (gstack). No branches, commits or code in this mode.

## Skill routing

Skills trigger from their own descriptions. On top of that:

- When a `mattpocock-skills` and a `superpowers` skill cover the same moment, use `mattpocock-skills`.
- Web browsing goes through `/browse` (gstack).
- The ship step (tests → review → version → PR) is `/ship` (gstack).
- Stack rules (Rails, Flutter) load on demand from `~/.claude/rules/`; a repo's
  own CLAUDE.md overrides them.

## Every task survives an interruption

Any session can be cut off mid-task. A follower with no chat history must be able
to pick the task up from the repo alone.

- **Resume first.** At session start: `git worktree list`, open issues and draft
  PRs assigned to you, working docs whose Status is not done. Continue the
  unfinished task; ask Peter only when more than one is unfinished.
- **Working doc per task** at `docs/plans/<issue#>-<slug>.md`, committed on the
  task branch, with these headings: Goal and issue · Status (done / doing / next) ·
  Background and discussion · Decisions and rejected alternatives · Unrelated
  findings · How to resume (branch, worktree, commands, test state, open questions).
- **Checkpoint** at every step boundary (a decision, a blocker, a finding, before
  the next step): update the doc, commit, push. A commit that leaves the doc stale
  is not a checkpoint. Open a draft PR at the first push so state survives the laptop.
- **On completion** set Status to done and keep the doc; move what belongs in the
  permanent docs there. Something unrelated you noticed becomes a new issue; its
  fix waits for its own branch.

## GitHub — repos with a remote

The issue tracker is the task list; issue and PR threads are shared memory.

- **Issue first.** Every task is an issue; agree the scope there before coding.
  Read open issues and PRs so two agents never take the same task; assign yourself.
- **One issue per PR**, body `Closes #<n>`. A status comment on the issue points
  at the working doc.
- **Review is the gate.** Post the PR link and stop. Merging is Peter's, after
  review; CI workflows are added only when asked.
- **Review feedback** → a new commit on the same branch, then reply in each thread
  with what changed or why it should not.

## Git

- Branch `<type>/<issue#>-<slug>` from the repo's integration branch; PR into it.
  Every change to `main` or `develop` arrives through a PR.
- Checkpoint commits are welcome; a hook failure gets a new commit. Stage explicit
  paths. Hard limits: no `--amend`, `--no-verify`, force-push or `git config` edits.
- One worktree per branch; check `git worktree list` first, edit only your own,
  remove it after the merge. Isolate parallel test runs: unique ports, a
  per-worktree test DB name; a shared dev DB is migrated or reset only when no
  other agent can be testing.

## Code · Test · Doc

- TDD (failing test first) for business logic, APIs, data models and bug fixes;
  test-after is fine for UI layout, spikes and prototypes. Nothing ships untested.
- Run the gates the repo's CLAUDE.md, its stack rule or CI defines, green before
  every commit; docs-only changes skip them. Reach green by fixing the code:
  tests, linters and type checks stay as strict as you found them.
- Toolchains come from the repo's version files (`.ruby-version`, `.fvmrc`,
  `mise.toml`, lockfiles); read them before installing anything globally.
- Secrets live in `.env`/keychain; gitignore a new secret file before creating it.
  Commands that destroy data on a device or consume a secret are Peter's to run:
  prepare everything, then hand him the exact command line.
