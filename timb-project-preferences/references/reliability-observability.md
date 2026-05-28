# Reliability And Observability Preferences

## Background jobs and queues

- Use a Postgres-backed queue by default when the app already depends on Postgres.
- Prefer Postgres `LISTEN`/`NOTIFY` or equivalent listener patterns for lightweight job wakeups and internal messaging.
- Jobs must be idempotent, retryable, observable, and safe to run more than once.
- Every job needs structured logs, failure tracking, retry limits, and a dead-letter or manual recovery path.
- Use dedicated jobs/workers for email, webhooks, billing sync, AI/background generation, imports/exports, and long-running external API calls.
- Redis and BullMQ require separate justification. If Redis already earns its place for caching, it can also be considered for messaging/queues.

## Caching

- Redis is optional, not automatic. Add it only when the project has a clear cache, coordination, rate-limit, pub/sub, or queue need.
- Prefer simpler in-process, database, HTTP, or framework caches when they satisfy the use case.
- Document cache keys, invalidation, TTLs, and failure behavior.

## Abuse prevention

- Public backend services need abuse controls: IP blocking, rate limits, request size limits, bot protection, auth checks, and structured audit logs where appropriate.
- Risky public surfaces such as AI chat messages, API calls, form submissions, signup, login, and contact forms need rate limiting and bot/abuse defenses.
- Use Cloudflare Turnstile for risky public human-submitted forms and anonymous flows.
- Backend services should have firewall or network exposure rules where the platform supports them. Railway may make some host firewall concerns irrelevant, but app-level limits still apply.

## Sentry and logging

- Sentry should be wired through typed env configuration and disabled by default in local development unless explicitly enabled.
- Next.js Sentry setup should use `@sentry/nextjs`, `src/instrumentation.ts`, server and edge config files, environment names, source map upload only when auth/org/project env vars are set, and explicit sampling env vars.
- Go Sentry setup should use a small local wrapper, initialize once, no-op when disabled or DSN is missing, attach Fiber request context with cloned hubs, recover/capture panics in goroutines, capture 5xx/server errors, and flush on shutdown.
- Do not send default PII to Sentry. Attach user/request context deliberately and avoid raw cookies, auth headers, uploaded content, or full AI prompts unless explicitly scrubbed.
- Use structured logs with request IDs/correlation IDs across API, workers, queue jobs, webhooks, and AI calls.

## Backups and restore drills

- Production-like data stores need documented backup and restore paths: Postgres, object storage, vector indexes, Redis if used, and provider-managed state where applicable.
- Add a restore drill checklist before launch and after major data-shape changes.
- `pnpm dev:wipe` is for dev/staging only and is not a backup strategy.

## E2E and browser testing

- Next.js/public apps should have Playwright E2E coverage for auth, critical user journeys, payments/billing, forms, AI chat flows, and destructive confirmations.
- E2E tests should use documented test users/env vars and run in CI when stable enough.
- Add accessibility and keyboard-navigation checks for critical flows.

## File and malware scanning

- Self-hosted or VM deployments that accept files should include ClamAV via Docker Compose or equivalent scanning infrastructure.
- Scan uploads before processing when files can come from untrusted users.
