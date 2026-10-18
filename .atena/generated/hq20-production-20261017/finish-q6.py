from pathlib import Path
import json,hashlib,shutil,re,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-920297fa-e4e1-4987-8623-5f93c5c8d676.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q6_maelor_escape_v01.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q6-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',inspection=dict(maelor_running_toward_purple_portal=True,nidhogg_alive_behind=True,clear_separation_no_wound=True,wood_cosmic_continuity=True,no_other_people_or_text=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q6-CANDIDATE-20261017-v01.md'
(r/evidence).write_text(f'''# HQ20 Q6 — candidata v01

CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P20-Q06, etapa 4/5 complementar; 3/5 concluídas. Autorização: aceite Q5 e regra explícita de próxima candidata.

Ferramenta integrada imagegen. Prompt efetivo `.atena/generated/hq20-production-20261017/q6-prompt-v01.txt`. Referências Q5 aceita para Maelor/Nidhogg/ambiente e Q3 v02 aceita para passagem, sem transportar seus personagens; caminhos/hashes em q6-production-r1.json.

Arquivo `{relative}`, SHA-256 `{sha}`, {size[0]}×{size[1]}. Fonte preservada `{source.as_posix()}`. PNG/proporção validados, cópia idêntica por hash.

Inspeção: Maelor corre à direita em direção à abertura roxa, corpo ainda sobre raiz; Nidhogg vivo com mesmo desenho à esquerda e distância clara, sem contato, ferimento, golpe ou queda. Pedra não substitui madeira robusta, universo preservado. Terreno fúngico apenas através da passagem, sem encontro antecipado. Sem texto/figuras extras. Aceite subjetivo pendente, sem runtime ou teste no leitor.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; m=re.search(pattern,t); assert m
block=m.group(); assert 'status: Q6_AUTHORIZED_IN_PROGRESS' in block
block=block.replace('status: Q6_AUTHORIZED_IN_PROGRESS','status: Q6_CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Produzir Q6; Maelor foge rumo ao portal e Nidhogg permanece vivo','next_activity: Aceite Q6; aprovação autoriza Q7 reencontro de Maelor e Marciela',1)
block+=f'  q6_candidate: {relative}\n  q6_approval: PENDING_V01\n  q6_evidence: {evidence}\n'
t=t[:m.start()]+block+t[m.end():]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q6 salva, PNG {size}, SHA-256 {sha}; estado/evidência válidos, aceite pendente.')
