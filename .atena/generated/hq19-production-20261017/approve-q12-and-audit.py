from pathlib import Path
import json,hashlib,yaml
from PIL import Image,ImageDraw
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q12-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q12-20261017-r1.md'
assert not (r/approval).exists()
(r/approval).write_text(f'''# HQ19 Q12 — aceite individual v01

CANON_OWNER_ASSET_APPROVAL. 2026-10-17. O dono respondeu “aprovado” à Q12 v01. S-P19-Q12 concluída. Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovado portal fechando, Maelor ausente e Aila sem asas sob custódia de Thalion vivo. Doze de 12 quadros com aceites individuais. Sem admissão no runtime ou publicação.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q12 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
entries=[]; sheet=Image.new('RGB',(1500,1252),'#11151d'); draw=ImageDraw.Draw(sheet)
for n in range(1,13):
    row=json.loads((base/f'q{n}-production-r1.json').read_text(encoding='utf-8'))
    assert row['status']=='APPROVED_V01',n
    imagepath=r/row['candidate']; digest=hashlib.sha256(imagepath.read_bytes()).hexdigest()
    assert digest==row['sha256'],n
    assert (r/row['approval_canon']).is_file(),n
    assert (base/row['tool_prompt']).is_file(),n
    with Image.open(imagepath) as im:
        dimensions=im.size; im.verify()
    assert dimensions==(1672,941),n
    with Image.open(imagepath) as im:
        thumb=im.convert('RGB'); thumb.thumbnail((490,276))
    x=((n-1)%3)*500+5; y=((n-1)//3)*313
    draw.text((x,y+5),f'Q{n:02d} | '+('ANTES DE DAGRUVE' if n<=4 else 'APOS DAGRUVE'),fill='white')
    sheet.paste(thumb,(x,y+27))
    entries.append(dict(panel=n,segment='before_dagruve' if n<=4 else 'after_dagruve',candidate=row['candidate'],sha256=digest,dimensions=list(dimensions),approval=row['approval_canon'],runtime_admitted=row.get('runtime_admitted',False)))
sheet.save(base/'hq19-approved-sequence-r1.jpg',quality=92)
manifest=dict(status='TWELVE_INDIVIDUAL_APPROVALS_FILES_VERIFIED',screenplay='.atena/vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r2.md',panels=entries,approved_panels=12,total_panels=12,sequence_preview='.atena/generated/hq19-production-20261017/hq19-approved-sequence-r1.jpg',runtime_authorized=False,visual_sequence_inspection='PENDING')
(base/'approved-sequence-r1.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
for old,new in [('q12_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q12_production_status: APPROVED_V01'),('q12_approval: PENDING_V01',"q12_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 11','approved_visual_panels: 12'),("next_activity: 'Aceite individual HQ19 Q12 v01; depois conferir sequência completa'","next_activity: 'Conferência final visual HQ19; 12/12 com aceites individuais'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q12_asset_approval: {approval}\n    visual_production_status: TWELVE_INDIVIDUAL_APPROVALS_FILES_VERIFIED\n    approved_sequence_manifest: .atena/generated/hq19-production-20261017/approved-sequence-r1.json\n    approved_sequence_preview: .atena/generated/hq19-production-20261017/hq19-approved-sequence-r1.jpg\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q12-CANDIDATE-20261017-r1.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nQ12 aprovada: “aprovado”. Hash reconferido; aceite canônico registrado. Doze de 12 aceitas. Manifesto da sequência verifica 12 arquivos, hashes, dimensões, prompts e registros de aprovação. Sem integração.\n')
print('PASS: Q12 aprovada; 12/12 PNGs, hashes, dimensões, prompts e aceites conferidos. Prancha pronta para inspeção.')
