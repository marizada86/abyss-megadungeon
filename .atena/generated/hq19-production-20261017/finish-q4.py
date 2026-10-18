from pathlib import Path
from PIL import Image
import shutil,json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
src=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-3bf5d0d5-4df6-4dc4-a6de-48180bca6ab4.png')
dst=base/'candidates/hq_n19_q4_sendrinah_prayer_v01.png'
assert src.is_file() and not dst.exists(); shutil.copy2(src,dst)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==sha(dst)
with Image.open(dst) as im: size=list(im.size); im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
p=base/'q4-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=dst.relative_to(r).as_posix(),source=src.as_posix(),sha256=sha(dst),dimensions=size,inspection={'image_valid':True,'landscape_16_9':True,'aila_wingless_same_clothes':True,'kneeling_clasped_hands_prayer':True,'statue_indirect_blurred_no_face':True,'stone_temple_candlelight':True,'no_divine_apparition':True,'no_embedded_caption':True},owner_approval='PENDING_V01',runtime_admitted=False)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q4-CANDIDATE-20261017-r1.md').write_text('''# HQ19 Q4 — candidata v01

Autorização: “autorizado” em 2026-10-17, após escopo concreto da candidata Q4. S-P19-Q04; três de 12 quadros já aprovados, Q4 aguardando aceite. Último quadro da abertura anterior a Dagruve. Seleção r1 e roteiro CANON r2 preservados.

Produzida uma candidata via built-in image_gen, com Aila frontal v02 e Q3 aceita como referências de identidade/roupa/acabamento. Prompt efetivo q4-tool-prompt-v01.txt, recibo q4-production-r1.json com hashes, origem e dimensões. Original mantido; cópia idêntica em candidates/hq_n19_q4_sendrinah_prayer_v01.png.

Inspeção do resultado: Aila sem asas, mesma face/cabelo/roupas, ajoelhada com mãos em oração; interior de pedra com velas; estátua ao fundo desfocada, rosto não definido; sem aparição divina, guardas, portal ou texto embutido. Composição arquitetônica não institui planta canônica do templo. Integridade PNG e proporção conferidas; leitura em UI não testada nesta produção.

Estado DRAFT/CANDIDATE, sem admissão em assets, alteração de runtime ou save. Q5 não autorizado por esta produção.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q4_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q4_production_status: AUTHORIZED_IN_PROGRESS','q4_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Autorizar candidata HQ19 Q4 conforme brief r1; Q1–Q3 aprovadas'","next_activity: 'Aceite individual HQ19 Q4 v01; Q5 não autorizado'",1)
block+='    q4_candidate: '+dst.relative_to(r).as_posix()+'\n    q4_approval: PENDING_V01\n    q4_evidence: EVID-NOTTGARD-HQ19-Q4-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(json.dumps({'status':record['status'],'path':record['candidate'],'dimensions':size,'sha256':record['sha256']},ensure_ascii=False))
