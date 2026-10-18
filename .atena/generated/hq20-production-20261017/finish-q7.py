from pathlib import Path
import json,hashlib,shutil,re,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-565abeb0-db81-4e64-9aef-9fd8205cf780.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q7_mother_reunion_v01.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q7-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',inspection=dict(maelor_and_marciela_identity=True,mutual_recognition=True,marciela_hood_loose_hair_official_costume=True,fungal_destination_root_ground=True,no_aila_or_other_figures=True,no_text=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q7-CANDIDATE-20261017-v01.md'
(r/evidence).write_text(f'''# HQ20 Q7 — candidata v01

CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P20-Q07, etapa 5/5 complementar; 4/5 concluídas. Seis de sete quadros aceitos. Autorização: aceite Q6 e regra de próxima candidata.

Imagegen integrada. Prompt efetivo `.atena/generated/hq20-production-20261017/q7-prompt-v01.txt`. Referências: retrato Marciela CHAR-038 aprovado, retrato Maelor, Q2 v02 aceita para roupa e Q6 aceita para destino além da passagem. Caminhos/hashes no registro q7-production-r1.json. Pacote externo permanece DRAFT na origem, autorizado como identidade nesta HQ.

Arquivo `{relative}`, SHA-256 `{sha}`, {size[0]}×{size[1]}. Fonte preservada `{source.as_posix()}`. PNG/proporção validados, cópia idêntica por hash.

Inspeção: Maelor e Marciela frente a frente, rostos legíveis em reconhecimento, mãos abertas em gesto contido; roupa, capuz e cabelo solto conforme referências, sem ferimentos. Paisagem fúngica e solo de raízes distinguem destino do universo de Yggdrasil. Sem Aila, outros integrantes, cobra, nova luta ou fala escrita. Sem texto embutido. Aceite subjetivo pendente; sem runtime ou teste no leitor.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; m=re.search(pattern,t); assert m
block=m.group(); assert 'status: Q7_AUTHORIZED_IN_PROGRESS' in block
block=block.replace('status: Q7_AUTHORIZED_IN_PROGRESS','status: Q7_CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Produzir Q7, reencontro com Marciela no lado abissal','next_activity: Aceite Q7; depois conferir sequência completa da HQ20',1)
block+=f'  q7_candidate: {relative}\n  q7_approval: PENDING_V01\n  q7_evidence: {evidence}\n'
t=t[:m.start()]+block+t[m.end():]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q7 salva, PNG {size}, SHA-256 {sha}; estado/evidência válidos; aceite pendente.')
