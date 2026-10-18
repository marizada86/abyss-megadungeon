from pathlib import Path
import json,subprocess,hashlib,sys,collections
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();base=root/'.atena/generated/source-port-20261018';out=base/'publication';load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
inventory=load(out/'working-tree-inventory.json');expected=set(load(base/'b001/pc-manifest.json'))
for batch in ['b002','b003']:expected.update(r['path']for r in load(base/batch/'final-write-set.json'))
changed=inventory['modified']+inventory['untracked'];runtime=[p for p in changed if p.startswith(('assets/','core/','data/','ui/','tests/','tools/'))]
assert all(p in expected for p in runtime),[p for p in runtime if p not in expected]
paths=set(runtime)
paths.add('.atena/state/plan.yaml')
for p in (root/'.atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018').glob('*.md'):paths.add(p.relative_to(root).as_posix())
for p in (root/'.atena/evidence').glob('EVID-NOTTGARD-SOURCE-PORT-*.md'):paths.add(p.relative_to(root).as_posix())
# Keep concise provenance and replay tools; backups, caches, raw snapshots and synthetic sessions stay local.
for folder in [base,base/'b001',base/'b002',base/'b003',base/'b004']:
 for p in folder.iterdir():
  if p.is_file() and p.suffix in ['.json','.py','.gd','.md','.cmd']:
   if p.name in ['working-tree-inventory.json','remaining-dispositions.json']:continue
   paths.add(p.relative_to(root).as_posix())
# Previously approved HQ04/HQ21 are part of the delivered PC tree; include their durable integration contracts.
for spec in ['SPEC-NOTTGARD-HQ-INTEGRATION-20261018','SPEC-NOTTGARD-HQ05-VISUAL-20261018']:
 for p in (root/'.atena/specs'/spec).glob('*.md'):paths.add(p.relative_to(root).as_posix())
for p in (root/'.atena/evidence').glob('EVID-NOTTGARD-HQ21-HQ04-*.md'):paths.add(p.relative_to(root).as_posix())
for p in (root/'.atena/vault/canon').glob('*.md'):
 if any(x in p.name.upper() for x in ['HQ21','HQ04','HQ-INTEGRATION']):paths.add(p.relative_to(root).as_posix())
for name in ['hq-integration-20261018','hq-continuation-20261018','hq05-selection-20261018']:
 folder=root/'.atena/generated'/name
 if folder.exists():
  for p in folder.glob('*.json'):paths.add(p.relative_to(root).as_posix())
print('SELECTED',len(paths),'runtime',len(runtime),'total_MiB',round(sum((root/p).stat().st_size for p in paths)/1048576,2));print('ROOTS',dict(collections.Counter(p.split('/')[0]for p in paths)))
(out/'selected-paths.json').write_text(json.dumps(sorted(paths),ensure_ascii=False,indent=2),encoding='utf-8')
