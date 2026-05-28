# Optional Runtime Preferences

Most projects should stay TypeScript/Next.js unless another runtime has a clear reason to exist. Go and Python are optional, not default.

## Go

- Use the latest stable Go version at project creation, then pin it in `go.mod`, CI, Docker, and docs.
- Prefer Fiber for HTTP services when a Go web service is warranted.
- Fiber services should include deliberate middleware: recover/panic handling, request ID, structured logging, timeout, CORS, security headers, compression when useful, rate limiting where exposed, auth/session middleware where applicable, and centralized error handling.
- Use GORM for ORM/database access by default.
- Use `golangci-lint` with strict rules, including complexity/cyclomatic limits, error handling checks, unused/dead code checks, formatting/import checks, security checks, and no warning-only drift in CI.
- `go test ./...` and `golangci-lint run` should be part of validation.

## Python

- Python is mostly for small scripts unless the project explicitly needs a Python service.
- Use the latest stable Python version at project creation, then pin it in `.python-version`, CI, Docker, and docs.
- Use an isolated virtual environment. Prefer `uv`/`pyproject.toml` when possible; otherwise document `.venv` creation and activation clearly.
- Use strict formatting/lint/type gates: Ruff for lint/format, plus pyright or mypy when scripts grow beyond trivial glue.
- Keep Python scripts typed where useful, small, and runnable from documented commands.
- Python validation should run lint/format checks, type checks when configured, and tests when behavior is non-trivial.
