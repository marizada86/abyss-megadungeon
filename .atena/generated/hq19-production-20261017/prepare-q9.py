from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q8-production-r1.json'; prior=json.loads(p.read_text(encoding='utf-8'))
assert prior['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/prior['candidate']).read_bytes()).hexdigest()==prior['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q8-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q9-production-brief-r1.md'
assert not (r/approval).exists() and not (base/'q9-production-r1.json').exists()
(r/approval).write_text(f'''# HQ19 Q8 — aceite individual v01

CANON_OWNER_ASSET_APPROVAL. 2026-10-17. O dono respondeu “aprovado” à Q8 v01. S-P19-Q08 concluída. Arquivo: `{prior['candidate']}`. SHA-256: `{prior['sha256']}`. Dimensões: 1672×941. Aprovadas raízes apodrecendo antes de alcançar Maelor e Aila sem asas ilesa. Oito de 12 aceitas. Sem admissão no runtime. Conforme decisão explícita de continuidade, este aceite autoriza produzir Q9 no roteiro e seleção vigentes.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q9 — produção r1

Estado: AUTHORIZED. Classificação IN_PLAN. Etapa S-P19-Q09, nona de 12; oito concluídas e quatro restantes incluindo esta. Uma candidata PC, aceite individual; aprovação anterior autoriza próxima candidata conforme DEC-HQ-CANDIDATE-APPROVAL-CONTINUATION-20261017-r1.

Escopo: guardas prendem fisicamente Maelor e Aila no templo de Dagruve; Maelor se rende para protegê-la. Identidades, roupas e ambiente do Q8 aprovado. Aila sem asas e ilesa, Maelor sem chifres. Mostrar mãos e postura de rendição de Maelor, guardas segurando braços, sem agressão consumada, ferimento ou raízes eficazes. Não antecipar interrogatório ou envio por portal. Guardas anônimos seguem armadura do Q5, sem nova ordem militar. Raízes do Q8 podem permanecer mortas no chão, nunca prendendo personagens.

Fala CANON separada da arte: Maelor: “Não machuque ela, a gente vai em paz, já estou rendido.” Não embutir texto. Entradas: roteiro HQ19 CANON r2, seleção aprovada r1, bible DRAFT r2 autorizada como direção; Q8 aceita e Q5 aceita. Saída: candidata horizontal aproximadamente 16:9, pixel art denso com dithering, velas âmbar e pedra fria, faixa inferior calma. Inspeção visual de identidade, captura física e rendição, ausência de ferimento/portal/raízes prendendo, arquivo/dimensões/hash. Zero BLOCKING. Integração e teste no leitor permanecem fora desta produção.
''',encoding='utf-8')
prompt='''Use case: illustration-story. Generate ONE new full-frame landscape approximately 16:9 (ideally 1672x941) dense dark fantasy pixel-art comic illustration for Nottgard HQ19 panel 9.
Reference 1 is the APPROVED PREVIOUS PANEL: preserve Maelor and Aila's recognizable faces, outfits, proportions and candlelit Gothic stone temple. Maelor: adult man with side-swept brown hair, short beard and moustache, tan high leather collar, grey layered cloak, blue/gold garment, straps and blue vials. No horns. Aila: pale ash-blonde hair loosely tied back, soft pale face, charcoal worn layered robe and cloak, brown belt and boots, fully covered, NO WINGS, unharmed. Reference 2 is GUARD ARMOR and temple style only: anonymous soldiers in restrained dark steel plate, closed helmets, blue-grey cloth. Do NOT reproduce Thalion in this image.
NARRATIVE: After the magical roots failed, the guards now capture Maelor and Aila PHYSICALLY. Maelor surrenders voluntarily to protect Aila. A clear medium-wide shot showing both faces, hands and guards' grips. Maelor near center-left, visibly calm but worried, mouth slightly open pleading to guards, both hands open and raised to chest height in surrender, not casting. One helmeted guard at his outer side holds his upper arm firmly with a gauntleted hand while his palms remain visible. Aila beside him at center-right, anxious but completely uninjured; another helmeted guard stands at her outer side and holds her upper arm securely but without striking, choking, twisting or tearing clothes. Clear natural separation of bodies and hands; two arms per figure, no extra limbs. Her posture is upright, not kneeling or collapsed. Maelor turns slightly toward the guards, staying beside Aila. This is surrender and arrest, not a fight or rescue. The two principal guards are sufficient; any more guards only distant subdued silhouettes.
Background: same temple's worn stone arches and columns, candles glowing warm amber, cool blue shadow. Small remnants of shriveled roots may lie inert at far floor edges, but roots do NOT touch or restrain anyone. There are NO active roots, purple portals, glowing runes, protective shields, magic attacks, wounds, blood, torture, weapons touching skin, chains around necks or interrogation chair. Do not show Maelor being sent to the Abyss yet. Do not include Kayron, Brook, Leoric, Korrak or other named companions.
Match reference 1's crisp sophisticated dense PIXEL ART, controlled dithering, rich cloth and metal and stone details, dark fantasy cinematic lighting and readable faces, NOT photorealism or smooth 3D. Lower strip calm dark stone for separately rendered game dialogue. Maelor's spoken line is added by the game, so absolutely NO text, letters, caption, balloons, UI, logos, watermark, panel borders or subdivisions. ONE full illustration.'''
(base/'q9-tool-prompt-v01.txt').write_text(prompt,encoding='utf-8')
paths=[base/'candidates/hq_n19_q8_roots_decay_v01.png',base/'candidates/hq_n19_q5_thalion_command_v01.png']
(base/'q9-production-r1.json').write_text(json.dumps(dict(status='AUTHORIZED_IN_PROGRESS',step='S-P19-Q09',authorization='Q8 aprovada (2026-10-17), continuidade explicitamente autorizada',authorization_canon='.atena/vault/canon/DEC-HQ-CANDIDATE-APPROVAL-CONTINUATION-20261017-r1.md',tool='built-in image_gen',references=[dict(path=p.as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in paths],tool_prompt='q9-tool-prompt-v01.txt',screenplay='.atena/vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r2.md',runtime_authorized=False),ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
for old,new in [('q8_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q8_production_status: APPROVED_V01'),('q8_approval: PENDING_V01',"q8_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 7','approved_visual_panels: 8'),("next_activity: 'Aceite individual HQ19 Q8 v01; aprovação autoriza próxima candidata Q9'","next_activity: 'Produzir candidata HQ19 Q9 autorizada por continuidade; 8/12 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f"    q8_asset_approval: {approval}\n    q9_brief: {brief}\n    q9_production_status: AUTHORIZED_IN_PROGRESS\n    q9_production_authorization: 'Q8 aprovada (2026-10-17), continuidade autorizada'\n    q9_production_record: .atena/generated/hq19-production-20261017/q9-production-r1.json\n"
t=t[:a]+block+t[b:]; yaml.safe_load(t)
prior.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q8 v01',approval_canon=approval)
p.write_text(json.dumps(prior,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q8-CANDIDATE-20261017-r1.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nQ8 aprovada pelo dono: “aprovado”. Hash reconferido, aceite canônico registrado. Oito de 12 aceitas. Q9 preparada e autorizada pela regra de continuidade. Sem integração.\n')
print('PASS: Q8 aprovada, hash conferido; Q9 preparada e autorizada, referências presentes, YAML válido.')
