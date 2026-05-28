# Timb In-Repo Docs Detail

## Design Source

Look for `design.md` in this order:

1. `./design.md`
2. `./docs/design.md`
3. `./.docs/design.md`
4. Fallback: `git ls-files | grep -iE '(^|/)design\.md$'`, excluding vendored/build/cache trees.

Read it for aesthetic tokens, HTML mode, `docsDir`, and markdown files that are page content. Once `<docsDir>` is known, also prefer `<docsDir>/design.md` if it exists and differs from the file already read.

If no `design.md` exists, report that, suggest design consultation, and fall back to plain single-file HTML under `docs/`.

## Consumer Check

Before converting any `.md`:

1. `rg -F "<basename>.md"` across the repo.
2. `rg -F "<basename-without-extension>"` across likely code/config files.
3. Detect content systems such as MDX, Contentlayer, Velite, Astro content, Docusaurus, VitePress, Nextra, Gatsby markdown, docs hosts, GitHub Pages, content/posts directories, RSS generators, or README rendering.
4. If any system or reference depends on markdown, keep the file as markdown and note why.
5. When unsure, ask.

## HTML Conventions

Every HTML doc needs:

- `<!doctype html>`, language, viewport, and UTF-8.
- `<title>` matching H1.
- Metadata block with doc kind, `last-updated`, and one-sentence tl;dr.
- Semantic landmarks and skip link.
- Anchored headings.
- Local assets under `<docsDir>/assets/`.
- Relative links to sibling docs.

Single-file mode inlines CSS and small JS. Shared-stylesheet mode links `assets/styles.css` and keeps it aligned with `design.md`.

Use Mermaid via pinned CDN only on pages that need it. Vendor Mermaid if the repo requires offline docs.

## Index

Maintain `<docsDir>/index.html` with an agent-managed region:

```html
<!-- docs:index:start -->
<!-- docs:index:end -->
```

Regenerate only that region from all HTML docs below `<docsDir>`, excluding `index.html`, grouped by kind. Preserve hand-edited content outside the markers. If an existing index lacks markers, ask where to insert them before editing.

## README Rules

Required at the repo root and in major packages/apps/services/workspace members. Also add one for coherent modules with roughly six or more source files.

Each README answers:

1. What it is.
2. Why it exists.
3. How to use it.
4. Where it fits.
5. Status, only when WIP/deprecated/non-stable.

## TODO Rules

Respect existing TODO/plan conventions first. For new or unstructured trackers:

- Open work stays at the top, grouped by area.
- Completed work moves near the bottom under `## Done - YYYY-MM`.
- Collapse monthly done sections past roughly 15 items.
- Never delete useful history only because git has it.

Only compact when you touch the file and completed items are interleaved with open work or the latest done section is too large.

## Structural Sweep

For a sweep:

1. Require a clean tree or explicit user confirmation for known changes.
2. Inventory tracked markdown and existing docs.
3. Classify protected, consumed, and convertible markdown.
4. Stop for user approval if a content system is present.
5. Convert eligible markdown one file at a time, preserving links and URL expectations.
6. Add missing READMEs.
7. Compact TODOs only when gates apply.
8. Regenerate the index.
9. Report converted, created, left-as-markdown, READMEs added, TODOs compacted, and decisions needed.
