from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q4-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q4-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q5-production-brief-r1.md'
(r/approval).write_text(f'''# HQ19 Q4 — aceite individual v01

Estado: CANON_OWNER_ASSET_APPROVAL. Data: 2026-10-17. O dono respondeu “aprovado” à candidata Q4 v01 e pergunta explícita de aceite. S-P19-Q04 concluída.

Arquivo: `{record['candidate']}`. SHA-256: `{record['sha256']}`. Dimensões: 1672×941. Aprovada Aila sem asas em oração, mesma aparência/roupas, com estátua indireta de Sendrinah desfocada ao fundo.

Quatro de 12 quadros visualmente aprovados. Q1–4, abertura antes de Dagruve, têm aceites individuais; isso não substitui a conferência final da sequência nem autoriza integração ou geração Q5. Originais e candidatas preservados.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q5 — preparação de produção r1

Estado: PREPARED_AWAITING_PRODUCTION_AUTHORIZATION. Uma candidata Q5, modo per-step. Entrada: roteiro CANON HQ19 r2, seleção r1 e Q1–4 aprovados. Q5 inicia o segmento exibido após Dagruve, na resolução do confronto; não reabre o roteiro aprovado nem declara vitória com morte de Thalion.

Cena: Thalion entra no templo de Sendrinah em Dagruve à frente de soldados, vivos e em postura de captura. Plano médio/aberto com Thalion como foco, expressão firme e gesto de comando; guardas atrás em silhuetas identificáveis como escolta. Não fixar contagem exata nem inventar nova ordem militar. Sem execução, sangue ou Thalion morto; raízes/portais e pessoas arrastadas pertencem ao Q6. Evitar acrescentar personagem nomeado desnecessário neste recorte.

Legenda/fala CANON para o leitor: Thalion: “Peguem-nos!” Sem texto ou balão na imagem.

Referências: Thalion frontal CHAR-054/inicio-Arco01-conselheiro/r01 e thalion.jpg nominal, aceitos como bases na seleção: cabelo longo claro, olhos azuis, roupa azul/dourada, manto e chapéu vermelhos ornamentados. Sem aparência demoníaca ou conversão religiosa posteriores. Q4 v01 aceita para pedra, arcos, velas e continuidade de ambiente; mudar ângulo para a entrada, sem inventar planta canônica. Nenhuma necessidade de mostrar a estátua frontalmente.

Direção: fantasia sombria com pixel art denso, 16:9 aproximado, área inferior calma, sem texto/UI/marca. Verificar referências e hashes antes da geração. Saída futura: uma candidata versionada para aceite individual. Checks: identidade e roupa de Thalion, comando/captura legíveis, continuidade de templo e figuras vivas, sem antecipar o envio. Zero BLOCKING na preparação; produção pendente de autorização própria.
''',encoding='utf-8')
record.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q4 v01',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8'); a=text.index('  hq19_visual_selection:\n'); b=text.index('  chapter_2_review:\n',a); block=text[a:b]
for old,new in [('q4_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q4_production_status: APPROVED_V01'),('q4_approval: PENDING_V01',"q4_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 3','approved_visual_panels: 4'),("next_activity: 'Aceite individual HQ19 Q4 v01; Q5 não autorizado'","next_activity: 'Autorizar candidata HQ19 Q5 conforme brief r1; Q1–Q4 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'    q4_asset_approval: {approval}\n    q5_brief: {brief}\n    q5_production_status: PREPARED_AUTHORIZATION_PENDING\n'
text=text[:a]+block+text[b:]; yaml.safe_load(text); state.write_text(text,encoding='utf-8')
e=r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q4-CANDIDATE-20261017-r1.md'
e.write_text(e.read_text(encoding='utf-8')+'\n## Aceite individual\n\nO dono respondeu “aprovado” à Q4 v01. Hash conferido e imagem preservada; aceite em ASSET-APPROVAL-HQ19-Q4-20261017-r1. Quatro de 12 quadros aceitos, encerrando a produção individual da abertura Q1–4. Brief Q5 preparado para o segmento posterior a Dagruve; geração ainda pendente. Sem admissão no runtime.\n',encoding='utf-8')
print('PASS: Q4 aprovada, hash preservado; 4/12; brief Q5 preparado, produção pendente.')
