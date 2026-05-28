# personal-skills

Personal AI skills, kept in one place and symlinked into every tool that uses
them (Claude Code, Cursor, Codex, OpenCode). One source of truth, no copy-paste
drift.

Lives at `~/Desktop/Projects/personal-skills/` — but the install script
resolves its own location, so the repo can move freely without breaking the
links.

## Layout

```
personal-skills/
├── install.sh            # symlink each skill into every configured tool dir
├── sync-global-skills.sh # reconcile skills across Claude/Cursor/Codex/OpenCode
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

What it does:
- Finds every `<name>/SKILL.md` in this directory
- For each, creates a symlink at:
  - `~/.claude/skills/<name>`
  - `~/.cursor/skills/<name>`
  - `~/.codex/skills/<name>`
  - `~/.config/opencode/skills/<name>`
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
Cursor, Codex, and OpenCode skill dirs, picks the real skill directory as the
source, and symlinks the other locations to it. If all copies are already
symlinks, it reuses the shared resolved target. It refuses ambiguous cases such
as two different real directories for the same skill name.

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
| `timb-handoff-and-follow-up` | End-of-session workflow: align docs/TODO markdown against the diff, then write prompts for one or more independent follow-up agents. Aliases: `handoff`, `handoff-and-follow-up`. |
| `timb-in-repo-docs` | Write and maintain in-repo docs. HTML in `docs/` for briefs/guides/explainers/architecture (styled per `design.md`, visual-first), markdown for TODOs/READMEs/CHANGELOG, and a consumer check before touching any `.md` that's used as page content. Two flows: author a single doc, or run a structural sweep across the whole repo. Aliases: `in-repo-docs`, `docs-sweep`. |
| `timb-project-preferences` | Default repo setup preferences: pnpm/Turbo, Next.js App Router, Node 24, Tailwind + shadcn/ui, Vitest, AI/data/deploy defaults, docs/TODO/contribution workflow, and i13n/i18n by default unless the project or user specifies otherwise. Aliases: `project-preferences`, `project-defaults`, `setup-preferences`, `repo-defaults`. |
| `timb-trim` | Code quality + line-count pass over the whole codebase or the diff vs main. Writes a findings report, gates refactors on real test coverage, implements after approval, deletes the report. Aliases: `trim`, `reduce`, `simplify-review`. |
| `timb-upstream-sync` | Merge/rebase from upstream safely while preserving both branch and upstream intent, resolving conflicts semantically, applying cross-cutting upstream requirements such as i13n/i18n to branch code, validating, updating docs/TODOs, and pushing. Aliases: `upstream-sync`, `sync-upstream`, `merge-upstream`, `rebase-upstream`. |
