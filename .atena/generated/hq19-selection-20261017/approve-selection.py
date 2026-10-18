from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-selection-20261017'
decision='.atena/vault/canon/DEC-HQ19-VISUAL-SELECTION-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q1-production-brief-r1.md'
manifest=json.loads((base/'selection-r1.json').read_text(encoding='utf-8'))
assert manifest['status']=='DRAFT_SELECTION_AWAITING_OWNER_APPROVAL'
(r/decision).write_text('''# HQ19 — seleção visual aprovada / r1

Estado: CANON_OWNER_SELECTION_APPROVAL. Data: 2026-10-17. Autorização: “aprovado”, em resposta à proposta visual HQ19 r1 e pergunta explícita “Aprova a seleção visual r1 da HQ19?”. Plano PLAN-NOTTGARD-HQ19-VISUAL-SELECTION-20261017, S-V19-001/1 concluída, CP-V19-01 aprovado.

Aprovados: bases de identidade apresentadas; Aila sem asas, Thalion conforme referência azul/dourado/vermelho, Bromnor espiritual e Kayron branco; continuidade dos demais; martelo amarelo no Q1 e transição a vermelho no Q2; jardim/Véu após o sacrifício; estátua de Sendrinah indireta; propostas dos 12 quadros. Zero reaproveitamentos diretos, 12 composições novas apoiadas no acervo auditado.

Uso dos pacotes DRAFT como referências autorizado; isso não promove seus detalhes reconstruídos a cânone independente nem altera o vault externo. Roteiro vigente HQ19 r2 e decisão de Aila sem asas permanecem autoritativos. Produção de candidata Q1 e integração ainda exigem autorização de escopo próprio, conforme modo per-step escolhido.

Proposta aceita: ../../specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-visual-selection-r1.md. Manifesto: ../../generated/hq19-selection-20261017/selection-r1.json.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q1 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Plataforma PC; uma candidata versionada do primeiro quadro, sem produção em lote ou integração. Modo per-step existente.

Cena aprovada: após o sacrifício de Helion, Redenção Divina sobre a estrela, que se abre e revela Aila desacordada, sem asas, no centro. Jardim de flores vermelhas e floresta circular; Véu Vivo já erguido. O martelo conserva luz amarela; a entrega a Brook e mudança para vermelho pertencem ao Q2. Portador fora do recorte se não identificado, evitando fixar quem realizou o gesto. Não despertar Aila ainda, inventar ferimentos ou restaurar o domo azul da Tarn.

Legenda CANON preservada para o leitor, sem texto na arte: “Depois que o Véu se ergueu, o martelo libertou Aila de dentro da estrela.”

Referências selecionadas: Aila CHAR-002/S14-desperta/r01 frontal v02 e costas v01; jardim/Véu assets/hq/chapter1_r1/hq_n03_q5_living_veil_v01.png; desenho do martelo assets/hq/chapter1_r1/hq_n18_q5_recovery_v01.png. Verificar hashes e anexar fontes pertinentes ao gerar. O primeiro registro de Aila no Q1 será adaptado à condição desacordada, sem copiar expressão desperta.

Direção: fantasia sombria, pixel art denso e dithering controlado, paisagem aproximadamente 16:9, composição calma para legenda no terço inferior, sem balões/UI/texto/marca. Saída futura: uma candidata local versionada com referências e recibo preservados, apresentada para aceite individual. Checks: identidade sem asas, estrela aberta, Aila inconsciente, martelo amarelo, ambiente pós-sacrifício, proporção e área de legenda. Zero BLOCKING no brief; ferramenta e referências serão conferidas antes da execução autorizada.
''',encoding='utf-8')
manifest.update(status='APPROVED_R1',owner_approval='aprovado (2026-10-17), seleção visual r1 somente',approval_canon=decision,resolvable=[],generation_authorized=False)
(base/'selection-r1.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8')
a=text.index('  hq19_visual_selection:\n'); b=text.index('  chapter_2_review:\n',a); block=text[a:b]
for old,new in [('status: DRAFT_SELECTION_AWAITING_OWNER_APPROVAL','status: COMPLETE_SELECTION_APPROVED'),('completed_steps: 0','completed_steps: 1'),('activity: REFERENCE_AUDIT_AND_SELECTION_PROPOSAL_DELIVERED','activity: OWNER_SELECTION_ACCEPTANCE_RECORDED'),('approval: PENDING_SELECTION_R1','approval: APPROVED_R1'),("next_activity: 'Confirmar seleção visual r1; produção de Q1 requer escopo próprio'","next_activity: 'Autorizar uma candidata HQ19 Q1 conforme brief r1 preparado'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f"    owner_approval: 'aprovado (2026-10-17), em resposta à seleção visual r1'\n    approval_canon: {decision}\n    q1_brief: {brief}\n    q1_production_status: PREPARED_AUTHORIZATION_PENDING\n"
text=text[:a]+block+text[b:]
text=text.replace("next_activity: 'HQ19: seleção visual r1 apresentada; capítulo 2 CANON r2 com Aila sem asas'","next_activity: 'HQ19: seleção visual r1 aprovada; candidata Q1 aguarda autorização por etapa'",1)
yaml.safe_load(text); state.write_text(text,encoding='utf-8')
spec=r/manifest['spec']; body=spec.read_text(encoding='utf-8').replace('Estado: DRAFT_SELECTION_AWAITING_OWNER_APPROVAL.','Estado: APPROVED_R1 — aceite do dono “aprovado” em 2026-10-17. Proposta original abaixo preservada como registro do escopo aceito.',1)
spec.write_text(body,encoding='utf-8')
evidence=r/'.atena/evidence/EVID-NOTTGARD-HQ19-VISUAL-SELECTION-20261017-r1.md'
body=evidence.read_text(encoding='utf-8')+'\n## Aceite da seleção\n\nO dono respondeu “aprovado” à seleção visual r1. CP-V19-01 fechado, uma de uma etapas concluídas. Bases DRAFT e estátua indireta aceitas para esse uso. DEC-HQ19-VISUAL-SELECTION-20261017-r1 registra o escopo; Q1 tem brief concreto preparado e produção pendente de autorização própria. Nenhuma imagem produzida, código ou save alterado.\n'
evidence.write_text(body,encoding='utf-8')
for p in [decision,brief]: assert (r/p).exists()
print('PASS: seleção HQ19 aprovada; brief Q1 preparado; geração permanece pendente.')
