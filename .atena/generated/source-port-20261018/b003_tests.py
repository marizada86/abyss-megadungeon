from pathlib import Path
import json,subprocess,sys,hashlib,shutil
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();b=root/'.atena/generated/source-port-20261018/b003';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');rows=json.loads((b/'write-set-r1.json').read_text(encoding='utf-8'));done={r['path']for r in rows};sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def put(rel,data):
 p=root/rel;before=sha(p);q=b/'before'/rel
 if not q.exists():q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
 p.write_bytes(data);rows.append({'path':rel,'before_sha256':sha(q),'after_sha256':sha(p),'source_sha256':sha(src/rel)})
for r in json.loads((b/'preflight.json').read_text(encoding='utf-8')):
 rel=r['path']
 if not rel.startswith('tests/') or not rel.endswith('.gd') or rel in done or r['before_sha256']==None:continue
 p=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True)
 if p.returncode!=0:continue
 old=p.stdout.decode('utf-8-sig').replace('\r\n','\n');up=(src/rel).read_text(encoding='utf-8-sig')
 if old==up:continue
 for kind,t in [('base',old),('local',(root/rel).read_text(encoding='utf-8-sig')),('upstream',up)]:
  q=b/kind/rel;q.parent.mkdir(parents=True,exist_ok=True);q.write_text(t,encoding='utf-8')
 p=subprocess.run(['rtk','proxy','git','merge-file','--diff3','--stdout',str(b/'local'/rel),str(b/'base'/rel),str(b/'upstream'/rel)],capture_output=True)
 if p.returncode!=0:raise AssertionError(rel)
 put(rel,p.stdout)
rel='data/secrets.json';d=json.loads((root/rel).read_text(encoding='utf-8-sig'));d['_regras']['camara_vista']=json.loads((src/rel).read_text(encoding='utf-8-sig'))['_regras']['camara_vista'];put(rel,(json.dumps(d,ensure_ascii=False,indent=2)+'\n').encode('utf-8'))
(b/'write-set-r1.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8');print('Ported changed source assertions preserving PC tests; total writes',len(rows))
# Refresh only affected scripts/data in the isolated candidate while its editor imports assets.
for r in rows:
 if r['path'].startswith(('tests/','data/')):shutil.copyfile(root/r['path'],root/'tmp/port-b3/candidate'/r['path'])


