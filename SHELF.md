# Temporarily inactive skills

Shelved means **not loaded right now, kept for later**. It does not mean obsolete,
bad, or permanently removed. Files stay on your machine at
`~/.agents/skills-shelf/<bundle>/<skill>/`, outside agent discovery directories.
No Cloudroom installation is required.

List the bundles and skills actually available on this machine:

```bash
python3 scripts/restore-shelved-skills.py
```

Restore a bundle and sync it to your existing tool directories:

```bash
python3 scripts/restore-shelved-skills.py cloudflare
```

The restore checks all shared-store destinations before moving anything. If a
name is already installed, it stops without overwriting or nesting directories.
The sync reports conflicts rather than overwriting real directories.

Sync skips names that still have a `SKILL.md` on the shelf, even if another tool
has a leftover copy. This prevents spreading those copies; it does not disable
an existing copy in that tool. To shelve more skills, move their source folders
out of discovery and remove only the corresponding discovery symlinks.

For additional local sync exclusions, put one exact skill name per line in
`~/.agents/skills-excluded.txt`. Remove a name to include it again. Override that
path with `PERSONAL_SKILLS_EXCLUDED_FILE` if needed. Exclusion only prevents
sync; it neither deletes files nor hides copies already installed.

The optional `MANIFEST.json` records the earlier move; current shelf folders
are the source of truth. The shelf and package-manager lock are local files,
not reproduced by cloning this repository. Moving folders back does not restore
package-manager update tracking. Reinstall from the original publisher when you
want managed updates, checking for local renames and edits first.

Application-owned and project-local skill copies are managed separately.
