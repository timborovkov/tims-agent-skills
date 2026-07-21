# personal-skills

Personal AI skills, kept in one place and symlinked into every tool that uses
them (Claude Code, Cursor, Codex, OpenCode, Hermes). One source of truth, no
copy-paste drift.

Lives at `~/Desktop/Projects/personal-skills/`. The install script normally
uses its own location, but if it is run from a disposable Codex worktree it
falls back to the stable checkout so global skill links do not point at a
worktree that may be deleted.

## Layout

```
personal-skills/
├── install.sh            # symlink each skill into every configured tool dir
├── sync-global-skills.sh # reconcile skills across Claude/Cursor/Codex/OpenCode/Hermes
├── timb-handoff-and-follow-up/
│   ├── SKILL.md          # end-of-session handoff + follow-up workflow
│   └── aliases           # optional legacy / short names
└── timb-<next-skill>/
    └── SKILL.md
```

Each skill is a folder with at minimum a `SKILL.md` (YAML frontmatter +
markdown body). Extra files (scripts, templates) live next to it.

## Install

```bash
./install.sh
```

Idempotent. Re-run after adding a new skill folder. Skips tools that aren't
installed on this machine.

If you intentionally want to install from a non-default checkout, set:

```bash
PERSONAL_SKILLS_SOURCE_DIR=/path/to/personal-skills ./install.sh
```

If you are deliberately testing from a Codex worktree, set:

```bash
PERSONAL_SKILLS_ALLOW_WORKTREE_SOURCE=1 ./install.sh
```

What it does:
- Finds every `<name>/SKILL.md` in this directory
- For each, creates a symlink at:
  - `~/.claude/skills/<name>`
  - `~/.cursor/skills/<name>`
  - `~/.codex/skills/<name>`
  - `~/.config/opencode/skills/<name>`
  - `~/.hermes/skills/<name>` (only if `~/.hermes` exists)
- Also creates aliases listed in `<name>/aliases` (one alias per line)
- Fixes stale symlinks pointing at old locations
- Leaves existing correct symlinks alone
- Refuses to overwrite non-symlink files (safety)

## Sync global skill dirs

```bash
./sync-global-skills.sh
```

Use this when a skill was created inside any one tool's skills directory and
the other tools should point at the same original. The script scans Claude,
Cursor, Codex, OpenCode, and Hermes skill dirs, picks the real skill directory
as the source, and symlinks the other locations to it. If all copies are
already symlinks, it reuses the shared resolved target. It refuses ambiguous
cases such as two different real directories for the same skill name. Hermes is
included only when `~/.hermes` exists.

Preview without changes:

```bash
./sync-global-skills.sh --dry-run
```

## Adding a new skill

1. `mkdir timb-<new-skill-name>` inside this repo
2. Write `timb-<new-skill-name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: timb-<new-skill-name>
   description: >-
     One paragraph explaining when to use this skill. Mention concrete trigger
     phrases. Be explicit about when NOT to use it.
   ---
   ```
3. Write the body — the model reads this as the skill's instructions.
4. Run `./install.sh` to fan out the symlink.
5. Commit the new skill folder.

## Available skills

| Skill | Description |
|---|---|
| `timb-contribution-workflow` | General contribution workflow: follow repo instructions, write meaningful tests, run validation such as `pnpm validate`, keep docs/TODOs current, push changes, handle GitHub CI, and fix or concisely reply to PR reviews/Bugbot comments. Aliases: `contribution-workflow`, `workflow`, `ship-workflow`, `validate-and-push`, `handle-ci`, `handle-review`. |
| `timb-diff-review` | Read-only, high-signal review of the current branch/worktree against the merge base with main/master/default branch. Verifies introduced defects, ranks findings P0-P3 with 0-100 confidence, and reports exact file/line evidence without changing code. Aliases: `diff-review`, `review-changes`, `branch-review`. |
| `timb-handoff-and-follow-up` | End-of-session workflow: align docs/TODO markdown against the diff, then write prompts for one or more independent follow-up agents. Aliases: `handoff`, `handoff-and-follow-up`. |
| `timb-in-repo-docs` | Write and maintain in-repo docs. HTML in `docs/` for briefs/guides/explainers/architecture (styled per `design.md`, visual-first), markdown for TODOs/READMEs/CHANGELOG, and a consumer check before touching any `.md` that's used as page content. Two flows: author a single doc, or run a structural sweep across the whole repo. Aliases: `in-repo-docs`, `docs-sweep`. |
| `timb-project-preferences` | Default repo setup preferences: pnpm/Turbo, TypeScript frontends chosen by project shape, Vite + React for lightweight apps, Next.js when its routing/SSR/server conventions help, Node 24, Tailwind + shadcn/ui, Vitest, AI/data/deploy defaults, docs/TODO/contribution workflow, and i13n/i18n by default unless the project or user specifies otherwise. Aliases: `project-preferences`, `project-defaults`, `setup-preferences`, `repo-defaults`. |
| `timb-test-strategy` | Testing strategy for adding, reviewing, and improving meaningful tests across unit, integration, API, DB, E2E, CI, and AI/agent eval layers. Aliases: `test-strategy`, `tests`, `testing`, `coverage`, `test-review`. |
| `timb-trim` | Code quality + line-count pass over the whole codebase or the diff vs main. Writes a findings report, gates refactors on real test coverage, implements after approval, deletes the report. Aliases: `trim`, `reduce`, `simplify-review`. |
| `timb-upstream-sync` | Merge/rebase from upstream safely while preserving both branch and upstream intent, resolving conflicts semantically, applying cross-cutting upstream requirements such as i13n/i18n to branch code, validating, updating docs/TODOs, and pushing. Aliases: `upstream-sync`, `sync-upstream`, `merge-upstream`, `rebase-upstream`. |

## Recommended third-party skills

Install these globally with the Skills CLI. They are **not** vendored in this repo — keep them updated with `npx skills update`.

```bash
npx skills add millionco/react-doctor -g -y
npx skills add mattpocock/skills -g -y
npx skills add railwayapp/railway-skills@use-railway -g -y
npx skills add upstash/context7@find-docs -g -y
npx skills add remotion-dev/skills -g -y
npx skills add vercel-labs/agent-skills -g -y
```

| Package | Key skills |
|---|---|
| [millionco/react-doctor](https://github.com/millionco/react-doctor) | `react-doctor` — React/Next health scoring and cleanup. Pairs with `timb-project-preferences`. |
| [mattpocock/skills](https://github.com/mattpocock/skills) | `grill-me`, `grill-with-docs`, `tdd`, `diagnose`, `prototype`, `to-prd`, `to-issues`, `triage`, `improve-codebase-architecture`, `setup-matt-pocock-skills`, `write-a-skill`. Matt's `handoff` overlaps naming with `timb-handoff-and-follow-up`. |
| [railwayapp/railway-skills](https://github.com/railwayapp/railway-skills) | `use-railway` — Railway deploy/ops. |
| [upstash/context7](https://github.com/upstash/context7) | `find-docs` — live library docs via Context7. |
| [remotion-dev/skills](https://github.com/remotion-dev/skills) | `remotion-best-practices` — Remotion video-in-React. |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `vercel-react-best-practices`, `vercel-composition-patterns`, `vercel-react-native-skills`, `web-design-guidelines`. |

This repo's `timb-*` skills are installed with `./install.sh`, not `npx skills add`.
