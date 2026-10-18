from pathlib import Path
import re,json,sys,copy
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');out=root/'.atena/generated/source-port-20261018/b002'
def read(rel,source=False):return ((src if source else root)/rel).read_text(encoding='utf-8-sig')
def write(rel,t):(root/rel).write_text(t,encoding='utf-8')
def replace(t,a,b):assert t.count(a)==1,(a[:120],t.count(a));return t.replace(a,b,1)
def function(text,name):
 m=re.search(r'(?ms)^func '+re.escape(name)+r'\(.*?(?=^func |\Z)',text);assert m,name
 return m.group(0).rstrip()+'\n\n'
# Retain PC root-navigation implementation; add only the lab's opt-in speed adapter.
t=read('core/hero.gd');t=replace(t,'const SPEED_PX := 190.0','static var dev_speed_override := 0.0  # Only initialized by HeroView with --walk-debug.\nconst SPEED_PX := 190.0')
t=replace(t,'return SPEED_PX * clampf(f, 0.4, 2.0)','var base := dev_speed_override if dev_speed_override > 0.0 else SPEED_PX\n\treturn base * clampf(f, 0.4, 2.0)');write('core/hero.gd',t)
# Do not introduce L4 shooting/cast fields or L5 boss mechanics in this visual batch.
t=read('ui/enemy_view.gd');start=t.index('\telif enemy.cast_t > 0.0 or enemy.shoot_wind > 0.0 or enemy.windup > 0.0:')
end=t.index('\telse:',start);t=t[:start]+t[end:];write('ui/enemy_view.gd',t)
t=read('ui/overlay.gd');start=t.index('\tif battle.boss_mech != null:');end=t.index('\tfor e in battle.enemies:',start);t=t[:start]+t[end:]
start=t.index('\t\tif e.shoot_wind > 0.0:');end=t.index('\n## SPEC-129:',start);t=t[:start]+t[end:];write('ui/overlay.gd',t)
# Ruin visuals are metadata only; PC positions/rewards/spawn rules stay untouched.
t=read('core/battle.gd');a='\t\t\t\tinteractions[-1].name = String(poi.name)\n\t\t\t\tplaced += 1'
assert t.count(a)==2
t=t.replace(a,'\t\t\t\tinteractions[-1].name = String(poi.name)\n\t\t\t\tinteractions[-1].ruin_art = "ruina_" + stage_id  # Visual-only port metadata.\n\t\t\t\tplaced += 1',1);write('core/battle.gd',t)
t=read('core/sfx.gd');t=replace(t,'voice.pitch_scale = (1.0 + randf_range(-jitter, jitter)) * pitch_mult','voice.pitch_scale = (1.0 + randf_range(-jitter, jitter)) * pitch_mult * float(definition.get("pitch", 1.0))');write('core/sfx.gd',t)
# Add lettering readers without moving UI/default-font choices from batch 3.
t=read('ui/lettering.gd');source=read('ui/lettering.gd',True)
chunk=source[source.index('## Preserva o Label'):source.index('static func margins_fit')]
t=replace(t,'static func margins_fit',chunk+'static func margins_fit');write('ui/lettering.gd',t)
# Transfer visual event fields recursively, matching events by stable ID; never copy gameplay fields.
before=json.loads(read('data/stage_events.json'));source=json.loads(read('data/stage_events.json',True));visual_keys={'asset','assets'};edits=[]
def visual_merge(dst,origin,path=''):
 if isinstance(dst,dict) and isinstance(origin,dict):
  for key,value in origin.items():
   if key in visual_keys:
    if dst.get(key)!=value:dst[key]=copy.deepcopy(value);edits.append(path+'/'+key)
   elif key in dst:visual_merge(dst[key],value,path+'/'+key)
 elif isinstance(dst,list) and isinstance(origin,list):
  if all(isinstance(x,dict) and 'id' in x for x in dst+origin):
   by_id={x['id']:x for x in origin}
   for item in dst:
    if item['id'] in by_id:visual_merge(item,by_id[item['id']],path+'/'+str(item['id']))
  elif len(dst)==len(origin):
   for i,(a,b) in enumerate(zip(dst,origin)):visual_merge(a,b,path+'/'+str(i))
def without_art(x):
 if isinstance(x,dict):return {k:without_art(v) for k,v in x.items() if k not in visual_keys}
 if isinstance(x,list):return [without_art(v) for v in x]
 return x
