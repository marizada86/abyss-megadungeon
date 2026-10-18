from pathlib import Path
import json
def load(n): return json.loads(Path('data/'+n+'.json').read_text(encoding='utf-8'))
def save(n,d): Path('data/'+n+'.json').write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
story=load('stage_story'); rules=load('stage_rules'); events=load('stage_events')
for sid,description in [('reino_abissal','Raízes colossais conduzem ao acampamento da legião e ao acesso ao ritual.'),('domwieck','Nottgard está sob invasão. Alcance o jardim de Ailalore.')]:
    story[sid]={'epigrafe':description,'fonte_vault':'Sessão 12; contrato do capítulo 1 r1','chefe':'Sobreviva e alcance o destino indicado.','fonte_chefe':'Objetivo de chegada aprovado, sem chefe jogável'}
    rules[sid]={'name':'Alcance o destino','kind':'none','desc':'Sobreviva e permaneça três segundos no destino após o tempo indicado.'}
    events[sid]=[]
save('stage_story',story); save('stage_rules',rules); save('stage_events',events)
p=Path('tests/test_data.gd'); t=p.read_text(encoding='utf-8')
t=t.replace('if not enemies.has(s.boss):','if String(s.get("completion", {}).get("kind", "boss")) == "timed_reach":\n\t\t\tif String(s.boss) != "" or float(s.completion.hold_seconds) <= 0: out.append("objetivo inválido: " + sid)\n\t\telif not enemies.has(s.boss):',1)
t=t.replace('String(stages.docas.next) != "shedaklah"','String(stages.docas.next) != "reino_abissal"')
p.write_text(t,encoding='utf-8')
p=Path('tests/test_map_objectives.gd'); t=p.read_text(encoding='utf-8')
a=t.index('\tif released.has("reino_abissal")'); z=t.index('\nfunc _full_run',a)
t=t[:a]+'''\tfor sid in ["reino_abissal", "domwieck"]:
\t\tif not released.has(sid) or bool(released[sid].get("qa_only", false)) or String(released[sid].completion.kind) != "timed_reach":
\t\t\tout.append("objetivo integrado ausente: " + sid)
\tif not Battle.stage_definition("stage_unknown_qa").is_empty(): out.append("ID desconhecido")
'''.replace('\n+','\n')+t[z:]
t=t.replace('if b.state == "won":','if b.stage_cleared:',1).replace('if b.state != "won" or not b.stage_cleared','if not b.stage_cleared',1)
t=t.replace('not b.stage_cleared or b.state != "won" or b.objective_presence','not b.stage_cleared or b.objective_presence')
t=t.replace('i.kind in ["boss_chest", "portal"]','i.kind == "boss_chest"')
p.write_text(t,encoding='utf-8')
print('Data contracts and objective tests updated for admitted stages.')
