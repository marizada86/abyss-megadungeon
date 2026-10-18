from pathlib import Path
import json,hashlib,collections,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();base=root/'.atena/generated/source-port-20261018';rows=json.loads((base/'b001/disposition-matrix.json').read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None;writes={r['path']for batch in ['b002','b003']for r in json.loads((base/batch/'final-write-set.json').read_text(encoding='utf-8'))}
pending=[]
for r in rows:
 if r['comparison'] in ['source_only','different'] and r['disposition']in ['PORT_WITH_DEPENDENCIES_KEEP_CONTENT_STATE','SEMANTIC_INTEGRATION_REQUIRED'] and r['path']not in writes and sha(root/r['path'])!=(r['source']or{}).get('sha256'):
  pending.append({k:r[k]for k in ['path','disposition','integration_batch']})
(base/'b004/remaining-dispositions.json').write_text(json.dumps(pending,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(pending,ensure_ascii=False,indent=2))
print('DEV_REVIEW_ROOTS',dict(collections.Counter(Path(r['path']).parts[0]for r in rows if r['disposition']=='REVIEW_DEV_TOOL_NO_AUTORUN')))
