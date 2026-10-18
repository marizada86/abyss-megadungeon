const fs=require('fs');const base='.atena/generated/path-revision-20261017';let s=fs.readFileSync(base+'/validate-s003.ps1','utf8').replaceAll('s002-','s003-');fs.writeFileSync(base+'/validate-s003.ps1',s);
s=fs.readFileSync(base+'/render-s002.gd','utf8').replace('for seed_value in [7502,7503,7504]:','for seed_value in [7202]:').replaceAll('"raiz_yggdrasil"','"reino_abissal"').replaceAll('"yggdrasil-','"abyss-').replace('"yggdrasil-7502-combat40"','"abyss-7202-combat50"');
s=s.replace('if seed_value==7502:','if seed_value==7202:').replace('nodes.C1','nodes.O').replace('for i in 40:','for i in 50:').replace('b._combat_count()!=40','b._combat_count()!=50').replace('missing40','missing50');
const begin=s.indexOf('\t\tvar art=scene.stage_root.get_node("YggdrasilArt")');const end=s.indexOf('\t\tscene.camera.position=',begin);
s=s.slice(0,begin)+`\t\tvar ground=scene.stage_root.get_node("Ground")
\t\tif ground.root_layout!=b.root_layout or not ground._prepare_root_art():
\t\t\tfailures.append("Spiral art/support injection failed")
\t\tvar art:=Node.new()
\t\tart.set_meta("floor_rect",ground._root_art_rect)
\t\tart.set_meta("floor_material",ground._root_art_material)
\t\tif b.hero.pos!=Vector2(30,54) or b.objective_target()!=Vector2(30,31):
\t\t\tfailures.append("Spiral runtime arrival/target incorrect")
`+s.slice(end);
s=s.replace('floor_node.bounds=art.floor_rect','floor_node.bounds=art.get_meta("floor_rect")').replace('var mat: ShaderMaterial=art.floor_material.duplicate()','var mat: ShaderMaterial=art.get_meta("floor_material").duplicate()').replace('"generation":definition.generation','"revision":definition.revision');
s=s.replace('await _mask(art,b.root_layout,seed_value)','await _mask(art,b.root_layout,seed_value)\n\t\tart.free()');
fs.writeFileSync(base+'/render-s003.gd',s);
console.log('S003 isolated launcher and spiral GPU/mask harness ready.');
