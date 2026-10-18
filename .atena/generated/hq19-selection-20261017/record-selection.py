from pathlib import Path
import json,hashlib,re,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-selection-20261017'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
owner='Aila sem asas em todos os quadros, ajustando também o Q1 aprovado'
old_path='.atena/vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r1.md'
new_path='.atena/vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r2.md'
old=(r/old_path).read_text(encoding='utf-8')
new=old.replace('# HQ19 — A Ordem de Thalion / r1','# HQ19 — A Ordem de Thalion / r2',1).replace('Aila alada no centro','Aila sem asas no centro',1)
assert new!=old and 'Aila alada no centro' not in new
note=f'\nRevisão r2 — correção explícita do dono em 2026-10-17 durante a seleção visual: “{owner}”. Aila não tem asas em nenhum quadro da HQ19. Permanecem aprovados os 12 quadros, todas as falas, a entrega a Brook no Q2 e a divisão antes/depois de Dagruve. R1 preservada como histórico.\n'
new=new.replace('\n\nEstado:',note+'\nEstado:',1)
assert not (r/new_path).exists()
(r/new_path).write_text(new,encoding='utf-8')
decision='.atena/vault/canon/DEC-AILA-WINGLESS-HQ19-20261017-r1.md'
(r/decision).write_text(f'''# Aila sem asas na HQ19 — r1

Estado: CANON_OWNER_CORRECTION. Data: 2026-10-17. Declaração direta do dono: “{owner}”. Resposta à divergência entre HQ19 Q1 alada e pacote visual S14 sem asas.

Decisão: Aila sem asas em todos os 12 quadros da HQ19, inclusive sua libertação física no Q1. Corrigir somente esse detalhe na revisão HQ19 r2; manter falas e demais ações aprovadas. Esta decisão prevalece sobre a descrição alada da Sessão 12 e HQ19 r1 para a adaptação atual. Não é mera inferência a partir do pacote DRAFT do vault. Não autoriza alterar o vault externo.

Referências: HQ19-SCREENPLAY-APPROVED-20261017-r2.md; pacote CHAR-002/S14-desperta/r01 frontal v02, aceito como referência DRAFT na origem. Seleção visual e produção continuam gates distintos.
''',encoding='utf-8')
vol_old='.atena/vault/canon/CHAPTER2-SCREENPLAYS-APPROVED-20261017-r1.md'
vol_new='.atena/vault/canon/CHAPTER2-SCREENPLAYS-APPROVED-20261017-r2.md'
volume=(r/vol_old).read_text(encoding='utf-8')
assert '## '+old[2:].rstrip() in volume
volume=volume.replace('## '+old[2:].rstrip(),'## '+new[2:].rstrip(),1).replace('revision: r1','revision: r2',1).replace('# Capítulo 2 — roteiros aprovados / r1','# Capítulo 2 — roteiros aprovados / r2',1)
volume=volume.replace('Manifesto de integridade: [consolidated-r1.json](../../generated/chapter2-editorial-20261017/consolidated-r1.json).','Manifesto de integridade vigente: [consolidated-r2.json](../../generated/chapter2-editorial-20261017/consolidated-r2.json).',1)
volume=volume.replace('Este volume reúne integralmente',f'Revisão r2: aplica exclusivamente a correção “{owner}”, confirmada pelo dono na seleção da HQ19. As nove outras HQs e a contagem total permanecem iguais; r1 preservada.\n\nEste volume reúne integralmente',1)
(r/vol_new).write_text(volume,encoding='utf-8')
m=json.loads((r/'.atena/generated/chapter2-editorial-20261017/consolidated-r1.json').read_text(encoding='utf-8'))
m['revision']='r2'; m['output']=vol_new; m['output_sha256']=sha(r/vol_new); m['owner_correction']=owner
for row in m['hqs']:
    if row['id']=='hqn_19':
        row['source']=new_path; row['sha256']=sha(r/new_path)
        row['normalized_text_sha256']=hashlib.sha256(new.encode()).hexdigest()
        rows=[s for s in new.splitlines() if s.startswith('| ') and s.split('|')[1].strip().isdigit()]
        row['panel_rows_sha256']=hashlib.sha256('\n'.join(rows).encode()).hexdigest()
    src=(r/row['source']).read_text(encoding='utf-8')
    assert '## '+src[2:].rstrip() in volume
    assert sha(r/row['source'])==row['sha256']
