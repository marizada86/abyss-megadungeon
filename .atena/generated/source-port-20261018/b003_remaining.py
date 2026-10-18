from pathlib import Path
import json,subprocess,sys,difflib
sys.stdout.reconfigure(encoding='utf-8');b=Path('.atena/generated/source-port-20261018/b003');src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');done={r['path']for r in json.loads((b/'write-set-r1.json').read_text(encoding='utf-8'))}
for r in json.loads((b/'preflight.json').read_text(encoding='utf-8')):
 rel=r['path']
 if rel in done or rel.endswith('.uid') or r['before_sha256']==r['source_sha256']:continue
 if r['before_sha256'] is None:print('EXCLUDED_NEW',rel);continue
 p=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True)
 if p.returncode:continue
 old=p.stdout.decode('utf-8-sig').replace('\r\n','\n');up=(src/rel).read_text(encoding='utf-8-sig')
 if up!=old:
  print('\nUNAPPLIED SOURCE CHANGE',rel)
  print('\n'.join(list(difflib.unified_diff(old.splitlines(),up.splitlines(),n=1))[:120]))
