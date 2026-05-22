---
name: timb-in-repo-docs
description: >-
  Write and maintain in-repo docs. Use when creating a new HTML doc under
  `docs/` (brief, guide, explainer, architecture, design notes, internal
  reference), creating a new package/subfolder README, converting markdown to
  HTML, or running a structural docs sweep across the repo. Triggers on
  "write docs," "structural docs sweep," "convert docs to HTML," "explain X
  in a doc," "architecture doc," "add a README for this package," "doc
  this," "sweep the docs." Two flows: authoring a single doc, and a
  structural sweep that converts markdown to HTML and adds missing READMEs.
  Do NOT invoke for ordinary edits to existing markdown
  (TODO/CHANGELOG/AGENTS/CLAUDE/design.md and any `.md` consumed as page
  content stay as they are). Do NOT use for end-of-session diff syncs against
  main — that is `timb-handoff-and-follow-up`'s job, even when phrased as
  "align the docs."
---

# Timb In-Repo Docs

The opinionated rules for how docs live in any repo I work in. Apply when creating a new HTML doc, creating a new package/subfolder README, converting markdown to HTML, or running an explicit alignment sweep. Do **not** apply to ordinary edits of existing markdown — those follow the existing file's conventions.

**Path conventions used below.** `<docsDir>` means whatever directory `design.md` declares, defaulting to `docs/`. Wherever this skill says `docs/` literally, substitute `<docsDir>`. The "agent-generated index" lives at `<docsDir>/index.html`; assets at `<docsDir>/assets/`; HTML cross-links use paths relative to the doc being written.

## Format selection — which files are HTML vs markdown

HTML in `docs/` (or whatever `docsDir` `design.md` declares):

- Project briefs, guides, explainers, architecture, design notes, internal references.

Markdown, untouched:

