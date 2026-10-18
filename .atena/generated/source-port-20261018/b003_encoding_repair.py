from pathlib import Path
import json,hashlib
b=Path('.atena/generated/source-port-20261018/b003');sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
for r in json.loads((b/'preflight.json').read_text()):
 p=Path(r['path'])
 if sha(p)==r['before_sha256']:continue
 q=b/'resolved'/r['path'];assert q.exists(),'Unexpected write '+r['path']
 expected=[]
 for enc in ['utf-8','cp1252']:
  try:bad=q.read_text(encoding=enc)
  except UnicodeDecodeError:continue
  if r['path']=='core/battle.gd':
   for signature in ['func _l2() -> Dictionary:','func l4_section(name: String) -> Dictionary:']:
    bad=bad.replace(signature+'\n',signature+'\n\tif is_dagruve_encounter():\n\t\treturn {}\n')
  expected.append(bad.encode('utf-8'))
 assert p.read_bytes() in expected,r['path']
 p.write_bytes((b/'before'/r['path']).read_bytes())
 print('Repaired interrupted encoding write:',r['path'])
