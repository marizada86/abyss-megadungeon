from pathlib import Path
import json,hashlib,shutil,yaml
b=Path('.atena/generated/chapter1-integration-20261017')
paths=json.loads((b/'baseline-r1.json').read_text())['paths']
for row in paths:
    p=Path(row['path'])
    if p.is_file():
        backup=b/'before'/p; backup.parent.mkdir(parents=True,exist_ok=True)
        assert not backup.exists(); shutil.copy2(p,backup)
legacy_stages=json.loads(Path('data/stages.json').read_text())
legacy_hqs=json.loads(Path('data/hqs.json').read_text(encoding='utf-8'))
flow=json.loads(Path('.atena/specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-flow-contract-r1.json').read_text())
flow['legacy_stages']=legacy_stages
flow['legacy_hqs']={k:{x:v for x,v in h.items() if x in ['achievement','trigger']} for k,h in legacy_hqs.items()}
flow['status']='APPROVED_IMPLEMENTATION_R1'; flow['implementation_authorized']=True
Path('data/chapter_flow.json').write_text(json.dumps(flow,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
art=json.loads((b/'approved-art-admission-r1.json').read_text(encoding='utf-8'))
titles={'hqn_15':'O Homem na Névoa','hqn_16':'A Igreja das Sombras','hqn_17':'A Descida','hqn_18':'O Exército Atravessa'}
hqs=legacy_hqs
for h in titles: hqs[h]={'title':titles[h],'panels':[]}
for h in ['hqn_03','hqn_14']: hqs[h]['panels']=[]
for r in art['panels']:
    src=Path(r['source']); dst=Path(r['destination']); assert hashlib.sha256(src.read_bytes()).hexdigest()==r['sha256']
    dst.parent.mkdir(parents=True,exist_ok=True); assert not dst.exists(); shutil.copy2(src,dst)
    text=r['caption']
    if r['text_role'] in ['helion_dialogue','helion_voice']: text='Helion: '+text
    hqs[r['hq']]['panels'].append({'image':'res://'+dst.as_posix(),'text':text})
for event in flow['events']:
    for h in event.get('queue',[]):
        if h not in ['hqn_01','hqn_02']: hqs[h]['trigger']={'type':event['event'],'stage':event['stage']}
Path('data/hqs.json').write_text(json.dumps(hqs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
stages=legacy_stages
protos=json.loads(Path('data/prototype_stages.json').read_text())
for h in ['reino_abissal','domwieck']:
    stages[h]=protos[h].copy(); stages[h].pop('qa_only',None)
    stages[h]['sub']= 'Primeira incursão · geometria provisória' if h=='reino_abissal' else 'Invasão · geometria provisória'
    stages[h]['order']=flow['stage_definitions'][h]['campaign_order']; stages[h]['next']=flow['stage_definitions'][h]['next']
stages['docas']['order']=0; stages['docas']['unlock']='start'; stages['docas']['next']='reino_abissal'
for i,h in enumerate(['dagruve','shedaklah','molor','durao','feng_tu','shendilavri','goranthis','pilares']): stages[h]['order']=i+3
Path('data/stages.json').write_text(json.dumps(stages,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=Path('.atena/state/plan.yaml'); t=p.read_text(encoding='utf-8')
t=t.replace('integration_implementation_authorized: false',"integration_implementation_authorized: true\n    integration_authorization: 'aprovado (2026-10-17), escopo r1 e coordenação única'",1)
t=t.replace('S_C1_004_PREFLIGHT_COMPLETE_APPROVAL_AND_MAP_HANDOFF_PENDING','S_C1_004_IMPLEMENTATION_IN_PROGRESS')
t=t.replace('integration_maps_handoff: PENDING_S_MAP_004_AND_EXECUTION_OWNER_RECONCILIATION','integration_maps_handoff: S_MAP_004_COMPLETE_VALIDATED_SINGLE_EXECUTOR_S_C1_004')
yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print('Admitidas 33 artes; catálogo e mapas; baseline before preservada.')
