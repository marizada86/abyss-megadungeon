from pathlib import Path
import json,sys,subprocess,difflib
sys.stdout.reconfigure(encoding='utf-8');b=Path('.atena/generated/source-port-20261018/b003');src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
for r in json.loads((b/'preflight.json').read_text()):
 if not r['path'].startswith('tests/') and r['before_sha256']!=r['source_sha256']: print(r['path'], 'NEW' if r['before_sha256']==None else 'CHANGE')
for rel in ['data/abilities.json','data/weapons.json','data/enemies.json','data/difficulty.json','core/boss_mechanics.gd','core/data.gd','ui/pause_menu.gd','ui/ability_slot.gd','ui/controller_options.gd','core/controller_input.gd']:
 p=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True)
 if p.returncode==0:
  base=p.stdout.decode('utf-8-sig').splitlines();up=(src/rel).read_text(encoding='utf-8-sig').splitlines()
  print('\nSOURCE CHANGE',rel);print('\n'.join(difflib.unified_diff(base,up,n=2)))
