from pathlib import Path
from PIL import Image
import shutil,json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
src=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-7c1e836d-8f5e-4103-b088-29b0ed5a61e7.png')
dst=base/'candidates/hq_n19_q1_aila_freed_v01.png'
assert src.is_file() and not dst.exists(); shutil.copy2(src,dst)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==sha(dst)
with Image.open(dst) as im: size=list(im.size); im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
prompt="""Create ONE new 16:9 landscape Nottgard dark fantasy comic panel, HQ19 Q1. Reference image 1: AILA IDENTITY ONLY, pale ash-blonde loosely tied hair, same face, worn fully covering charcoal layered robe/cloak, brown belt and boots. Reference image 2: garden, Living Veil tree and accepted detailed pixel art style ONLY, ignore all characters and enemies. Reference image 3: ornate rectangular golden hammer design and pixel art style ONLY, ignore corpses, monsters and abyssal setting. Scene is AFTER Helion's sacrifice. In the beautiful garden of red flowers and weathered stones, the large fallen pale ice-blue crystalline star Ailalore has split into TWO substantial luminous halves, revealing AILA lying safely UNCONSCIOUS inside its low central cradle. Clearly human-sized star large enough to have contained her. Aila lies on her back with closed eyes, head slightly elevated and face clearly visible in three-quarter profile, fully dressed in referenced charcoal clothes, peaceful exhausted expression, uninjured. ABSOLUTELY NO WINGS, no feathers, no halo. She is not awake or standing. Medium-wide garden-level camera slightly elevated to reveal her face and both split star halves. Her body and star occupy the middle two-thirds of the image. Background: circular forest ring, the immense sacred Living Veil tree with luminous gold branches and blue threads in bark rising behind, a few distant gothic city silhouettes, clear starry night. From the extreme lower-left edge ONLY an anonymous leather-gloved hand/forearm holds the reference hammer toward the STAR, finishing Divine Redemption with golden YELLOW light and a modest yellow magical trail directed into the star. Owner's body and face entirely off frame, identity not specified; do not show Brook receiving it yet. Hammer never strikes the person. Hammer head matches reference 3, rectangular gold block, circular sun emblem, engraved bands and wrapped handle, all shining YELLOW, never red at this moment. Golden Living Veil already exists: NO blue Tarn dome, no blue overhead barrier, no vertical star-to-barrier beam. No Helion, Adam, monsters, additional companions, apparition or portal. The moment must read as a living but unconscious woman just released from a split magical star, not a corpse on a stone altar. Dense sophisticated crisp pixel art with controlled dithering and richly detailed dark fantasy lighting, exactly matching the accepted comic references rather than a 3D character sheet. No chibi, smooth painting, photo, words, lettering, caption boxes, speech bubbles, border, UI, logos or watermarks. Keep a visually calm darker bottom strip for separately rendered caption. Single full-frame high resolution image, approximately 16:9 landscape."""
(base/'q1-tool-prompt-v01.txt').write_text(prompt,encoding='utf-8')
record_path=base/'q1-production-r1.json'; record=json.loads(record_path.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=dst.relative_to(r).as_posix(),source=src.as_posix(),sha256=sha(dst),dimensions=size,tool_prompt='q1-tool-prompt-v01.txt',inspection={'image_valid':True,'landscape_16_9':True,'aila_wingless':True,'eyes_closed':True,'star_open':True,'hammer_yellow':True,'living_veil_present':True,'no_tarn_dome':True,'no_embedded_caption':True},owner_approval='PENDING_V01',runtime_admitted=False)
record_path.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q1-CANDIDATE-20261017-r1.md').write_text('''# HQ19 Q1 — candidata v01

Autorização: “autorizado” em 2026-10-17, em resposta ao escopo concreto de uma candidata Q1. S-P19-Q01, modo per-step. Seleção r1 e roteiro CANON HQ19 r2 preservados.

Produzida uma imagem pela ferramenta built-in image_gen com três referências locais inspecionadas e hashes conferidos: Aila frontal sem asas, jardim/Véu HQ03 Q5 e martelo HQ18 Q5. Prompt efetivamente enviado em q1-tool-prompt-v01.txt, distinto do brief expandido de preparação. Resultado original mantido e cópia idêntica em candidates/hq_n19_q1_aila_freed_v01.png. Recibo q1-production-r1.json registra origem, dimensões, SHA-256 e referências.

Inspeção visual da imagem retornada: Aila com roupas escuras, olhos fechados e sem asas; estrela grande aberta em cristais azuis; martelo amarelo em mão anônima no recorte; jardim de flores vermelhas, árvore do Véu e noite sem domo da Tarn; sem texto embutido. Integridade do PNG e proporção verificadas. Legibilidade no leitor deve ser validada em integração futura, sem alegar teste de UI não executado.

Estado DRAFT/CANDIDATE, aguardando aceite individual do dono. Não foi admitida em assets nem alterado data/hqs.json, runtime ou save. Q2 não autorizado por esta produção.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q1_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q1_production_status: AUTHORIZED_IN_PROGRESS','q1_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Autorizar uma candidata HQ19 Q1 conforme brief r1 preparado'","next_activity: 'Aceite individual da candidata HQ19 Q1 v01; Q2 ainda não autorizado'",1)
block+='    q1_candidate: '+dst.relative_to(r).as_posix()+'\n    q1_approval: PENDING_V01\n    q1_evidence: EVID-NOTTGARD-HQ19-Q1-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(json.dumps({'status':record['status'],'path':record['candidate'],'dimensions':size,'sha256':record['sha256']},ensure_ascii=False))
