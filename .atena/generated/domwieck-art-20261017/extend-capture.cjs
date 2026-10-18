const fs=require('fs');const dir='.atena/generated/domwieck-art-20261017/';
let text=fs.readFileSync(dir+'capture-s004.gd','utf8');
text=text.replace('"side_l","combat"]','"side_l","behind_building","tree_near","combat","combat_garden"]');
text=text.replace('"combat":Vector2(30,30)','"behind_building":Vector2(7,19.5),"tree_near":Vector2(30,12.4),"combat_garden":Vector2(30,15),"combat":Vector2(30,30)');
text=text.replace('if phase == "combat":','if phase in ["combat","combat_garden"]:');
text=text.replace('if stage_id == "reino_abissal" and phase == "garden":','if stage_id == "reino_abissal" and phase in ["garden","tree_near","behind_building"]:');
text=text.replace('phase in ["target","combat"]','phase in ["target","combat_garden"]');
fs.writeFileSync(dir+'capture-s004.gd',text);
let perf=fs.readFileSync(dir+'render-audit.gd','utf8');
const func=`func _root_regression() -> Dictionary:
 var view:=SubViewport.new()
 view.size=Vector2i(1280,720)
 view.transparent_bg=true
 view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 root.add_child(view)
 var previous: Image
 var equal:=true
 for script_path in ["res://.atena/generated/domwieck-art-20261017/s004-before/ui/ground.gd","res://ui/ground.gd"]:
  var ground=load(script_path).new()
  ground.map_size=Vector2i(60,60)
  ground.terrain_layout_id="reino_abissal"
  ground.scale=Vector2(0.42,0.42)
  ground.position=Vector2(640,-90)
  view.add_child(ground)
  await _frame()
  await _frame()
  var current:=view.get_texture().get_image()
  if previous==null:
   previous=current
  else:
   equal=previous.get_data()==current.get_data()
  ground.queue_free()
  await _frame()
 view.queue_free()
 await process_frame
 if not equal:
  failures.append("Root rendering changed after Domwieck integration")
 return {"root_art_pixels_identical_to_baseline":equal}

`;
perf=perf.replace('func _percentiles(',func+'func _percentiles(');
perf=perf.replace('var mask: Dictionary={"scope":"Domwieck A/B visual toggle; root regression in capture run"}','var mask: Dictionary=await _root_regression()');
fs.writeFileSync(dir+'render-audit.gd',perf);
console.log('Added occlusion/combat-garden captures and exact root pixel regression.');
