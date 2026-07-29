# Deployment And Operations Preferences

- Railway for deployment by default.
- Install the Railway CLI with agent support (`bash <(curl -fsSL https://railway.com/install.sh) --agents -y`) and keep the `use-railway` skill available. For an existing CLI installation, run `railway setup agent -y`.
- Use Railway tooling for deploys and production operations, including status checks, build/runtime logs, metrics, variables, SSH, databases, domains, and service debugging.
- Use Railpack for Railway deployments unless the project has a clear reason to use a custom Dockerfile/build path.
- Include proper `railway.json` files for each deployable service/app.
- For Railway-hosted dev/staging wipes, document the flow:
  1. `railway login`
  2. `railway link` for the web app
  3. `railway ssh`
  4. `ALLOW_DESTRUCTIVE_DEV_WIPE=true NODE_ENV=development pnpm dev:wipe` inside the shell
- Docker and `docker-compose.yml` for local dependencies and reproducible app/service runs.
- GitHub Actions should validate, test, and build before merge.
- Deployment config should match local commands and pinned runtime versions.
