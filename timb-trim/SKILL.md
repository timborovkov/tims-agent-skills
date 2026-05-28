---
name: timb-trim
description: >-
  Reviews code for behavior-preserving line-count reduction and quality
  improvements: verbose comments, legacy patterns, dead private code,
  duplication, and logic simplification. Use when the user says "trim the
  code," "reduce line count," "simplify," "code quality pass," or "modernize
  patterns." Skip targeted bug fixes, new feature work, and public API changes
  unless the user explicitly opts in.
---

# Timb Trim

Two-phase: read-only findings, then user-approved implementation. Never refactor without verifying meaningful test coverage for risky changes.

## Quick Start

1. Ask whether to review the current diff vs default branch or the whole codebase.
2. Build the in-scope file list, excluding generated files, vendor/build output, lockfiles, and agent state.
3. Learn the stack from manifests. Fetch current docs only when a finding touches a third-party API.
4. Collect findings under: comments, legacy patterns, dead private code, duplication, simplification, and public-surface risks.
5. Gate risky findings on real tests, not tautological mocks.
6. Write a markdown findings report and ask the user what to implement.
7. Implement approved findings only, lowest risk first. Add missing tests first when needed.
8. Run repo verification gates, delete the report, and summarize shipped/skipped findings.

## Non-Negotiables

- No behavior changes.
- No compatibility shims for internal renames; update all in-repo consumers instead.
- Treat public exports as public even when there are no in-repo callers. Public-surface findings require explicit per-item opt-in.
- One commit per approved finding when committing.
- If verification is already red on the base branch, stop and surface that before refactoring.

## Detailed Rules

Read [references/trim-detail.md](references/trim-detail.md) before producing findings or editing code. It contains scope detection, exclusion rules, finding buckets, report format, approval handling, and cleanup rules.
