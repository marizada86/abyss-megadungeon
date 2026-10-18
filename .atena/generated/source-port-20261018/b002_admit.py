from pathlib import Path
import sys,json,hashlib,shutil,collections
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');base=root/'.atena/generated/source-port-20261018/b001';out=base.parent/'b002';out.mkdir(exist_ok=True)
a=json.loads((base/'source-manifest.json').read_text(encoding='utf-8'));b=json.loads((base/'pc-manifest.json').read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
matrix=json.loads((base/'disposition-matrix.json').read_text(encoding='utf-8'))
assets=[r['path'] for r in matrix if r['path'].startswith('assets/') and not r['path'].startswith('assets/hq/') and r['comparison'] in ['source_only','different']]
readers=['ui/hero_view.gd','ui/enemy_view.gd','ui/overlay.gd','ui/happening_art.gd','ui/interaction_anim.gd','ui/hero_portraits.gd','ui/ui_fonts.gd','ui/sheet_art.gd','core/projectile_vfx.gd','core/hero_ability_vfx.gd','core/radiant_pulse_vfx.gd','core/hourglass_vfx.gd','core/melee_vfx.gd','core/happenings.gd']
tests=['test_animation_assets','test_hero_own_art','test_interaction_anim','test_breakable_death_art','test_actor_strips_b003','test_happening_art','test_hero_portraits','test_projectile_and_ability_vfx','test_radiant_pulse_vfx','test_hourglass_vfx','test_walk_lab']
copies=assets+readers+['data/interaction_anims.json','data/cursor.json','data/audio_manifest.json']+['tests/'+n+'.gd' for n in tests]
copies+= [p+'.uid' for p in readers+['tests/'+n+'.gd' for n in tests] if p+'.uid' in a and p+'.uid' not in b]
adapt=['core/hero.gd','core/battle.gd','core/sfx.gd','ui/run.gd','ui/lettering.gd','data/stage_events.json']
affected=sorted(set(copies+adapt));before=out/'before';changes=[]
# Validate every planned input before the first mutation; no fallback to stale source snapshots.
for rel in affected:
 p=root/rel
 assert (sha(p) if p.is_file() else None)==(b[rel]['sha256'] if rel in b else None),'PC concurrent change: '+rel
 if rel in copies:assert sha(src/rel)==a[rel]['sha256'],'Source concurrent change: '+rel
for rel in affected:
 p=root/rel
 if p.is_file():q=before/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
 changes.append({'path':rel,'before_sha256':sha(p) if p.is_file() else None,'operation':'COPY_SOURCE' if rel in copies else 'ADAPT_PC','source_sha256':a[rel]['sha256'] if rel in copies else None,'content_state':'DRAFT_SOURCE_PRESERVED' if rel.startswith('assets/') else 'TECHNICAL_INTEGRATION_NO_CANON_PROMOTION'})
(out/'authorized-write-set.json').write_text(json.dumps(changes,ensure_ascii=False,indent=2),encoding='utf-8')
for rel in copies:
 p=root/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src/rel,p)
 assert sha(p)==a[rel]['sha256']
(out/'admission-r1.json').write_text(json.dumps({'authorized_batch':'B-PORT-002','source_head':'a558cd8532ffa39cabfe49bb7b4d1c1cb978a783','copied_files':len(copies),'asset_files':len(assets),'write_set':changes,'hq_assets_preserved':True,'retentions_preserved':True,'gameplay_activation':'DEFERRED_B003','status':'COPIED_AWAITING_READER_ADAPTATIONS_AND_VALIDATION'},indent=2,ensure_ascii=False),encoding='utf-8')
print('COPIED',len(copies),'ASSET_FILES',len(assets),'BACKED_UP',sum(r['before_sha256'] is not None for r in changes),'planned writes',len(changes))
