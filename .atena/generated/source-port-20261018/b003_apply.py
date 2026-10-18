from pathlib import Path
import subprocess,shutil,json,hashlib,re,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');b=root/'.atena/generated/source-port-20261018/b003';rows=json.loads((b/'preflight.json').read_text());index={r['path']:r for r in rows};writes=[]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
def write(rel,data):
 p=root/rel;before=sha(p)
 if before==hashlib.sha256(data).hexdigest():return
 if rel in index:assert before==index[rel]['before_sha256'],rel
 elif p.exists():
  q=b/'before'/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
 p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
 writes.append({'path':rel,'before_sha256':before,'after_sha256':sha(p),'source_sha256':sha(src/rel)})
def source(rel):write(rel,(src/rel).read_bytes())
def merge(rel):
 r=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True);assert r.returncode==0,rel
 for name,data in [('base',r.stdout),('local',(root/rel).read_bytes()),('upstream',(src/rel).read_bytes())]:
  q=b/name/rel;q.parent.mkdir(parents=True,exist_ok=True);q.write_text(data.decode('utf-8-sig').replace('\r\n','\n'),encoding='utf-8')
 r=subprocess.run(['rtk','proxy','git','merge-file','--diff3','--stdout',str(b/'local'/rel),str(b/'base'/rel),str(b/'upstream'/rel)],capture_output=True);assert r.returncode==0,(rel,r.returncode)
 return r.stdout
# Reviewed conflict resolutions; maps, HQ readers, terrain and platform configuration are excluded.
for p in (b/'resolved').rglob('*.gd'):
 rel=p.relative_to(b/'resolved').as_posix();t=p.read_text(encoding='utf-8')
 if rel=='core/battle.gd':
  t=t.replace('func _l2() -> Dictionary:\n','func _l2() -> Dictionary:\n\tif is_dagruve_encounter():\n\t\treturn {}\n')
  t=t.replace('func l4_section(name: String) -> Dictionary:\n','func l4_section(name: String) -> Dictionary:\n\tif is_dagruve_encounter():\n\t\treturn {}\n')
 write(rel,t.encode('utf-8'))
for rel in ['core/controller_input.gd','ui/ability_slot.gd','ui/abyss_panel.gd','ui/event_pointer.gd','ui/leaderboard.gd','ui/pause_menu.gd','ui/prop.gd','ui/quest_panel.gd','ui/stage_structures.gd','ui/menu.tscn','ui/theme.tres']:
 write(rel,merge(rel))
for r in rows:
 rel=r['path']
 if r['before_sha256'] is None and rel.startswith(('core/','ui/','data/')) and not any(x in rel for x in ['mobile_controls','touch_ui']):source(rel)
# Only changed fields from the source are applied to data; PC-only fields remain.
missing=object()
def combine(base,local,up,path):
 if up==base:return local
 if local==base or local==up:return up
 if all(isinstance(v,dict) for v in [base,local,up]):
  out=dict(local)
  for k in up:
   v=combine(base.get(k,missing),local.get(k,missing),up[k],path+'/'+k)
   out[k]=v
  return out
 raise AssertionError('Data conflict '+path)
for rel in ['data/abilities.json','data/weapons.json','data/enemies.json','data/difficulty.json']:
 r=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True);assert r.returncode==0
 data=combine(json.loads(r.stdout),json.loads((root/rel).read_text(encoding='utf-8-sig')),json.loads((src/rel).read_text(encoding='utf-8-sig')),rel)
 write(rel,(json.dumps(data,ensure_ascii=False,indent=2)+'\n').encode('utf-8'))
# Chamber metadata is additive by stable event id; local event text and exclusive maps remain.
rel='data/stage_events.json';local=json.loads((root/rel).read_text(encoding='utf-8-sig'));up=json.loads((src/rel).read_text(encoding='utf-8-sig'))
def hints(a,z):
 if isinstance(a,dict) and isinstance(z,dict):
  if 'chamber_hint' in z:a['chamber_hint']=z['chamber_hint']
  for k in a:
   if k in z and k!='chamber_hint':hints(a[k],z[k])
 elif isinstance(a,list) and isinstance(z,list):
  ids={str(x['id']):x for x in z if isinstance(x,dict) and 'id'in x}
  for x in a:
   if isinstance(x,dict) and str(x.get('id','')) in ids:hints(x,ids[str(x['id'])])
hints(local,up);write(rel,(json.dumps(local,ensure_ascii=False,indent=2)+'\n').encode('utf-8'))
# Test modules follow the same code paths; restore strict B002 expectations now that definitions exist.
for r in rows:
 rel=r['path']
 if rel.startswith('tests/') and r['before_sha256'] is None and not any(x in rel for x in ['mobile','touch']):source(rel)
for rel in ['tests/test_actor_strips_b003.gd','tests/test_projectile_and_ability_vfx.gd','tests/test_radiant_pulse_vfx.gd']:source(rel)
# Defensive boundary: the Thalion encounter never receives raid mechanics.
rel='core/boss_mechanics.gd';p=root/rel;t=p.read_text(encoding='utf-8');t=t.replace('static func create(battle: Battle, e: Enemy) -> BossMechanics:\n','static func create(battle: Battle, e: Enemy) -> BossMechanics:\n\tif battle.is_dagruve_encounter():\n\t\treturn null\n');p.write_text(t,encoding='utf-8')
for r in writes:r['after_sha256']=sha(root/r['path'])
(b/'write-set-r1.json').write_text(json.dumps(writes,ensure_ascii=False,indent=2),encoding='utf-8');print('APPLIED',len(writes),'files')

