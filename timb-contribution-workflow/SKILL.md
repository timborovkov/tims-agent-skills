---
name: timb-contribution-workflow
description: >-
  Runs the general contribution workflow for shipping changes: follows
  AGENTS/CLAUDE and CONTRIBUTING guidance, writes meaningful tests, validates
  with `pnpm validate`, keeps docs/TODOs current, pushes changes, monitors GitHub CI,
  and responds to PR reviews or Cursor Bugbot comments by fixing or replying
  concisely. Use for "ship this," "validate and push," "handle CI," "respond to
  review," "fix PR comments," "follow the contribution guide," or "finish the
  workflow." Skip for read-only review unless the user asks to act.
---

# Timb Contribution Workflow

Purpose: finish work the way the repo expects, with evidence.

Run in order.

## 1. Read the local contract

Before changing behavior or pushing, inspect the repo's instructions:

- `AGENTS.md` and/or `CLAUDE.md`
- `CONTRIBUTING.md`
- package manifests and scripts
- CI workflows under `.github/workflows/`
- TODO/status docs in the blast radius

If `CLAUDE.md` and `AGENTS.md` both exist, treat them as the same class of agent instruction. If they conflict, follow the more specific local file and report the conflict.

## 2. Keep tests meaningful

Add or update tests when behavior changes.

Good tests:

- exercise behavior through the public or intended boundary
- assert real outputs, side effects, permissions, rendering, data writes, or errors
- cover the edge case that would fail without the fix
- avoid tautologies where the mock simply returns the asserted value

Avoid snapshot churn, shallow implementation tests, and tests that only prove a stub was called unless the call itself is the contract.

## 3. Keep project state current

- Update docs when the user-facing, developer-facing, or operational contract changes.
- Update TODO/PLAN/ROADMAP files when work is completed, deferred, newly discovered, or made obsolete.
- Keep completed TODOs compact using the repo's existing convention.
- Do not leave stale comments, dead checklist items, or "follow up later" notes without an owner or clear next action.

## 4. Validate before push

Run the repo's required gates. For pnpm repos, prefer:

```bash
pnpm validate
```

If no single validate command exists, run the closest available set:

- format/prettier check
- lint
- typecheck/compile
- tests
- build when CI requires it

Fix failures before pushing. If a gate is unavailable or already broken on the base branch, document the evidence.

## 5. Push responsibly

- Inspect `git status --short` and `git diff --check`.
- Review the final diff for accidental files, debug output, secrets, conflict markers, hardcoded strings where i13n/i18n is expected, and stale TODO/docs.
- Commit with the repo's style.
- Push the branch.
- If history was rewritten, use `git push --force-with-lease`, never plain force.

## 6. React to GitHub CI

Use `gh` when available.

- Find the PR and current checks.
- For each failing check, open the relevant log and identify the first real failure, not only the summary.
- Fix the cause locally, rerun the matching local command when possible, commit, and push.
- If CI failed for external infrastructure, quota, or a known flaky test, leave a concise PR comment with evidence and next action.

Do not ignore pending required checks unless the user explicitly says to stop before they finish.

## 7. React to reviews and Bugbot comments

For every reviewer, Cursor Bugbot, or automated comment:

- Decide: fix, already handled, not applicable, or disagree.
- If fixing, implement the smallest correct change, add/update tests if behavior changes, validate, commit, and push.
- If not fixing, reply concisely with the reason and evidence. Do not be defensive.
- Mark resolved only when the thread is genuinely handled.

Final response should say what changed, what passed, what was pushed, and which review/CI items remain.
