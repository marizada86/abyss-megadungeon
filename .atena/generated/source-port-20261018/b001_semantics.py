from pathlib import Path
import sys,json,re,configparser,collections,hashlib
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');out=root/'.atena/generated/source-port-20261018/b001'
config=configparser.RawConfigParser(strict=False)
try:
 config.read(src/'.git/config',encoding='utf-8')
 info={k:config.get('core',k,fallback=None) for k in ['bare','worktree','repositoryformatversion']}
except Exception as e:info={'read_error':str(e)}
head=(src/'.git/HEAD').read_text().strip();info['HEAD_file']=head
if head.startswith('ref: '):
 ref=src/'.git'/head[5:]; info['resolved_loose_head']=ref.read_text().strip() if ref.exists() else 'packed ref'
(out/'git-source-readonly.json').write_text(json.dumps(info,indent=2),encoding='utf-8');print('GIT',info)
manifests={k:json.loads((out/(k+'-manifest.json')).read_text(encoding='utf-8')) for k in ['source','pc']}
matrix=json.loads((out/'disposition-matrix.json').read_text(encoding='utf-8'))
# Optional dev-tool ADD files were not retained in the final isolated snapshots.
matrix=[r for r in matrix if not r['path'].startswith('.atena/') or r['path'] in manifests['source'] or r['path'] in manifests['pc']]
for row in matrix:
 p=row['path'];row['integration_batch']='B-PORT-002' if p.startswith('assets/') or p in ['ui/hero_view.gd','ui/interaction_anim.gd'] else 'B-PORT-003' if p.startswith(('core/','data/','ui/')) else 'B-PORT-004'
 if row['disposition']=='SEMANTIC_INTEGRATION_REQUIRED':
  row['review_gate']='Compare source addition with PC acceptance contract; no full-file replacement'
 if p.startswith('assets/hq/') and row['comparison']!='identical':row['disposition']='PRESERVE_PC_APPROVED_HQ_REVIEW_HASH_AND_COMPOSITION'
 if p.startswith('.atena/'):row['disposition']='TEST_CONTRACT_INPUT_NON_RUNTIME'
(out/'disposition-matrix.json').write_text(json.dumps(matrix,ensure_ascii=False,indent=2),encoding='utf-8')
conflicts=[]
for row in matrix:
 if row['comparison']!='different':continue
 p=row['path'];rec={'path':p,'disposition':row['disposition'],'batch':row['integration_batch']}
 if p.endswith('.gd'):
  a=(src/p).read_text(encoding='utf-8-sig');b=(root/p).read_text(encoding='utf-8-sig')
  funcs=lambda t:set(re.findall(r'(?m)^(?:static )?func\s+(\w+)',t))
  rec.update(source_only_functions=sorted(funcs(a)-funcs(b)),pc_only_functions=sorted(funcs(b)-funcs(a)))
 elif p.endswith('.json'):
  a=json.loads((src/p).read_text(encoding='utf-8-sig'));b=json.loads((root/p).read_text(encoding='utf-8-sig'))
  if isinstance(a,dict) and isinstance(b,dict):
   rec.update(source_only_keys=sorted(a.keys()-b.keys()),pc_only_keys=sorted(b.keys()-a.keys()),changed_keys=[k for k in a.keys()&b.keys() if a[k]!=b[k]])
 conflicts.append(rec)
(out/'conflict-index.json').write_text(json.dumps(conflicts,ensure_ascii=False,indent=2),encoding='utf-8')
print('COUNTS',dict(collections.Counter(r['comparison'] for r in matrix)))
print('CONFLICTS',json.dumps([r for r in conflicts if r['path'].startswith(('core/','data/'))],ensure_ascii=False,indent=2)[:14000])
print('DIFFERENT ASSETS','\n'.join(r['path'] for r in conflicts if r['path'].startswith('assets/')))
print('JSON UI refs',json.dumps({name:json.loads((src/name).read_text(encoding='utf-8-sig')) for name in ['data/cursor.json','data/lettering.json']},ensure_ascii=False)[:3000])
