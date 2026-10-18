from pathlib import Path
import json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'q9-production-r1.json'; prior=json.loads(p.read_text(encoding='utf-8'))
assert prior['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/prior['candidate']).read_bytes()).hexdigest()==prior['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ19-Q9-20261017-r1.md'
brief='.atena/specs/SPEC-NOTTGARD-CHAPTER2-EDITORIAL-20261017/hq19-q10-production-brief-r1.md'
assert not (r/approval).exists() and not (base/'q10-production-r1.json').exists()
(r/approval).write_text(f'''# HQ19 Q9 — aceite individual v01

CANON_OWNER_ASSET_APPROVAL. 2026-10-17. O dono respondeu “aprovado” à Q9 v01. S-P19-Q09 concluída. Arquivo: `{prior['candidate']}`. SHA-256: `{prior['sha256']}`. Dimensões: 1672×941. Aprovada captura física de Maelor e Aila por guardas, Maelor em rendição. Nove de 12 aceitas. Sem admissão no runtime. Aceite autoriza próxima candidata conforme regra explícita de continuidade.
''',encoding='utf-8')
(r/brief).write_text('''# HQ19 Q10 — produção r1

Estado: AUTHORIZED. Classificação IN_PLAN. S-P19-Q10, décima de 12; nove concluídas e três restantes incluindo esta. Uma candidata PC, com aceite individual; regra de continuidade vigente.

Escopo: Maelor algemado diante de Thalion, que o interroga sobre Kayron; Aila sob custódia ao fundo. Não inventar resposta ou fala nova. Enquadramento restrito no mesmo templo, sem definir prisão/planta nova. Preservar identidades e roupas de Q9/Q5, Aila sem asas e ilesa, Thalion vivo em aparência de conselheiro. Mãos algemadas visíveis, tensão e gesto de pergunta; sem tortura, ferimento, runa, raízes ou portal antecipado.

Texto CANON separado: “Sob custódia, Maelor foi interrogado por Thalion.” Entradas: roteiro CANON HQ19 r2, seleção r1 aprovada, bible DRAFT r2 autorizada como direção, Q9/Q5 aceitas. Saída: candidata pixel art denso horizontal aproximadamente 16:9, sombras frias e velas âmbar, faixa inferior calma, sem letras/UI/marca. Checks: identidade dos três, algemas e interrogatório legíveis, Aila retida no lado material, cronologia preservada, arquivo/dimensões/hash. Zero BLOCKING. Integração e testes no leitor fora deste escopo.
''',encoding='utf-8')
prompt='''Use case: illustration-story. Generate ONE new cinematic landscape approximately 16:9, ideally 1672x941, dark fantasy PIXEL ART comic illustration for Nottgard HQ19 panel 10.
REFERENCE ROLES: Image 1 provides the accepted faces, costumes and physical custody of Maelor and Aila, the anonymous guard armor and candlelit stone temple. Maelor: adult man with side-swept brown hair, short beard/moustache, tan high leather collar, grey layered cloak, blue/gold garments, brown straps, blue vials, no horns. Aila: pale ash-blonde loosely tied hair, charcoal layered worn robe/cloak, brown belt/boots, fully covered, NO WINGS, alive and uninjured. Image 2 provides THALION identity/costume only: tall slender adult elf, pointed ears, long pale blonde wavy hair, BLUE eyes, clean-shaven sharp face, elaborate gold armor over deep blue clothes, deep red embroidered cape, RED wide angular hat with blue central panel and sweeping gold ornaments. Maintain his recognizable face, hat and clothes; alive/unharmed, no demonic transformation. Use both references for dense pixel-art visual continuity.
NARRATIVE: Under custody after surrender, Maelor is being interrogated by Thalion about the escaped Kayron. No answer is invented. Intimate medium-wide three-quarter shot, Maelor at left foreground in profile/three-quarter facing Thalion at right foreground. Both faces clearly readable. Maelor stands upright with wrists restrained together in simple iron HANDCUFFS in FRONT at waist height, short chain between cuffs clearly visible; no chains around neck, no binding to furniture. His expression guarded and worried, mouth closed, no answer. Thalion faces him sternly, leaning slightly forward with a restrained open-hand questioning gesture, mouth slightly open as he demands information. This is questioning under authority, no physical attack, weapon or torture. Thalion's other hand relaxed, both have anatomically plausible hands.
In the middle-background, visible in the gap between or beside the two men, Aila stands under guard custody, one helmeted soldier beside her holding her upper arm. Her recognizable face and dark clothes visible but less prominent than the interrogation; anxious and unhurt, without wings. She is not released or sent anywhere. Guard armor follows reference 1. Only these named characters; no Kayron, Brook, Leoric, Korrak or other companion.
Same old stone temple at Dagruve, close framing with dark Gothic column/arch, warm candle clusters, cool blue shadows; avoid establishing a different dungeon cell, throne room, detailed new prison or interrogation furniture. No active roots, magical shield, glyphs, purple portal or abyssal transfer: those occur later. No blood, bruises, execution, corpse or violent contact. No maps or written documents implying an answer.
STYLE: sophisticated dense crisp PIXEL ART with controlled dithering and detailed metal/fabric/stone, strong readable faces and hands, mature proportions matching approved illustrations. Not photorealism, anime or smooth 3D. Keep lower edge relatively calm for separately rendered game narration. NO words, letters, caption, speech balloons, UI, logo, watermark, borders or panel subdivisions. ONE complete full-frame illustration.'''
(base/'q10-tool-prompt-v01.txt').write_text(prompt,encoding='utf-8')
paths=[base/'candidates/hq_n19_q9_surrender_v01.png',base/'candidates/hq_n19_q5_thalion_command_v01.png']
(base/'q10-production-r1.json').write_text(json.dumps(dict(status='AUTHORIZED_IN_PROGRESS',step='S-P19-Q10',authorization='Q9 aprovada (2026-10-17), continuidade explicitamente autorizada',authorization_canon='.atena/vault/canon/DEC-HQ-CANDIDATE-APPROVAL-CONTINUATION-20261017-r1.md',tool='built-in image_gen',references=[dict(path=p.as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in paths],tool_prompt='q10-tool-prompt-v01.txt',screenplay='.atena/vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r2.md',runtime_authorized=False),ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
for old,new in [('q9_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL','q9_production_status: APPROVED_V01'),('q9_approval: PENDING_V01',"q9_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('approved_visual_panels: 8','approved_visual_panels: 9'),("next_activity: 'Aceite individual HQ19 Q9 v01; aprovação autoriza próxima candidata Q10'","next_activity: 'Produzir candidata HQ19 Q10 autorizada por continuidade; 9/12 aprovadas'")]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f"    q9_asset_approval: {approval}\n    q10_brief: {brief}\n    q10_production_status: AUTHORIZED_IN_PROGRESS\n    q10_production_authorization: 'Q9 aprovada (2026-10-17), continuidade autorizada'\n    q10_production_record: .atena/generated/hq19-production-20261017/q10-production-r1.json\n"
t=t[:a]+block+t[b:]; yaml.safe_load(t)
prior.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite individual Q9 v01',approval_canon=approval)
p.write_text(json.dumps(prior,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q9-CANDIDATE-20261017-r1.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite individual\n\nQ9 aprovada: “aprovado”. Hash reconferido e aceite canônico registrado. Nove de 12 aceitas; Q10 preparada e autorizada pela regra de continuidade. Sem integração.\n')
print('PASS: Q9 aprovada, hash conferido; Q10 preparada e autorizada; YAML válido.')