after=copy.deepcopy(before);visual_merge(after,source);assert without_art(before)==without_art(after)
write('data/stage_events.json',json.dumps(after,ensure_ascii=False,indent=2)+'\n');(out/'event-visual-metadata.json').write_text(json.dumps(edits,ensure_ascii=False,indent=2),encoding='utf-8')
# Layer only accepted presentation onto the current PC run; retain all campaign/HQ/QA/map logic.
t=read('ui/run.gd');source=read('ui/run.gd',True)
t=replace(t,'var _final_victory_event_seen := false','var _final_victory_event_seen := false\nvar _proj_vfx: Array[Dictionary] = []\nvar _ability_follow := {}\nvar _active_dir := Vector2.ZERO\nvar _swing_dir_frame := Vector2.ZERO')
t=replace(t,'func _load_stage() -> void:\n','func _load_stage() -> void:\n\tfor entry in _proj_vfx:\n\t\tif is_instance_valid(entry.node): entry.node.queue_free()\n\t_proj_vfx.clear()\n\t_ability_follow.clear()\n')
t=replace(t,'\t\tif battle.use_active(battle.aim_dir):','\t\t_active_dir = battle.aim_dir\n\t\tif battle.use_active(battle.aim_dir):')
t=replace(t,'\t_sync_decoys()\n\t_update_divine_aura()','\t_sync_decoys()\n\t_sync_projectile_vfx()\n\t_sync_ability_follow()\n\t_update_divine_aura()')
t=replace(t,'func _consume_events() -> void:\n','func _consume_events() -> void:\n\t_swing_dir_frame = Vector2.ZERO\n')
t=replace(t,'\t\t\t\t_swing(ev, _divine_theme())','\t\t\t\t_swing_dir_frame = ev.get("dir", Vector2.ZERO)\n\t\t\t\t_swing(ev, _divine_theme())')
t=replace(t,'\t\t\t\t_ring(ev.pos, ev.radius, _divine_theme().impact_accent, 0.35)','\t\t\t\t_nova_effect(ev)')
t=replace(t,'\t\t\t\t_float_text(at + Vector2(0, -50), ev.text, Color(0.7, 0.8, 1.0), 12)','\t\t\t\t_float_text(at + Vector2(0, -50), ev.text, Color(0.7, 0.8, 1.0), 12)\n\t\t\t\tif String(ev.text).to_lower() == "dominado":\n\t\t\t\t\t_ability_effect("dominacao", ev)')
t=replace(t,'\t\t\t\thero_node.play_action(&"active")\n\t\t\t\t_ring(ev.pos, float(ev.get("radius", 2.0)), _dcol(String(ev.get("dtype", "radiante"))), 0.3)','\t\t\t\thero_node.play_action(&"active")\n\t\t\t\tif not _ability_effect(String(ev.get("ability_id", "")), ev):\n\t\t\t\t\t_ring(ev.pos, float(ev.get("radius", 2.0)), _dcol(String(ev.get("dtype", "radiante"))), 0.3)\n\t\t\t\t_swing_dir_frame = Vector2.ZERO')
t=replace(t,'["zuggtmoy", "socothbenoth", "sintese_abissal"]','["zuggtmoy", "socothbenoth", "sintese_abissal", "manifestacao_de_juiblex"]')
t=t.replace(function(t,'_play_interaction'),function(source,'_play_interaction'))
for name in ['_sync_projectile_vfx','_retire_projectile_vfx','_ability_effect','_sync_ability_follow','_nova_effect']:t+='\n'+function(source,name)
write('ui/run.gd',t)
# Totem rendering is tested with a synthetic Enemy; its new gameplay definition is batch 3.
t=read('tests/test_actor_strips_b003.gd');t=replace(t,'\t\tview.setup(Enemy.make(id, Vector2.ZERO))','\t\tvar actor := Enemy.new() if id == "totem_de_chefe" else Enemy.make(id, Vector2.ZERO)\n\t\tactor.id = id\n\t\tview.setup(actor)');write('tests/test_actor_strips_b003.gd',t)
# Check all VFX routes now; validate weapon mechanics only once those definitions enter in batch 3.
t=read('tests/test_projectile_and_ability_vfx.gd');old='if not weapons.has(weapon) or weapons[weapon].kind != "bolt" or weapons[weapon].dtype != spec.dtype: failures.append(family + ": arma " + weapon + " nao e bolt do dtype esperado")'
new='if not weapons.has(weapon):\n\t\t\t\tif weapon not in ["raio_da_ruina", "dominio_coletivo"]: failures.append("arma existente ausente: " + weapon)\n\t\t\telif weapons[weapon].kind != "bolt" or weapons[weapon].dtype != spec.dtype: failures.append(family + ": arma " + weapon + " nao e bolt do dtype esperado")'
t=replace(t,old,new);write('tests/test_projectile_and_ability_vfx.gd',t)
print('ADAPTED: retained PC navigation/campaign; presentation wired; event metadata',len(edits),'fields; future gameplay unchanged')
