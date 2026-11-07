# Install skills in cloud agents

The local `scripts/install.sh` links folders on your Mac. Cloud agents need their own
copy of the skills and any required command-line tools. These instructions cover
personal `timb-*` skills and the third-party packages listed in [README.md](README.md#recommended-third-party-tooling-and-skills).

## Cursor Cloud Agents

For cloud agents you start yourself:

1. Install the skills locally using this repo's instructions.
2. In Cursor, open **Settings → Agents → Context and Tools** and enable
   **Sync Skills for Cloud Agents**. You can also start sync from
   **Customize → Skills**.
3. Check that the intended skills appear, then start a new cloud agent and ask
   it to use one, for example: “Use timb-x to draft this reply.”

Only personal skills in `~/.cursor/skills/` sync. This repo uses symlinks into
that folder; the docs do not establish whether external symlink targets sync.
Verify the skill and its references are readable in the cloud. If they are
missing, use the project-folder method below.

For Cursor automations, put complete skill folders in the project's
`.cursor/skills/` directory and commit them. Personal skill sync does not apply
to automation runs, including Run as Me.

## Codex Cloud

The simplest route is to include the needed skills in the project repository:

```text
.agents/skills/timb-x/SKILL.md
.agents/skills/timb-x/references/...
.agents/skills/timb-x/NOTICE.md
```

Copy whole skill folders, including references, scripts, assets, and notices.
Commit and push them before starting the cloud task. Do not commit symlinks that
point to paths on your Mac.

Alternatively, install skills in the cloud environment's setup script using
Node.js/npm and the Skills CLI. This installs one personal skill globally in
that environment:

```bash
npx --yes skills add https://github.com/timborovkov/tims-agent-skills \
  --skill timb-x --agent codex -g -y
```

Replace `timb-x` with another personal skill name. To install the whole personal
collection, omit `--skill timb-x`. For third-party skills, use their repository
instead, for example:

```bash
npx --yes skills add coreyhaines31/marketingskills --agent codex -g -y
npx --yes skills add Leonxlnx/taste-skill \
  --skill design-taste-frontend --agent codex -g -y
```

Install during environment setup so the files are available when the task starts.
After changing setup, rebuild/reset the prepared environment as appropriate and
start a fresh task. For repeatable installs, pin the source revision using the
installer's supported revision syntax rather than tracking a moving branch.

The GitHub source must contain the skill: local uncommitted or unpushed additions
cannot be downloaded by the cloud. A private repository also needs authenticated
read access in that environment. Use its secret configuration, not tokens in the
setup script or chat.

## Grok Bot (x.ai/bot)

Grok Bot has a separate persistent cloud computer and a private-skills feature.
Give it an accessible repository link or upload the complete skill folders, then
ask:

> Import the selected timb-* skills from
> https://github.com/timborovkov/tims-agent-skills as private skills. Preserve their
> names, references, scripts, assets, and notices. Adapt machine-specific paths
> for your cloud computer. Verify that you can load each skill and report missing
> dependencies. Start with timb-x. Do not publish any posts as part of setup.

For third-party skills, give it the selected upstream links from the README too;
their contents are not stored in this repository.

This is an import request for the Bot to carry out, not a documented one-command
GitHub importer. Cloning files alone does not prove they have been registered as
private skills. Ask it to verify discovery and load a supporting reference.

If a private skill is not available to the current Bot, open **Connect apps**,
select the connected count, and enable it under **Private skills**. Once enabled,
ask for the skill by name. Keep durable files under `/workspace`; installed
packages may need reinstalling after the cloud computer is rebuilt.

## Install tools separately

Skill files contain instructions; they do not automatically install or authorize
the tools those instructions use. Install only what your chosen skills need in
the cloud environment:

| Skill | Additional setup |
|---|---|
| `timb-x` | Drafting works without an X account connection. Live reading needs an available reader; publishing needs an authenticated posting tool or browser and authorization. |
| Marketing Skills | Writing skills can use supplied context. Analytics, ads, and other operational workflows need the relevant accounts/tools. |
| Taste Skill | Node.js 22+ and Chrome, Edge, or Chromium. |
| Image-to-Code | An image-generation capability available to the agent. |
| Playwright CLI | `npm install -g @playwright/cli@latest`, plus an available browser. Verify with `playwright-cli --help` and a disposable browser session. |
| `brag` | Node.js 22+, FFmpeg/FFprobe, Chrome, and Hyperframes (`npm install -g hyperframes`). Run `hyperframes doctor`. |
| Cloudflare / Railway | Install and authenticate the relevant CLI in the cloud. Use `cf` for Cloudflare unless the project has Wrangler configuration. |

Use the cloud OS's installation instructions. Mac Homebrew commands and Mac-only
binaries are not portable to a Linux cloud machine.

## Check the result

Ask the cloud agent to load the chosen skill, read one of its linked references
if present, and report missing tools. Try a draft-only task before a publishing
workflow. Distinguish “files downloaded”, “skill discovered”, and “tools ready”.

## Official documentation

Checked 7 November 2026; UI labels and cloud setup flows can change.

- [Cursor: personal skills with Cloud Agents](https://cursor.com/docs/skills#use-personal-skills-with-cloud-agents)
- [Codex skill locations](https://learn.chatgpt.com/docs/build-skills)
- [Codex cloud environment setup](https://learn.chatgpt.com/docs/environments/cloud-environment)
- [Grok Bot: skills and routines](https://cursor.com/docs/grok-bot/work#skills-and-routines)
