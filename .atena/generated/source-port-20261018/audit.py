from pathlib import Path
import hashlib,json,subprocess,collections,sys
sys.stdout.reconfigure(encoding='utf-8')
dst=Path.cwd(); src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
def git(root,*args):
 p=subprocess.run(['rtk','proxy','git',*args],cwd=root,text=True,encoding='utf-8',errors='replace',stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=40)
 return p.stdout.strip() if p.returncode==0 else 'UNAVAILABLE: '+p.stderr.strip()[:700]
skip={'.git','.godot','.atena','atena','tmp','build','builds','dist','.vscode','.idea','node_modules'}
def files(root):
 import os
 out={}
 for base,dirs,names in os.walk(root):
  dirs[:]=[d for d in dirs if d not in skip and (Path(base)!=root or d in {'assets','core','data','ui','tools','tests'})]
  for name in names:
   p=Path(base)/name; rel=p.relative_to(root).as_posix()
   out[rel]=hashlib.sha256(p.read_bytes()).hexdigest()
 return out
a=files(src); b=files(dst)
groups={k:[] for k in ['source_only','different','destination_only','identical']}
for p in sorted(a.keys()|b.keys()):
 k='destination_only' if p not in a else 'source_only' if p not in b else 'identical' if a[p]==b[p] else 'different'
 groups[k].append(p)
report={'source':str(src),'destination':str(dst),'source_head':git(src,'rev-parse','HEAD'),'destination_head':git(dst,'rev-parse','HEAD'),'scope':'local working tree; excludes infrastructure/cache/build directories; includes .import and .uid','counts':{k:len(v) for k,v in groups.items()},'groups':groups,'source_tracked_dirty':git(src,'status','--short','--untracked-files=no'),'destination_tracked_dirty':git(dst,'status','--short','--untracked-files=no'),'source_commits_since_bootstrap':git(src,'log','--oneline','b83f188a6dae9d32f78420a318bffedcac4ff4a3..HEAD')}
(dst/'.atena/generated/source-port-20261018/audit-r1.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps({k:v for k,v in report.items() if k not in ['groups','source_commits_since_bootstrap']},indent=2,ensure_ascii=False))
for k in ['different','source_only','destination_only']:
 print(k,dict(collections.Counter(p.split('/')[0] for p in groups[k])))
 print('\n'.join(p for p in groups[k] if not p.startswith('assets/'))[:11000])
print('RECENT SOURCE COMMITS\n'+report['source_commits_since_bootstrap'][:13000])
