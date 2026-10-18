from pathlib import Path
import json, hashlib, shutil, yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-02a84d5a-1a5b-4f17-9a21-a21d983b983e.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q6_roots_abduction_v01.png'
candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate)
sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q6-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,leoric_identity_and_staff=True,korrak_identity_scale_and_no_axe=True,black_roots_restrain_both=True,two_purple_portals=True,temple_stone_floor_and_candles=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ19-Q6-CANDIDATE-20261017-r1.md'
(r/evidence).write_text(f'''# HQ19 Q6 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. Etapa S-P19-Q06. Autorização: “autorizado” (2026-10-17), uma candidata conforme brief r1. Cinco de 12 quadros aprovados; Q6 aguarda aceite individual.

Produção com ferramenta integrada imagegen. Prompt efetivo: `.atena/generated/hq19-production-20261017/q6-tool-prompt-v01.txt`. Entradas e hashes em `q6-production-r1.json`: retrato de Leoric, retrato de Korrak apenas para identidade/vestuário sem machado, e Q5 aprovada para templo e estilo.

Candidata: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Original preservado em `{source.as_posix()}`; cópia conferida por hash e PNG validado.

Inspeção visual da saída: Leoric de cartola e cajado azul à esquerda, Korrak maior com braços cinzentos e sem machado à direita; raízes negras prendem ambos diante de duas aberturas roxas. Corpos resistem ao arrasto, pedra e velas mantêm continuidade do templo. Grafismo angular mágico ilustrativo; não estabelece runa canônica. Sem texto embutido. Arquivo e proporção horizontal conferidos. Aceite subjetivo do dono pendente. Sem integração ou teste no leitor do jogo.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q6_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q6_production_status: AUTHORIZED_IN_PROGRESS','q6_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1)
block=block.replace("next_activity: 'Produzir candidata HQ19 Q6 autorizada; 5/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q6 v01; Q7 não autorizado'",1)
block+=f'    q6_candidate: {relative}\n    q6_approval: PENDING_V01\n    q6_evidence: EVID-NOTTGARD-HQ19-Q6-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q6 salva, PNG {size}, SHA-256 {sha}; evidência e estado válidos, aceite pendente.')
