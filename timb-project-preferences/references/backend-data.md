# Backend And Data Preferences

- Auth.js for authentication.
- Postgres as the default database.
- Drizzle ORM for TypeScript apps by default.
- GORM for Go services by default.
- Vector store:
  - pgvector when vector needs are simple, relationally coupled, or operational simplicity matters.
  - Qdrant when vector search is a first-class workload or needs dedicated indexing/filtering behavior.
- RustFS for S3-compatible bucket storage by default.
- Zod-based env loader that validates and types env at process startup.
- Sentry for error reporting.
- A `pnpm dev:wipe` script that can clear object storage, vectors, database state, run migrations, and seed when seed data exists.
- `pnpm dev:wipe` must hard-fail unless `ALLOW_DESTRUCTIVE_DEV_WIPE=true` and `NODE_ENV` is non-production.
- Example local invocation: `ALLOW_DESTRUCTIVE_DEV_WIPE=true NODE_ENV=development pnpm dev:wipe`.
