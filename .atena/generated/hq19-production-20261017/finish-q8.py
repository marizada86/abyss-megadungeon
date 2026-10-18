from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-05b87b8e-99c4-4f5b-8dca-3c12e51fce4e.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q8_roots_decay_v01.png'; candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate); sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q8-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8')); assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,maelor_identity_preserved=True,aila_wingless_unharmed=True,roots_decay_before_contact=True,no_shield_or_attack=True,stone_temple_continuity=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q8-CANDIDATE-20261017-r1.md').write_text(f'''# HQ19 Q8 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P19-Q08. Sete de 12 aprovadas; aceite Q8 pendente. Autorização: instrução explícita de continuidade após Q7 aprovada, registrada em DEC-HQ-CANDIDATE-APPROVAL-CONTINUATION-20261017-r1.

Ferramenta integrada imagegen. Prompt: `.atena/generated/hq19-production-20261017/q8-tool-prompt-v01.txt`. Referências e hashes em q8-production-r1.json: Maelor retrato, Aila frontal v02, Q3 aceita para identidades/roupas e Q6 aceita para templo/raízes.

Arquivo: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Fonte preservada: `{source.as_posix()}`. PNG e proporção conferidos, cópia idêntica por hash.

Inspeção visual: Maelor e Aila em pé, roupas coerentes, Aila sem asas e ilesa. Raízes negras se desfazem em fragmentos no primeiro plano, com espaço de pedra livre antes dos pés, sem contato/restrição. Sem escudo, golpe ou captura; templo de pedra, velas e sombras frias preservados. Sem texto embutido. Aceite subjetivo pendente; sem admissão ou teste no leitor.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q8_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q8_production_status: AUTHORIZED_IN_PROGRESS','q8_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace("next_activity: 'Produzir candidata HQ19 Q8 autorizada por continuidade; 7/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q8 v01; aprovação autoriza próxima candidata Q9'",1)
block+=f'    q8_candidate: {relative}\n    q8_approval: PENDING_V01\n    q8_evidence: EVID-NOTTGARD-HQ19-Q8-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q8 salva, PNG {size}, SHA-256 {sha}; evidência e estado válidos, aceite pendente.')
