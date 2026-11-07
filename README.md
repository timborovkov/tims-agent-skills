# personal-skills

Reusable AI skills, kept in one place and symlinked into every tool that uses
them (Claude Code, Cursor, Codex, OpenCode, Hermes). One source of truth, no
copy-paste drift.

The `timb-` prefix identifies this collection, not the intended user. Skills work
with the invoking user's goals, voice, and project conventions. Personal examples,
account history, and machine-specific settings belong in user or project context.

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

For Codex Cloud, Cursor Cloud Agents, and Grok Bot, see
[Cloud installation](CLOUD-INSTALL.md).

## Install

```bash
./install.sh
```

Idempotent. Re-run after adding a new skill folder. Creates skill directories for Claude Code, Cursor, Codex, and OpenCode. Hermes is included when installed.

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
  - `~/.agents/skills/<name>` (shared source/discovery)
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
the other tools should point at the same original. The script includes the shared `~/.agents/skills` source and scans Claude,
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
| `timb-ship` | Explicit shipping command: scoped cleanup, review, relevant React Doctor checks, validation, docs, commit/push, PR, and CI/review follow-through. Replaces contribution-workflow and trim; legacy contribution aliases are removed. Alias: `ship`. |
| `timb-diff-review` | Read-only, high-signal review of the current branch/worktree against the merge base with main/master/default branch. Verifies introduced defects, ranks findings P0-P3 with 0-100 confidence, and reports exact file/line evidence without changing code. Aliases: `diff-review`, `review-changes`, `branch-review`. |
| `timb-document-release` | Repository-wide documentation release: inventories every maintained docs surface, refreshes stale content from code and release evidence, regenerates derived docs, and verifies links, formatting, builds, and the final diff. Aliases: `document-release`, `release-docs`, `docs-release`, `refresh-docs`. |
| [`timb-finnish`](timb-finnish/SKILL.md) | Write, translate, proofread, and naturalize Finnish text. Combines Finnish grammar, typography, and register-aware style editing, with self-contained references for spelling, sentence structure, inflection, word choice, lists, punctuation, and formatting. |
| `timb-handoff-and-follow-up` | Explicit handoff command: save current context, evidence, constraints, and next steps. No compulsory sync, docs sweep, or agent-count question. Alias: `handoff`. |
| `timb-in-repo-docs` | Write and maintain in-repo docs. HTML in `docs/` for briefs/guides/explainers/architecture (styled per `design.md`, visual-first), markdown for TODOs/READMEs/CHANGELOG, and a consumer check before touching any `.md` that's used as page content. Two flows: author a single doc, or run a structural sweep across the whole repo. Aliases: `in-repo-docs`, `docs-sweep`. |
| `timb-project-preferences` | Default repo setup preferences: Bun/Turbo, TypeScript frontends chosen by project shape, Vite + React for lightweight apps, Next.js when its routing/SSR/server conventions help, Tailwind + shadcn/ui, Vitest, AI/data/deploy defaults, docs/TODO/contribution workflow, and i13n/i18n by default unless the project or user specifies otherwise. Aliases: `project-preferences`, `project-defaults`, `setup-preferences`, `repo-defaults`. |
| `timb-test-strategy` | Testing strategy for adding, reviewing, and improving meaningful tests across unit, integration, API, DB, E2E, CI, and AI/agent eval layers. Aliases: `test-strategy`, `tests`, `testing`, `coverage`, `test-review`. |
| `timb-untangle-codebase` | Untangle a whole codebase in one pass so later agent work reads less, breaks less, and debugs faster. Asks whether to also clean restating comments and weak tests. Adapted from [caldoai/skills `untangle-codebase`](https://github.com/caldoai/skills/blob/main/skills/untangle-codebase/SKILL.md). Aliases: `untangle-codebase`, `untangle`. |
| `timb-upstream-sync` | Merge/rebase from upstream safely while preserving both branch and upstream intent, resolving conflicts semantically, applying cross-cutting upstream requirements such as i13n/i18n to branch code, validating, updating docs/TODOs, and pushing. Aliases: `upstream-sync`, `sync-upstream`, `merge-upstream`, `rebase-upstream`. |
| [`timb-x`](timb-x/SKILL.md) | X posts, replies, quote posts, threads, editing, content planning, profile reviews, performance analysis, and optional reach experiments in the user's or brand's voice. Combines selected ideas from viral-x-posts and x-skills; publishing requires an available authenticated tool and authorization. |

## Recommended third-party tooling and skills

Railway is the default deployment and production-operations platform. Install
the Railway CLI with agent support so coding agents can deploy, inspect status,
read build and runtime logs, view metrics, manage configuration, use SSH, and
debug services with the current `use-railway` skill and Railway MCP integration:

```bash
bash <(curl -fsSL https://railway.com/install.sh) --agents -y
```

If the CLI is already installed, add or refresh its agent tooling with:

```bash
railway setup agent -y
```

### Cloudflare

Follow the current [official agent setup instructions](https://developers.cloudflare.com/agent-setup/prompt.md)
for Cloudflare skills, MCP, and the optional beta `cf` CLI. Install the skills
globally for Codex and Cursor on this machine:

```bash
bunx skills add cloudflare/skills --skill '*' --yes --global --agent codex cursor
codex mcp add cloudflare --url https://mcp.cloudflare.com/mcp
codex mcp login cloudflare
bun add --global cf
cf auth login
```

Add `"cloudflare": { "url": "https://mcp.cloudflare.com/mcp" }` under
`mcpServers` in `~/.cursor/mcp.json`, preserving existing servers. Cursor
requests OAuth authorization on first use; restart agents after MCP setup.
In each agent's user-level instructions, use Cloudflare's preference:

> When interacting with Cloudflare, use the cf CLI unless the project has a Wrangler configuration file.

The Skills CLI stores these skills in `~/.agents/skills`. Keep any explicit
links in `~/.codex/skills` and `~/.cursor/skills` pointing to that shared source.
For other agents, follow the agent-specific setup in the official guide;
Claude Code uses `claude plugin marketplace add cloudflare/skills` followed by
`claude plugin install cloudflare@cloudflare` and `/reload-plugins`.

### Other skill packages

Install the remaining third-party skills globally with the Skills CLI. These
skills are **not** vendored in this repo — keep them updated with
`bunx skills update`.

```bash
bunx skills add jakubkrehel/skills -g -y
bunx skills add millionco/react-doctor -g -y
bunx skills add mattpocock/skills -g -y
bunx skills add upstash/context7@find-docs -g -y
bunx skills add remotion-dev/skills -g -y
bunx skills add vercel-labs/agent-skills -g -y
bunx skills add Leonxlnx/taste-skill --skill design-taste-frontend -g -y
bunx skills add Leonxlnx/imagegen-skills --skill image-to-code -g -y
bunx skills add microsoft/playwright-cli --skill playwright-cli -g -y
bunx skills add latent-spaces/brag --skill brag -g -y
bunx skills add coreyhaines31/marketingskills -g -y
```

Playwright's skill also needs its CLI:

```bash
npm install -g @playwright/cli@latest
playwright-cli --version
```

Taste Skill requires Node.js 22+ and Chrome, Edge, or Chromium. Image-to-Code
lives in `Leonxlnx/imagegen-skills` after moving out of the Taste Skill repo.
`brag` requires Node.js 22+, FFmpeg on `PATH`, and Hyperframes (`npm install -g
hyperframes`; check readiness with `hyperframes doctor`).

To install only the Railway skill without the CLI or MCP integration:

```bash
bunx skills add railwayapp/railway-skills@use-railway -g -y
```

| Tool or package | Key capabilities |
|---|---|
| [Railway CLI](https://github.com/railwayapp/cli) + [railwayapp/railway-skills](https://github.com/railwayapp/railway-skills) | Preferred deployment and operations tooling. The `use-railway` skill covers deploys, configuration, logs, metrics, SSH, databases, domains, and build/runtime debugging. |
| [Cloudflare CLI](https://developers.cloudflare.com/cf/) + [cloudflare/skills](https://github.com/cloudflare/skills) + [MCP](https://github.com/cloudflare/mcp) | Cloudflare API operations with `cf`, remote MCP access, and skills for Workers, Wrangler, Durable Objects, Agents SDK, networking, and performance. Use Wrangler when the project has a Wrangler configuration. |
| [jakubkrehel/skills](https://github.com/jakubkrehel/skills) | `better-interface`, `better-ui`, `better-typography`, `better-colors`, `better-accessibility`, `better-layout`, `better-writing` — holistic interface review plus focused UI polish, typography, color, accessibility, layout, and product-writing guidance. |
| [millionco/react-doctor](https://github.com/millionco/react-doctor) | `react-doctor` — React/Next health scoring and cleanup. Pairs with `timb-project-preferences`. |
| [mattpocock/skills](https://github.com/mattpocock/skills) | `grill-me`, `grill-with-docs`, `tdd`, `diagnose`, `prototype`, `to-prd`, `to-issues`, `triage`, `improve-codebase-architecture`, `setup-matt-pocock-skills`, `write-a-skill`. Matt's `handoff` overlaps naming with `timb-handoff-and-follow-up`. |
| [upstash/context7](https://github.com/upstash/context7) | `find-docs` — live library docs via Context7. |
| [remotion-dev/skills](https://github.com/remotion-dev/skills) | `remotion-best-practices` — Remotion video-in-React. |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `vercel-react-best-practices`, `vercel-composition-patterns`, `vercel-react-native-skills`, `web-design-guidelines`. |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) | `design-taste-frontend` — art direction, coherent visual systems, real assets, and browser checks for websites. |
| [Image-to-Code](https://github.com/Leonxlnx/imagegen-skills/tree/main/skills/image-to-code) | `image-to-code` — generate visual references, analyze them, and implement a matching website. |
| [Playwright CLI](https://github.com/microsoft/playwright-cli) | `playwright-cli` — browser automation, screenshots, debugging, and test generation through a CLI and companion skill. |
| [latent-spaces/brag](https://github.com/latent-spaces/brag) | `brag` — turn a project into a launch video with music, motion, and share copy using Hyperframes. |
| [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | Marketing strategy, website copywriting and editing, SEO, conversion optimization, social content, cold email, and sales enablement. Start with `product-marketing` for shared product context, then use `copywriting`, `copy-editing`, `social`, or the relevant specialist skill. |

This repo's `timb-*` skills are installed with `./install.sh`, not `bunx skills add`.

## Workflow policy and retired skills

`ship` resolves to `timb-ship`, not the third-party React Doctor shipping workflow.
React Doctor and its specialist skills remain available globally. `timb-trim` is
retired; its public-API and meaningful-verification safeguards live in `timb-ship`.
Old contribution-workflow names and the redundant third-party `matt-handoff` are retired.
Use `timb-ship` / `ship` and `timb-handoff-and-follow-up` / `handoff`.

Shipping and handoff are explicit commands packaged as portable skills:
`disable-model-invocation: true` plus Codex's
`agents/openai.yaml` `allow_implicit_invocation: false`. Invoke them by name;
clients may expose different slash or dollar command syntax.

`disabled-skills.txt` excludes skills from global synchronization. Context7 MCP is
disabled on this machine because it is not configured; `find-docs` and
`context7-cli` remain available for CLI lookup/setup. Remove the exclusion and
restore/install that skill if MCP becomes available. Third-party updates may
restore retired skills; rerun installation and inspect the sync preview afterward.
The sync reports excluded installed entries for cleanup; it never deletes them.

After third-party installation or updates, run `./install.sh` and then
`./sync-global-skills.sh`. App-bundled plugin and internal system skills remain
managed by their own apps; they are not copied between clients.

### Local tooling and overlap policy

Install the React Doctor CLI locally as well as its skill:

```bash
bun add --global react-doctor@latest
react-doctor --version
react-doctor --help
```

`react-doctor` and all its specialist skills remain globally available. Installing
skill instructions alone does not install the executable.

`install.sh` reapplies `scripts/apply-skill-policy.py` after skill installation.
It makes `context7-cli` and `code-review` explicit-only in Claude/Cursor frontmatter
and Codex invocation policy, preserving their content and supporting references.
Use `find-docs` for ordinary documentation lookup and `timb-diff-review` for the
personal review workflow. Context7 setup and the alternative Standards/Spec review
remain available when explicitly requested or called by their parent workflows.
Keep `interface-review` and the `better-*` family together: they depend on one
another and cover change scope versus individual UI disciplines.
