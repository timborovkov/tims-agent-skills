#!/usr/bin/env python3
"""Keep overlapping third-party workflows explicitly invoked after updates."""
from pathlib import Path
import re

root = Path.home() / '.agents/skills'
for name in ('context7-cli', 'code-review'):
    folder = root / name
    entry = folder / 'SKILL.md'
    if not entry.is_file():
        print(f'{name}: not installed; skipped')
        continue
    text = entry.read_text()
    match = re.match(r'\A---\n(.*?)\n---(?=\n)', text, re.S)
    if not match:
        raise SystemExit(f'{entry}: invalid frontmatter; left unchanged')
    front = match.group(1)
    if re.search(r'^disable-model-invocation:', front, re.M):
        front = re.sub(r'^disable-model-invocation:.*$', 'disable-model-invocation: true', front, flags=re.M)
    else:
        front += '\ndisable-model-invocation: true'
    updated = '---\n' + front + '\n---' + text[match.end():]
    metadata = folder / 'agents/openai.yaml'
    original = metadata.read_text() if metadata.exists() else ''
    # Preserve third-party metadata; reject unfamiliar policy layouts rather than overwrite.
    if re.search(r'^policy:', original, re.M):
        policy = re.search(r'^policy:\s*\n((?:[ \t]+[^\n]*\n|\n)*)', original, re.M)
        if not policy:
            raise SystemExit(f'{metadata}: unsupported policy layout; left unchanged')
        block = policy.group(0)
        if re.search(r'^  allow_implicit_invocation:', block, re.M):
            new_block = re.sub(r'^  allow_implicit_invocation:.*$', '  allow_implicit_invocation: false', block, flags=re.M)
        else:
            new_block = block + '  allow_implicit_invocation: false\n'
        result = original[:policy.start()] + new_block + original[policy.end():]
    else:
        result = original.rstrip() + ('\n\n' if original.strip() else '') + 'policy:\n  allow_implicit_invocation: false\n'
    if updated != text:
        entry.write_text(updated)
    metadata.parent.mkdir(exist_ok=True)
    if result != original:
        metadata.write_text(result)
    print(f'{name}: explicit-only (upstream content retained)')
