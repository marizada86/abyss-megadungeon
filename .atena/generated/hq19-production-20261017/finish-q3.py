from pathlib import Path
from PIL import Image
import shutil,json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
src=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-351721ee-1af7-4fbf-8f9b-b8b6f7521f29.png')
dst=base/'candidates/hq_n19_q3_aila_awakens_v01.png'
assert src.is_file() and not dst.exists(); shutil.copy2(src,dst)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==sha(dst)
with Image.open(dst) as im: size=list(im.size); im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
p=base/'q3-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=dst.relative_to(r).as_posix(),source=src.as_posix(),sha256=sha(dst),dimensions=size,inspection={'image_valid':True,'landscape_16_9':True,'maelor_reference_preserved':True,'aila_eyes_open_wingless':True,'same_dark_clothes':True,'ethereal_stone_and_absorption_light':True,'no_repeated_star_liberation':True,'no_embedded_caption':True},owner_approval='PENDING_V01',runtime_admitted=False)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q3-CANDIDATE-20261017-r1.md').write_text('''# HQ19 Q3 — candidata v01

Autorização: “autorizado” em 2026-10-17, após escopo concreto da candidata Q3. S-P19-Q03; dois de 12 quadros já aprovados, Q3 pendente de aceite individual. Seleção r1 e roteiro CANON HQ19 r2 preservados.

Produzida uma candidata via built-in image_gen com três referências inspecionadas: Maelor, Aila sem asas e Q1 aceita. Ficha Luz Mais Pura de Thalion consultada: objeto é pedra trazida pelo desejo e absorvida no despertar. Prompt efetivo em q3-tool-prompt-v01.txt; hashes, origem e dimensões no recibo q3-production-r1.json. Original preservado; cópia idêntica em candidates/hq_n19_q3_aila_awakens_v01.png.

Inspeção visual: Maelor reconhecível com traje e rosto de referência, mão aberta oferecendo pedra etérea luminosa; luz suave chegando ao peito coberto de Aila, olhos abertos, sem asas, cabelo/roupas preservados. Fundo restrito, sem fixar nome/localização do quarto, sem repetir estrela ou martelo. Sem legenda/UI embutidas. PNG e proporção conferidos. Cor da iluminação é recurso pictórico proposto, não nova regra canônica do objeto. Legibilidade no leitor não testada nesta produção.

Estado DRAFT/CANDIDATE, sem admissão em assets, mudança de runtime ou save. Q4 não autorizado por esta produção.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q3_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q3_production_status: AUTHORIZED_IN_PROGRESS','q3_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Autorizar candidata HQ19 Q3 conforme brief r1; Q1/Q2 aprovadas'","next_activity: 'Aceite individual HQ19 Q3 v01; Q4 não autorizado'",1)
block+='    q3_candidate: '+dst.relative_to(r).as_posix()+'\n    q3_approval: PENDING_V01\n    q3_evidence: EVID-NOTTGARD-HQ19-Q3-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(json.dumps({'status':record['status'],'path':record['candidate'],'dimensions':size,'sha256':record['sha256']},ensure_ascii=False))
