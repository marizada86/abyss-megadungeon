from pathlib import Path
import json,hashlib,re,sys,subprocess
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();base=root/'.atena/generated/source-port-20261018';out=base/'publication';paths=set(json.loads((out/'selected-paths.json').read_text(encoding='utf-8')))
paths.update(json.loads((base/'b001/pc-snapshot-scope.json').read_text(encoding='utf-8'))['retained_add_inputs'])
paths.add('.atena/evidence/EVID-NOTTGARD-SOURCE-PORT-PUBLISH-20261018-r1.md');paths.add('.atena/generated/source-port-20261018/publication-stage.py')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8');end=t.index('\nhq20_reference_production_plan:');h=t[:end];tail=t[end:]
assert 'publication_authorization:'not in h
h+='\n  publication_authorization: \'Atena, vamos só comparr com o projeto antigo pra vewr se deu tudo certo. Depois commit e push (2026-10-18)\'\n  publication_comparison: VERIFIED_NO_SOURCE_OR_DELIVERY_DRIFT\n  publication_evidence: .atena/evidence/EVID-NOTTGARD-SOURCE-PORT-PUBLISH-20261018-r1.md\n  publication_result_receipt: .atena/generated/source-port-20261018/publication/result.json\n  publication_content_gates: DRAFT_RETAINED_HUMAN_ACCEPTANCE_PENDING\n'
p.write_text(h+tail,encoding='utf-8');assert p.read_text(encoding='utf-8').endswith(tail)
bad=[];total=0;manifest=[]
for rel in sorted(paths):
 p=root/rel;assert p.is_file(),rel;data=p.read_bytes();total+=len(data)
 assert not any(part in rel.split('/')for part in ['before','import-before','sessions','a','l','appdata','localappdata']),rel
 assert len(data)<90*1024*1024,rel
 if p.suffix in ['.json','.py','.gd','.md','.yaml','.tres','.tscn','.cfg']:
  text=data.decode('utf-8-sig')
  if re.search(r'(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|sk-proj-[A-Za-z0-9_-]{35,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----)',text):bad.append(rel)
 manifest.append({'path':rel,'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)})
assert not bad,'Potential sensitive literals in '+str(bad)
(out/'commit-input-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8');(out/'stage-paths.nul').write_bytes(b'\0'.join(r['path'].encode('utf-8')for r in manifest)+b'\0')
print('READY',len(paths),'paths;',round(total/1048576,2),'MiB; no high-confidence secret literal found; synthetic sessions/backups excluded')
