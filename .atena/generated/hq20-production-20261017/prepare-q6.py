from pathlib import Path
import json,hashlib,re,yaml
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
p=base/'q5-production-r1.json'; prior=json.loads(p.read_text(encoding='utf-8'))
assert prior['owner_approval']=='PENDING_V01'
assert hashlib.sha256((r/prior['candidate']).read_bytes()).hexdigest()==prior['sha256']
approval='.atena/vault/canon/ASSET-APPROVAL-HQ20-Q5-20261017-r1.md'
spec='.atena/specs/SPEC-NOTTGARD-HQ20-COMPLETION-20261017/q6-r1.md'
assert not (r/approval).exists() and not (base/'q6-production-r1.json').exists()
(r/approval).write_text(f'''# HQ20 Q5 — aceite v01

CANON_OWNER_ASSET_APPROVAL. 2026-10-17. O dono respondeu “aprovado” à Q5 v01. Arquivo `{prior['candidate']}`, SHA-256 `{prior['sha256']}`, 1672×941. Aprovada representação de Nidhogg como cobra gigante guardiã de Yggdrasil, corpo escamoso escuro, sem patas/asas/chifres, tentativa de mordida com Maelor ileso fora da boca. Esta cena serve como referência visual para continuidade Q6. Cinco de sete quadros com aceites individuais; candidata seguinte autorizada pela regra de continuidade, sem admissão no runtime.
''',encoding='utf-8')
(r/spec).write_text('''# HQ20 Q6 — produção r1

AUTHORIZED. IN_PLAN. S-P20-Q06, etapa 4/5 complementar, 3 concluídas e 2 restantes. Uma candidata PC autorizada pelo aceite Q5 e regra de continuidade. Entrada: roteiro CANON HQ20 r1, bible DRAFT r2 autorizada, Q5 aceita para Maelor/Nidhogg/ambiente e Q3 v02 aceita para passagem roxa/recorte de Shedaklah.

Cena: Maelor corre pela raiz de madeira de Yggdrasil rumo ao portal roxo; Nidhogg permanece vivo atrás. Sem golpe, morte, queda, nova mordida ou ferimento. Maelor sozinho no lado da raiz, roupa/face Q5, mãos livres, sem feitiço/arma. Nidhogg mesma cobra gigante escura sem membros/asas/chifres. Portal destino com terreno fúngico restrito, não importar Marciela/Leoric/Korrak da Q3 nem mostrar reunião antecipada. Madeira robusta e universo preservados. Legenda externa CANON: “Maelor fugiu em direção ao portal.” Arte sem texto/UI/marca, pixel art denso horizontal aproximadamente 16:9. Checks: corrida em direção à abertura, distância da cobra viva, identidade, anatomia e apoio na raiz, ausência de novos acontecimentos, PNG/dimensões/hash. Zero BLOCKING. Sem runtime ou teste no leitor.
''',encoding='utf-8')
prompt='''Use case: illustration-story. Generate ONE new cinematic landscape approximately 16:9 ideally 1672x941 dark fantasy PIXEL ART comic illustration for Nottgard HQ20 panel 6.
REFERENCE 1 is the APPROVED preceding panel: preserve Maelor's recognizable face, brown side-swept hair, short beard/moustache, tan high leather collar, grey layered cloak, blue/gold garment, leather straps and small blue vials. Preserve NIDHOGG's accepted appearance: a giant dark charcoal/earth-brown scaled SNAKE, massive head with golden reptile eye, lighter underside, enormous long thick legless body, no wings, legs, horns or new powers. Keep robust warm-brown WOOD root/trunk/branches and cosmic universe filled with stars/galaxies. Reference 2 is the accepted PURPLE PASSAGE with a restricted view of fungal terrain beyond, plus wood/cosmic style. IGNORE AND EXCLUDE Marciela, Korrak and Leoric from reference 2. This is Maelor's solitary route, not their simultaneous encounter.
NARRATIVE: Maelor FLEES TOWARD THE PORTAL after escaping the missed bite. Nidhogg remains ALIVE behind him. New dynamic wide three-quarter side view, clear left-to-right movement along the root. Maelor center-right mid-stride RUNNING on the broad solid wood root toward an open glowing PURPLE portal at right, head and torso pointed toward escape, face partly readable in profile, cloak streaming behind, empty hands moving naturally, no spellcasting or weapon. One planted foot and the other in natural running stride; no falling or levitation. His whole body still on the root side, not already through or stopped posing.
The portal at right is clearly reachable further along the same root, its violet luminous rim reveals a restrained slice of misty fungal terrain with giant mushroom silhouettes matching reference 2. No carved stone gate or rune alphabet, no new named location or buildings. NO other person inside or near the opening. Maelor runs TO it, not away. Farther back at left, Nidhogg's huge recognizable living snake head and thick coiling body follow or loom over the root, at a CLEAR SAFE SEPARATION from Maelor. Its eyes open, body intact, alert threat persists, not defeated, injured, dead or falling. Avoid another bite close to Maelor; the near miss was previous panel. No teeth touching him. No strike from Maelor, no magic bolt, explosion, blood, wounds, shattered tree or attack on the snake.
Root remains colossal warm robust wood, longitudinal grain and thick bark plates, rounded knots and massive junctions, visible side face into deep cosmic space, same golden wood highlights and cool blue star shadows. No earth/stone floor or red fissures. Exactly ONE human, Maelor, and ONE serpent; no Marciela, Aila, Leoric, Korrak, Thalion or Brook, no reunion yet. Maintain clear silhouettes, dramatic escape urgency with no invented combat outcome. Lower strip quieter wood for separately rendered narration.
STYLE: sophisticated dense crisp PIXEL ART matching approved references, controlled dithering and detailed wood, scales and fabric, cinematic dark fantasy lighting, adult proportions, no photorealistic smooth 3D, chibi or anime. No words, letters, captions, speech balloons, UI, watermark, logo, borders or panel subdivisions. ONE complete illustration.'''
(base/'q6-prompt-v01.txt').write_text(prompt,encoding='utf-8')
refs=[base/'candidates/hq_n20_q5_nidhogg_misses_v01.png',base/'candidates/hq_n20_q3_passage_v02.png']
(base/'q6-production-r1.json').write_text(json.dumps(dict(status='AUTHORIZED_IN_PROGRESS',step='S-P20-Q06',authorization='Q5 aprovada (2026-10-17), próxima candidata autorizada',tool='built-in image_gen',tool_prompt='q6-prompt-v01.txt',references=[dict(path=p.as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in refs],runtime_admitted=False),ensure_ascii=False,indent=2),encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; m=re.search(pattern,t); assert m
block=m.group()
for old,new in [('status: Q5_CANDIDATE_V01_AWAITING_OWNER_APPROVAL','status: Q6_AUTHORIZED_IN_PROGRESS'),('current_step: S-P20-Q05','current_step: S-P20-Q06'),('completed_steps: 2','completed_steps: 3'),('q5_approval: PENDING_V01',"q5_approval: 'APPROVED_V01: aprovado (2026-10-17)'"),('next_activity: Aceite Q5 v01; aprovação autoriza Q6 fuga de Maelor','next_activity: Produzir Q6; Maelor foge rumo ao portal e Nidhogg permanece vivo'),('future_gap: Nenhum BLOCKING para Q5; primeira candidata de Nidhogg sujeita a aceite','future_gap: Nenhum BLOCKING para Q6; Nidhogg visual aprovado na Q5')]:
    assert old in block,old
    block=block.replace(old,new,1)
block+=f'  q5_asset_approval: {approval}\n  q6_spec: {spec}\n  q6_record: .atena/generated/hq20-production-20261017/q6-production-r1.json\n'
t=t[:m.start()]+block+t[m.end():]; yaml.safe_load(t)
prior.update(status='APPROVED_V01',owner_approval='aprovado (2026-10-17), aceite Q5 v01',approval_canon=approval)
p.write_text(json.dumps(prior,ensure_ascii=False,indent=2),encoding='utf-8'); state.write_text(t,encoding='utf-8')
with (r/'.atena/evidence/EVID-NOTTGARD-HQ20-Q5-CANDIDATE-20261017-v01.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite\n\nQ5 v01 aprovada: “aprovado”. Hash reconferido, aceite canônico registrado e Nidhogg desta cena admitido como referência visual de continuidade. Cinco de sete aceitas. Q6 preparada/autorizada. Sem integração.\n')
print('PASS: Q5 aprovada, hash conferido; Q6 preparada e autorizada, estado válido.')
