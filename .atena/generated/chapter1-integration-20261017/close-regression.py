from pathlib import Path
import hashlib, json, re

root=Path.cwd()
base=root/'.atena/generated/chapter1-integration-20261017'
session=max(base.glob('s004-validation-*'))
writer=json.loads((session/'regression-writer.json').read_text(encoding='utf-8-sig'))
reader=json.loads((session/'regression-reader.json').read_text(encoding='utf-8-sig'))
assert not writer['failures'] and not reader['failures']
assert writer['fixtures']==reader['fixtures']==46
assert reader['input_checks']==21 and reader['pause_checks']==4 and reader['diary_checks']==2
baseline=json.loads((base/'regression-baseline-r1.json').read_text(encoding='utf-8'))
current={p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in baseline}
assert current==baseline, 'runtime changed since validated integration'
session_rel=session.relative_to(root).as_posix()
report={
 'status':'PASS','step':'S-C1-005','revision':'r1','session':session_rel,
 'persisted_panels':46,'distinct_godot_processes':2,'legacy_cases':7,
 'input_checks':21,'pause_presenter_combinations':4,'diary_openings':2,
 'runtime_changes':0,'runtime_hashes':current,
 'reused_integration_tests':'.atena/generated/chapter1-integration-20261017/s004-validation-20261017-172322-312/results.json',
 'reused_render_smoke':'.atena/generated/chapter1-integration-20261017/s004-validation-20261017-172218-458/smoke-result.json',
 'limits':['synthetic input events; physical controller pending','full-run resume unsupported by approved contract','new maps use provisional geometry','human difficulty/readability/feel acceptance pending'],
 'next_step':'S-C1-006','next_checkpoint':'CP-C1-06','next_authorization':'PENDING'
}
(base/'regression-delivery-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
evidence=root/'.atena/evidence/EVID-NOTTGARD-CHAPTER1-REGRESSION-20261017-r1.md'
evidence.write_text(f'''# S-C1-005 — regressão ampliada / r1

Resultado: PASS. Autorização: “autorizado”, 2026-10-17, em resposta à etapa de regressão ampliada. Plano PLAN-NOTTGARD-CHAPTER1-CLOSEOUT-20261016 r1, modo per-step. Classificação IN_PLAN. Cinco etapas concluídas de seis; S-C1-006 aguarda CP-C1-06.

Sessão: `{session_rel}`. Relatório: `../generated/chapter1-integration-20261017/regression-delivery-r1.json`. Sonda confirmou user_data_dir sob APPDATA exclusivo antes de executar o projeto; perfil sintético explícito. Nenhum save real foi lido.

Dois processos Godot distintos: o primeiro gravou 46 perfis intermediários pelo Game.save atômico e copiou os arquivos resultantes. O segundo recarregou todos os quadros das oito HQs, conferiu a imagem correspondente, cursor, fila seguinte, dispensa sem leitura/recompensa e conclusão/repetição sem recompensa duplicada. A inicialização normal de Game também recuperou o último perfil gravado pelo primeiro processo.

Sete perfis legados: moedas; run/morte; antiga Dagruve concluída; Docas concluída/Shedaklah alcançada; fases avançadas concluídas; conquistas/HQ histórica; melhorias/códex/configuração. Conferidos acessos herdados mais Docas inicial, preservação dos campos, nenhuma nova fila ou conclusão fictícia de Domwieck, arquivos históricos HQ11/12/13 e migração idempotente após JSON.

Entrada: 21 verificações com eventos sintéticos, incluindo Enter/Espaço/Enter numérico, eco e soltura ignorados, Esc, controle padrão/legado, botão mantido/solto, mouse, perda de foco e notas F5. Quatro combinações do apresentador real de run: pausa anterior ligada/desligada × completar/dispensar; restauram a pausa anterior e persistem a resolução correta. Duas aberturas pelo Diário real: retomar HQ14 no quadro salvo e reler desde o início, sem prêmio duplicado.

Primeiras execuções preservadas: uma expectativa de teste esquecia que Docas é acesso inicial na nova rota; outra comparava estritamente inteiros em memória com floats retornados pelo JSON. Diagnóstico dos sete pares serializados confirmou igualdade de dados. As expectativas foram corrigidas na matriz, sem alteração de código de produção. Também foi corrigida uma tipagem na extensão do teste de Diário e acrescentado tempo de encerramento para os recursos pendentes da cena. A execução final com diagnóstico detalhado passou sem falhas, erros de script ou avisos de recursos no encerramento.

Reutilizados os 16 testes aprovados da integração e suas 15 capturas (1280×720/1920×1080). Hashes do runtime pertinente permanecem iguais ao início de S-C1-005. Nenhuma alteração de motor, dependência, arte ou regra canônica nesta etapa.

Limites: eventos simulados não substituem controle físico. Retomada integral de combate continua fora do contrato. Cenários dos dois mapas têm geometria provisória. Ritmo, legibilidade percebida, dificuldade e diversão dependem do dono. Próximo: proposta operacional `../specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-playtest-r1.md`; execução não autorizada por S-C1-005.
''',encoding='utf-8')
state=root/'.atena/state/plan.yaml'
text=state.read_text(encoding='utf-8')
start=text.index('  chapter_1_closeout:\n')
match=re.search(r'^  [a-zA-Z_][\w]*:\s*$',text[start+len('  chapter_1_closeout:\n'):],re.M)
end=start+len('  chapter_1_closeout:\n')+match.start() if match else len(text)
block=text[start:end]
for old,new in [
 ('    status: S_C1_005_REGRESSION_IN_PROGRESS','    status: S_C1_005_COMPLETE_S_C1_006_AUTHORIZATION_PENDING'),
 ('    current_step: S-C1-005','    current_step: S-C1-006'),
 ('    completed_steps: 4','    completed_steps: 5'),
 ('    next_step: S-C1-004','    next_step: S-C1-006'),
 ('    checkpoint: CP-C1-05','    checkpoint: CP-C1-06'),
 ('    regression_authorized: true','    regression_authorized: false'),
 ('    completed_checkpoint: CP-C1-02','    completed_checkpoint: CP-C1-05'),
 ('    approval: APPROVED_R1_S_C1_003_HQ15_SELECTION','    approval: PENDING_S_C1_006_HUMAN_PLAYTEST'),
 ("    next_activity: 'Executar S-C1-005: persistência por quadro, legado e entrada; S-C1-006 permanece pendente'", "    next_activity: 'Autorizar S-C1-006: playtest humano isolado do capítulo 1; procedimento r1 preparado'")
]:
 assert old in block, old
 block=block.replace(old,new,1)
block=block.replace('    regression_authorized: false','    regression_authorized: false\n    regression_status: PASS\n    regression_delivery: .atena/generated/chapter1-integration-20261017/regression-delivery-r1.json\n    regression_evidence: EVID-NOTTGARD-CHAPTER1-REGRESSION-20261017-r1\n    human_playtest_proposal: .atena/specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-playtest-r1.md\n    human_playtest_authorized: false',1)
state.write_text(text[:start]+block+text[end:],encoding='utf-8')
print(json.dumps({'status':'PASS','session':session_rel,'completed_steps':5,'next':'CP-C1-06'},ensure_ascii=False))
