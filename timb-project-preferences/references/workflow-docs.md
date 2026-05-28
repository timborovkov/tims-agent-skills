# Workflow And Documentation Preferences

- Keep TODOs, docs, and contribution guidance current as part of the same change, not as a later cleanup.
- Prefer concise, visual HTML docs under `docs/` for substantial internal documentation, including briefs, explainers, architecture notes, and guides.
- Keep README files for the repo and major packages/apps.
- Root `README.md` must be clear enough for a new contributor: project purpose, folder structure, setup, commands, docs, tests, deployment, and contribution path.
- `CONTRIBUTING.md` is mandatory for non-trivial repos and should explain setup, validation, branch/PR flow, review responses, CI expectations, docs/TODO updates, and release/deploy rules.
- Use `pnpm validate` before push.
- Push changes after validation when the user asked to ship.
- React to GitHub CI failures and PR review comments until each is fixed or answered.
- Route substantial docs work through `timb-in-repo-docs`.
- Route validation, push, CI, and review-response work through `timb-contribution-workflow`.
