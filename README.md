# personal-skills

Reusable agent skills for coding, design, writing, and shipping. This repository
owns the `timb-*` workflows and links them into Claude Code, Cursor, Codex,
OpenCode, and Hermes. Third-party skills stay with their upstream publishers.

The `timb-` prefix identifies the collection. Skills use the invoking user's
context; personal history and machine-specific settings belong outside them.

## Start here

```bash
./scripts/install.sh
```

Run from a stable checkout. The installer links each top-level skill into the
supported tools, repairs stale links, and refuses to overwrite regular files or
directories. Re-running it is safe.

| Tool | Skill directory |
|---|---|
| Shared discovery | `~/.agents/skills` |
| Claude Code | `~/.claude/skills` |
| Cursor | `~/.cursor/skills` |
| Codex | `~/.codex/skills` |
| OpenCode | `~/.config/opencode/skills` |
| Hermes, when installed | `~/.hermes/skills` |

The installer normally uses its own checkout. From a disposable Codex worktree,
it falls back to `~/Desktop/Projects/personal-skills` so links survive worktree
removal. Override the source deliberately with
`PERSONAL_SKILLS_SOURCE_DIR=/path/to/personal-skills ./scripts/install.sh`.
For worktree testing, use `PERSONAL_SKILLS_ALLOW_WORKTREE_SOURCE=1`.

For hosted agents, see [Cloud installation](CLOUD-INSTALL.md).

## Skills in this repository

| Skill | Use it for |
|---|---|
| [timb-ship](timb-ship/SKILL.md) | Finish a change: cleanup, review, validation, docs, commit, PR, and CI/review follow-through. |
| [timb-diff-review](timb-diff-review/SKILL.md) | Read-only review of introduced defects, with severity, confidence, and file evidence. |
| [timb-document-release](timb-document-release/SKILL.md) | Refresh every maintained documentation surface for a release. |
| [timb-handoff-and-follow-up](timb-handoff-and-follow-up/SKILL.md) | Save context, evidence, constraints, and next steps for another session. |
| [timb-in-repo-docs](timb-in-repo-docs/SKILL.md) | Write repository docs and READMEs, or review their structure. |
| [timb-project-preferences](timb-project-preferences/SKILL.md) | Apply project setup defaults for the stack, infrastructure, design, and workflow. |
| [timb-test-strategy](timb-test-strategy/SKILL.md) | Choose meaningful tests and verification across application and AI systems. |
| [timb-untangle-codebase](timb-untangle-codebase/SKILL.md) | Perform an explicitly requested structural cleanup of a whole codebase. |
| [timb-upstream-sync](timb-upstream-sync/SKILL.md) | Merge or rebase upstream while preserving both sides' intent. |
| [timb-finnish](timb-finnish/SKILL.md) | Write, translate, proofread, and naturalize Finnish. |
| [timb-x](timb-x/SKILL.md) | Draft and edit X posts, replies, threads, and content plans. |

Folder names are the entry points. The installer removes old alias symlinks
only when they point to the corresponding skill in this checkout. Shipping,
handoff, and whole-codebase untangling require explicit invocation; they are not automatic
end-of-task steps.

## Temporarily inactive skills

Keep skills you may want later outside the discovery directories, in
`~/.agents/skills-shelf/<bundle>/<skill>/`. Sync skips names still on that shelf.
See [SHELF.md](SHELF.md) for listing and restoring them. This is local state;
cloning this repository does not recreate another machine's installed catalog.

## Recommended third-party skills and tools

**Sources reviewed: 17 November 2026.** These are recommendations, not an
inventory of what is installed. If you have shelved a recommended bundle,
see [SHELF.md](SHELF.md) before installing a package again. Each package link
leads to its current setup instructions. Skill names and installation methods
change; check upstream before updating an existing installation.

Choose packages for the work you do. A skill supplies guidance; a CLI supplies
an executable. Some publishers bundle skills, hooks, and MCP servers in a plugin
or dedicated installer. Use one installation method per package and agent to
avoid duplicate discovery.

### Design and interfaces

