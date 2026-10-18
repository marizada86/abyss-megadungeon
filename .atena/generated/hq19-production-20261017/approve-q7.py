from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q7-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q7-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q8-production-brief-r1.md'
assert not (r/approval).exists() and not (r/brief).exists()
references=[r/'assets/portraits/maelor.png',Path('D:/dev/nottgard/vault/output/referencias-personagens/CHAR-002/S14-desperta/r01/aila-front-candidate-v02.png'),base/'candidates/hq_n19_q3_aila_awakens_v01.png',base/'candidates/hq_n19_q6_roots_abduction_v01.png']
for ref in references:
    assert ref.is_file(),str(ref)
(r/approval).write_text(f'''# HQ19 Q7 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q7 v01. Etapa S-P19-Q07 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovadas duas vinhetas distintas: Kayron branco escapando pela janela com guardas atrás; Brook fora do templo, com Martelo da Glória de luz vermelha. Sem fuga conjunta.

Sete de 12 quadros visualmente aprovados; cinco restantes. Aceite individual sem admissão no runtime. Produção Q8 depende de autorização própria no modo per-step.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q8 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Etapa S-P19-Q08, oitava de 12; sete concluídas e cinco restantes incluindo esta. Classificação IN_PLAN. Uma candidata Q8 para aceite individual, PC, modo per-step.

Entradas: roteiro CANON HQ19 r2, seleção visual r1 aprovada, bible visual DRAFT r2 autorizada como direção. Retrato assets/portraits/maelor.png, Aila CHAR-002/S14-desperta/r01 frontal v02 (pacote DRAFT autorizado como referência), Q3 aprovada para identidade e roupas dos dois; Q4–Q6 para continuidade do templo, raízes e iluminação. Referências conservam autoridade de origem, sem promover detalhes novos a lore.

Cena: dentro do templo de Sendrinah em Dagruve, Maelor e Aila sem asas lado a lado. Em primeiro plano, as primeiras raízes negras enfraquecem e apodrecem ANTES de tocar Maelor. Mostrar extremidades murchas, quebradiças, se desfazendo, com espaço visível entre raízes e personagens. Aila permanece ilesa e sem contato. Plano médio com raízes em destaque, mantendo rostos e proximidade dos dois legíveis. Não inventar escudo, cúpula, círculo protetor, ataque, golpe ou explicação nova para o efeito.

Maelor mantém cabelo castanho de lado, barba/bigode curtos, roupa azul/dourada, gola clara alta e capa cinza do retrato; não acrescentar chifres. Aila mantém cabelo claro preso de forma solta e roupa escura gasta aprovada, totalmente coberta, sem asas. Sem ferimentos, algemas ou captura consumada; guardas prendem fisicamente os dois apenas no Q9. Não mostrar Maelor já sendo enviado pelo portal, evento posterior ao interrogatório.

Ambiente: pedra e arcos do templo, velas âmbar e sombras frias, sem converter piso inteiro em raízes. Preservar natureza negra/lenhosa das raízes do Q6, agora apodrecidas. Sem inventar runa legível ou nova arquitetura detalhada.

Texto CANON separado da arte: “Diante de Maelor e Aila, as primeiras raízes enfraqueceram e apodreceram.” Arte sem letras, balões ou legenda; pixel art denso de fantasia sombria, horizontal aproximadamente 16:9, faixa inferior calma, sem UI/marca.

Saída: uma candidata versionada. Antes da geração, inspecionar referências pertinentes. Checks: identidades/roupas, Aila sem asas, raízes se desfazendo antes do contato com distância visível, nenhum escudo ou golpe acrescentado, templo coerente e cronologia preservada; validar arquivo, dimensões e hash. Zero BLOCKING na preparação. Produção aguarda autorização própria; integração e teste no leitor ficam para checkpoint posterior.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
for old,new in [('q7_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q7_production_status: APPROVED_V01'),('q7_approval: PENDING_V01',"q7_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 6','approved_visual_panels: 7'),("next_activity: 'Aceite individual HQ19 Q7 v01; Q8 não autorizado'","next_activity: 'Autorizar candidata HQ19 Q8 conforme brief r1; Q1–Q7 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q7_asset_approval: {approval}\n    q8_brief: {brief}\n    q8_production_status: PREPARED_AUTHORIZATION_PENDING\n'
updated=t[:a]+block+t[b:]; yaml.safe_load(updated)
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q7 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(updated,encoding='utf-8')
e=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q7-CANDIDATE-20261017-r1.md'
with e.open('a',encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nO dono respondeu “aprovado” à Q7 v01. Hash reconferido; aceite em ASSET-APPROVAL-HQ19-Q7-20261017-r1. Sete de 12 quadros aceitos. Brief Q8 preparado: raízes apodrecem antes de alcançar Maelor; Aila ilesa ao lado. Produção pendente de autorização própria; sem admissão no runtime.\n')
for path in [approval,brief,record['candidate']]:
    assert (r/path).is_file()
print('PASS: Q7 aprovada, hash conferido; 7/12. Brief Q8 preparado, referências presentes e YAML válido.')
