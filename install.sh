#!/usr/bin/env bash
# install.sh — symlink every skill in this folder into each AI tool's skills dir.
#
# Source of truth: the stable personal-skills checkout. Running this script
# from a disposable Codex worktree falls back to ~/Desktop/Projects/personal-skills
# so global skill links do not point at a worktree that may be deleted.
# Symlink targets:
#   ~/.claude/skills/<skill-name-or-alias>          (Claude Code)
#   ~/.cursor/skills/<skill-name-or-alias>          (Cursor)
#   ~/.codex/skills/<skill-name-or-alias>           (Codex)
#   ~/.config/opencode/skills/<skill-name-or-alias> (OpenCode)
#   ~/.hermes/skills/<skill-name-or-alias>          (Hermes, if ~/.hermes exists)
#
# Idempotent: skipping skills already symlinked correctly. Re-run any time
# you add a new skill folder here to fan it out to every configured tool.
# Optional aliases: add one alias per line in <skill>/aliases.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SOURCE_DIR="${HOME}/Desktop/Projects/personal-skills"
SOURCE_DIR="${PERSONAL_SKILLS_SOURCE_DIR:-${SCRIPT_DIR}}"

has_skills() {
  local dir="$1"
  [[ -d "${dir}" ]] && find "${dir}" -mindepth 2 -maxdepth 2 -name "SKILL.md" -print -quit | grep -q .
}

if [[ -z "${PERSONAL_SKILLS_SOURCE_DIR:-}" && "${SCRIPT_DIR}" == "${HOME}/.codex/worktrees/"* && "${PERSONAL_SKILLS_ALLOW_WORKTREE_SOURCE:-}" != "1" ]]; then
  if has_skills "${DEFAULT_SOURCE_DIR}"; then
    SOURCE_DIR="${DEFAULT_SOURCE_DIR}"
    echo "running from Codex worktree; using stable source: ${SOURCE_DIR}"
    echo "set PERSONAL_SKILLS_ALLOW_WORKTREE_SOURCE=1 to install from this worktree"
    echo
  else
    echo "error: refusing to install skills from disposable Codex worktree: ${SCRIPT_DIR}" >&2
    echo "       stable source not found at ${DEFAULT_SOURCE_DIR}" >&2
    echo "       set PERSONAL_SKILLS_SOURCE_DIR=/path/to/personal-skills or PERSONAL_SKILLS_ALLOW_WORKTREE_SOURCE=1" >&2
    exit 1
  fi
fi
TARGETS=(
  "${HOME}/.claude/skills"
  "${HOME}/.cursor/skills"
  "${HOME}/.codex/skills"
  "${HOME}/.config/opencode/skills"
)

if [[ -d "${HOME}/.hermes" ]]; then
  mkdir -p "${HOME}/.hermes/skills"
  TARGETS+=("${HOME}/.hermes/skills")
fi

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "error: ${SOURCE_DIR} does not exist" >&2
  exit 1
fi

# Collect skill folders (anything under SOURCE_DIR that has a SKILL.md).
skills=()
while IFS= read -r -d '' skill_md; do
  skills+=("$(dirname "${skill_md}")")
done < <(find "${SOURCE_DIR}" -mindepth 2 -maxdepth 2 -name "SKILL.md" -print0)

if [[ ${#skills[@]} -eq 0 ]]; then
  echo "no skills found under ${SOURCE_DIR} (expected ${SOURCE_DIR}/<name>/SKILL.md)"
  exit 0
fi

echo "Found ${#skills[@]} skill(s): $(printf '%s ' "${skills[@]##*/}")"
echo

linked=0
skipped=0
errors=0

for target_root in "${TARGETS[@]}"; do
  if [[ ! -d "${target_root}" ]]; then
    echo "target missing: ${target_root} — skipping (tool likely not installed)"
    continue
  fi

  for skill_dir in "${skills[@]}"; do
    skill_name="${skill_dir##*/}"
    link_names=("${skill_name}")

    if [[ -f "${skill_dir}/aliases" ]]; then
      while IFS= read -r alias_name || [[ -n "${alias_name}" ]]; do
        [[ -z "${alias_name}" || "${alias_name}" == \#* ]] && continue
        if [[ "${alias_name}" == */* ]]; then
          echo "  ERROR: invalid alias '${alias_name}' in ${skill_dir}/aliases"
          errors=$((errors + 1))
          continue
        fi
        link_names+=("${alias_name}")
      done < "${skill_dir}/aliases"
    fi

    for link_name in "${link_names[@]}"; do
      link_path="${target_root}/${link_name}"

      if [[ -L "${link_path}" ]]; then
        current="$(readlink "${link_path}")"
        if [[ "${current}" == "${skill_dir}" ]]; then
          skipped=$((skipped + 1))
          continue
        fi
        echo "  fixing stale symlink: ${link_path} -> ${current}"
        rm "${link_path}"
      elif [[ -e "${link_path}" ]]; then
        echo "  ERROR: ${link_path} exists and is not a symlink — refusing to overwrite"
        errors=$((errors + 1))
        continue
      fi

      ln -s "${skill_dir}" "${link_path}"
      echo "  linked: ${link_path} -> ${skill_dir}"
      linked=$((linked + 1))
    done
  done
done

echo
echo "Done. ${linked} created, ${skipped} already correct, ${errors} errors."
exit "${errors}"
