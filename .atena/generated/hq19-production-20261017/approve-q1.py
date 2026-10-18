from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q1-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
candidate=r/record['candidate']; assert hashlib.sha256(candidate.read_bytes()).hexdigest()==record['sha256']
assert record['owner_approval']=='PENDING_V01'
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q1-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q2-production-brief-r1.md'
(r/approval).write_text(f'''# HQ19 Q1 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata v01 apresentada e à pergunta “Aprova este primeiro quadro?”. Etapa S-P19-Q01 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aceita a cena de Aila desacordada e sem asas dentro da estrela partida, martelo amarelo e Véu Vivo ao fundo, conforme HQ19 r2. Sem modificação da imagem para registrar o aceite.

Um de 12 quadros aprovado visualmente. Aceite individual não equivale a aprovação da sequência final nem autoriza integração ou produção de Q2 por inferência. Original e candidata preservados.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q2 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Uma candidata do Q2, modo per-step; entrada Q1 v01 aprovada, seleção visual r1 e roteiro CANON HQ19 r2. Sem lote ou integração.

Cena: no jardim após a libertação de Aila, manifestação espiritual de Bromnor diante de Brook. Brook recebe e segura o martelo no gesto de assumir seu legado; o espírito de Bromnor se desfaz em páginas etéreas. A luz do martelo muda de amarela para vermelha, mantendo a geometria da arma. Plano médio com mãos e rostos legíveis, escala dos dois anões adultos coerente. Bromnor translúcido e espiritual, sem ressuscitar fisicamente. Brook mantém cabelo/barba brancos, armadura e capa vinho. Mesmo jardim de flores vermelhas e Véu Vivo, sem domo da Tarn. Aila pode ficar fora do recorte para manter foco no legado. Nenhuma fala/texto embutido.

Legenda CANON preservada para leitor: “Brook recebeu o legado de Bromnor. A arma tornou-se o Martelo da Glória.”

Referências selecionadas: retratos atuais Brook/Bromnor; pacote Bromnor CHAR-010/historico-em-vida/r01 aprovado para uso de referência; martelo HQ18 Q5; candidata Q1 aceita para estilo, jardim e continuidade. Conferir e anexar fontes pertinentes antes da geração. Saída futura: uma candidata versionada apresentada para aceite individual; checks de identidade/escala, gesto de recepção por Brook, espírito/páginas, martelo amarelo→vermelho, ambiente e legibilidade. Zero BLOCKING na preparação; geração pendente de autorização própria.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q1 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8'); a=text.index('  hq19_visual_selection:\n'); b=text.index('  chapter_2_review:\n',a); block=text[a:b]
for old,new in [('q1_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q1_production_status: APPROVED_V01'),('q1_approval: PENDING_V01',"q1_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),("next_activity: 'Aceite individual da candidata HQ19 Q1 v01; Q2 ainda não autorizado'","next_activity: 'Autorizar candidata HQ19 Q2 conforme brief r1; Q1 aprovada'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q1_asset_approval: {approval}\n    approved_visual_panels: 1\n    total_visual_panels: 12\n    q2_brief: {brief}\n    q2_production_status: PREPARED_AUTHORIZATION_PENDING\n'
text=text[:a]+block+text[b:]; yaml.safe_load(text); state.write_text(text,encoding='utf-8')
evidence=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q1-CANDIDATE-20261017-r1.md'
evidence.write_text(evidence.read_text(encoding='utf-8')+'\n## Aceite individual\n\nO dono respondeu “aprovado” à v01. Hash da candidata conferido, arquivo preservado, aceite em ASSET-APPROVAL-HQ19-Q1-20261017-r1. Um de 12 quadros visualmente aceito. Brief Q2 preparado, produção pendente; sem admissão no runtime.\n',encoding='utf-8')
print('PASS: Q1 v01 aprovada, hash preservado; 1/12; Q2 preparada e sem autorização de produção.')