| Package | When to choose it | Entry point |
|---|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) | Build or refine interfaces, review UX, audit accessibility, and improve typography, layout, copy, or polish. | `impeccable critique` or `impeccable polish` with a target. |
| [Emil Kowalski's skills](https://github.com/emilkowalski/skills) | Motion and interaction design: easing, timing, gestures, choreography, performance, and mobile behavior. | `emil-design-eng` for the main guidance; `animate`, `gestures`, and `choreograph` for specific work. |
| [Jakub Krehel's skills](https://github.com/jakubkrehel/skills) | Review an interface across disciplines, then address specific issues. | `better-interface`, with the `better-*` skills for UI, typography, colors, accessibility, layout, and writing. |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) | Build or redesign a company website with a coherent visual direction, real assets, and browser verification. | `design-taste-frontend`. Requires Node.js 22+ and Chrome, Edge, or Chromium. |
| [Imagegen skills](https://github.com/Leonxlnx/imagegen-skills) | Explore web/mobile design images or brand assets before implementation. | `imagegen-frontend-web`, `imagegen-frontend-mobile`, `brandkit`; `image-to-code` also implements the result. Requires image-generation capability. |

Start with one lead workflow: Impeccable for general interface work, Emil for
motion, or Taste Skill for a company website. Use Jakub's focused reviews when
you need a particular discipline checked. This is a selection guide, not a
requirement to run every package on every screen.

Shared-skill installation examples:

```bash
bunx skills@latest add pbakaus/impeccable -g
bunx skills@latest add emilkowalski/skills -g
bunx skills@latest add jakubkrehel/skills -g
bunx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend -g
bunx skills@latest add Leonxlnx/imagegen-skills --skill image-to-code -g
```

For Impeccable's tool-specific integrations, use `npx impeccable install`
instead of a second shared-skill install. Its installer offers project/global
scope and design hooks; `npx impeccable update` updates that installation.
A copied skill alone does not install hooks or subagents. Project initialization
is separate: `$impeccable init` in Codex, or `/impeccable init` in agents using
slash commands. See the [installation guide](https://impeccable.style/#downloads).

### Engineering, documentation, and browser work

| Package | Recommended use | Setup |
|---|---|---|
| [React Doctor](https://github.com/millionco/react-doctor) | Deterministic React checks for state/effects, performance, architecture, accessibility, and maintainability. | Scan with `npx react-doctor@latest`; install agent guidance with `npx react-doctor@latest install`. |
| [Matt Pocock's skills](https://github.com/mattpocock/skills) | Specification, debugging, TDD, domain modeling, architecture, and implementation workflows. | Start with `ask-matt`; configure a project with `setup-matt-pocock-skills`. |
| [Vercel Agent Skills](https://github.com/vercel-labs/agent-skills) | React and React Native guidance, composition patterns, view transitions, web/writing reviews, Vercel optimization, and deployment. | Select the relevant skills from the package. |
| [Context7](https://github.com/upstash/context7) | Current library documentation and examples. | `npx ctx7 setup`; choose CLI + Skills or MCP. Requires Node.js 22.13+. |
| [Playwright CLI](https://github.com/microsoft/playwright-cli) | Browser interaction, screenshots, debugging, and flow verification from a coding agent. | `npm install -g @playwright/cli@latest`, then `playwright-cli install --skills` in the intended project. Requires Node.js 20+. |

```bash
bunx skills@latest add mattpocock/skills -g
bunx skills@latest add vercel-labs/agent-skills -g
```

Matt's current workflows include `to-spec`, `to-tickets`, `implement`,
`diagnosing-bugs`, `tdd`, and `prototype`. Select deliberately: the repository's
own `ship`, `handoff`, and review workflows remain the defaults here.

For global Playwright guidance managed alongside the other shared skills, use
`bunx skills@latest add microsoft/playwright-cli --skill playwright-cli -g`
instead of also creating a project copy. The executable is still required.
Context7's setup handles authentication and installs guidance for the selected
mode; installing a skill alone does not configure access.

### Video, motion graphics, and launch content

| Package | When to choose it | Entry point |
|---|---|---|
| [HyperFrames](https://github.com/heygen-com/hyperframes) | HTML-based video compositions, demos, explainers, captions, and motion graphics. | `hyperframes`; `hyperframes-cli`, `hyperframes-registry`, and `media-use` cover execution, components, and assets/audio. |
| [Remotion skills](https://github.com/remotion-dev/skills) | React-based video and existing Remotion projects. | `remotion-best-practices` routes to creation, markup, Studio, rendering, captions, maps, and other specialists. |
| [brag](https://github.com/latent-spaces/brag) | Turn a project into a launch video with soundtrack and share copy. | `brag` for the full workflow; `brag-slim` is a newer alternative without HyperFrames or bundled assets. |

For a new HyperFrames setup:

```bash
npm install -g hyperframes
hyperframes doctor
hyperframes skills update
```

The publisher's core set now includes six skills: the four above plus
`reverse-any-video` and `style-sampling`, which require HyperFrames Pro.
`hyperframes skills update` installs release-matched core skills and refreshes
already installed optional skills. `figma`, `slideshow`, and
`remotion-to-hyperframes` are available on demand. See the
[skills guide](https://github.com/heygen-com/hyperframes/blob/main/docs/guides/skills.mdx)
before changing an installation managed by another installer.

HyperFrames requires Node.js 22+ and FFmpeg. Run `hyperframes doctor` to check
rendering dependencies and optional media tools. The classic `brag` workflow
also uses HyperFrames and FFmpeg; check the chosen `brag` variant's requirements.

```bash
bunx skills@latest add remotion-dev/skills -g
bunx skills@latest add latent-spaces/brag --skill brag brag-slim -g
```

In an existing Remotion project, `npx remotion skills add` is the native
installation route. Keep Remotion dependencies in that project.

### Deployment and operations

**Railway is the default deployment platform for this collection.** The
[Railway CLI](https://github.com/railwayapp/cli) installer can configure skills
and authenticated MCP access for detected agents:

```bash
bash <(curl -fsSL https://railway.com/install.sh) --agents -y
```

For an existing CLI, use `railway setup agent -y`. The `use-railway` skill covers
deployments, configuration, logs, metrics, SSH, databases, and debugging.
`railway skills update` reviews skill updates, including locally modified copies
that automatic updates skip. See [Railway skills](https://github.com/railwayapp/railway-skills).

For **Cloudflare**, follow the [official agent setup guide](https://developers.cloudflare.com/agent-setup/prompt.md)
and [Cloudflare skills](https://github.com/cloudflare/skills). The package covers
Workers, frameworks, Agents SDK, Durable Objects, networking, and operations.
Native plugins bundle guidance and MCP; standalone skill installs need MCP
configuration separately.

```bash
npm install -g cf
cf auth login
```

Repository preference:

> When interacting with Cloudflare, use the cf CLI unless the project has a Wrangler configuration file.

The `cf` CLI is in beta. For a shared standalone skills setup, install with
`bunx skills@latest add cloudflare/skills --skill '*' -g` and follow the official
guide for your agent's MCP configuration. Authentication is a separate step.
Use Vercel's deployment and optimization skills above when the project runs on
Vercel.

### Marketing and growth

[Corey Haines' Marketing Skills](https://github.com/coreyhaines31/marketingskills)
cover copy, SEO, conversion, analytics, acquisition, retention, pricing, and
sales. Start with `product-marketing` for shared product/audience context, then
choose a specialist such as `copywriting`, `seo-audit`, `cro`, or `social`.

```bash
bunx skills@latest add coreyhaines31/marketingskills -g
```

The current context file is `.agents/product-marketing.md`. Live marketing
accounts and external tools need their own connections; the skills do not grant
account access.

## Updates, shared links, and overlaps

Use the installer that owns each package:

| Installation | Update route |
|---|---|
| This repository's `timb-*` skills | Update the checkout, then run `./scripts/install.sh`. |
| Skills CLI | `bunx skills@latest update`; rerun `add` to select newly published skills. |
| Native plugin | Use that agent's plugin manager. |
| Publisher CLI | Follow its update command, such as `impeccable update` or `hyperframes skills update`. |
| Manual copy or Codex skill-installer helper | Refresh from upstream explicitly, preserving local changes; do not assume the Skills CLI tracks it. |

After changing shared standalone skills:

```bash
./scripts/install.sh
./scripts/sync-global-skills.sh --dry-run
./scripts/sync-global-skills.sh
```

The sync script discovers one original directory per skill and links other tools
to it. It refuses multiple real copies with the same name. Resolve those
conflicts before applying; do not delete a copy until its contents and owner are
understood. App-bundled plugin and internal system skills remain app-managed.

Overlap rules for this collection:

- `timb-ship` and `timb-handoff-and-follow-up` are this repository's workflows.
  Third-party skills can be shelved temporarily when you do not need them.
  Shelving does not mean a skill is obsolete or permanently excluded.
- Emil and Matt both publish `prototype`. The local convention is
  `emil-prototype` for Emil's version, renamed in both folder and frontmatter.
  Preserve that rename when refreshing; it is not an upstream skill name.
- Impeccable's `animate` is a subcommand, so it can coexist with Emil's standalone
  `animate` skill.
- The [policy script](scripts/apply-skill-policy.py), run by `install.sh`, makes
  `context7-cli` and `code-review` explicit-only when a restored copy is present
  in the shared store. Use `find-docs` for the existing ordinary docs workflow and
  `timb-diff-review` for repository reviews. Configure MCP servers separately;
  skill sync does not enable or disable them.
- Keep related skill bundles together when their entry point calls companion
  skills. In particular, retain the `better-*` family for `better-interface`.

## Add a skill

Create a top-level folder containing `SKILL.md`:

```text
personal-skills/
├── scripts/
│   ├── install.sh
│   ├── sync-global-skills.sh
│   ├── apply-skill-policy.py
│   ├── legacy-aliases.txt
│   └── restore-shelved-skills.py
└── timb-example/
    ├── SKILL.md
    └── references/      # optional supporting material
```

```yaml
---
name: timb-example
description: Explain when to use this skill and when to skip it.
---
```

Write the workflow beneath the frontmatter, add any supporting files, and run
`./scripts/install.sh`. Check the generated links before committing. Keep skill
instructions portable and put local account details in user or project context.
