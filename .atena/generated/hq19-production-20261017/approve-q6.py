from pathlib import Path
import json, hashlib, yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q6-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q6-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q7-production-brief-r1.md'
assert not (r/approval).exists() and not (r/brief).exists()
refs=['.atena/generated/hq03-production-20261017/reference-audit/kayron-white-front.png','.atena/generated/hq03-production-20261017/reference-audit/kayron-white-back.png','assets/portraits/brook.png']
for ref in refs:
    assert (r/ref).is_file(),ref
(r/approval).write_text(f'''# HQ19 Q6 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q6 v01. Etapa S-P19-Q06 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovados Leoric e Korrak presos por raízes negras e arrastados para portais roxos, com continuidade do templo e Korrak sem machado. O glifo ilustrativo não estabelece alfabeto canônico.

Seis de 12 quadros visualmente aprovados; seis restantes. Aceite individual sem admissão no runtime. Produção Q7 requer autorização própria no modo per-step.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q7 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Etapa S-P19-Q07, sétima de 12; seis concluídas e seis restantes incluindo esta. Classificação IN_PLAN. Uma candidata Q7 para aceite individual, somente PC, modo per-step.

Entradas: roteiro CANON HQ19 r2, seleção visual r1 aprovada, bible visual DRAFT r2 autorizada como direção; Kayron branco frontal/costas nas cópias auditadas de .atena/generated/hq03-production-20261017/reference-audit/; retrato assets/portraits/brook.png e Q2 aprovada para Brook e Martelo da Glória; Q4–Q6 para pedra, arcos, velas e noite do templo. Referências conservam seus estados de origem; não promover elementos novos por associação.

Cena: duas vinhetas visualmente separadas dentro de uma imagem horizontal. Na primeira, Kayron com roupa branca de padrões pretos e faixa vermelha escapa pela janela do templo; guardas ficam atrás dele no interior. Mostrar ação de transpor a janela e relação espacial legível, sem inventar altura perigosa, ferimento ou combate adicional. Na segunda, Brook está em outro ponto fora do templo, com cenário externo noturno coerente e sem compartilhar a fuga ou a janela. Não fixar planta arquitetônica nova; a separação entre vinhetas deve impedir leitura de fuga conjunta.

Brook é um halfling adulto pequeno, cabelo branco penteado para trás, barba branca curta, armadura de aço e capa vinho. Se o martelo estiver visível, usar o Martelo da Glória já entregue no Q2: mesma geometria aprovada, luz vermelha. Não substituir por maça do retrato nem colocar Sylas como portador. Kayron usa a skin branca aprovada, não a antiga roupa preta.

Texto CANON separado da arte: “Kayron escapou. Brook estava fora do templo.” Sem texto ou balões na imagem. Pixel art denso de fantasia sombria, proporção aproximada 16:9, continuidade de iluminação fria externa e velas internas, faixa inferior calma. Duas vinhetas de narrativa, sem UI ou ornamentação de moldura.

Saída: uma candidata versionada. Antes da geração, inspecionar referências de identidade e ambiente. Checks: identidade/roupa branca de Kayron, fuga pela janela e guardas atrás, Brook reconhecível e fora do templo em cena distinta, sem fuga conjunta, cronologia do martelo preservada, sem texto embutido; validar arquivo, dimensões e hash. Zero BLOCKING na preparação. Produção pendente de autorização; integração e teste no leitor ficam para checkpoint posterior.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
for old,new in [('q6_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q6_production_status: APPROVED_V01'),('q6_approval: PENDING_V01',"q6_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 5','approved_visual_panels: 6'),("next_activity: 'Aceite individual HQ19 Q6 v01; Q7 não autorizado'","next_activity: 'Autorizar candidata HQ19 Q7 conforme brief r1; Q1–Q6 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q6_asset_approval: {approval}\n    q7_brief: {brief}\n    q7_production_status: PREPARED_AUTHORIZATION_PENDING\n'
updated=t[:a]+block+t[b:]; yaml.safe_load(updated)
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q6 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(updated,encoding='utf-8')
e=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q6-CANDIDATE-20261017-r1.md'
with e.open('a',encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nO dono respondeu “aprovado” à Q6 v01. Hash reconferido; aceite em ASSET-APPROVAL-HQ19-Q6-20261017-r1. Seis de 12 quadros aceitos. Brief Q7 preparado, com vinhetas separadas de Kayron branco e Brook. Produção aguarda autorização própria; sem admissão no runtime.\n')
for path in [approval,brief,record['candidate']]:
    assert (r/path).is_file()
print('PASS: Q6 aprovada, hash conferido; 6/12. Brief Q7 preparado, referências presentes e estado YAML válido.')
