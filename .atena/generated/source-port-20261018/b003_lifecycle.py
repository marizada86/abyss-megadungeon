from pathlib import Path
import hashlib,json,shutil
p=Path('core/boss_mechanics.gd');t=p.read_text(encoding='utf-8');assert 'var b: Battle\n' in t
t=t.replace('var b: Battle\n','var _battle_ref: WeakRef\nvar b: Battle:\n\tget:\n\t\treturn _battle_ref.get_ref() as Battle if _battle_ref != null else null\n\tset(value):\n\t\t_battle_ref = weakref(value) if value != null else null\n')
p.write_text(t,encoding='utf-8');shutil.copyfile(p,Path('tmp/port-b3/candidate')/p)
b=Path('.atena/generated/source-port-20261018/b003');rows=json.loads((b/'write-set-r1.json').read_text(encoding='utf-8'))
for r in rows:
 if r['path']==p.as_posix():r['after_sha256']=hashlib.sha256(p.read_bytes()).hexdigest()
(b/'write-set-r1.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
v=Path('.atena/generated/source-port-20261018/b003_validate.py').read_text(encoding='utf-8-sig');v=v.split("if '--targeted' in sys.argv:")[0]
v+='\nassert json.loads((out/"isolation.json").read_text())["verified"]\ncommon=["--headless","--path",str(root)]\ninvoke("suite-final",common+["--quit-after","36000","-s","tests/run_all.gd","--","--controller-profile",str(profile)],300)\ninvoke("smoke-final",common+["--quit-after","12000","res://tools/smoke.tscn","--","--controller-profile",str(profile)],180)\n'
Path('.atena/generated/source-port-20261018/b003_finalcheck.py').write_text(v,encoding='utf-8');print('Removed strong Battle/BossMechanics ownership cycle; final checks prepared')
