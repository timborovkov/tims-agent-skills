#!/usr/bin/env bash
# install.sh — symlink every skill in this folder into each AI tool's skills dir.
#
# Source of truth: this script's own directory (run from anywhere).
# Symlink targets:
#   ~/.claude/skills/<skill-name-or-alias>          (Claude Code)
#   ~/.cursor/skills/<skill-name-or-alias>          (Cursor)
#   ~/.config/opencode/skills/<skill-name-or-alias> (OpenCode)
#
# Idempotent: skipping skills already symlinked correctly. Re-run any time
# you add a new skill folder here to fan it out to all three tools.
# Optional aliases: add one alias per line in <skill>/aliases.

set -euo pipefail

# Resolve this script's directory so the repo can live anywhere.
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(
  "${HOME}/.claude/skills"
  "${HOME}/.cursor/skills"
  "${HOME}/.config/opencode/skills"
)

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
