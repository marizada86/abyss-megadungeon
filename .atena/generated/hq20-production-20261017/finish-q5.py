from pathlib import Path
import json,hashlib,shutil,re,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-e8310df2-585d-4a07-9eb2-306cfb7cabae.png')
relative='.atena/generated/hq20-production-20261017/candidates/hq_n20_q5_nidhogg_misses_v01.png'; target=r/relative
assert not target.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,target); sha=hashlib.sha256(target.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q5-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8'))
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',inspection=dict(giant_legless_snake=True,maelor_outside_mouth_unharmed=True,no_contact_with_teeth=True,wood_cosmic_continuity=True,no_counterattack_or_dead_snake=True,no_text=True),inspection_note='Mandíbulas ainda abertas no instante da esquiva; falha representada pela distância clara, não por boca totalmente fechada.')
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-Q5-CANDIDATE-20261017-v01.md'
(r/evidence).write_text(f'''# HQ20 Q5 — candidata v01

CANDIDATE_V01_AWAITING_OWNER_APPROVAL. S-P20-Q05, etapa 3/5 complementar, 2/5 concluídas. Direção explícita do dono: Nidhogg cobra gigante guardiã de Yggdrasil, registrada em DEC-NIDHOGG-GIANT-SNAKE-20261017-r1. Cor/detalhes desta primeira representação são proposta sujeita a aceite.

Imagegen integrada. Prompt efetivo `.atena/generated/hq20-production-20261017/q5-prompt-v01.txt`. Referências Q4 aceita e retrato Maelor, caminhos/hashes em q5-production-r1.json.

Arquivo `{relative}`. SHA-256 `{sha}`, {size[0]}×{size[1]}. Fonte preservada `{source.as_posix()}`. PNG e proporção verificados, cópia idêntica por hash.

Inspeção visual: cobra gigantesca sem patas/asas/chifres à esquerda, corpo entre raízes ao fundo; Maelor recua sobre madeira sólida à direita, separado de todos os dentes, vivo e sem ferimento. Mandíbulas ainda abertas no instante da esquiva; não se alega boca totalmente fechada. Cobra viva, sem contra-ataque. Madeira robusta e universo coerentes com referências, sem texto/portal. Aceite subjetivo pendente; sem integração ou teste no leitor.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; m=re.search(pattern,t); assert m
block=m.group(); assert 'status: Q5_AUTHORIZED_IN_PROGRESS' in block
block=block.replace('status: Q5_AUTHORIZED_IN_PROGRESS','status: Q5_CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace('next_activity: Produzir Q5 com Nidhogg cobra gigante; definição do dono resolve identidade','next_activity: Aceite Q5 v01; aprovação autoriza Q6 fuga de Maelor',1)
block+=f'  q5_candidate: {relative}\n  q5_approval: PENDING_V01\n  q5_evidence: {evidence}\n'
t=t[:m.start()]+block+t[m.end():]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print(f'PASS: Q5 salva, PNG {size}, SHA-256 {sha}; evidência/estado válidos, aceite pendente.')
