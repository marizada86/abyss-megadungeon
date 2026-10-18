from pathlib import Path
import json,hashlib,re,yaml
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
p=base/'q2-v02-production-r1.json'; prior=json.loads(p.read_text(encoding='utf-8'))
assert prior['owner_approval']=='PENDING_V02'
assert hashlib.sha256((r/prior['candidate']).read_bytes()).hexdigest()==prior['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ20-Q2-20261017-r1.md'
assert not (r/approval).exists() and not (base/'q3-v02-production-r1.json').exists()
(r/approval).write_text(f'''# HQ20 Q2 — aceite v02

CANON_OWNER_ASSET_APPROVAL. Data 2026-10-17. O dono respondeu “aprovado” à Q2 v02 com visual de Marciela atualizado pelo pacote CHAR-038 aprovado. Arquivo `{prior['candidate']}`, SHA-256 `{prior['sha256']}`, 1672×941. Q2 concluída; Q1/Q3/Q4 já tinham aceites próprios. V01 genérica preservada como superada. Aceite autoriza candidata seguinte pela regra de continuidade; reconciliar Q3 com mesma personagem sem alterar roteiro. Sem integração ou promoção integral do pacote DRAFT externo.
''',encoding='utf-8')
spec='.atena/specs/SPEC-NOTTGARD-HQ20-COMPLETION-20261017/q3-correction-r1.md'
(r/spec).write_text('''# HQ20 Q3 — correção de continuidade r1

AUTHORIZED. IN_PLAN, S-P20-Q03C, etapa 2/5 do plano complementar após Q2 aceita, 1 concluída e 4 restantes. A lista incorpora correção de continuidade resultante do pedido explícito de Marciela oficial; regra de aceite autorizando próxima candidata vigente. Preservar Q3 v01 e aceite histórico, não revogar nem alterar fontes do plano de referências/mapa. Uma candidata Q3 v02 substitui apenas figura genérica de Marciela por mesma aparência da Q2 v02 e pacote CHAR-038: capuz, cabelo solto, vestes gastas e tiras/cintos. Manter gesto apontando passagem, costas/três quartos, Leoric/Korrak, madeira robusta e universo, portal roxo e terreno fúngico. Não acrescentar evento de aquisição de item da S17.

Entradas: roteiro CANON HQ20 r1, bible DRAFT r2, Q3 aceita como alvo, Q2 v02 aceita para continuidade, referência costas/frente mestre CHAR-038 aprovada como identidade (origem DRAFT). Texto externo preservado: “Ela os guiou por uma passagem para Shedaklah.” Sem texto na arte. Zero BLOCKING. Checks: roupa/identidade de Marciela, gesto, continuidade do resto, ausência de arma posterior, PNG/dimensões/hash. Sem runtime ou testes no leitor. Nidhogg ainda requer referência antes de Q5/Q6.
''',encoding='utf-8')
prompt='''Use case: identity-preserve image edit. Edit image 1, the existing Nottgard HQ20 panel 3. Change ONLY the generic featureless dark silhouette of Marciela standing just left of the purple portal and pointing to it. Preserve exact landscape composition, portal position/shape/PURPLE color, fungal landscape through portal, cosmic stars/galaxies, warm robust wood bark/root/trunk, Leoric and Korrak with unchanged faces, poses, costumes, size, positions and blue-crystal staff. No axe on Korrak. Keep all other image content intact.
Image 2 is the ACCEPTED UPDATED Marciela from previous panel, use for exact scene-to-scene costume consistency. Image 3 is official BACK clothing reference; image 4 official FRONT master for identity/costume only. Replace Marciela's plain black-purple cloak with her approved worn DARK BROWN/CHARCOAL layered ragged long tunic/coat, muted olive-brown tattered hood UP, ragged shoulder mantle, crossed brown leather straps across back, two broad brown leather waist belts with rectangular buckles, fitted leather forearm bracers, dark trousers and brown boots. Long loose wavy BROWN hair, not braid, visible only where natural under hood. Match texture and weathered fabric of image 2 and references. Do not introduce new weapon, bow, pack, jewelry, crest or magical effect. Both hands empty.
Maintain Marciela's exact place and original narrative gesture: seen from behind/three-quarter back, her right arm extended POINTING THROUGH THE PASSAGE, guiding Leoric and Korrak. Feet supported on root, no posing toward camera. Back view need not show face; do not invent a different face, species or age. Light the clothing enough to clearly see hood, ragged layered mantle, cross straps and double belts. Strong purple portal rim lighting is natural, but do not make her a featureless silhouette or solid purple glow. Her lower coat is ragged layered fabric, not an enormous smooth flowing cape. Only she changes; no alterations to men, tree, portal or landscape.
Match existing dense crisp dark fantasy PIXEL ART, controlled dithering and warm wood/cloth pixel clusters; do not copy flat character-sheet backgrounds or smooth 3D shading. One complete landscape approximately 16:9 ideally 1672x941. No text, letters, caption, speech bubbles, UI, logo, watermark, border or panel subdivisions.'''
(base/'q3-prompt-v02.txt').write_text(prompt,encoding='utf-8')
refroot=Path('D:/dev/nottgard/vault/output/referencias-personagens/CHAR-038/S17-S18-manto-pantano/r01')
refs=[base/'candidates/hq_n20_q3_passage_v01.png',base/'candidates/hq_n20_q2_marciela_meeting_v02.png',refroot/'marciela-back-v01-hq.png',refroot/'marciela-front-candidate-v02-hq.png']
(base/'q3-v02-production-r1.json').write_text(json.dumps(dict(status='AUTHORIZED_IN_PROGRESS',step='S-P20-Q03C',authorization='Q2 v02 aprovada; correção de continuidade de Marciela oficial e regra de próxima candidata',tool='built-in image_gen edit',tool_prompt='q3-prompt-v02.txt',references=[dict(path=q.as_posix(),sha256=hashlib.sha256(q.read_bytes()).hexdigest()) for q in refs],spec=spec,runtime_admitted=False),ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8')
pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'
match=re.search(pattern,t); assert match
block=match.group()
for old,new in [('status: Q2_CANDIDATE_V02_AWAITING_OWNER_APPROVAL','status: Q3_OFFICIAL_MARCIELA_CORRECTION_IN_PROGRESS'),('current_step: S-P20-Q02','current_step: S-P20-Q03C'),('ordered_steps: [S-P20-Q02, S-P20-Q05, S-P20-Q06, S-P20-Q07]','ordered_steps: [S-P20-Q02, S-P20-Q03C, S-P20-Q05, S-P20-Q06, S-P20-Q07]'),('completed_steps: 0','completed_steps: 1'),('total_steps: 4','total_steps: 5'),('q2_approval: PENDING_V02',"q2_approval: 'APPROVED_V02: aprovado (2026-10-17)'"),('next_activity: Aceite Q2 v02; reconciliar visual de Marciela na Q3 antes de sequência completa','next_activity: Produzir Q3 v02 com Marciela oficial, demais conteúdos preservados')]:
    assert old in block,old
    block=block.replace(old,new,1)
# Reconcile only known HQ fields inadvertently appended after another chat's top-level section.
keys=['q2_v01_result','q2_v02_record','marciela_reference','q2_v02_candidate','q2_v02_evidence','marciela_q3_continuity']
outside=t[:match.start()]+t[match.end():]
for key in keys:
    found=re.search(r'^  '+key+r': .*\n',outside,re.M)
    if found:
        block+=found.group(); outside=outside[:found.start()]+outside[found.end():]
block=block.replace('marciela_q3_continuity: RECONCILIATION_PENDING_OFFICIAL_REFERENCE','marciela_q3_continuity: CORRECTION_AUTHORIZED_IN_PROGRESS')
block+=f'  q2_asset_approval: {approval}\n  q3_correction_spec: {spec}\n  q3_v02_record: .atena/generated/hq20-production-20261017/q3-v02-production-r1.json\n'
# Preserve every unrelated section; insert the reconciled block in its previous position.
t=re.sub(pattern,lambda _:block,t,count=1)
for key in keys:
    occurrences=list(re.finditer(r'^  '+key+r': .*\n',t,re.M))
    if len(occurrences)>1:
        for duplicate in reversed(occurrences[1:]): t=t[:duplicate.start()]+t[duplicate.end():]
yaml.safe_load(t)
prior.update(status='APPROVED_V02',owner_approval='aprovado (2026-10-17), aceite Q2 v02',approval_canon=approval)
p.write_text(json.dumps(prior,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ20-Q2-CANDIDATE-20261017-v02.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite\n\nQ2 v02 aprovada: “aprovado”. Hash conferido e aceite canônico registrado. Correção Q3 preparada por continuidade, preservando antiga imagem e aceite histórico. Reconciliados campos operacionais desta HQ no bloco próprio do estado, mantendo demais planos.\n')
print('PASS: Q2 v02 aprovada, Q3 v02 preparada; estado reconciliado sem substituir outros planos.')
