from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-d0e38f9e-1668-4929-8b52-be33e29ff38a.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q2_marciela_meeting_v01.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q2-production-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
m.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',inspection=dict(three_figures=True,peaceful_meeting=True,marciela_indirect_back_view=True,wood_strength_cosmic_continuity=True,korrak_no_axe=True,no_portal_or_text=True))
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q2-CANDIDATE-20261017-v01.md'
(r/evidence).write_text(f'''# HQ20 Q2 — candidata v01

CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P20-Q02, etapa 1/4 complementar, 0/4 aceites neste recorte; Q1/Q3/Q4 já aceitas em plano próprio. Autorização “continue” após escolha de continuar produção HQ20 aqui.

Imagegen integrada; prompt efetivo `.atena/generated/hq20-production-20261017/q2-prompt-v01.txt`; referências Q1 v03 correta e Q3 v01 aceitas, hashes em q2-production-r1.json.

Arquivo `{relative}`. SHA-256 `{sha}`, dimensões {size[0]}×{size[1]}. Fonte preservada `{source.as_posix()}`. PNG, proporção e cópia por hash conferidos.

Inspeção: três figuras, Leoric pequeno com cartola/cajado azul, Korrak grande sem machado, Marciela de costas em silhueta aproximando-se; encontro pacífico sobre raiz de madeira robusta no universo, continuidade da Q1 v03. Sem rosto novo de Marciela, combate, portal, texto ou marca. Aceite subjetivo pendente; sem runtime ou teste no leitor. Antes de Q5/Q6, localizar referência de Nidhogg.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); a=t.index('\nhq20_completion_production_plan:\n'); block=t[a:]
assert 'status: Q2_AUTHORIZED_IN_PROGRESS' in block
block=block.replace('status: Q2_AUTHORIZED_IN_PROGRESS','status: Q2_CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Produzir Q2 e apresentar para aceite individual','next_activity: Aceite Q2; depois conferir referência de Nidhogg para Q5',1)
block+=f'  q2_candidate: {relative}\n  q2_approval: PENDING_V01\n  q2_evidence: {evidence}\n'
t=t[:a]+block; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q2 salva, {size}, SHA-256 {sha}; estado/evidência válidos, aceite pendente.')
