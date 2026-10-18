from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-cbc1b2a8-6312-4bb3-92de-c3c3a32af7ff.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q9_surrender_v01.png'; candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate); sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q9-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8')); assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,maelor_surrender_open_hands=True,aila_wingless_unharmed=True,guards_physical_capture=True,no_active_roots_or_portal=True,temple_continuity=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'.atena/evidence/EVID-NOTTGARD-HQ19-Q9-CANDIDATE-20261017-r1.md').write_text(f'''# HQ19 Q9 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P19-Q09. Oito de 12 aprovadas; aceite Q9 pendente. Autorização: Q8 aprovada e regra explícita de continuidade registrada em DEC-HQ-CANDIDATE-APPROVAL-CONTINUATION-20261017-r1.

Ferramenta integrada imagegen. Prompt efetivo: `.atena/generated/hq19-production-20261017/q9-tool-prompt-v01.txt`. Referências: Q8 aceita para personagens/ambiente e Q5 aceita para guardas; caminhos e hashes em q9-production-r1.json.

Arquivo: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Fonte preservada: `{source.as_posix()}`. PNG, proporção e cópia por hash conferidos.

Inspeção visual: Maelor com mãos abertas erguidas em rendição e guarda segurando seu braço; Aila sem asas, ilesa, segurada fisicamente pelo outro guarda. Identidades e roupas mantidas. Raízes inertes nas bordas, sem aprisionar; nenhuma abertura ou envio antecipado. Pedra, arcos e velas coerentes. Sem texto embutido. Aceite subjetivo pendente. Sem admissão nem teste no leitor do jogo.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q9_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q9_production_status: AUTHORIZED_IN_PROGRESS','q9_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace("next_activity: 'Produzir candidata HQ19 Q9 autorizada por continuidade; 8/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q9 v01; aprovação autoriza próxima candidata Q10'",1)
block+=f'    q9_candidate: {relative}\n    q9_approval: PENDING_V01\n    q9_evidence: EVID-NOTTGARD-HQ19-Q9-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q9 salva, PNG {size}, SHA-256 {sha}; evidência e YAML válidos; aceite pendente.')
