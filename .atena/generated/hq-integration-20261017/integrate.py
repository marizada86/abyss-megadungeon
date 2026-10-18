from pathlib import Path
import json,hashlib,shutil,re,yaml
r=Path.cwd(); output=r/'.atena/generated/hq-integration-20261017'
output.mkdir(parents=True,exist_ok=True)
hqs_path=r/'data/hqs.json'; hqs=json.loads(hqs_path.read_text(encoding='utf-8'))
assert 'hqn_19' not in hqs and 'hqn_20' not in hqs
(output/'hqs-before.json').write_bytes(hqs_path.read_bytes())
admissions=[]
for number,title,count,screenplay in [(19,'A Ordem de Thalion',12,'HQ19-SCREENPLAY-APPROVED-20261017-r2.md'),(20,'Entre Raízes',7,'HQ20-SCREENPLAY-APPROVED-20261017-r1.md')]:
    source_manifest=r/f'.atena/generated/hq{number}-production-20261017/approved-sequence-r1.json'
    manifest=json.loads(source_manifest.read_text(encoding='utf-8')); assert manifest['status']=='COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED'
    script=r/'.atena/vault/canon'/screenplay
    rows=[line.split('|') for line in script.read_text(encoding='utf-8').splitlines() if re.match(r'^\|\s*\d+\s*\|',line)]
    assert len(rows)==count
    panels=[]
    for row,entry in zip(rows,manifest['panels']):
        n=int(row[1].strip()); assert entry['panel']==n
        src=r/entry['candidate']; digest=hashlib.sha256(src.read_bytes()).hexdigest(); assert digest==entry['sha256']
        assert (r/entry['approval']).is_file()
        dst=r/'assets/hq/chapter2_r1'/src.name; dst.parent.mkdir(parents=True,exist_ok=True); assert not dst.exists()
        shutil.copy2(src,dst); assert hashlib.sha256(dst.read_bytes()).hexdigest()==digest
        raw=row[3].strip()
        caption=re.sub(r'^Narração:\s*','',raw).replace('“','').replace('”','')
        assert caption
        panels.append(dict(image='res://'+dst.relative_to(r).as_posix(),text=caption))
        admissions.append(dict(hq=f'hqn_{number}',panel=n,source=entry['candidate'],target=dst.relative_to(r).as_posix(),sha256=digest,approval=entry['approval']))
    hqs[f'hqn_{number}']=dict(title=title,chapter=2,trigger=dict(type='chapter2_content',milestone='dagruve_resolution' if number==19 else 'yggdrasil_traversed'),panels=panels)
    if number==19: hqs[f'hqn_{number}']['presentation_segments']=[dict(id='before_dagruve',first_panel=0,panel_count=4),dict(id='after_dagruve',first_panel=4,panel_count=8)]
hqs_path.write_text(json.dumps(hqs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(output/'admission-r1.json').write_text(json.dumps(dict(platform='windows-x86_64',authorization='integrar tudo, commit e push (2026-10-17)',entries=admissions,automated_chapter2_triggers=False,qa_reader_available=True,portage='PC-specific approved content; no Web synchronization'),ensure_ascii=False,indent=2),encoding='utf-8')
p=r/'.atena/state/plan.yaml'; text=p.read_text(encoding='utf-8'); assert 'hq19_hq20_integration_plan:' not in text
text+='\nhq19_hq20_integration_plan:\n  id: PLAN-NOTTGARD-HQ19-HQ20-INTEGRATION-20261017\n  revision: r1\n  mode: per-step\n  status: LOCAL_ADMISSION_VALIDATION_PENDING\n  current_step: S-I20-002\n  ordered_steps: [S-I20-001, S-I20-002, S-I20-003]\n  completed_steps: 1\n  total_steps: 3\n  authorization: integrar tudo, commit e push (2026-10-17)\n  spec: .atena/specs/SPEC-NOTTGARD-HQ19-HQ20-INTEGRATION-20261017/spec.md\n  admission: .atena/generated/hq-integration-20261017/admission-r1.json\n  automatic_chapter2_triggers: false\n  commit_authorized: true\n  push_authorized: true\n  next_activity: Validar HQs e consolidar alterações locais\n'
yaml.safe_load(text); p.write_text(text,encoding='utf-8')
print('PASS: 19 PNGs aprovados admitidos; HQ19/20 e legendas CANON adicionadas, segmentos preservados.')
