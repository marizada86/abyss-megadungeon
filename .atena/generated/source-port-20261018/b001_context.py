from pathlib import Path
import json,sys,re
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();out=root/'.atena/generated/source-port-20261018/b001';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
refs=json.loads((out/'add-dependencies.json').read_text(encoding='utf-8'))
for label in ['source','pc']:
 grouped={}
 for r in refs[label]:
  if not r['consumer'].startswith(('ui/','core/','tests/')):continue
  print('ADD INPUT/OUTPUT',label,r)
 # Retain only explicitly required, non-personal test contract inputs. Tools are not executed in bulk.
 inv=json.loads((out/(label+'-manifest.json')).read_text(encoding='utf-8'))
 kept={' .unused'}
 kept={r['reference'][6:] for r in refs[label] if r['consumer'].startswith(('tests/','ui/','core/')) and r['exists'] and not r['directory'] and not any(x in r['reference'].lower() for x in ['profile','app_userdata','relato'])}
 removed=[]
 for rel in list(inv):
  if rel.startswith('.atena/') and rel not in kept:
   p=(root/'tmp/port-b1'/label/rel).resolve();assert p.is_relative_to((root/'tmp/port-b1'/label).resolve())
   if p.is_file():p.unlink()
   removed.append(rel); del inv[rel]
 (out/(label+'-manifest.json')).write_text(json.dumps(inv,ensure_ascii=False,indent=2),encoding='utf-8')
 (out/(label+'-snapshot-scope.json')).write_text(json.dumps({'retained_add_inputs':sorted(kept),'excluded_optional_add_count':len(removed),'reason':'No dev-tool captures, personal historical evidence or profiles in baseline snapshots; runtime assets untouched'},indent=2),encoding='utf-8')
print('REFERENCES MISSING', (out/'static-reference-candidates.json').read_text(encoding='utf-8')[:7000])
for p in [src/'.atena/specs/SPEC-185-integracao-pacotes-chatgpt-lot02-a-lot17.md',src/'.atena/state/plan-110-integracao-pacotes-lot02-a-lot17.yaml']:
 if p.exists():print('\n',p.name,'\n',p.read_text(encoding='utf-8-sig')[:10000])
for p in (src/'.atena/evidence').glob('*27[45]*'):
 print('\nEVIDENCE',p.name,'\n',p.read_text(encoding='utf-8-sig')[:7500])
for name in ['core/boss_mechanics.gd','core/damage_feedback.gd','ui/interaction_anim.gd','core/hero_ability_vfx.gd']:
 t=(src/name).read_text(encoding='utf-8-sig'); print('CONTRACT',name,t[:4200])
print('GIT LOCAL MARKER',[(str(p),p.is_file(),p.is_dir()) for p in [src/'.git',src.parent/'.git',src.parent.parent/'.git']])