(r/'.atena/generated/chapter2-editorial-20261017/consolidated-r2.json').write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
selection_path='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-visual-selection-r1.md'
assert (r/selection_path).is_file()
audit=json.loads((base/'audit-r1.json').read_text(encoding='utf-8'))
assert len(audit)==28 and all(sha(Path(row['path']))==row['sha256'] for row in audit)
selection={'id':'HQ19-VISUAL-SELECTION-20261017','revision':'r1','status':'DRAFT_SELECTION_AWAITING_OWNER_APPROVAL','scope':'reference audit and visual selection only','direct_reuse':0,'new_compositions':12,'identity_reference_entries':12,'reuse_audit_entries':16,'spec':selection_path,'screenplay':new_path,'owner_correction':decision,'generation_authorized':False,'runtime_authorized':False,'selection_blocking_gaps':[],'resolvable':['owner acceptance of DRAFT reference packages','indirect statue depiction without new canonical face'],'deferred':['candidate production','architectural detail','legible canonical glyphs','runtime integration'],'panels':[{'panel':i,'strategy':'new composition using inspected references'} for i in range(1,13)]}
(base/'selection-r1.json').write_text(json.dumps(selection,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ19-VISUAL-SELECTION-20261017-r1.md'
(r/evidence).write_text('''# Seleção visual HQ19 — r1

Pedido IN_PLAN de preparação visual após plano editorial concluído: conferir referências/personagens e reaproveitamento; PC, modo per-step existente. Etapa S-V19-001: proposta preparada, aguardando CP-V19-01. Produção não autorizada.

Autoridade e contexto: HQ19 CANON r2; bíblia DRAFT r2 e imagens aceitas no capítulo 1; direção Kayron branco preservada. Divergência de asas apresentada ao dono e resolvida explicitamente: Aila sem asas em todos os quadros, ajustando Q1 aprovado. Criadas decisão CANON, HQ19 r2 e consolidação capítulo 2 r2, mantendo r1 e as outras nove HQs sem alteração.

Inspeção: 12 entradas de identidade e 16 entradas de acervo/comparação (15 cenas PNG e uma prancha anterior), todas exibidas em duas pranchas locais de auditoria; Aila frontal, Thalion frontal e martelo HQ18 Q5 vistos individualmente. Pranchas são apoio de inspeção, não novas artes da HQ. Manifesto audit-r1.json contém caminhos, dimensões e hashes. Nenhuma afirmação de auditoria universal do vault/backups.

Encontrados Aila sem asas, Thalion e Bromnor no vault; seus pacotes mantêm estado DRAFT. Referências atuais do grupo e Kayron branco conferidas. Reaproveitamento proposto: identidades, martelo, jardim/Véu, efeitos de raízes; zero quadros prontos reutilizáveis e 12 composições novas. HQ11 consultada somente como referência de Bromnor/energia, sem reativar seleção removida.

Propostas e limites por quadro no spec hq19-visual-selection-r1.md. Templo de Dagruve sem copiar templo posterior; estátua indireta sem novo rosto canônico; portais roxos; terra material do templo não vira solo abissal; machado de Xar'gath excluído; amarelo antes e transição para vermelho no legado. Prontidão textual da seleção sem BLOCKING; aprovação das bases/encenação pendente. Produção, glifos definitivos e detalhamento arquitetônico diferidos.

Checks: 12 quadros, referências existentes e hashes/dimensões válidos; consolidação r2 com 10 HQs/75 quadros e nove fontes individuais inalteradas; YAML válido; autorizações de arte/runtime falsas. Sem alteração de código, imagens oficiais, saves ou vault externo; testes de runtime não se aplicam à pesquisa/documentação.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; text=state.read_text(encoding='utf-8')
assert '  hq19_visual_selection:' not in text
block=f'''  hq19_visual_selection:
    plan: PLAN-NOTTGARD-HQ19-VISUAL-SELECTION-20261017
    revision: r1
    classification: IN_PLAN_VISUAL_PREPARATION_AFTER_EDITORIAL_CLOSEOUT
    status: DRAFT_SELECTION_AWAITING_OWNER_APPROVAL
    mode: per-step
    current_step: S-V19-001
    completed_steps: 0
    total_steps: 1
    activity: REFERENCE_AUDIT_AND_SELECTION_PROPOSAL_DELIVERED
    checkpoint: CP-V19-01
    authorization: 'Atena, vamos começar a seleção visual da HQ19, conferindo as referências dos personagens e o que podemos reaproveitar. (2026-10-17)'
    approval: PENDING_SELECTION_R1
    spec: {selection_path}
    manifest: .atena/generated/hq19-selection-20261017/selection-r1.json
    audit: .atena/generated/hq19-selection-20261017/audit-r1.json
    references_preview: .atena/generated/hq19-selection-20261017/references-r1.jpg
    reuse_preview: .atena/generated/hq19-selection-20261017/reuse-audit-r1.jpg
    evidence: EVID-NOTTGARD-HQ19-VISUAL-SELECTION-20261017-r1
    aila_owner_correction: {decision}
    generation_authorized: false
    runtime_authorized: false
    next_activity: 'Confirmar seleção visual r1; produção de Q1 requer escopo próprio'
'''
text=text.replace('  chapter_2_review:\n',block+'  chapter_2_review:\n',1)
text=text.replace(old_path,new_path).replace(vol_old,vol_new).replace('consolidated_manifest: .atena/generated/chapter2-editorial-20261017/consolidated-r1.json','consolidated_manifest: .atena/generated/chapter2-editorial-20261017/consolidated-r2.json',1)
text=text.replace('hq19_approval: APPROVED_R1_WITH_BROOK_HANDOVER_AND_DAGRUVE_SPLIT','hq19_approval: APPROVED_R2_AILA_WINGLESS_BROOK_HANDOVER_DAGRUVE_SPLIT',1)
text=text.replace("  next_activity: 'Roteiros dos dois capítulos aprovados; capítulo 2 consolidado em CANON'","  next_activity: 'HQ19: seleção visual r1 apresentada; capítulo 2 CANON r2 com Aila sem asas'",1)
yaml.safe_load(text); state.write_text(text,encoding='utf-8')
for path in [selection_path,evidence,new_path,vol_new,decision]: assert (r/path).exists()
assert len(re.findall(r'^\| \d+ \|',new,re.M))==12
print(json.dumps({'status':selection['status'],'direct_reuse':0,'new_compositions':12,'inspected_entries':28,'screenplay':new_path,'chapter2':vol_new,'yaml':'PASS'},ensure_ascii=False))