- Any file matching (case-insensitive) `todo.md`, `todos.md`, `plan.md`, `plans.md`, `roadmap.md` — TODO/plan tracking stays markdown.
- `README.md` (any case) at repo root and in every package / major subfolder.
- `CHANGELOG.md`, `CHANGES.md`, `HISTORY.md`, `NEWS.md`, `LICENSE`, `LICENCE`, `LICENSE.md`, `LICENCE.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `GOVERNANCE.md`, `AUTHORS.md`, `MAINTAINERS.md`, `AGENTS.md`, `CLAUDE.md` — all case-insensitive.
- `SKILL.md` anywhere in the tree — these define agent skills. Converting one breaks skill discovery, installer scripts, and the harness. Never touch.
- `design.md` at any of these locations — repo root, `<docsDir>/design.md`, `docs/design.md`, `.docs/design.md` — this skill *reads* `design.md`; it must never convert, rename, or delete any copy in these paths.
- Any `.md` file consumed as page content (MDX imports, content collections, docs sites). Detect before touching.

Match the protected list case-insensitively (`README.MD`, `Todo.md`, and `readme.md` are all protected). When in doubt about whether a file is protected, treat it as protected and ask.

### Consumer check — mandatory before converting any `.md` to HTML

Before you delete or convert any existing `.md`:

1. `rg -F "<basename>.md"` across the repo — references by full filename.
2. `rg -F "<basename-without-extension>"` — content systems usually import by slug (`./posts/foo`), not `./foo.md`. False positives are fine; you're looking for any hit in `*.ts`, `*.tsx`, `*.js`, `*.mjs`, `*.svelte`, `*.astro`, `*.vue`, `*.config.*`, `next.config.*`, `astro.config.*`, `contentlayer.config.*`, `velite.config.*`, `mdsvex.config.*`, `*.yml`/`*.yaml` build configs.
3. Look for content systems and conventions even when the basename grep is clean: `next-mdx`, `contentlayer`, `velite`, `astro:content`, `docusaurus`, `vitepress`, `nextra`, `mdx-bundler`, `gatsby-*-md*`, framework `content/` or `posts/` directories with frontmatter, MD→RSS feeds, README rendered on a public page, GitHub Pages, Read the Docs. If any of these are wired up in the repo at all, **prompt the user before converting any `.md`** — even files outside the obvious content directory may be globbed in.
4. `docs/` served via GitHub Pages or a static host counts as a consumer too. Respect URL slugs and `index.html` conventions; don't rename files that have inbound URLs.
5. If anything (code, build config, URL slug pattern, public site) depends on the file being `.md`, **leave it as markdown** and note it in the report.
6. When in doubt, ask the user.

## `design.md` is the per-repo source of truth

Look for `design.md` in this order, taking the first one that exists: `./design.md` (repo root), `./docs/design.md`, `./.docs/design.md`. Read it for:

- Aesthetic tokens — colors, type, spacing, radii, motion.
- HTML mode — **single-file self-contained** (CSS inlined per page) or **shared stylesheet** (`docs/assets/styles.css` linked).
- Optional overrides — `docsDir`, "these .md files are page content, never convert."

Once you've resolved `docsDir`, also check for a `design.md` at `<docsDir>/design.md` whenever it differs from the file you already loaded. If a different file exists there, it takes precedence — reload from that path. Never load `design.md` from `node_modules`, vendored trees, or anywhere not in this list.

If `design.md` is missing:

1. Report its absence.
2. Suggest `/design-consultation` to produce one.
3. Fall back to plain defaults — single-file self-contained, system font stack, neutral palette, `docs/` as docs root. Keep them deliberately plain so the user notices.

Never invent a brand aesthetic when `design.md` is absent.

## HTML doc conventions

Every HTML doc under `docs/`:

- `<!doctype html>`, `<html lang="…">`, viewport meta, UTF-8.
- `<title>` matches the H1.
- Metadata block at the top: doc kind (brief / guide / explainer / architecture / reference), `last-updated` ISO date, one-sentence tl;dr. Get today's date with `date -u +%Y-%m-%d` — never guess or hallucinate it.
- Images, screenshots, and any binary visual assets live in `docs/assets/` with kebab-case filenames. Reference them with relative paths. Inline SVG stays in the HTML; raster images stay external.
- Skip-link to `<main>`, semantic landmarks (`<main>`, in-page `<nav>` for TOC, `<aside>` for callouts).
- Anchored headings (`id` attributes) so other docs can deep-link.
- Relative cross-links to sibling docs (`./architecture.html`).

**Single-file mode (default):** all CSS in a `<style>` block, any small JS inline. The only external asset allowed is the pinned mermaid CDN script (see Visual-first authoring), and only on pages that actually contain a mermaid diagram. Everything else — images, fonts, icons, additional JS libraries — is local under `<docsDir>/assets/`. If `design.md` declares an offline requirement, vendor mermaid too.

**Shared-stylesheet mode:** pages link `./assets/styles.css` (relative to the doc — adjust depth for nested docs); keep that file aligned with `design.md` tokens. Avoid per-page `<style>` blocks beyond small page-specific tweaks.

## Visual-first authoring

Spirit of the skill, not a checklist. Prefer visual structure over paragraphs.

1. **HTML/CSS-native visuals first** — comparison tables, definition grids, stat cards, badge rows, side-by-side columns, callout boxes, stepper lists, before/after splits, status pills. Cheap, accessible, no JS.
2. **Inline SVG** for fixed diagrams (architecture boxes-and-arrows, sequence outlines, state machines) when a grid won't convey it.
3. **Mermaid via pinned CDN script** for flowcharts, sequence diagrams, ERDs, gantt. Author the source in `<pre class="mermaid">…</pre>` and include the script once per page, pinned to a major version so CDN updates don't break old docs:

   ```html
   <script type="module">
     import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
     mermaid.initialize({ startOnLoad: true });
   </script>
   ```

   If `design.md` declares an offline requirement, vendor mermaid into `docs/assets/` instead and reference it locally.

If a section is three paragraphs explaining a relationship, replace it with a table or diagram plus one sentence of context.

## Writing style — applies to HTML and markdown READMEs

- Extremely concise. Short sentences. Active voice.
- Each section answers one question. Lead with the answer, then the why.
- No filler ("In this document, we will discuss…"). No "Conclusion" sections.
- Code examples are minimal and runnable.
- Define jargon on first use, or link to where it's defined.

## README.md in every package / major subfolder

Mandatory README locations:

- Repo root.
- Every entry under `packages/`, `apps/`, `services/`, `crates/`, `pkg/`, `internal/`, `libs/`, or any workspace member declared in `package.json` / `Cargo.toml` / `go.work` / `pyproject.toml` workspaces.
- Any subfolder with roughly 6+ source files that represents a coherent module — use judgment.

Each README answers, in order:

1. **What it is.**
2. **Why it exists.**
3. **How to use it** — one runnable example or import.
4. **Where it fits** — link to the relevant HTML doc.
5. **Status** — only include if non-stable. Add a `WIP` or `Deprecated` line when true; omit entirely when the package is stable. Stale "stable" labels are worse than no label.

These stay markdown — GitHub renders them and tooling expects them.

## TODO compaction

Applies to every protected TODO/plan file: `todo.md`, `todos.md`, `plan.md`, `plans.md`, `roadmap.md` (all case-insensitive).

**Respect existing format first.** If the file already uses a non-default convention — different "Done" header, dated sections in a different shape, a separate `DONE.md` archive, an issue-tracker convention, frontmatter the project relies on, etc. — preserve it. Apply the rules below only when the file has no established convention yet, or when the user explicitly asks for the canonical shape.

**Canonical shape (default for new or un-conventioned files):**

- Open work stays at the top, grouped by area.
- Completed items move to a `## Done — YYYY-MM` section under a horizontal rule near the bottom. One line per item. No detail bloat.
- When a month's Done section grows past ~15 items, collapse it to a single line: `Done — 2026-04: shipped auth rewrite, fixed payments races, migrated to Postgres 16.`
- Never delete — git has history, but the file itself should let a human skim the arc of the project.

