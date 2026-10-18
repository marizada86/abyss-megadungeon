from pathlib import Path
from PIL import Image
import shutil,json,hashlib,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
src=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-0e71ba26-5efb-47e8-892f-9b490b2c89ba.png')
dst=base/'candidates/hq_n19_q2_bromnor_legacy_v01.png'
assert src.is_file() and not dst.exists(); shutil.copy2(src,dst)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(src)==sha(dst)
with Image.open(dst) as im: size=list(im.size); im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
p=base/'q2-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=dst.relative_to(r).as_posix(),source=src.as_posix(),sha256=sha(dst),dimensions=size,inspection={'image_valid':True,'landscape_16_9':True,'brook_receives_with_two_hands':True,'bromnor_spectral_with_pages':True,'single_hammer_sun_emblem':True,'red_light_and_fading_yellow':True,'garden_living_veil_continuity':True,'no_embedded_caption':True},owner_approval='PENDING_V01',runtime_admitted=False)
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q2-CANDIDATE-20261017-r1.md').write_text('''# HQ19 Q2 — candidata v01

Autorização: “autorizado” em 2026-10-17, em resposta ao escopo concreto do Q2. Etapa S-P19-Q02; uma de 12 imagens já aprovada, Q2 aguardando aceite. Seleção visual r1 e roteiro CANON r2 preservados.

Produzida uma candidata pela ferramenta built-in image_gen, com retratos de Brook/Bromnor e Q1 aceita como referências. Prompt efetivamente enviado em q2-tool-prompt-v01.txt; recibo q2-production-r1.json com hashes, origem e dimensões. Original mantido e cópia idêntica em candidates/hq_n19_q2_bromnor_legacy_v01.png.

Conferência de identidade: data/heroes.json identifica Brook como halfling. Corrigida no brief operacional a expressão equivocada “dois anões” para Brook halfling e Bromnor anão, preservando as referências e o roteiro. A manifestação flutuante de Bromnor não define nova altura física canônica.

Inspeção visual do resultado: Brook sólido com cabelo/barba brancos, armadura e capa vinho, segurando um único martelo com as duas mãos; Bromnor de longa barba branca e armadura azul/dourada em forma translúcida, páginas dispersas, mão soltando o legado; martelo com emblema solar e energia vermelha entre brilhos amarelos; jardim de flores vermelhas/Véu, noite sem Tarn. Sem legenda/UI embutidas. PNG e proporção conferidos; legibilidade no leitor depende de integração futura.

Estado DRAFT/CANDIDATE, sem admissão em assets, alteração de runtime ou save. Aceite do Q2 pendente, Q3 não autorizado por esta produção.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q2_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q2_production_status: AUTHORIZED_IN_PROGRESS','q2_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Autorizar candidata HQ19 Q2 conforme brief r1; Q1 aprovada'","next_activity: 'Aceite individual HQ19 Q2 v01; Q3 não autorizado'",1)
block+='    q2_candidate: '+dst.relative_to(r).as_posix()+'\n    q2_approval: PENDING_V01\n    q2_evidence: EVID-NOTTGARD-HQ19-Q2-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(json.dumps({'status':record['status'],'path':record['candidate'],'dimensions':size,'sha256':record['sha256']},ensure_ascii=False))
