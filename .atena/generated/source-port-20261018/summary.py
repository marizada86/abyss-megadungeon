import json,sys
from pathlib import Path
sys.stdout.reconfigure(encoding='utf-8')
r=json.loads(Path('.atena/generated/source-port-20261018/audit-r1.json').read_text(encoding='utf-8'))
for k in ['source_head','destination_head','counts','source_tracked_dirty','destination_tracked_dirty']: print(k,r[k])
print('DIFFERENT NON ASSET', '\n'.join(p for p in r['groups']['different'] if not p.startswith('assets/')))
print('SOURCE ONLY DATA', '\n'.join(p for p in r['groups']['source_only'] if p.startswith(('data/','core/','ui/','tests/'))))
print('ASSET GROUPS')
from collections import Counter
for k in r['groups']: print(k,dict(Counter('/'.join(p.split('/')[:2]) for p in r['groups'][k] if p.startswith('assets/'))))
