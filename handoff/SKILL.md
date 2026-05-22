---
name: handoff
description: >-
  End-of-session handoff workflow. Runs after a chunk of substantive work
  completes (a step shipped, a PR is about to merge, or you're handing off to
  the next agent). Three phases: (1) align docs against the diff so every
  README / PLAN / TODOS file matches what shipped, (2) write a self-contained
  prompt for the next agent that includes architectural invariants, file
  references, the deliverables, open questions worth asking before coding,
  verification gates, and the first action, (3) save the prompt to a known
  location the user can paste into the next session.

  Use this skill when the user says "handoff," "wrap up this step," "what's
  next," "prep the next agent," or after /ship + /document-release on any
  meaningful piece of work. Do NOT use for trivial fixes or tasks that don't
  produce a meaningful next step.
---

# Handoff skill

Three phases. Run them in order. Do not skip.

## Phase 1 — Align documentation against what shipped

The goal: every `*.md` file in the diff's blast radius reflects what
actually shipped, no more, no less.

1. Run `git status -s` and `git diff origin/<base>...HEAD --stat` to see
   what's about to land (or just landed).
2. List every `*.md` file in the repo: `find . -name "*.md" -not -path
   "./.git/*" -not -path "*/node_modules/*" | sort`.
3. For each doc file in the blast radius, read it and cross-reference
   against the diff. Apply factual corrections directly (test counts,
   file paths, new CLI subcommands, added scripts). Leave narrative /
   voice changes for human review.
4. Check the project's TODOS / status file (`TODOS.md`, `PLAN.md`,
   `CHANGELOG.md`, or equivalent). Move completed items to the closed
   section. Add new items for any deferred follow-up work surfaced
   during the chunk.
5. Verify test / suite counts match reality. Run whatever the project's
   "collect tests" command is (e.g. `uv run pytest tests/ -q --collect-only
   | tail -1`, `npm test -- --listTests`, `go test ./... -list .`) and
   make sure status blocks in PLAN.md / equivalent match.
6. Run the project's verification gates (whatever the project's CLAUDE.md
   or AGENTS.md says). Tests + linter + formatter + type checker. If
   any are red, fix before declaring the chunk done.

If the project has a `/document-release` skill installed, you may
invoke it instead of doing this by hand. The criteria are the same.

## Phase 2 — Write the next-agent handoff prompt

The next agent will start cold. The prompt must be self-contained.

Structure (use these exact section headers):

```markdown
# Step <N> — <one-line title> (handoff prompt for next agent)

## Context

What just shipped (1-2 paragraphs). What this next step is for. The
relationship between them. Branch suggestion.

## Read first, in this order

A numbered list of files the next agent must read before typing code.
Include filenames AND a one-line "why this file." Order matters: the
most recently-merged, most architecturally-similar code goes first.
Aim for 5-10 entries.

## Deliverables

Suggested commit boundaries inside the PR. Under each, list the public
surface to add or change, with type signatures or schemas inline. For
arithmetic-heavy work, write out the math in pseudocode BEFORE the
agent starts coding. This is the most important section.

## Architectural invariants to carry forward

A bullet list of patterns from the just-merged work that the next
agent must reuse, not reinvent. Lock ordering, validation discipline,
quantization rules, CSV-injection defense, etc. Cite the file:line
of the canonical implementation.

## Open questions to raise WITH THE USER (don't guess)

A numbered list of decisions the next agent must NOT make alone.
Naming conventions, tax-rate-dependent shapes, scope tradeoffs.
Tell them to use AskUserQuestion for these BEFORE the implementation
plan, not during.

## Verification gates (per PR)

The exact bash commands that must pass. Expected test count after the
step. End-to-end smoke commands the agent can run against a scratch
fixture.

## Out of scope (defer)

Bullet list of things the next agent will be tempted to fold in but
shouldn't. Name the future step where each belongs.

## First action

The literal first thing the next agent should do. Usually: "run /plan
and produce ~/.claude/plans/<step-name>.md. Do not skip planning —
the <X> is the part that needs to be wrong on paper before being
wrong in code."
```

Voice rules:
- Lead with the point. No throat-clearing.
- Be concrete. File paths, function names, line numbers, account
  codes, schema field names.
- When recommending a pattern, cite the file:line of the canonical
  implementation, not a description.
- Call out where the next agent will be tempted to guess and tell them
  to ask the user instead.
- For multi-entity / multi-jurisdiction systems: write out the
  branch logic for each case. Don't say "handle both entities" —
  spell out the JE shape per entity.

## Phase 3 — Save the prompt

Default location: `<repo>/.claude/handoff-<step-name>.md`. If the
project's `.claude/` is gitignored (most are), this stays local.
Otherwise pick `~/.claude/handoffs/<repo-name>-<step-name>.md`.

After writing, print the file path AND show the user the section
headers so they can verify shape without re-reading the whole thing.

If the user wants the prompt inline instead of saved to a file, do
both: save AND show. The file is the artifact; the inline copy is
for quick review.

## When to skip phases

- **Phase 1 already done in-session?** The user just ran
  `/document-release` or you applied doc updates earlier. Confirm by
  running `git status -s` — if docs are committed / staged, just
  echo the alignment summary and move to Phase 2.
- **No next step?** If the chunk that just shipped genuinely ends the
  feature (no follow-up, no deferred items), say so explicitly:
  "Nothing to hand off — feature complete. TODOS.md has no open
  items in this area." Skip Phase 2 and Phase 3.
- **User wants a thinner prompt?** Default is comprehensive. If the
  user says "short version" or the chunk is small (typo fix, single
  refactor), drop sections and keep Context + Deliverables + First
  action.

## Completion report

End with a single line: `Handoff prepared: <file path>. Next: <one
sentence on what the next agent will do first>.`
