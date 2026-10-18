from pathlib import Path
import hashlib,json,sys,collections,zipfile,importlib.util
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();out=root/'.atena/generated/source-port-20261018/b001';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
drifts={}
for label,origin in [('source',src),('pc',root)]:
 inv=json.loads((out/(label+'-manifest.json')).read_text(encoding='utf-8'));changed=[]
 for rel,entry in inv.items():
  p=origin/rel
  if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest()!=entry['sha256']:changed.append(rel)
 drifts[label]=changed
 print(label,'files verified',len(inv),'changed',len(changed),flush=True)
matrix=json.loads((out/'disposition-matrix.json').read_text(encoding='utf-8'))
assert len(matrix)==len({r['path'] for r in matrix})
assert all(r['disposition'] and r['integration_batch'] for r in matrix)
feature=json.loads((out/'functional-matrix.json').read_text(encoding='utf-8'));assert len(feature)==12
for label in ['source','pc']:
 with zipfile.ZipFile(out/(label+'-text-baseline.zip')) as z:assert z.testzip() is None
state=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8-sig')
assert state.count('source_port_20261018_proposal:')==1
assert 'suspension_return_cursor: S-V05-001_CP-V05-01_SELECTION_R1_AWAITING_OWNER_APPROVAL' in state
assert 'authorized_batches: [B-PORT-001]' in state
yaml_verified=False
if importlib.util.find_spec('yaml'):
 import yaml
 parsed=yaml.safe_load(state);assert parsed['source_port_20261018_proposal']['mode']=='per-batch';yaml_verified=True
report={'original_tree_drifts':drifts,'runtime_unchanged':not any(drifts.values()),'file_matrix_count':len(matrix),'dispositions':dict(collections.Counter(r['disposition'] for r in matrix)),'comparisons':dict(collections.Counter(r['comparison'] for r in matrix)),'functional_families':12,'text_archives_valid':True,'hq05_cursor_preserved':True,'yaml_parse_verified':yaml_verified}
(out/'integrity-verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
