#!/usr/bin/env python3
"""List inactive bundles, or restore one without overwriting installed skills."""
import argparse
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('bundle', nargs='?', help='bundle to restore; omit to list')
args = parser.parse_args()
shelf = Path.home() / '.agents/skills-shelf'
if not args.bundle:
    for bundle in sorted(shelf.iterdir()) if shelf.is_dir() else []:
        if bundle.is_dir():
            names = sorted(p.name for p in bundle.iterdir() if (p / 'SKILL.md').is_file())
            print(f'{bundle.name}: {", ".join(names)}')
    raise SystemExit(0)
if args.bundle in ('.', '..') or '/' in args.bundle:
    parser.error('expected a bundle name, not a path')
bundle = shelf / args.bundle
skills = sorted(p for p in bundle.iterdir() if (p / 'SKILL.md').is_file()) if bundle.is_dir() else []
if not skills:
    parser.error(f'no skills found in {bundle}')
target = Path.home() / '.agents/skills'
# Check every destination before moving any files, including broken symlinks.
conflicts = [target / p.name for p in skills if (target / p.name).exists() or (target / p.name).is_symlink()]
if conflicts:
    parser.error('nothing restored; destinations already exist: ' + ', '.join(map(str, conflicts)))
target.mkdir(parents=True, exist_ok=True)
for skill in skills:
    shutil.move(str(skill), str(target / skill.name))
    print(f'Restored {skill.name}', flush=True)
# MANIFEST.json is historical; current folder contents determine shelf state.
result = subprocess.run(['bash', str(Path(__file__).with_name('sync-global-skills.sh'))])
if result.returncode:
    print('Files restored to ~/.agents/skills; resolve the reported sync conflicts and rerun sync.')
raise SystemExit(result.returncode)
