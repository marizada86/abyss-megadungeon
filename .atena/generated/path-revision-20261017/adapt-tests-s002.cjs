const fs=require('fs');
function edit(p,fn){let s=fs.readFileSync(p,'utf8');fs.writeFileSync(p,fn(s));}
edit('tests/test_root_navigation.gd',s=>s.replace('root_definition("raiz_yggdrasil").nodes.size()==7','root_definition("raiz_yggdrasil").nodes.size()==12').replaceAll('Vector2(30,52.5)','Vector2(30,51.5)'));
edit('tests/test_yggdrasil_navigation.gd',s=>{s=s.replace('var d := TerrainLayout.root_definition("raiz_yggdrasil")','var d: Dictionary = b.root_layout').replace('d.nodes.size()==7 and d.edges.size()==8','d.nodes.size()==12 and d.edges.size()>=16 and d.edges.size()<=17').replace('Vector2(30,52.5)','Vector2(30,51.5)').replace('Vector2(16,28)','TerrainLayout.root_point(d.nodes.W1)').replace('var rim := Vector2(37.6,48)','var rim := Vector2(30,52.1)');s=s.replaceAll('Vector2(50,0)','Vector2(0,50)').replaceAll('Vector2(30,0)','Vector2(0,30)').replaceAll('Vector2.RIGHT','Vector2.DOWN').replaceAll('.pos.x<38.0','.pos.y<52.5').replaceAll('rim-Vector2(0.2,0)','rim-Vector2(0,0.2)').replace('Vector2(34,48)','Vector2(30,50)');
const anchor='\treturn out';const more=`
\t# Reproducible topology, widths and routing across 128 seeds. No combat RNG use.
\tvar seeds: Array = range(120)
\tseeds.append_array([7502,7503,7504,7601,7602,7603,1000001,2147483647])
\tvar unique: Dictionary = {}
\tvar fallback_count := 0
\tvar base := TerrainLayout.root_definition("raiz_yggdrasil")
\tfor seed_value: int in seeds:
\t\tvar first := RootPathGenerator.new().generate(base,seed_value)
\t\tvar second := RootPathGenerator.new().generate(base,seed_value)
\t\t_check(out,not first.is_empty() and first == second,"Seed is invalid/non-reproducible: %d" % seed_value)
\t\tif first.is_empty():
\t\t\tcontinue
\t\tunique[JSON.stringify([first.nodes,first.edges])] = true
\t\tfallback_count += int(first.generation.fallback)
\t\t_check(out,RootPathGenerator.valid(first),"Generated geometry violates bounds/area/graph guards")
\t\tfor index in first.edges.size():
\t\t\tvar width := float(first.edges[index][2])
\t\t\t_check(out,width>=7.0 and width<=8.0 if index<3 else width>=4.5 and width<=5.5,"Width outside approved range")
\t\t# Exercise the actual eroded four-neighbor AI grid, not just graph theory.
\t\tb.root_layout=first
\t\tb.hero.root_layout=first
\t\tb._root_grids.clear()
\t\tb._root_fields.clear()
\t\tfor radius in [0.3,0.4,0.8,1.2]:
\t\t\tvar cells := b._root_grid(radius)
\t\t\tvar field := b._root_field(Vector2(30,12),radius)
\t\t\t_check(out,not cells.is_empty() and field.size()==cells.size() and field.has(b._root_cell(Vector2(30,48),cells)),"Disconnected real AI grid seed %d radius %s" % [seed_value,radius])
\t_check(out,unique.size()>=120 and fallback_count<=6,"Diversity/fallback contract failed")
\tvar first_battle := Battle.new(7502,"durvall","raiz_yggdrasil")
\tvar first_hash := JSON.stringify(first_battle.root_layout)
\tvar second_battle := Battle.new(7503,"durvall","raiz_yggdrasil")
\tvar abyss := Battle.new(7202,"durvall","reino_abissal")
\tvar city := Battle.new(7202,"durvall","domwieck")
\tfor i in 3:
\t\tsecond_battle._root_field(Vector2(30,12),0.4)
\t\tabyss._root_field(Vector2(30,15),0.4)
\t\t_check(out,JSON.stringify(first_battle.root_layout)==first_hash and first_battle.root_layout!=second_battle.root_layout,"Battle geometry contaminated by other seed/map")
\t\t_check(out,city.root_layout.is_empty() and abyss.root_layout.nodes.size()==9,"Geometry leaked into other stages")
\tfirst_battle.load_stage("domwieck")
\t_check(out,first_battle.root_layout.is_empty() and first_battle.hero.root_layout.is_empty(),"Root geometry survives a stage change")
\tvar combat_rng := RandomNumberGenerator.new()
\tcombat_rng.seed=7502
\tvar rng_state := combat_rng.state
\tRootPathGenerator.new().generate(base,7502)
\t_check(out,combat_rng.state==rng_state,"Generator consumed unrelated RNG")
\tvar malformed := base.duplicate(true)
\tmalformed.edges[0][1]=malformed.edges[0][0]
\t_check(out,RootPathGenerator.new().generate(malformed,7502).is_empty(),"Unsafe fallback admitted malformed base")
\tprint("PATH_SEEDS=128 UNIQUE=%d FALLBACKS=%d" % [unique.size(),fallback_count])
`;
return s.replace(anchor,more+anchor)});
edit('tests/test_yggdrasil_art.gd',s=>s.replace('nodes.size()!=7 or edges.size()!=8 or widths.size()!=8','nodes.size()!=32 or edges.size()!=32 or widths.size()!=32 or int(art.floor_material.get_shader_parameter("node_count"))!=12 or int(art.floor_material.get_shader_parameter("edge_count"))!=17').replace('accepted r3','approved r4').replace('!=28.0','!=20.0').replace('\tart.free()\n\treturn out',`\tvar other=load("res://ui/yggdrasil_art.gd").new()
\tother.root_layout=RootPathGenerator.new().generate(d,7503)
\tif not other.prepare() or other.floor_material==art.floor_material or int(other.floor_material.get_shader_parameter("edge_count"))!=other.root_layout.edges.size():
\t\tout.append("Per-instance material/geometry unavailable")
\tother.free()
\tart.free()
\treturn out`));
// The objective/cap assertions stay exact; derive test spawn points from real support.
edit('tests/test_yggdrasil_map.gd',s=>s.replaceAll('Vector2(30,32)','TerrainLayout.root_point(b.root_layout.nodes.C1)'));
console.log('Navigation/art/map fixtures adapted; behavior assertions retained.');
