# personal-skills

Personal AI skills, kept in one place and symlinked into every tool that uses
them (Claude Code, Cursor, OpenCode). One source of truth, no copy-paste drift.

Lives at `~/Desktop/Projects/personal-skills/` — but the install script
resolves its own location, so the repo can move freely without breaking the
links.

## Layout

```
personal-skills/
├── install.sh            # symlink each skill into all three tool dirs
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
  - `~/.config/opencode/skills/<name>`
- Also creates aliases listed in `<name>/aliases` (one alias per line)
- Fixes stale symlinks pointing at old locations
- Leaves existing correct symlinks alone
- Refuses to overwrite non-symlink files (safety)

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
| `timb-handoff-and-follow-up` | End-of-session workflow: align docs/TODO markdown against the diff, then write prompts for one or more independent follow-up agents. Aliases: `handoff`, `handoff-and-follow-up`. |
| `timb-in-repo-docs` | Write and maintain in-repo docs. HTML in `docs/` for briefs/guides/explainers/architecture (styled per `design.md`, visual-first), markdown for TODOs/READMEs/CHANGELOG, and a consumer check before touching any `.md` that's used as page content. Two flows: author a single doc, or sweep the whole repo into shape. Aliases: `docs`, `in-repo-docs`, `align-docs`. |
