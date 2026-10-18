from pathlib import Path
import json,collections,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();b=root/'.atena/generated/source-port-20261018/b004';b.mkdir(exist_ok=True)
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8');end=t.index('\nhq20_reference_production_plan:');h=t[:end];tail=t[end:];assert 'status: B003_COMPLETE_AWAITING_B004_APPROVAL' in h
for a,z in [('status: B003_COMPLETE_AWAITING_B004_APPROVAL','status: B004_AUTHORIZED_VALIDATION_IN_PROGRESS'),('approval: APPROVED_OWNER_R1_B001_B002_B003','approval: APPROVED_OWNER_R1_B001_B002_B003_B004'),('authorized_batches: [B-PORT-001, B-PORT-002, B-PORT-003]','authorized_batches: [B-PORT-001, B-PORT-002, B-PORT-003, B-PORT-004]'),('active_batch: null','active_batch: B-PORT-004'),('checkpoint: CP-PORT-006_COMPLETE_B004_APPROVAL_REQUIRED','checkpoint: CP-PORT-007_IN_PROGRESS'),('current_step: S-PORT-006','current_step: S-PORT-007'),('b004_approval: PENDING_OWNER_PER_BATCH','b004_approval: APPROVED_OWNER_VALIDATION_AND_HUMAN_PREPARATION')]:assert a in h;h=h.replace(a,z,1)
h+='\n  b004_authorization: \'Atena, aprovado o lote 4. Pode executar a validação final e preparar a avaliação humana, preservando DRAFT e as retenções pendentes. Depois retornamos à HQ05. (2026-10-18)\'\n'
p.write_text(h+tail,encoding='utf-8');assert p.read_text(encoding='utf-8').endswith(tail)
rows=json.loads((root/'.atena/generated/source-port-20261018/b001/disposition-matrix.json').read_text(encoding='utf-8'));print('Matrix fields',list(rows[0]));print('Comparisons',dict(collections.Counter(r['comparison'] for r in rows)))
for key in rows[0]:
 if key not in ['path','source','pc','comparison']:print(key,dict(collections.Counter(str(r.get(key)) for r in rows)))
