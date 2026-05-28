---
name: timb-project-preferences
description: >-
  Applies Tim's default project setup preferences when creating, initializing, or
  standardizing a repo. Defaults include GitHub Actions, AGENTS/CLAUDE guidance,
  CONTRIBUTING/design docs, TODO structure, pnpm + Turbo monorepo, Next.js App
  Router, Node 24, Tailwind + shadcn/ui, Vitest, LangChain/LangGraph,
  LangSmith, Vercel AI SDK UI, OpenRouter inference, LangChain middleware,
  Auth.js, Postgres, Qdrant/pgvector, RustFS, Railway deployment, Docker
  Compose, zod env loader, Sentry, React Query, model config files, reset
  scripts, and i13n/i18n by default. Use for "set up the project,"
  "standardize this repo," "apply my defaults," "new app scaffold," or "repo
  preferences." Skip when maintaining an established repo unless the user asks
  to migrate it.
---

# Timb Project Preferences

Purpose: apply Tim's defaults when the user has not specified another stack. Existing project conventions win unless the user asks to migrate.

Before using library/framework-specific APIs, fetch current docs according to the repo's doc-fetching rule, such as `ctx7`/Context7.

## Core repo shape

- Monorepo using pnpm workspaces and Turbo.
- Pin Node.js v24 in `.nvmrc`, `package.json` engines, CI, Docker, and deployment config where applicable.
- Package manager: pnpm.
- Standard commands:
  - `pnpm validate` runs the full local gate.
  - `pnpm test` runs tests.
  - Include focused commands for lint, format/prettier, typecheck, build, and any app-specific checks.
- GitHub Actions for CI. CI should run the same validation commands developers run locally.
- `AGENTS.md` for agent instructions.
- `CLAUDE.md` as an alias or near-identical companion to `AGENTS.md`, including the general contribution workflow.
- `CONTRIBUTING.md` with setup, commands, branch/PR expectations, validation, CI, review response, docs/TODO rules, and release/deploy notes.
- `design.md` for product/design system direction.
- `docs/` for HTML docs when writing briefs, guides, explainers, architecture, or internal references.
- `TODO.md` with clear open sections and compact/collapsed done items.
- Proper `.gitignore` for the stack and local agent state. Ignore generated/build/cache outputs, secrets, logs, local database/storage files, and tool worktrees/state such as `.claude/`, `.codex/`, `.cursor/`, `.opencode/`, `worktrees/`, and `.worktrees/` unless the repo intentionally tracks a specific config file.
- Use `grill-with-docs` when domain language, product plan, or architecture direction is fuzzy enough to deserve interrogation before implementation.

## Frontend defaults

- Next.js with App Router.
- Tailwind CSS and shadcn/ui for UI primitives, including modals, popovers, buttons, menus, form controls, and dialogs.
- No custom one-off component primitives when shadcn/ui fits.
- Proper loading, empty, pending, optimistic, success, and error states.
- i13n/i18n by default: no hardcoded user-facing strings in app code when the project has or should have a message/catalog system.
- React Query where reasonable for client/server state, especially caching, invalidation, optimistic updates, and mutation status.
- Vitest for unit/component tests unless the repo has a stronger existing choice.

## AI and model defaults

- LangChain and LangGraph for agent/workflow orchestration when useful.
- Use LangChain middleware for agent cross-cutting concerns such as tool selection, human-in-the-loop approval/checkpoints, conversation summarization, guardrails, retries, tracing hooks, and context management.
- LangSmith for tracing/evaluation when AI behavior needs observability.
- Vercel AI SDK, including its UI utilities, for streaming/chat UI when appropriate.
- OpenRouter is the default inference gateway and model access layer unless the project explicitly requires direct provider SDKs.
- Model definitions and model routing/config live in code as versioned config files, not in environment variables. Env vars should hold secrets and deployment-specific endpoints only.

## Backend and data defaults

- Auth.js for authentication.
- Postgres as the default database.
- Vector store:
  - pgvector when vector needs are simple, relationally coupled, or operational simplicity matters.
  - Qdrant when vector search is a first-class workload or needs dedicated indexing/filtering behavior.
- RustFS for S3-compatible bucket storage by default.
- Zod-based env loader that validates and types env at process startup.
- Sentry for error reporting.
- A reset script that can clear object storage, vectors, database state, run migrations, and seed when seed data exists. Make destructive behavior explicit and gated.

## Deployment and operations

- Railway for deployment by default.
- Include proper `railway.json` files for each deployable service/app.
- Docker and `docker-compose.yml` for local dependencies and reproducible app/service runs.
- GitHub Actions should validate, test, and build before merge.
- Deployment config should match local commands and pinned runtime versions.

## Documentation and workflow defaults

- Keep TODOs, docs, and contribution guidance current as part of the same change, not as a later cleanup.
- Prefer concise, visual HTML docs under `docs/` for substantial documentation.
- Keep README files for the repo and major packages/apps.
- Use `pnpm validate` before push.
- Push changes after validation when the user asked to ship.
- React to GitHub CI failures and PR review comments until each is fixed or answered.

## When applying to an existing repo

1. Inventory existing conventions first.
2. Preserve intentional choices unless the user asked to standardize or migrate.
3. Propose migration steps when the change is broad, risky, or touches deploy/auth/database/runtime.
4. Implement in small vertical slices with validation after each slice.
5. Update `CONTRIBUTING.md`, `AGENTS.md`, `CLAUDE.md`, `design.md`, docs, and TODOs to match the actual repo state.
