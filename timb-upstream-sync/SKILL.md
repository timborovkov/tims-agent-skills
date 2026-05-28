---
name: timb-upstream-sync
description: >-
  Safely sync a feature branch with upstream/default branch using merge or
  rebase while preserving all intended work on both sides. Use for "rebase on
  main," "merge upstream," "sync with main," "resolve conflicts," "update this
  PR from upstream," or when upstream has landed related behavior that the
  current branch must semantically incorporate. Goes beyond mechanical conflict
  resolution: validates behavior, updates tests/docs/TODOs, and pushes the
  result. Skip for unrelated ordinary feature work.
---

# Timb Upstream Sync

Purpose: integrate upstream without losing intent. A green merge that drops a requirement is a failed merge.

Run in order.

## 1. Establish the sync target

- Inspect `git status --short` first. Preserve unrelated user work; do not stash or rewrite it without explicit approval.
- Detect the default branch:
  `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'`, falling back to the first existing `main`, `master`, `trunk`, or `develop`.
- Fetch the relevant remote when available.
- Identify the branch's intended work:
  - `git diff --stat <base>...HEAD`
  - `git log --oneline --decorate <base>..HEAD`
  - changed tests/docs/TODOs
  - issue/PR text if available locally or via `gh`
- Identify upstream changes since the branch diverged:
  - `git log --oneline HEAD..<upstream>`
  - `git diff --name-status HEAD..<upstream>`
  - recent commits/PRs that touch the same files, domain terms, migrations, routes, schemas, copy, env, CI, or tests.

## 2. Choose merge vs rebase

- Use the user's requested strategy if they named one.
- Prefer rebase for local/private branches with no shared dependency.
- Prefer merge for shared branches, branches already reviewed, branches with merge commits that carry meaning, or when preserving PR discussion history matters.
- If the repo's contribution guide says otherwise, follow it.

## 3. Resolve semantically

For every conflict or overlapping upstream change, preserve both sides' intent.

- Do not choose ours/theirs wholesale unless the replaced side is truly obsolete.
- Read nearby code and tests before editing.
- If upstream introduced a cross-cutting requirement, apply it to this branch too. Example: if upstream implemented i13n/i18n, new UI text from this branch must use the same message/catalog pattern instead of hardcoded strings.
- If upstream changed data shape, validation, permissions, env loading, model config, routes, copy conventions, loading states, or error handling, update this branch's new code to match.
- Update tests to assert the integrated behavior, not just the old branch behavior.
- Update docs/TODO/CHANGELOG when the merge changes project-facing state or closes/reopens work.

When unsure which intent should win, inspect the code, contribution docs, TODOs, and recent commits first. Ask only if the trade-off cannot be resolved from the repo.

## 4. Validate the integration

Run the repo's documented gates from `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, package scripts, or CI config.

Default expectations when present:

- install/check lockfile consistency
- lint/format/prettier
- typecheck/compile
- unit/integration tests
- `pnpm validate` for Node/pnpm repos

Fix failures caused by the sync. If a failure predates the sync, prove it with a base-branch check or prior logs, then report it clearly.

## 5. Review before pushing

- Inspect `git diff` and `git diff --check`.
- Confirm no conflict markers remain.
- Confirm intended branch changes still exist.
- Confirm upstream requirements are applied to newly introduced code.
- Confirm docs/TODOs are current if touched or affected.
- Commit the merge/rebase result if needed using the repo's commit style.
- Push. If rebased, use `--force-with-lease`, never plain force.

## 6. Final report

Report:

- strategy used and target branch
- conflicts or semantic overlaps resolved
- validation commands and results
- docs/TODO updates
- push status and any remaining reviewer/CI follow-up
