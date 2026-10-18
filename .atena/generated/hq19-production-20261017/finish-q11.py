from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-a19fe86d-0ecf-4bd0-8e18-ca54aec34518.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q11_maelor_sent_v01.png'; candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate); sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q11-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8')); assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,maelor_handcuffed_root_abduction=True,purple_portal=True,aila_wingless_material_side_guarded=True,thalion_alive_reference_costume=True,temple_stone_floor=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q11-CANDIDATE-20261017-r1.md').write_text(f'''# HQ19 Q11 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P19-Q11. Dez de 12 aprovadas; aceite Q11 pendente. Autorização: aceite Q10 e regra explícita de continuidade.

Ferramenta integrada imagegen. Prompt efetivo: `.atena/generated/hq19-production-20261017/q11-tool-prompt-v01.txt`. Referências Q10 e Q6 aceitas, com caminhos/hashes no registro q11-production-r1.json.

Arquivo: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Fonte preservada: `{source.as_posix()}`. PNG/proporção validados, cópia conferida por hash.

Inspeção visual: Maelor algemado, raízes negras agarrando corpo e puxando para portal roxo à esquerda. Aila sem asas sob guarda, isolada das raízes no lado material à direita; Thalion vivo com aparência aprovada. Pedra e velas preservadas. Glifo ilustrativo sem autoridade de alfabeto. Sem texto embutido ou sangue. Aceite subjetivo pendente, sem admissão nem teste no leitor.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q11_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q11_production_status: AUTHORIZED_IN_PROGRESS','q11_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace("next_activity: 'Produzir candidata HQ19 Q11 autorizada por continuidade; 10/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q11 v01; aprovação autoriza próxima candidata Q12'",1)
block+=f'    q11_candidate: {relative}\n    q11_approval: PENDING_V01\n    q11_evidence: EVID-NOTTGARD-HQ19-Q11-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q11 salva, PNG {size}, SHA-256 {sha}; evidência e YAML válidos, aceite pendente.')
