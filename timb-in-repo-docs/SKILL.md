---
name: timb-in-repo-docs
description: >-
  Writes and maintains in-repo docs using Tim's conventions: HTML docs under
  `docs/`, markdown READMEs/TODOs, protected project files, visual-first docs,
  and safe markdown-to-HTML conversion. Use when creating docs, adding a
  package README, converting markdown to HTML, running a structural docs sweep,
  or the user says "write docs," "doc this," "architecture doc," or "sweep the
  docs." Skip ordinary edits to TODO/CHANGELOG/AGENTS/CLAUDE/design markdown
  and end-of-session docs syncs.
---

# Timb In-Repo Docs

Use for new HTML docs, package/subfolder READMEs, markdown-to-HTML conversion, and explicit docs sweeps. Existing protected markdown keeps its format.

`<docsDir>` means the directory declared by `design.md`, defaulting to `docs/`.

## Quick Start

1. Resolve `design.md`: root `design.md`, `docs/design.md`, `.docs/design.md`, then one safe fallback search.
2. Determine whether the target stays markdown or becomes HTML.
3. Before converting any markdown, run the consumer checks from [references/in-repo-docs-detail.md](references/in-repo-docs-detail.md).
4. For HTML docs, write concise visual-first pages under `<docsDir>`, update `<docsDir>/index.html`, and set `last-updated` using `date -u +%Y-%m-%d`.
5. For READMEs, keep markdown and cover what it is, why it exists, how to use it, where it fits, and status only when non-stable.
6. For TODO/plan files, preserve the existing convention and compact done items only when the gates apply.
7. End with what changed, what remains, and any human decision needed.

## Protected Markdown

Never convert or delete these unless the user explicitly asks and the repo can tolerate it:

- TODO/PLAN/ROADMAP files.
- README files.
- CHANGELOG, LICENSE, CONTRIBUTING, SECURITY, SUPPORT, governance/maintainer files.
- `AGENTS.md`, `CLAUDE.md`, `SKILL.md`, and `design.md`.
- Any markdown consumed by a site, MDX/content system, build config, public URL, or docs host.

## HTML Defaults

- Use semantic HTML, anchored headings, skip links, and relative links.
- Prefer tables, grids, callouts, steppers, and diagrams over long prose.
- Use inline SVG for fixed diagrams and pinned Mermaid only when it materially helps.
- If `design.md` is missing, report it, suggest design consultation, and use plain neutral defaults.

## Detailed Rules

Read [references/in-repo-docs-detail.md](references/in-repo-docs-detail.md) before converting markdown, running a docs sweep, creating an index, or compacting TODOs.
