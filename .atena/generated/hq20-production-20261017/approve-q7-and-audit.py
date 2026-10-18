from pathlib import Path
import json,hashlib,re,yaml
from PIL import Image,ImageDraw
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
p=base/'q7-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ20-Q7-20261017-r1.md'
assert not (r/approval).exists()
(r/approval).write_text(f'''# HQ20 Q7 — aceite v01

CANON_OWNER_ASSET_APPROVAL. 2026-10-17. O dono respondeu “aprovado” à Q7 v01. Arquivo `{record['candidate']}`, SHA-256 `{record['sha256']}`, 1672×941. Aprovado reencontro de Maelor com sua mãe Marciela no lado abissal, aparência conforme referências aprovadas, sem Aila. Sete de sete quadros com aceites individuais. Sem integração no runtime.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite Q7 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
sources=['q1-owner-acceptance-v03.json','q2-v02-production-r1.json','q3-v02-production-r1.json','q4-owner-acceptance-v01.json','q5-production-r1.json','q6-production-r1.json','q7-production-r1.json']
sheet=Image.new('RGB',(1500,939),'#11151d'); draw=ImageDraw.Draw(sheet); entries=[]
for n,name in enumerate(sources,1):
    item=json.loads((base/name).read_text(encoding='utf-8'))
    assert item['status'].startswith('APPROVED'),(n,item['status'])
    path=r/item['candidate']; sha=hashlib.sha256(path.read_bytes()).hexdigest(); assert sha==item['sha256'],n
    canon=item.get('approval_canon',item.get('canon')); assert (r/canon).is_file()
    with Image.open(path) as im: dimensions=im.size; im.verify()
    assert abs(dimensions[0]/dimensions[1]-16/9)<0.003,n
    with Image.open(path) as im:
        thumb=im.convert('RGB'); thumb.thumbnail((490,276))
    x=((n-1)%3)*500+5; y=((n-1)//3)*313
    draw.text((x,y+5),f'Q{n:02d}',fill='white'); sheet.paste(thumb,(x,y+27))
    entries.append(dict(panel=n,candidate=item['candidate'],sha256=sha,dimensions=list(dimensions),approval=canon,record=name))
preview='.atena/generated/hq20-production-20261017/hq20-approved-sequence-r1.jpg'; sheet.save(r/preview,quality=92)
manifest='.atena/generated/hq20-production-20261017/approved-sequence-r1.json'
(r/manifest).write_text(json.dumps(dict(status='SEVEN_INDIVIDUAL_APPROVALS_FILES_VERIFIED',screenplay='.atena/vault/canon/HQ20-SCREENPLAY-APPROVED-20261017-r1.md',approved_panels=7,total_panels=7,panels=entries,preview=preview,visual_sequence_inspection='PENDING',runtime_admitted=False),ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; match=re.search(pattern,t); assert match
block=match.group()
for old,new in [('status: Q7_CANDIDATE_V01_AWAITING_OWNER_APPROVAL','status: SEVEN_INDIVIDUAL_APPROVALS_FILES_VERIFIED'),('completed_steps: 4','completed_steps: 5'),('q7_approval: PENDING_V01',"q7_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('next_activity: Aceite Q7; depois conferir sequência completa da HQ20','next_activity: Conferir visualmente sequência completa HQ20; 7/7 aceitas')]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'  q7_asset_approval: {approval}\n  approved_visual_panels: 7\n  total_visual_panels: 7\n  sequence_manifest: {manifest}\n  sequence_preview: {preview}\n'
t=t[:match.start()]+block+t[match.end():]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ20-Q7-CANDIDATE-20261017-v01.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite\n\nQ7 aprovada: “aprovado”. Hash conferido, aceite canônico registrado. Sete quadros aceitos e arquivos/hashes/PNGs/proporções/registros de aceite conferidos. Q4 mantém dimensão original 1672×940 aprovada, demais 1672×941. Sem integração.\n')
print('PASS: Q7 aprovada; 7/7 PNGs, hashes, proporções e aceites conferidos; prancha pronta.')
