#!/usr/bin/env bash
# sync-global-skills.sh — make Claude, Cursor, Codex, and OpenCode share skills.
#
# For each skill name found in any configured skills directory, choose the
# original directory and symlink the other tools to it. If a skill physically
# lives in ~/.claude/skills/foo, for example, the other tools get symlinks to
# that directory. If every copy is already a symlink, the resolved target is
# reused as the original.

set -euo pipefail

ROOTS=(
  "${HOME}/.claude/skills"
  "${HOME}/.cursor/skills"
  "${HOME}/.codex/skills"
  "${HOME}/.config/opencode/skills"
)

apply=1
case "${1:-}" in
  --dry-run)
    apply=0
    ;;
  ""|--apply)
    apply=1
    ;;
  -h|--help)
    cat <<'USAGE'
Usage: ./sync-global-skills.sh [--apply|--dry-run]

Discovers skill folders in:
  ~/.claude/skills
  ~/.cursor/skills
  ~/.codex/skills
  ~/.config/opencode/skills

For each skill name, finds one original directory and symlinks the other tool
directories to it. Refuses to overwrite regular files or reconcile multiple
real directories for the same skill name.
USAGE
    exit 0
    ;;
  *)
    echo "error: unknown argument: $1" >&2
    echo "usage: ./sync-global-skills.sh [--apply|--dry-run]" >&2
    exit 2
    ;;
esac

real_path() {
  local path="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "${path}"
  else
    python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "${path}"
  fi
}

is_skill() {
  local path="$1"
  [[ -d "${path}" && -f "${path}/SKILL.md" ]]
}

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT
names_file="${tmpdir}/names"
: > "${names_file}"

for root in "${ROOTS[@]}"; do
  [[ -d "${root}" ]] || continue

  while IFS= read -r -d '' entry; do
    name="${entry##*/}"
    [[ "${name}" == .* ]] && continue
    is_skill "${entry}" || continue
    printf '%s\n' "${name}" >> "${names_file}"
  done < <(find "${root}" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -print0)
done

if [[ ! -s "${names_file}" ]]; then
  echo "No skills found in configured roots."
  exit 0
fi

linked=0
fixed=0
ok=0
skipped=0
conflicts=0

choose_original() {
  local name="$1"
  local root entry target
  local real_dirs_file targets_file real_count target_count

  real_dirs_file="${tmpdir}/${name}.real"
  targets_file="${tmpdir}/${name}.targets"
  : > "${real_dirs_file}"
  : > "${targets_file}"

  for root in "${ROOTS[@]}"; do
    entry="${root}/${name}"
    is_skill "${entry}" || continue
    target="$(real_path "${entry}")"
    printf '%s\n' "${target}" >> "${targets_file}"
    if [[ -d "${entry}" && ! -L "${entry}" ]]; then
      printf '%s\n' "${target}" >> "${real_dirs_file}"
    fi
  done

  sort -u "${real_dirs_file}" -o "${real_dirs_file}"
  sort -u "${targets_file}" -o "${targets_file}"
  real_count="$(wc -l < "${real_dirs_file}" | tr -d ' ')"
  target_count="$(wc -l < "${targets_file}" | tr -d ' ')"

  if [[ "${real_count}" -eq 1 ]]; then
    sed -n '1p' "${real_dirs_file}"
    return 0
  fi

  if [[ "${real_count}" -gt 1 ]]; then
    echo "CONFLICT: ${name} has multiple real directories:" >&2
    sed 's/^/  /' "${real_dirs_file}" >&2
    return 1
  fi

  if [[ "${target_count}" -eq 1 ]]; then
    sed -n '1p' "${targets_file}"
    return 0
  fi

  echo "CONFLICT: ${name} has multiple symlink targets and no real directory:" >&2
  sed 's/^/  /' "${targets_file}" >&2
  return 1
}

sync_one() {
  local name="$1"
  local original root entry current

  if ! original="$(choose_original "${name}")"; then
    conflicts=$((conflicts + 1))
    skipped=$((skipped + 1))
    return
  fi

  for root in "${ROOTS[@]}"; do
    [[ -d "${root}" ]] || {
      echo "missing root: ${root} — skipping"
      skipped=$((skipped + 1))
      continue
    }

    entry="${root}/${name}"

    if [[ -L "${entry}" ]]; then
      current="$(real_path "${entry}")"
      if [[ "${current}" == "${original}" ]]; then
        ok=$((ok + 1))
        continue
      fi
      echo "fix symlink: ${entry} -> ${original}"
      if [[ ${apply} -eq 1 ]]; then
        rm "${entry}"
        ln -s "${original}" "${entry}"
      fi
      fixed=$((fixed + 1))
      continue
    fi

    if [[ -e "${entry}" ]]; then
      current="$(real_path "${entry}")"
      if [[ -d "${entry}" && "${current}" == "${original}" ]]; then
        ok=$((ok + 1))
        continue
      fi
      echo "CONFLICT: ${entry} exists and is not the chosen original"
      conflicts=$((conflicts + 1))
      skipped=$((skipped + 1))
      continue
    fi

    echo "link: ${entry} -> ${original}"
    if [[ ${apply} -eq 1 ]]; then
      ln -s "${original}" "${entry}"
    fi
    linked=$((linked + 1))
  done
}

while IFS= read -r name; do
  sync_one "${name}"
done < <(sort -u "${names_file}")

if [[ ${apply} -eq 0 ]]; then
  echo
  echo "Dry run. No filesystem changes made."
fi

echo
echo "Done. ${linked} linked, ${fixed} fixed, ${ok} already correct, ${skipped} skipped, ${conflicts} conflict(s)."
exit "${conflicts}"
