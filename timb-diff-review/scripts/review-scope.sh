#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: review-scope.sh [--base <git-ref>] [--no-fetch]

Resolve the default branch, merge base, and effective branch/worktree review
scope. The script never changes the working tree. By default it refreshes an
origin/* base ref when possible and falls back to the existing ref on failure.
EOF
}

base_arg=""
fetch_base=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -ge 2 ]] || { echo "error: --base requires a git ref" >&2; exit 2; }
      base_arg="$2"
      shift 2
      ;;
    --no-fetch)
      fetch_base=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "error: not inside a Git repository" >&2
  exit 2
}
cd "$repo_root"

git rev-parse --verify HEAD^{commit} >/dev/null 2>&1 || {
  echo "error: repository has no HEAD commit to compare" >&2
  exit 2
}

current_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
if [[ -z "$current_branch" ]]; then
  current_branch="(detached HEAD at $(git rev-parse --short HEAD))"
fi

base_branch=""
base_ref=""

if [[ -n "$base_arg" ]]; then
  if git rev-parse --verify --quiet "$base_arg^{commit}" >/dev/null; then
    base_ref="$base_arg"
  elif [[ "$base_arg" != */* ]] && git rev-parse --verify --quiet "origin/$base_arg^{commit}" >/dev/null; then
    base_ref="origin/$base_arg"
  else
    echo "error: base ref does not resolve to a commit: $base_arg" >&2
    exit 2
  fi
else
  origin_head=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
  if [[ -n "$origin_head" ]] && git rev-parse --verify --quiet "$origin_head^{commit}" >/dev/null; then
    base_ref="$origin_head"
  else
    for candidate in origin/main origin/master origin/trunk origin/develop main master trunk develop; do
      if git rev-parse --verify --quiet "$candidate^{commit}" >/dev/null; then
        base_ref="$candidate"
        break
      fi
    done
  fi
fi

[[ -n "$base_ref" ]] || {
  echo "error: could not detect a default base; pass --base <git-ref>" >&2
  exit 2
}

if [[ "$base_ref" == origin/* ]]; then
  base_branch=${base_ref#origin/}
else
  base_branch=${base_ref#refs/heads/}
fi

fetch_status="not requested"
if [[ $fetch_base -eq 1 && "$base_ref" == origin/* ]]; then
  if git fetch --quiet origin "+refs/heads/$base_branch:refs/remotes/origin/$base_branch"; then
    fetch_status="updated origin/$base_branch"
  else
    fetch_status="failed; using existing $base_ref"
  fi
elif [[ $fetch_base -eq 1 ]]; then
  fetch_status="skipped; base is local"
fi

merge_base=$(git merge-base "$base_ref" HEAD 2>/dev/null) || {
  echo "error: $base_ref and HEAD have no merge base" >&2
  exit 2
}

committed_count=$(git diff --name-only "$merge_base" HEAD | awk 'NF {n++} END {print n+0}')
staged_count=$(git diff --cached --name-only | awk 'NF {n++} END {print n+0}')
unstaged_count=$(git diff --name-only | awk 'NF {n++} END {print n+0}')
untracked_count=$(git ls-files --others --exclude-standard | awk 'NF {n++} END {print n+0}')
tracked_effective_count=$(git diff --name-only "$merge_base" | awk 'NF {n++} END {print n+0}')
shortstat=$(git diff --shortstat "$merge_base" | sed 's/^[[:space:]]*//' || true)
[[ -n "$shortstat" ]] || shortstat="no tracked changes"

printf 'REPO_ROOT: %s\n' "$repo_root"
printf 'CURRENT_BRANCH: %s\n' "$current_branch"
printf 'BASE_BRANCH: %s\n' "$base_branch"
printf 'BASE_REF: %s\n' "$base_ref"
printf 'FETCH_STATUS: %s\n' "$fetch_status"
printf 'MERGE_BASE: %s\n' "$merge_base"
printf 'SCOPE: merge base through current worktree\n'
printf 'COVERAGE: committed + staged + unstaged tracked changes; untracked listed separately\n'
printf 'COUNTS: committed_paths=%s staged_paths=%s unstaged_paths=%s effective_tracked_paths=%s untracked_paths=%s\n' \
  "$committed_count" "$staged_count" "$unstaged_count" "$tracked_effective_count" "$untracked_count"
printf 'DIFFSTAT: %s\n' "$shortstat"

printf '\nCHANGED_PATHS:\n'
git diff --name-status "$merge_base"
git ls-files --others --exclude-standard | sed $'s/^/??\t/'

if [[ $tracked_effective_count -eq 0 && $untracked_count -eq 0 ]]; then
  printf '\nNOTHING_TO_REVIEW: true\n'
else
  printf '\nNOTHING_TO_REVIEW: false\n'
fi
