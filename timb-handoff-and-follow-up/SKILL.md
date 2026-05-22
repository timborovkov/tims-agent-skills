---
name: timb-handoff-and-follow-up
description: >-
  End-of-session handoff and follow-up workflow after substantive work (step
  shipped, PR landing, or switching agents). Syncs with main/recent merged PRs,
  aligns docs/TODO markdown to the full merged state, writes self-contained
  prompts for one or more next agents, and saves them for the next session. Use
  for "handoff," "wrap up," "what's next," "prep the next agent," or starting
  follow-up agents. Skip trivial fixes with no follow-up.
---

# Timb Handoff And Follow-Up

Run in order.

## 1. Sync with main and recent merged work

- Check the worktree/branch state against main. Fetch or inspect the latest base branch as appropriate for the repo.
- Make sure the branch is in line with main before preparing handoff: intended changes from this branch and all recently merged PRs must both be preserved.
- Review recently merged PRs/commits when they may affect the next work or TODOs. Carry forward their constraints, migrations, naming, copy, data shapes, or cleanup decisions.
- Do not let follow-up prompts reintroduce behavior that main just removed. Example: if a recently merged PR changed hardcoded Finnish strings to English, every follow-up prompt must preserve that invariant and tell agents not to add new Finnish hardcoded strings.
- If sync/merge creates conflicts or reveals incompatible direction, stop and report the blocker before writing follow-up prompts.

## 2. Align docs and TODOs

- Inspect the diff against the synced base (`git status`, `git diff` vs base).
- Update README / PLAN / CHANGELOG and any project TODO markdown in the blast radius.
- If the project tracks work in markdown (`TODO.md`, `TODOS.md`, `PLAN.md`, status docs, checklists), keep it current: close completed items, add deferred follow-ups, and preserve the project's existing format.
- Include TODO changes implied by recent merged PRs, not only the current branch.
- Run project verification gates (tests, lint, typecheck - per AGENTS.md or CLAUDE.md). Fix reds before handoff.

If `/document-release` is available and docs weren't updated this session, use it instead, then still check TODO/status markdown.

**Skip** only if docs and TODOs are already aligned - confirm with `git status`, summarize, continue.

## 3. Decide follow-up shape

If the user already specified what the next agent should work on, use that as the primary follow-up target.

Ask how many follow-up agents to prepare/start:

- `1`
- `as many as feasible`
- `custom amount`

Cap parallel agents at the number of independent tasks that can start now without merge-heavy conflicts or depending on code that does not exist yet. If the requested count exceeds the cap, explain the cap and use the capped count.

## 4. Write next-agent prompt(s)

Each agent starts cold. Be concrete: paths, names, canonical `file:line` patterns. Tell them what to ask the user, not guess.

Use these sections (drop any that don't apply):

```markdown
# <agent/task title>

## Context
What shipped on this branch, relevant recently merged PR context, what this follow-up does, suggested branch.

## Read first
Numbered files + one line each on why (5-10, most relevant first).

## Deliverables
What to build, in commit-sized chunks. Signatures/schemas/math spelled out.

## Invariants
Patterns from this branch and recent main work to reuse (cite file:line). Include things not to regress.

## Ask the user first
Decisions not to guess - ask before coding.

## Verify
Commands that must pass; expected test count if relevant.

## Out of scope
What to defer and which follow-up owns it.

## First action
Literal first step (often: plan before code).
```

**No next step?** Say the feature is done and skip phases 4-5.

**Short handoff?** Keep Context, Deliverables, First action only.

## 5. Save and report

Default: `<repo>/.claude/handoff-<task>.md` (or `~/.claude/handoffs/<repo>-<task>.md` if `.claude/` is gitignored). For multiple agents, save one file per startable task.

If the environment supports subagents and the user asked to start them now, launch only the independent startable tasks. Otherwise, save prompts for later.

Print paths and section headers. If the user wants prompts inline, show them too.

End with: `Handoff prepared: <path(s)>. Next: <one sentence>.`
