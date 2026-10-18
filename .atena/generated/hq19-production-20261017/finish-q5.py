from pathlib import Path
from PIL import Image
import shutil,json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
src=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-f2906af2-9849-4229-a341-05b8833fc94e.png')
dst=base/'candidates/hq_n19_q5_thalion_command_v01.png'
assert src.is_file() and not dst.exists(); shutil.copy2(src,dst)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==sha(dst)
with Image.open(dst) as im: size=list(im.size); im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
p=base/'q5-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=dst.relative_to(r).as_posix(),source=src.as_posix(),sha256=sha(dst),dimensions=size,inspection={'image_valid':True,'landscape_16_9':True,'thalion_identity_and_costume':True,'command_gesture_with_living_soldiers':True,'temple_stone_arches_candle_continuity':True,'no_roots_or_portals_yet':True,'no_embedded_caption':True},owner_approval='PENDING_V01',runtime_admitted=False)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q5-CANDIDATE-20261017-r1.md').write_text('''# HQ19 Q5 — candidata v01

Autorização: “autorizado” em 2026-10-17, após escopo concreto Q5. S-P19-Q05; quatro de 12 quadros já aprovados, Q5 aguardando aceite. Início do segmento exibido após Dagruve. Seleção r1 e roteiro CANON r2 preservados.

Uma candidata criada via built-in image_gen com Thalion frontal CHAR-054 e Q4 aceita para ambiente/acabamento. Prompt efetivo q5-tool-prompt-v01.txt; recibo q5-production-r1.json com origem, dimensões e hashes. Original mantido; cópia idêntica em candidates/hq_n19_q5_thalion_command_v01.png.

Inspeção: Thalion reconhecível com cabelo claro, chapéu/manto vermelhos, traje azul/dourado, expressão e braço de comando; soldados vivos entrando, armas sem golpe consumado, interior de pedra/arcos/velas coerente com Q4. Sem portal, raízes, morte de Thalion ou texto/UI embutidos. Figuras e arquitetura não fixam nova ordem militar nem planta canônica. PNG e proporção conferidos. Legibilidade no leitor não testada nesta produção.

Estado DRAFT/CANDIDATE, sem alteração de assets oficiais, runtime ou save. Q6 não autorizado por esta produção.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q5_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q5_production_status: AUTHORIZED_IN_PROGRESS','q5_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Autorizar candidata HQ19 Q5 conforme brief r1; Q1–Q4 aprovadas'","next_activity: 'Aceite individual HQ19 Q5 v01; Q6 não autorizado'",1)
block+='    q5_candidate: '+dst.relative_to(r).as_posix()+'\n    q5_approval: PENDING_V01\n    q5_evidence: EVID-NOTTGARD-HQ19-Q5-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(json.dumps({'status':record['status'],'path':record['candidate'],'dimensions':size,'sha256':record['sha256']},ensure_ascii=False))