**When to compact:** opportunistically, whenever you touch one of these files and either (a) the latest Done section already has >15 items, or (b) completed items sit interleaved at the top of the open list. Don't edit a TODO/plan file and leave it un-compacted. If you're unsure whether to restructure an existing convention, ask — don't rewrite the file's shape unprompted.

## Flow A — authoring a single new/edited doc

1. Determine the doc kind. Any file in the protected list above (TODO / PLAN / README / CHANGELOG / LICENSE / CONTRIBUTING / CODE_OF_CONDUCT / SECURITY / AGENTS / CLAUDE / `design.md` / etc., case-insensitive) → markdown. Otherwise HTML in `<docsDir>`.
2. Read `design.md` (repo root, or `<docsDir>/design.md`) to resolve `<docsDir>` and the HTML mode. If absent, report and fall back to defaults (`<docsDir>` = `docs/`, single-file self-contained, plain palette).
3. If editing an existing `.md` that should be HTML, run the consumer check first. If consumed as content, keep it markdown and note it.
4. Write the doc following the style and visual-first rules. Add `id` anchors on headings. Discover sibling docs with a recursive listing of `<docsDir>` (e.g. `find <docsDir> -name '*.html'`). Any link to another doc in this repo points to `.html`, never `.md` (unless that target is a content-consumed `.md` per the consumer check).
5. Update `<docsDir>/index.html` so the new doc is linked from the index, grouped by kind. The index's doc-list region is agent-generated — wrap it in `<!-- docs:index:start -->` / `<!-- docs:index:end -->` markers and regenerate it from a recursive walk of `<docsDir>` for every `.html` file (excluding `index.html` itself) on every run. Outside those markers (intro, custom sections) is hand-editable and must be preserved verbatim. If `index.html` doesn't exist, create it with the markers in place.
6. Set the `last-updated` metadata to today's date (`date -u +%Y-%m-%d`).
7. End with one line: what changed, what's outstanding, any human decisions needed.

## Flow B — alignment sweep across the whole repo

