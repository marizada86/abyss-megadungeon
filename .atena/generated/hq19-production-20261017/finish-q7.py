from pathlib import Path
import json,hashlib,shutil,yaml
from PIL import Image
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
source=Path('C:/Users/gui-m/.codex/generated_images/01a14512-f318-7471-b2d2-ab2faaf3127c/exec-3279a5be-6936-4798-8564-dc39315f205b.png')
relative='.atena/generated/hq19-production-20261017/candidates/hq_n19_q7_separate_escapes_v01.png'; candidate=r/relative
assert not candidate.exists()
with Image.open(source) as im:
    size=im.size; im.verify()
assert abs(size[0]/size[1]-16/9)<0.003
shutil.copy2(source,candidate); sha=hashlib.sha256(candidate.read_bytes()).hexdigest()
assert sha==hashlib.sha256(source.read_bytes()).hexdigest()
p=base/'q7-production-r1.json'; record=json.loads(p.read_text(encoding='utf-8')); assert record['status']=='AUTHORIZED_IN_PROGRESS'
record.update(status='CANDIDATE_V01_AWAITING_OWNER_APPROVAL',candidate=relative,source=source.as_posix(),sha256=sha,dimensions=list(size),owner_approval='PENDING_V01',runtime_admitted=False,inspection=dict(image_valid=True,landscape_16_9=True,kayron_white_outfit_red_sash=True,window_escape_guards_behind=True,two_separate_vignettes=True,brook_outside_stationary=True,brook_rectangular_hammer_red_glow=True,no_embedded_caption=True))
p.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ19-Q7-CANDIDATE-20261017-r1.md'
(r/evidence).write_text(f'''# HQ19 Q7 — candidata v01

Estado: CANDIDATE_V01_AWAITING_OWNER_APPROVAL. Etapa S-P19-Q07. Autorização do dono: “autorizado” (2026-10-17), uma candidata conforme brief r1. Seis de 12 quadros aprovados; aceite Q7 pendente.

Ferramenta: imagegen integrada. Prompt efetivo: `.atena/generated/hq19-production-20261017/q7-tool-prompt-v01.txt`. Referências e hashes no registro q7-production-r1.json: Kayron branco frontal (identidade/roupa), Brook retrato (identidade/armadura, sem maça), Q2 aprovada (Brook e martelo), Q5 aprovada (templo/estilo).

Arquivo: `{relative}`. SHA-256: `{sha}`. Dimensões: {size[0]}×{size[1]}. Fonte preservada: `{source.as_posix()}`. PNG validado e cópia idêntica por hash.

Inspeção visual: duas vinhetas separadas por intervalo escuro. À esquerda, Kayron de cabelo branco e roupa branca com padrões pretos/faixa vermelha transpõe janela de pedra, guardas no interior atrás. À direita, Brook adulto pequeno com armadura e capa vinho está parado fora do templo com martelo retangular dourado de luz vermelha. Cenas não mostram fuga conjunta. Noite azul e velas âmbar coerentes com templo aceito. Sem texto embutido. Aceite subjetivo pendente; sem integração ou testes no leitor do jogo.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
assert 'q7_production_status: AUTHORIZED_IN_PROGRESS' in block
block=block.replace('q7_production_status: AUTHORIZED_IN_PROGRESS','q7_production_status: CANDIDATE_V01_AWAITING_OWNER_APPROVAL',1).replace("next_activity: 'Produzir candidata HQ19 Q7 autorizada; 6/12 aprovadas'","next_activity: 'Aceite individual HQ19 Q7 v01; Q8 não autorizado'",1)
block+=f'    q7_candidate: {relative}\n    q7_approval: PENDING_V01\n    q7_evidence: EVID-NOTTGARD-HQ19-Q7-CANDIDATE-20261017-r1\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print(f'PASS: Q7 salva, PNG {size}, SHA-256 {sha}; evidência e YAML válidos, aceite pendente.')
