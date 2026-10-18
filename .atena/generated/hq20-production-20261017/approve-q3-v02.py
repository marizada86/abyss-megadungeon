from pathlib import Path
import json,hashlib,re,yaml
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
p=base/'q3-v02-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['owner_approval']=='PENDING_V02'
assert hashlib.sha256((r/record['candidate']).read_bytes()).hexdigest()==record['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ20-Q3-20261017-r2.md'
assert not (r/approval).exists()
(r/approval).write_text(f'''# HQ20 Q3 — aceite v02, revisão r2

CANON_OWNER_ASSET_APPROVAL. Data 2026-10-17. O dono respondeu “aprovado” à Q3 v02, com Marciela no visual do pacote oficial já aplicado à Q2. Arquivo `{record['candidate']}`, SHA-256 `{record['sha256']}`, 1672×941. V02 é a versão selecionada para continuidade da HQ neste plano complementar. V01 e seu aceite r1 preservados como histórico; fontes de outros planos não são alteradas silenciosamente.

Marciela indica passagem roxa para Shedaklah, Leoric/Korrak sobre madeira robusta no universo. Sem alteração de roteiro ou integração. Pacote externo permanece DRAFT na origem. Q1 v03, Q2 v02, Q3 v02 e Q4 v01 têm aceites individuais; faltam Q5/Q6/Q7.
''',encoding='utf-8')
record.update(status='APPROVED_V02',owner_approval='aprovado (2026-10-17), aceite Q3 v02',approval_canon=approval)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
spec='.atena/specs/SPEC-NOTTGARD-HQ20-COMPLETION-20261017/q5-preparation-r1.md'
(r/spec).write_text('''# HQ20 Q5 — preparação r1

PREPARED_REFERENCE_REQUIRED. IN_PLAN, S-P20-Q05, etapa 3/5 complementar, 2 concluídas e 3 restantes. Produção da próxima candidata autorizada pelo aceite Q3 e regra vigente, condicionada à identidade visual pertinente. Q4 v01 já aceita permanece.

Cena CANON: mandíbulas de Nidhogg fecham no vazio junto a Maelor, que escapa sem ferimento. Nidhogg vivo; sem contra-ataque, morte ou queda. Maelor e raiz cósmica da Q4 aceita são bases; respeitar personagem isolado e madeira de Yggdrasil v03. Texto externo: “Nidhogg tentou mordê-lo. Não conseguiu.”

BLOCKING: identidade visual de Nidhogg ainda não localizada. Pesquisa local por nomes nidhogg/Nidhogg e radical nidh em arquivos do vault/output, fontes visuais, assets e documentos pertinentes; sem pacote visual nominal encontrado. Referências textuais/editoriais documentam evento e declaram dependência de referência futura; não fornecem aparência aprovada. Não fabricar corpo, cabeça, escamas, chifres ou tamanho definitivo. Solicitar indicação da imagem existente ou direção aprovada para primeiro estudo visual. Q5/Q6 compartilham dependência. Nenhuma geração Q5 efetuada. Sem runtime.
''',encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q3-ACCEPTANCE-Q5-READINESS-20261017-r1.md'
(r/evidence).write_text('''# HQ20 — aceite Q3 v02 e prontidão Q5

Q3 v02 aprovada “aprovado”, hash conferido e aceite r2 registrado. Quatro de sete quadros da HQ com imagens aceitas: Q1 v03, Q2 v02, Q3 v02, Q4 v01. Plano complementar 2/5 concluído; Q5/Q6/Q7 restantes.

Busca delimitada por arquivos de nome Nidhogg/radical nidh no vault, output, fontes visuais e assets não localizou referência visual. Busca textual encontrou roteiro aprovado e documentos que mantêm dependência visual futura; arquivos de importação histórica não foram tratados como imagem oficial. Prontidão Q5: identidade Nidhogg requerida. Produção autorizada por continuidade, mas geração não iniciada sem resolver referência. Não houve alteração de runtime.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; match=re.search(pattern,t); assert match
block=match.group()
for old,new in [('status: Q3_CANDIDATE_V02_AWAITING_OWNER_APPROVAL','status: Q5_PREPARED_AWAITING_NIDHOGG_REFERENCE'),('current_step: S-P20-Q03C','current_step: S-P20-Q05'),('completed_steps: 1','completed_steps: 2'),('q3_v02_approval: PENDING_V02',"q3_v02_approval: 'APPROVED_V02: aprovado (2026-10-17)'"),('marciela_q3_continuity: CORRECTION_AUTHORIZED_IN_PROGRESS','marciela_q3_continuity: APPROVED_V02_OFFICIAL_REFERENCE'),('next_activity: Aceite Q3 v02; depois conferir referência de Nidhogg para Q5','next_activity: Resolver referência visual de Nidhogg antes de produzir Q5 autorizado')]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'  q3_v02_asset_approval: {approval}\n  q5_preparation: {spec}\n  q5_authorization: Próxima candidata autorizada pelo aceite Q3; referência requerida\n  q5_reference_gap: BLOCKING_NIDHOGG_VISUAL_IDENTITY\n  readiness_evidence: {evidence}\n'
t=t[:match.start()]+block+t[match.end():]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ20-Q3-CANDIDATE-20261017-v02.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite\n\nQ3 v02 aprovada, hash reconferido e aceite r2 registrado. Q4 já aceita; Q5 preparada, referência Nidhogg ainda requerida.\n')
print('PASS: Q3 v02 aprovada; Q1–Q4 aceitas. Q5 preparada, referência visual Nidhogg requerida; estado válido.')
