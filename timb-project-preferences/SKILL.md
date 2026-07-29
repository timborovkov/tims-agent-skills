---
name: timb-project-preferences
description: >-
  Applies Tim's default project setup preferences when creating, initializing,
  or standardizing a repo. Covers repo shape, TypeScript/frontend defaults,
  optional Go/Python stacks, AI/model infrastructure, backend/data choices,
  product services, design quality, compliance, reliability/observability,
  deployment, docs, workflow, and i13n/i18n. Use for "set up the project,"
  "standardize this repo," "apply my defaults," "new app scaffold," or "repo
  preferences." Skip when maintaining an established repo unless the user asks
  to migrate it.
---

# Timb Project Preferences

Purpose: apply Tim's defaults when the user has not specified another stack. Existing project conventions win unless the user asks to migrate.

Before using library/framework-specific APIs, fetch current docs according to the repo's doc-fetching rule, such as `ctx7`/Context7.

Prefer the latest stable supported dependencies and current APIs by default. Do not introduce deprecated patterns when setting up or standardizing a project. Pick the frontend framework by project shape: lightweight frontends should usually use Vite with React, while Next.js remains appropriate when the app benefits from routing conventions, SSR/RSC, full-stack server routes, SEO-heavy pages, or platform integrations. For example, in Next.js 16 use `proxy.ts`/`proxy.js` and `proxy` exports instead of deprecated `middleware.ts`/`middleware.js` and `middleware` exports, unless the repo has a documented reason to keep the old convention.

## Quick Start

1. Inventory existing conventions first.
2. Preserve intentional choices unless the user asked to standardize or migrate.
3. Read only the references needed for the current task.
4. Propose migration steps when the change is broad, risky, or touches deploy/auth/database/runtime.
5. Implement in small vertical slices with validation after each slice.
6. Keep `CONTRIBUTING.md`, `AGENTS.md`, `CLAUDE.md`, `design.md`, docs, and TODOs aligned to the actual repo state.

## References

- Repo shape, commands, agent files, `.gitignore`: [references/repo-structure.md](references/repo-structure.md)
- Frontend defaults: [references/frontend.md](references/frontend.md)
- AI/model defaults: [references/ai-stack.md](references/ai-stack.md)
- Backend/data defaults and `pnpm dev:wipe`: [references/backend-data.md](references/backend-data.md)
- Optional Go/Python defaults: [references/optional-runtimes.md](references/optional-runtimes.md)
- Product services: [references/product-services.md](references/product-services.md)
- Design quality, accessibility, SEO/GEO: [references/design-quality.md](references/design-quality.md)
- Compliance/legal docs: [references/compliance.md](references/compliance.md)
- Reliability, observability, queues, abuse controls, backups, E2E: [references/reliability-observability.md](references/reliability-observability.md)
- Railway, Docker, CI, operations: [references/deployment-ops.md](references/deployment-ops.md)
- Docs and shipping workflow: [references/workflow-docs.md](references/workflow-docs.md)

## Skill Routing

- Use `use-railway` for deployments and Railway operations, including configuration, build/runtime debugging, logs, metrics, SSH, databases, domains, and service health.
- Use `grill-with-docs` when domain language, product plan, or architecture direction is fuzzy enough to deserve interrogation before implementation.
- Use `timb-test-strategy` when adding, reviewing, or standardizing unit, integration, API, DB, E2E, CI, or AI/agent eval test layers.
- Use `timb-in-repo-docs` for substantial docs, HTML docs under `docs/`, package READMEs, markdown-to-HTML conversion, or docs sweeps.
- Use `timb-contribution-workflow` when the task is to validate, test, push, monitor CI, or respond to reviews.
- Use `timb-upstream-sync` when rebasing/merging upstream or resolving conflicts while preserving both upstream and current-PR intent.
- Use `react-doctor` for Next.js/React health, performance, security, and architecture checks.
- Use `make-interfaces-feel-better` for UI polish and interaction detail work.
- Use `seo-geo` for search visibility, schema, metadata, indexing, and AI search citation work.
