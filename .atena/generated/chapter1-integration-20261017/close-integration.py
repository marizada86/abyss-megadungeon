from pathlib import Path
import json,hashlib,yaml
b=Path('.atena/generated/chapter1-integration-20261017')
tests=b/'s004-validation-20261017-172322-312/results.json'
results=json.loads(tests.read_text(encoding='utf-8-sig')); assert len(results['results'])==16 and all(r['passed'] for r in results['results'])
smoke=b/'s004-validation-20261017-172218-458/smoke-result.json'; s=json.loads(smoke.read_text(encoding='utf-8')); assert not s['failures'] and len(s['captures'])==15
manifest=json.loads((b/'approved-art-admission-r1.json').read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for row in manifest['panels']: assert sha(Path(row['destination']))==row['sha256']
manifest['status']='ADMITTED_PC_R1'; (b/'approved-art-admission-r1.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
paths=[r['path'] for r in json.loads((b/'baseline-r1.json').read_text())['paths']]
paths+=['core/chapter_flow.gd','ui/stage_structures.gd','tests/test_battle.gd','tests/test_playtest.gd','tests/test_data.gd','tests/test_stage_structures.gd']
changed=[]
for name in sorted(set(paths)):
    p=Path(name); before=b/'before'/name
    if p.is_file() and (not before.exists() or sha(p)!=sha(before)):
        changed.append(dict(path=name,sha256=sha(p),before_sha256=sha(before) if before.is_file() else None))
assert len(changed)<=48
report=dict(status='S_C1_004_IMPLEMENTED_DIRECTED_CHECKS_PASS',tests=tests.as_posix(),test_count=16,smoke=smoke.as_posix(),captures=15,art_count=33,changed_paths=changed,text_file_count=len(changed),maps_visuals='PROVISIONAL_GEOMETRY_NOT_FINAL_ART',real_save_access=False,web_changed=False,commits=False,playtest='PENDING_S_C1_006',extended_regression='PENDING_S_C1_005')
(b/'delivery-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
Path('.atena/evidence/EVID-NOTTGARD-CHAPTER1-INTEGRATION-20261017-r1.md').write_text('# S-C1-004 — integração PC implementada\n\nEscopo r1 e coordenação única aprovados em 2026-10-17. Handoff S-MAP-004 encontrado concluído e validado antes de editar. Integração única executada neste plano; S-MAP-005 não declarada concluída automaticamente.\n\n33 PNGs aceitos admitidos com hash em assets/hq/chapter1_r1; HQ01/02 preservadas. Campanha Docas → Reino Abissal → Domwieck, sete HQs principais, HQ14 complementar e direitos legados de arquivo. Progresso/cursor aditivos, fila persistente, dispensa distinta de leitura, pausa preservada, migração antes da equivalência antiga e permissões no início da run. Objetivos sem chefe fictício ou drops; continuar/extrair e encerramento no resultado/menu.\n\nValidação: 16 testes dirigidos PASS (fila/migração, HQs, perfil, resiliência, dados, objetivos, compilação, história/estruturas, escala/terreno/alcance, batalha, QA, playtest e catálogo). Sonda comprovou user_data_dir sintético antes de Godot. Smoke automatizado PASS: abertura/fila, objetivos, retorno, HQ03 e fechamento, zero boss kill por objetivo; 15 capturas incluindo seis HQs em 1280x720/1920x1080, menu e resultado. Inspecionadas capturas de HQ03/HQ14 e resultado; título persistente do capítulo confirmado. Não substitui playtest humano ou matriz ampliada de interrupção/input.\n\nPreservação: dados HQ01/02 semanticamente idênticos; mapas/cenas, terreno/ground e dados de layout dos protótipos iguais ao handoff. Baseline recuperável antes das edições; não houve restore global. '+str(len(changed))+' arquivos de texto/cena/teste na entrega, abaixo de 48; 33 PNGs e metadados importados. Relatório delivery-r1.json documenta paths/hashes. Nenhum save real, Web, dependência, commit ou publicação.\n\nLimites: mapas ainda em geometria provisória; aceitação de acabamento final pendente. Etapas completas 4/6. Próxima S-C1-005: regressão ampliada com interrupção/reabertura em pontos de fila, matriz legada/UI e controle, sem repetir os checks válidos sem motivo. S-C1-006: playtest e aceite humano.\n',encoding='utf-8')
p=Path('.atena/state/plan.yaml'); t=p.read_text(encoding='utf-8')
t=t.replace('S_C1_004_IMPLEMENTATION_IN_PROGRESS','S_C1_004_COMPLETE_S_C1_005_AUTHORIZATION_PENDING',1)
t=t.replace('integration_implementation_authorized: true','integration_implementation_authorized: false\n    integration_implementation_status: COMPLETE_DIRECTED_VALIDATION_PASS\n    integration_delivery: '+(b/'delivery-r1.json').as_posix()+'\n    integration_evidence: EVID-NOTTGARD-CHAPTER1-INTEGRATION-20261017-r1',1)
# Checkpoint belongs only to this chapter plan; no reset of concurrent plan state.
lines=t.splitlines(); inside=False
for i,line in enumerate(lines):
    if line=='  chapter_1_closeout:': inside=True
    elif inside and line and not line.startswith('    '): inside=False
    if inside:
        if line=='    completed_steps: 3': lines[i]='    completed_steps: 4'
        elif line=='    current_step: S-C1-004': lines[i]='    current_step: S-C1-005'
        elif line=='    checkpoint: CP-C1-04': lines[i]='    checkpoint: CP-C1-05'
        elif line.startswith('    next_activity:'): lines[i]="    next_activity: 'Autorizar S-C1-005, matriz ampliada de interrupção, legado e entrada; playtest depois'"
t='\n'.join(lines)+'\n'
# Parent's checkpoint references the same scoped active chapter cursor.
data=yaml.safe_load(t)
if data['all_hq_screenplays'].get('next_checkpoint')=='CP-C1-04':
    t=t.replace('  next_checkpoint: CP-C1-04','  next_checkpoint: CP-C1-05',1)
yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print('PASS delivery:',len(changed),'text files, 33 PNGs, 16 tests, 15 captures; 4/6 steps.')
