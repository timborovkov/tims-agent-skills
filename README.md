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
├── handoff/
│   └── SKILL.md          # end-of-session handoff workflow
└── <next-skill>/
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
- Fixes stale symlinks pointing at old locations
- Leaves existing correct symlinks alone
- Refuses to overwrite non-symlink files (safety)

## Adding a new skill

1. `mkdir <new-skill-name>` inside this repo
2. Write `<new-skill-name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: <new-skill-name>
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
| `handoff` | End-of-session workflow: align docs against the diff, then write a self-contained prompt for the next agent. Use after /ship + /document-release on substantive work. |
