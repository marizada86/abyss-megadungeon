from pathlib import Path
import json,hashlib,yaml
b=Path('.atena/generated/chapter1-integration-20261017')
p=Path('.atena/state/plan.yaml'); t=p.read_text(encoding='utf-8'); data=yaml.safe_load(t); c=data['all_hq_screenplays']['chapter_1_closeout']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
panels=[]
for h in ['15','16','17','18','03','14']:
    manifest=Path(c[f'hq{h}_sequence']); m=json.loads(manifest.read_text(encoding='utf-8')); assert m['status']=='APPROVED_BY_OWNER_R1'
    for row in m['panels']:
        asset=Path(row['path']); assert sha(asset)==row['sha256']; assert Path(row['individual_approval']).exists()
        panels.append(dict(hq=m['hq'],panel=row['panel'],source=asset.as_posix(),destination=f"assets/hq/chapter1_r1/{asset.name}",sha256=row['sha256'],caption=row['caption'],text_role=row.get('text_role','narration')))
assert len(panels)==33
(b/'approved-art-admission-r1.json').write_text(json.dumps(dict(status='PREPARED_NOT_ADMITTED',panels=panels),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
paths=['data/hqs.json','data/chapter_flow.json','data/stages.json','data/prototype_stages.json','core/data.gd','core/hq_catalog.gd','core/profile.gd','core/game.gd','core/battle.gd','ui/run.gd','ui/menu.gd','ui/hq_screen.gd','ui/hq_screen.tscn','ui/hud.gd','ui/stage_progress.gd','core/terrain_layout.gd','ui/ground.gd','ui/stages/reino_abissal.tscn','ui/stages/domwieck.tscn','data/stage_story.json','data/stage_events.json','data/stage_rules.json','data/stage_structures.json','data/level_design.json','data/scenery.json','data/prop_visuals.json','tests/test_hqs.gd','tests/test_profile.gd','tests/test_chapter_flow.gd','tests/test_map_objectives.gd','tests/test_qa_sandbox.gd','core/playtest.gd','tools/playtest_interop.gd']
baseline=[dict(path=s,exists=Path(s).exists(),sha256=sha(Path(s)) if Path(s).is_file() else None) for s in paths]
(b/'baseline-r1.json').write_text(json.dumps(dict(status='READ_ONLY_INFORMATIONAL_RECAPTURE_BEFORE_WRITING',paths=baseline,concurrent_maps_state=data.get('missing_maps_proposal',{})),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec=Path('.atena/specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-integration-preflight-r1.md')
k='    status: S_C1_003_COMPLETE_S_C1_004_AUTHORIZATION_PENDING'; assert k in t
t=t.replace(k,'    status: S_C1_004_PREFLIGHT_COMPLETE_APPROVAL_AND_MAP_HANDOFF_PENDING',1)
key='    current_step: S-C1-004'; assert key in t
t=t.replace(key,key+'\n    integration_preparation_authorization: autorizado (2026-10-17), preparação somente\n    integration_preflight: '+spec.as_posix()+'\n    integration_baseline: '+(b/'baseline-r1.json').as_posix()+'\n    integration_art_manifest: '+(b/'approved-art-admission-r1.json').as_posix()+'\n    integration_implementation_authorized: false\n    integration_maps_handoff: PENDING_S_MAP_004_AND_EXECUTION_OWNER_RECONCILIATION',1)
lines=t.splitlines(); inside=False
for i,line in enumerate(lines):
    if line=='  chapter_1_closeout:': inside=True
    elif inside and line and not line.startswith('    '): inside=False
    if inside and line.startswith('    next_activity:'):
        lines[i]="    next_activity: 'Aprovar integração r1 e coordenação única com mapas; aguardar handoff para caminhos compartilhados'"
t='\n'.join(lines)+'\n'; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
Path('.atena/evidence/EVID-NOTTGARD-CHAPTER1-INTEGRATION-PREFLIGHT-20261017.md').write_text('# S-C1-004 — preparação concluída\n\nPedido autorizado restringe-se à preparação. Contrato aceito e runtime local conferidos. 33 artes e seis sequências aprovadas verificadas por hash/registro; manifesto de admissão preparado sem copiar a assets. Baseline informativa de 33 caminhos candidatos, recapturar antes de escrita.\n\nObservados objetivos QA já implementados, catálogo de protótipos e S-MAP-004 em progresso; não sobrepor execução de mapas. Integração requer fila persistente, migração/permissões e encerramento além de artes. Ficha r1 delimita responsabilidades, aceitação, checks sintéticos e gates. JSON/YAML PASS; nenhum Godot, save real, runtime, Web ou processo remoto executado.\n\nPróximo CP-C1-04: aprovação de escopo/coordenação; handoff estável dos mapas requerido antes de editar caminhos comuns. Geometria provisória não é acabamento final aceito.\n',encoding='utf-8')
print('PASS: 33 artes aprovadas; baseline de 33 caminhos; escopo/checks preparados; implementação não autorizada.')
