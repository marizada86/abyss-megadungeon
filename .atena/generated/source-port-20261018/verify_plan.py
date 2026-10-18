from pathlib import Path
import json,re,sys
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd()
spec=root/'.atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018/plan-r1.md'
state=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8-sig')
text=spec.read_text(encoding='utf-8')
audit=json.loads((root/'.atena/generated/source-port-20261018/audit-r1.json').read_text(encoding='utf-8'))
assert all(len(audit['groups'][k])==n for k,n in audit['counts'].items())
assert all(f'S-PORT-{n:03}' in text for n in range(1,9))
assert state.count('source_port_20261018_proposal:')==1
for p in ['.atena/add.yaml','.atena/state/plan.yaml','.atena/evidence/EVID-NOTTGARD-SOURCE-PORT-PLAN-20261018-r1.md','.atena/generated/source-port-20261018/audit-r1.json']:
 assert (root/p).is_file(),p
print('PASS: plan references, 8 step IDs, unique state entry and original audit counts.')
