from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-da3aa0a7-e34b-4ac4-a866-4ed7017c533b.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q10_interrogation_v01.png'; candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate); sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q10-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8')); assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,maelor_handcuffed=True,thalion_identity_questioning=True,aila_wingless_guarded_unharmed=True,no_early_portal_or_roots=True,temple_continuity=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q10-CANDIDATE-20261017-r1.md').write_text(f'''# HQ19 Q10 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P19-Q10. Nove de 12 aprovadas; aceite Q10 pendente. Autorização: Q9 aprovada e regra explícita de continuidade.

Ferramenta integrada imagegen. Prompt efetivo: `.atena/generated/hq19-production-20261017/q10-tool-prompt-v01.txt`. Referências Q9 e Q5 aceitas, caminhos/hashes em q10-production-r1.json.

Arquivo: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Fonte preservada: `{source.as_posix()}`. PNG/proporção validados e cópia idêntica por hash.

Inspeção visual: Maelor algemado à frente do corpo à esquerda; Thalion com aparência/roupa de referência, gesto de pergunta à direita; Aila sem asas e ilesa, guardada ao fundo. Pedra e velas mantidas, sem raízes eficazes, runa, portal, violência ou resposta escrita inventada. Sem texto embutido. Aceite subjetivo pendente. Sem admissão nem teste no leitor.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q10_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q10_production_status: AUTHORIZED_IN_PROGRESS','q10_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace("next_activity: 'Produzir candidata HQ19 Q10 autorizada por continuidade; 9/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q10 v01; aprovação autoriza próxima candidata Q11'",1)
block+=f'    q10_candidate: {relative}\n    q10_approval: PENDING_V01\n    q10_evidence: EVID-NOTTGARD-HQ19-Q10-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q10 salva, PNG {size}, SHA-256 {sha}; evidência e YAML válidos, aceite pendente.')