1. **Clean tree.** Confirm `git status` is clean (or only contains changes the user explicitly told you about). Flow B mutates and deletes files — uncommitted hand-edits could be lost. If the tree is dirty, stop and ask.
2. **Read `design.md`.** Resolve `<docsDir>` and HTML mode. If absent, report it, suggest `/design-consultation`, and fall back to defaults (`<docsDir>` = `docs/`, single-file self-contained, plain palette) — do **not** halt the sweep. Halting is only for a dirty tree (step 1).
3. **Inventory.** List every tracked markdown file (any case: `.md`, `.MD`, `.Md`) and every existing file under `<docsDir>` (recursive). **Exclude** anything inside `node_modules/`, `.git/`, `vendor/`, `third_party/`, `dist/`, `build/`, `out/`, `target/`, `.next/`, `.nuxt/`, `.svelte-kit/`, `.cache/`, `coverage/`, or any path listed in `.gitignore`. Use `git ls-files | grep -iE '\.md$'` as the canonical inventory source — `git ls-files` already respects gitignore and excludes vendored/build trees; the `-i` grep catches uppercase extensions that `git ls-files '*.md'` would miss on case-sensitive filesystems. Note which files are content-consumed (consumer check + framework patterns above) and which are in the protected list (case-insensitive match against the full protected set above, including `SKILL.md` anywhere in the tree).
4. **CMS gate.** Run the consumer check on the full inventory and detect any content systems wired into the repo (`next-mdx`, `contentlayer`, `velite`, `astro:content`, `docusaurus`, `vitepress`, `nextra`, `mdx-bundler`, `gatsby-*-md*`, framework `content/`/`posts/` with frontmatter, MD→RSS, GitHub Pages, Read the Docs). If **any** content system is present, stop and ask the user once: list every `.md` you intend to convert and the systems detected, and proceed only with the user's explicit go-ahead (per-file or blanket). If no content system is present, continue without a prompt.
5. **Convert (one commit per file).** For each `.md` that should be HTML and isn't consumed or protected:
   - Convert to HTML and place the result under `<docsDir>`. Path mapping rules:
     - File already under `<docsDir>`: mirror its sub-path verbatim. `<docsDir>/architecture/overview.md` → `<docsDir>/architecture/overview.html`.
     - File at repo root and not in the protected list (e.g. `ARCHITECTURE.md`, `ONBOARDING.md`, `STYLE_GUIDE.md`): place at `<docsDir>/<basename>.html`, lower-cased and kebab-cased (`<docsDir>/architecture.html`, `<docsDir>/style-guide.html`). Note: `ROADMAP.md`, `TODO.md`, `PLAN.md`, `LICENSE.md`, `README.md`, `SECURITY.md`, etc. are protected and never reach this step.
     - File under a meaningful tree like `packages/<pkg>/docs/foo.md`, `apps/<app>/notes/bar.md`, `src/<area>/explainer.md`: collapse the framework/scaffolding prefix and preserve the rest. `packages/<pkg>/docs/foo.md` → `<docsDir>/<pkg>/foo.html`. `apps/<app>/notes/bar.md` → `<docsDir>/<app>/bar.html`. `src/<area>/explainer.md` → `<docsDir>/<area>/explainer.html`. If two source files would collapse to the same destination, prefix with the tree (e.g. `<docsDir>/packages-<pkg>-foo.html`) rather than overwriting.
     - Never flatten everything to a single directory and never leave converted HTML scattered at the repo root or inside source trees.
   - Preserve info and apply the style and visual-first rules.
   - Rewrite every in-doc link from `*.md` → the new `.html` location (using the mapping rules above), except links pointing to content-consumed or protected markdown files (those keep `.md`).
   - Update any other files in the repo that referenced the old `.md` path.
   - Stage the new `.html`, the link updates, and the `.md` deletion as a **single commit per converted file** so each conversion is trivially revertable. Don't bundle multiple conversions into one commit.
6. **READMEs.** For each subfolder/package missing a README, draft one from the code.
7. **TODOs.** Run TODO compaction on every TODO/PLAN file.
8. **Index.** Create `<docsDir>/index.html` if it doesn't exist (with the `<!-- docs:index:start -->` / `<!-- docs:index:end -->` markers in place per Flow A step 5). Then regenerate the agent-generated region between the markers from a recursive walk of `<docsDir>` for every `.html` file (excluding `index.html` itself), grouped by kind. Preserve everything outside the markers verbatim.
9. **Report.** Summarize: converted, created, left-as-markdown (with reason), READMEs added, TODOs compacted, anything that needs human input.

End with one line: what changed, what's outstanding, any human decisions needed.
