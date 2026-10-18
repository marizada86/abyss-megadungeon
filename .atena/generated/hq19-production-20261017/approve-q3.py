from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q3-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q3-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q4-production-brief-r1.md'
(r/approval).write_text(f'''# HQ19 Q3 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q3 v01 e pergunta explícita de aceite. S-P19-Q03 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovada a cena de Maelor oferecendo a pedra de luz que alcança Aila, que desperta sem asas, com aparência preservada.

Três de 12 quadros visualmente aprovados. Imagem e original preservados. O aceite individual não autoriza produção Q4 nem admissão no runtime; a sequência final permanece para conferência própria.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q4 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Uma candidata do Q4, modo per-step. Entradas: seleção r1, roteiro CANON HQ19 r2 e três quadros aprovados. Último quadro da abertura anterior a Dagruve; Q5–12 pertencem ao desfecho posterior.

Cena: Aila desperta e sem asas, plenamente vestida nas mesmas roupas escuras, reza diante da estátua de Sendrinah no templo de Dagruve. Enquadramento de três quartos ou lateral mostra seu rosto reconhecível e mãos em oração; estátua ao fundo de costas ou desfocada, conforme seleção aprovada, sem definir novo rosto, símbolo ou vestimenta canônica da deusa. O foco é a oração e a mensagem; não representar Sendrinah materializada nem inventar um segundo personagem para comunicá-la. O texto narrativo comunica o resultado após a oração, sem fingir citação direta de Aila ou da deusa.

Legenda CANON preservada para o leitor: “A mensagem de Sendrinah era clara: a ameaça continuava no Plano Abissal.”

Referências: Aila frontal v02 do pacote CHAR-002/S14-desperta/r01 e Q3 v01 aceita para identidade/roupa/acabamento. Interior de templo com pedra, arcos e velas discretos como composição DRAFT; sem copiar a Igreja das Sombras, Igreja de Nott ou templos posteriores de Domwieck/Quillen. Ambiente e detalhes de arquitetura não definem planta canônica. Sem asas, texto embutido, balões ou aparição divina. Formato aproximadamente 16:9, faixa inferior calma para legenda.

Saída futura: uma candidata versionada, apresentada para aceite individual. Checks: identidade/roupa de Aila, sem asas, oração reconhecível, estátua indireta, templo coerente e legibilidade. Zero BLOCKING para a composição indireta já aprovada; exigir retrato frontal detalhado da estátua reabre a necessidade de referência própria. Produção ainda depende de autorização.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q3 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8'); a=text.index('  hq19_visual_selection:\n'); b=text.index('  chapter_2_review:\n',a); block=text[a:b]
for old,new in [('q3_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q3_production_status: APPROVED_V01'),('q3_approval: PENDING_V01',"q3_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 2','approved_visual_panels: 3'),("next_activity: 'Aceite individual HQ19 Q3 v01; Q4 não autorizado'","next_activity: 'Autorizar candidata HQ19 Q4 conforme brief r1; Q1–Q3 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q3_asset_approval: {approval}\n    q4_brief: {brief}\n    q4_production_status: PREPARED_AUTHORIZATION_PENDING\n'
text=text[:a]+block+text[b:]; yaml.safe_load(text); state.write_text(text,encoding='utf-8')
e=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q3-CANDIDATE-20261017-r1.md'
e.write_text(e.read_text(encoding='utf-8')+'\n## Aceite individual\n\nO dono respondeu “aprovado” à Q3 v01. Hash conferido e imagem preservada; aceite em ASSET-APPROVAL-HQ19-Q3-20261017-r1. Três de 12 quadros aceitos. Brief Q4 preparado, geração pendente; sem admissão no runtime.\n',encoding='utf-8')
print('PASS: Q3 aprovada, hash preservado; 3/12; brief Q4 preparado, produção pendente.')
