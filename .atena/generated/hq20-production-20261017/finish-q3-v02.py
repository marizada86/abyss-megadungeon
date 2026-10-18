from pathlib import Path
import json,hashlib,shutil,re,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-35c9578e-5bcb-4f0d-a23a-25ac87dee756.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q3_passage_v02.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q3-v02-production-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
m.update(status='CANDIDATE_V02_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V02',inspection=dict(marciela_official_costume=True,pointing_gesture_back_view=True,tree_companions_and_purple_portal_preserved=True,no_text=True))
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q3-CANDIDATE-20261017-v02.md'
(r/evidence).write_text(f'''# HQ20 Q3 — continuidade Marciela v02

CANDIDATE_V02_AWAITING_OWNER_APPROVAL. S-P20-Q03C, etapa 2/5 complementar; 1/5 concluída. Autorização: Q2 v02 aprovada e regra explícita de produção da próxima candidata. Edição de continuidade do visual solicitado, sem alteração narrativa.

Imagegen integrada, prompt efetivo `.atena/generated/hq20-production-20261017/q3-prompt-v02.txt`. Alvo Q3 v01 aceita; referências Q2 v02 aceita, costas e frente mestre CHAR-038. Fontes e hashes em q3-v02-production-r1.json; origem DRAFT do pacote preservada. Q3 v01 e aceite histórico mantidos; nenhuma alteração automática no plano das referências do mapa.

Arquivo `{relative}`, SHA-256 `{sha}`, {size[0]}×{size[1]}. Original preservado `{source.as_posix()}`. PNG/proporção validados, cópia idêntica por hash.

Inspeção visual: Marciela de costas aponta para passagem, capuz erguido, ombreira rasgada, tiras cruzadas, cintos e roupa escura em camadas conforme pacote. Árvore amadeirada correta, Leoric/Korrak, portal roxo e terreno fúngico mantidos. Sem arma futura ou texto. Aceite subjetivo pendente; sem runtime/teste no leitor. Após aceite, Q4 já aceita é reaproveitada e próximo quadro novo é Q5, com referência de Nidhogg a conferir.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; match=re.search(pattern,t); assert match
block=match.group(); assert 'status: Q3_OFFICIAL_MARCIELA_CORRECTION_IN_PROGRESS' in block
block=block.replace('status: Q3_OFFICIAL_MARCIELA_CORRECTION_IN_PROGRESS','status: Q3_CANDIDATE_V02_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Produzir Q3 v02 com Marciela oficial, demais conteúdos preservados','next_activity: Aceite Q3 v02; depois conferir referência de Nidhogg para Q5',1)
block+=f'  q3_v02_candidate: {relative}\n  q3_v02_approval: PENDING_V02\n  q3_v02_evidence: {evidence}\n'
t=t[:match.start()]+block+t[match.end():]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q3 v02 salva, PNG {size}, SHA-256 {sha}; evidência e estado válidos, aceite pendente.')
