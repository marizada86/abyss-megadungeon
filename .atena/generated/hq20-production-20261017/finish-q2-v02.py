from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-08415f7c-f199-420a-a294-3da8e732adfb.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q2_marciela_meeting_v02.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q2-v02-production-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
m.update(status='CANDIDATE_V02_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V02',inspection=dict(marciela_official_hood_loose_brown_hair=True,ragged_layers_cross_straps_double_belts=True,face_partial_profile=True,empty_hands=True,tree_and_companions_preserved=True,no_text=True))
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q2-CANDIDATE-20261017-v02.md'
(r/evidence).write_text(f'''# HQ20 Q2 — correção Marciela v02

CANDIDATE_V02_AWAITING_OWNER_APPROVAL. S-P20-Q02, 1/4 complementar. Pedido explícito: atualizar imagem com visual oficial definido em outro chat. Pacote CHAR-038/S17-S18-manto-pantano/r01 README registra aprovação das seis referências, EV-REF-099; origem permanece DRAFT, uso nesta edição autorizado pelo dono. Não importa evento futuro de aquisição do manto nem promove lore.

Imagegen integrada em edição. Prompt efetivo `.atena/generated/hq20-production-20261017/q2-prompt-v02.txt`. Alvo Q2 v01; referências frente mestre v02, costas v01 e retrato três quartos v01. Caminhos/hashes no registro q2-v02-production-r1.json. V01 preservada.

Arquivo `{relative}`, SHA-256 `{sha}`, {size[0]}×{size[1]}. Fonte preservada `{source.as_posix()}`. PNG validado, cópia idêntica por hash.

Inspeção visual: Marciela substitui silhueta genérica com capuz erguido, cabelo castanho solto, perfil parcial, roupa escura rasgada em camadas, tiras cruzadas, dois cintos, braçadeiras e botas, mãos vazias. Árvore correta, Leoric e Korrak e encontro pacífico mantidos. Sem texto, portal ou arma posterior. Aceite subjetivo pendente, sem runtime/teste no leitor. Continuidade de Marciela na Q3 antiga registrada para reconciliação futura, sem invalidar silenciosamente aceite anterior.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); a=t.index('\nhq20_completion_production_plan:\n'); block=t[a:]
assert 'status: Q2_V02_OFFICIAL_MARCIELA_CORRECTION_IN_PROGRESS' in block
block=block.replace('status: Q2_V02_OFFICIAL_MARCIELA_CORRECTION_IN_PROGRESS','status: Q2_CANDIDATE_V02_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Corrigir Q2 com pacote oficial de Marciela; preservar candidata anterior','next_activity: Aceite Q2 v02; reconciliar visual de Marciela na Q3 antes de sequência completa',1).replace('q2_approval: PENDING_V01','q2_approval: PENDING_V02',1)
block+=f'  q2_v02_candidate: {relative}\n  q2_v02_evidence: {evidence}\n  marciela_q3_continuity: RECONCILIATION_PENDING_OFFICIAL_REFERENCE\n'
t=t[:a]+block; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q2 v02 salva, PNG {size}, SHA-256 {sha}; estado e evidência válidos, aceite pendente.')
