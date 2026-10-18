from pathlib import Path
import json, hashlib, yaml

r = Path.cwd()
p = r / '.atena/generated/hq19-production-20261017/q5-production-r1.json'
record = json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval'] == 'PENDING_V01'
assert hashlib.sha256((r / record['candidate']).read_bytes()).hexdigest() == record['sha256']
approval = '.atena/vault/canon/ASSET-APPROVAL-HQ19-Q5-20261017-r1.md'
brief = '.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q6-production-brief-r1.md'
assert not (r / approval).exists() and not (r / brief).exists()
(r / approval).write_text(f'''# HQ19 Q5 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q5 v01. Etapa S-P19-Q05 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovados Thalion com identidade e vestuário de referência, gesto de comando e soldados vivos no templo de Dagruve.

Cinco de 12 quadros visualmente aprovados; sete restantes. Aceite individual, sem admissão no runtime. Produção Q6 depende de autorização própria no modo per-step.
''', encoding='utf-8')
(r / brief).write_text('''# HQ19 Q6 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Etapa S-P19-Q06, sexta de 12; cinco concluídas e sete restantes incluindo esta. Classificação IN_PLAN. Escopo: uma candidata Q6 para aceite individual, PC, modo per-step.

Entradas: roteiro CANON HQ19 r2, seleção visual r1 aprovada, bible visual DRAFT r2 autorizada como direção, retratos de Leoric e Korrak em assets/portraits/leoric.png e korrak.png, e Q4/Q5 aprovados para continuidade do templo. Pacotes de referência conservam seu estado original; uso não promove detalhes adicionais a lore.

Cena: no templo de Sendrinah em Dagruve, uma runa de inspiração nórdica paira no ar; portais roxos se abrem e raízes negras prendem e arrastam Leoric e Korrak para o Abismo. Mostrar os dois reconhecíveis e ainda parcialmente no lado material, com direção do arrasto clara. Leoric é baixo, de cartola, barba grisalha, sobretudo marrom e cajado com gema azul. Korrak é um goliath muito maior, de braços cinzentos tatuados, cabelo/barba escuros curtos e vestes de couro e pele. Não incluir o machado Xar’gath, adquirido posteriormente. Composição aberta suficiente para distinguir escala, identidades, raízes e abertura roxa; não requer inserir outros integrantes.

Preservar pedra, arcos e velas do templo no lado material. Raízes invadem a cena, sem converter todo o piso em terreno abissal. Grafismos mágicos ilustrativos, sem definir alfabeto ou runa canônica definitiva. Não antecipar envio de Maelor nem captura de Aila. Thalion permanece vivo no roteiro.

Texto CANON separado da imagem: “Thalion abriu portais. As raízes arrastaram Leoric e Korrak para o Abismo.” Sem letras, legenda ou balões na arte.

Saída: uma candidata versionada, imagem horizontal aproximadamente 16:9, pixel art denso de fantasia sombria, faixa inferior calma. Referências visuais devem ser inspecionadas antes da geração. Checks: identidade e escala dos dois personagens, arrasto legível por raízes negras, portais roxos, continuidade do templo, ausência de arma futura e de texto embutido; validar arquivo, dimensões e hash. Zero gaps BLOCKING na preparação. Produção aguarda autorização; integração e teste no jogo ficam para checkpoint posterior.
''', encoding='utf-8')
state = r / '.atena/state/plan.yaml'
text = state.read_text(encoding='utf-8')
a = text.index('  hq19_visual_selection:\n'); b = text.index('  chapter_2_review:\n', a)
block = text[a:b]
for old, new in [
    ('q5_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL', 'q5_production_status: APPROVED_V01'),
    ('q5_approval: PENDING_V01', "q5_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),
    ('approved_visual_panels: 4', 'approved_visual_panels: 5'),
    ("next_activity: 'Aceite individual HQ19 Q5 v01; Q6 não autorizado'", "next_activity: 'Autorizar candidata HQ19 Q6 conforme brief r1; Q1–Q5 aprovadas'")
]:
    assert old in block, old
    block = block.replace(old, new, 1)
block += f'    q5_asset_approval: {approval}\n    q6_brief: {brief}\n    q6_production_status: PREPARED_AUTHORIZATION_PENDING\n'
updated = text[:a] + block + text[b:]
yaml.safe_load(updated)
record.update(status='APPROVED_V01', owner_approval='aprovado (2026-10-17), aceite individual Q5 v01', approval_canon=approval)
p.write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding='utf-8')
state.write_text(updated, encoding='utf-8')
e = r / '.atena/evidence/EVID-NOTTGARD-HQ19-Q5-CANDIDATE-20261017-r1.md'
with e.open('a', encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nO dono respondeu “aprovado” à Q5 v01. Hash reconferido; aceite registrado em ASSET-APPROVAL-HQ19-Q5-20261017-r1. Cinco de 12 quadros aceitos. Brief Q6 preparado; produção aguarda autorização própria. Sem admissão no runtime.\n')
for relative in [approval, brief, record['candidate']]:
    assert (r / relative).is_file(), relative
assert yaml.safe_load(state.read_text(encoding='utf-8')) is not None
print('PASS: Q5 aprovada, hash conferido; 5/12. Brief Q6 preparado, produção pendente. Estado YAML válido e referências presentes.')
