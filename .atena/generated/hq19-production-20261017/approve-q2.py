from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q2-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q2-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q3-production-brief-r1.md'
(r/approval).write_text(f'''# HQ19 Q2 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q2 v01 apresentada e pergunta explícita de aceite. S-P19-Q02 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovada a cena de Brook recebendo o martelo, Bromnor espiritual se desfazendo em páginas e luz mudando de amarela para vermelha, no jardim sob o Véu Vivo. Brook é halfling; Bromnor, anão; manifestação espiritual não redefine altura física.

Dois de 12 quadros visualmente aprovados. Original e candidata preservados. Aceite individual não equivale ao aceite da sequência completa, admissão no jogo ou autorização de produção Q3.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q3 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Uma candidata do Q3, modo per-step. Entradas: seleção visual r1, roteiro CANON HQ19 r2, Q1 e Q2 aprovadas. Sem lote ou integração.

Cena aprovada: em momento posterior, Maelor oferece a Aila a pedra de luz etérea obtida pelo desejo, que estava com Thalion. Ela entra em Aila, que desperta. Plano médio íntimo e legível: Maelor com o rosto/figurino de referência, ao lado de Aila reclinada, plenamente vestida nas mesmas roupas escuras, sem asas, abrindo os olhos. A luz é localizada e suave; sua cor será um recurso de iluminação sem instituir nova regra de lore. Não transformar o objeto em colar, semente de Helion ou martelo, não mostrar uma segunda libertação da estrela nem acrescentar gesto romântico. Enquadramento restrito e fundo discreto, sem inventar arquitetura/localização canônica.

Legenda CANON preservada para o leitor: “Mais tarde, Maelor trouxe a luz que estava com Thalion. Aila despertou.”

Referências: assets/portraits/maelor.png; Aila CHAR-002/S14-desperta/r01 frontal v02; Q1 aceita para rosto, roupa e condição anterior de Aila e para acabamento da HQ. Ficha Luz Mais Pura de Thalion como autoridade do objeto. Verificar fontes e hashes pertinentes antes da geração. Saída futura: candidata versionada para aceite individual. Checks: Maelor e Aila reconhecíveis, sem asas, despertar legível, pedra/luz absorvida, sem estrela repetida ou texto embutido, proporção 16:9 e espaço inferior para legenda. Zero BLOCKING na preparação; geração aguarda autorização própria.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q2 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8'); a=text.index('  hq19_visual_selection:\n'); b=text.index('  chapter_2_review:\n',a); block=text[a:b]
for old,new in [('q2_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q2_production_status: APPROVED_V01'),('q2_approval: PENDING_V01',"q2_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 1','approved_visual_panels: 2'),("next_activity: 'Aceite individual HQ19 Q2 v01; Q3 não autorizado'","next_activity: 'Autorizar candidata HQ19 Q3 conforme brief r1; Q1/Q2 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q2_asset_approval: {approval}\n    q3_brief: {brief}\n    q3_production_status: PREPARED_AUTHORIZATION_PENDING\n'
text=text[:a]+block+text[b:]; yaml.safe_load(text); state.write_text(text,encoding='utf-8')
e=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q2-CANDIDATE-20261017-r1.md'
e.write_text(e.read_text(encoding='utf-8')+'\n## Aceite individual\n\nO dono respondeu “aprovado” à Q2 v01. Hash conferido e imagem preservada; aceite em ASSET-APPROVAL-HQ19-Q2-20261017-r1. Dois de 12 quadros aceitos. Brief Q3 preparado, geração pendente; sem admissão no runtime.\n',encoding='utf-8')
print('PASS: Q2 v01 aprovada, hash preservado; 2/12; brief Q3 preparado, produção pendente.')
