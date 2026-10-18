from pathlib import Path
import subprocess,sys,json,hashlib,shutil
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');base=root/'.atena/generated/source-port-20261018';out=base/'b003';out.mkdir(exist_ok=True)
old=json.loads((base/'b001/pc-manifest.json').read_text(encoding='utf-8'));after={r['path']:r['after_sha256'] for r in json.loads((base/'b002/final-write-set.json').read_text(encoding='utf-8'))};source=json.loads((base/'b001/source-manifest.json').read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
paths=[r['path'] for r in json.loads((base/'b001/disposition-matrix.json').read_text(encoding='utf-8')) if r['path'].startswith(('core/','data/','ui/','tests/')) and r['comparison'] in ['source_only','different']]
# Snapshot every potential integration path before touching runtime, including B002 changes.
rows=[]
for rel in paths:
 p=root/rel;expected=after.get(rel,old.get(rel,{}).get('sha256'))
 assert (sha(p) if p.is_file() else None)==expected,'PC drift '+rel
 assert sha(src/rel)==source[rel]['sha256'],'source drift '+rel
 if p.exists():q=out/'before'/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
 rows.append({'path':rel,'before_sha256':sha(p) if p.exists() else None,'source_sha256':source[rel]['sha256']})
(out/'preflight.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
reference='b83f188a6dae9d32f78420a318bffedcac4ff4a3'
results=[]
for rel in ['core/battle.gd','core/game.gd','core/profile.gd','core/enemy.gd','core/weapon.gd','core/playtest.gd','ui/run.gd','ui/hud.gd','ui/menu.gd','ui/options_panel.gd','ui/character_sheet.gd','ui/overlay.gd','ui/enemy_view.gd','ui/ground.gd','ui/edge_fog.gd','ui/hero_panel.gd','ui/offer_card.gd','ui/stage_progress.gd','ui/lettering.gd','ui/title.gd','ui/ui_kit.gd']:
 p=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show',reference+':'+rel],capture_output=True,timeout=30)
 if p.returncode!=0:
  results.append({'path':rel,'status':'BASE_UNAVAILABLE','error':p.stderr.decode('utf-8',errors='replace')[:250]});continue
 original=out/'base'/rel;original.parent.mkdir(parents=True,exist_ok=True);original.write_text(p.stdout.decode('utf-8-sig').replace('\r\n','\n'),encoding='utf-8')
 local=out/'local'/rel;local.parent.mkdir(parents=True,exist_ok=True);local.write_text((root/rel).read_text(encoding='utf-8-sig'),encoding='utf-8')
 upstream=out/'upstream'/rel;upstream.parent.mkdir(parents=True,exist_ok=True);upstream.write_text((src/rel).read_text(encoding='utf-8-sig'),encoding='utf-8')
 p=subprocess.run(['rtk','proxy','git','merge-file','--diff3','--stdout',str(local),str(original),str(upstream)],capture_output=True,timeout=30)
 candidate=out/'merged'/rel;candidate.parent.mkdir(parents=True,exist_ok=True);candidate.write_bytes(p.stdout)
 results.append({'path':rel,'merge_exit':p.returncode,'conflict_markers':p.stdout.count(b'<<<<<<<'),'bytes':len(p.stdout)})
(out/'merge-review.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(results,ensure_ascii=False,indent=2))
