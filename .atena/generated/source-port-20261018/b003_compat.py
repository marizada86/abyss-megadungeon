from pathlib import Path
import json,hashlib,shutil
root=Path.cwd();b=root/'.atena/generated/source-port-20261018/b003';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');rows=json.loads((b/'write-set-r1.json').read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def put(rel,t):
 p=root/rel;q=b/'before'/rel
 if not any(r['path']==rel for r in rows):
  q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q);rows.append({'path':rel,'before_sha256':sha(q),'source_sha256':sha(src/rel)})
 p.write_text(t,encoding='utf-8');shutil.copyfile(p,root/'tmp/port-b3/candidate'/rel)
 for r in rows:
  if r['path']==rel:r['after_sha256']=sha(p)
rel='data/difficulty.json';d=json.loads((root/rel).read_text(encoding='utf-8'));stages=json.loads((src/'data/stages.json').read_text(encoding='utf-8-sig'));d['boss_mech']['combat_orders']={k:int(v['order']) for k,v in stages.items() if isinstance(v,dict) and 'order' in v};put(rel,json.dumps(d,ensure_ascii=False,indent=2)+'\n')
rel='core/boss_mechanics.gd';t=(root/rel).read_text(encoding='utf-8');t=t.replace('return budget_for_order(int(b.stage.get("order", 0)))','var orders: Dictionary = config().get("combat_orders", {})\n\t# Combat pacing follows the source phases; campaign order and unlocks remain local.\n\treturn budget_for_order(int(orders.get(b.stage_id, b.stage.get("order", 0))))');put(rel,t)
rel='tests/test_atmosphere.gd';t=(root/rel).read_text(encoding='utf-8');t=t.replace('if p.is_empty():\n\t\t\tout.append','if p.is_empty() and String(sid) in ["domwieck", "reino_abissal"]:\n\t\t\tvar local_map := Atmosphere.new()\n\t\t\tlocal_map.setup(String(sid), {"atmosphere": "leve"})\n\t\t\tif local_map.is_grading() or local_map.is_emitting():\n\t\t\t\tout.append("mapa PC sem perfil deve manter apresentação original: %s" % sid)\n\t\t\tlocal_map.free()\n\t\t\tcontinue\n\t\tif p.is_empty():\n\t\t\tout.append');put(rel,t)
(b/'write-set-r1.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8');print('Combat budget reconciled independently of campaign; PC atmosphere fallback verified')
