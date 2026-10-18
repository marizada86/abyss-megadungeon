extends RefCounted

func _check(out: Array, ok: bool, message: String) -> void:
	if not ok:
		out.append(message)

func run() -> Array:
	var out: Array = []
	var b := Battle.new(7502,"durvall","raiz_yggdrasil")
	b.hero.blockers.clear()
	var d: Dictionary = b.root_layout
	_check(out,b.hero.pos==Vector2(30,48) and not b.hero.dead,"Yggdrasil arrival unsupported")
	_check(out,d.nodes.size()==12 and d.edges.size()>=16 and d.edges.size()<=17 and d.air_ids.is_empty(),"Yggdrasil geometry/air contract changed")
	for radius in [Hero.RADIUS,0.4,0.8]:
		var grid := b._root_grid(radius)
		var field := b._root_field(Vector2(30,12),radius)
		_check(out,field.size()==grid.size() and not field.is_empty(),"Disconnected Yggdrasil support grid")
		for node: Array in d.nodes.values():
			_check(out,b.hero.can_stand(TerrainLayout.root_point(node),radius),"Unsupported node/body")
		for edge: Array in d.edges:
			var a := TerrainLayout.root_point(d.nodes[edge[0]])
			var z := TerrainLayout.root_point(d.nodes[edge[1]])
			_check(out,b.hero.sweep(a,z-a,radius).distance_to(z)<0.01,"Sweep failed along edge")
			_check(out,b.hero.sweep(z,a-z,radius).distance_to(a)<0.01,"Reverse sweep failed along edge")
			var normal := (z-a).normalized().orthogonal()
			var near: Vector2 = a.lerp(z,0.5)+normal*(TerrainLayout.root_edge_width(d,edge)*0.5-float(radius)-0.01)
			var stopped := b.hero.sweep(near,normal*12.0,radius)
			_check(out,b.hero.can_stand(stopped,radius),"Outward displacement left supporting roots")
	_check(out,not b.hero.can_stand(Vector2(15,45)),"Yggdrasil inherited unrelated western root")
	_check(out,b.hero.can_stand(Vector2(30,51.5)),"Yggdrasil arrival did not use its own radius/center")
	_check(out,b.hero.can_stand(Vector2(15,45),0.4,true),"Synthetic flight cannot cross internal void")
	_check(out,not b.hero.can_stand(Vector2(-1,45),0.4,true),"Synthetic flight escaped outer map")
	for node: Array in d.nodes.values():
		b.hero.pos=TerrainLayout.root_point(node)
		for i in 12:
			var spot := b._ring_pos()
			_check(out,spot.is_finite() and b._root_spawn_valid(spot,0.4),"No valid spawn connected to node")
	var count := b.enemies.size()
	_check(out,b._spawn("cultista_adaga",Vector2.INF).dead and b.enemies.size()==count,"Invalid spawn was admitted")
	b._drop("gold",Vector2(15,45),7,"ygg-nav")
	_check(out,b.pickups.size()==1 and b.hero.can_stand(b.pickups[0].pos,0.15) and b.hero.gold==0,"Loot unsupported or automatically paid")
	b.hero.pos=Vector2(30,32)
	for pickup in b.pickups:
		pickup.magnet=true
	for i in 60:
		b._update_pickups(0.02)
		for pickup in b.pickups:
			_check(out,b.hero.can_stand(pickup.pos,0.15),"Magnet crossed void")
	var chaser := b._spawn("cultista_adaga",TerrainLayout.root_point(d.nodes.W1))
	b.hero.pos=Vector2(30,22)
	chaser.abilities=[]
	chaser.speed=3.0
	for i in 2400:
		b._enemy_step(chaser,0.02)
		_check(out,b.hero.can_stand(chaser.pos,chaser.radius),"Chaser crossed a void")
		if chaser.pos.distance_to(b.hero.pos)<2.0:
			break
	_check(out,chaser.pos.distance_to(b.hero.pos)<2.0,"Chaser could not traverse the branch")
	# Exercise production movement consumers against an exposed arrival rim.
	var rim := Vector2(30,52.1)
	b.hero.pos=rim
	b.hero.push=Vector2(0,50)
	b.hero.step(Vector2.ZERO,1.0)
	_check(out,b.hero.can_stand(b.hero.pos) and b.hero.pos.y<52.5,"Actual push escaped arrival rim")
	b.hero.push=Vector2.ZERO
	var dash := Battle.new(7503,"sylas","raiz_yggdrasil")
	dash.hero.pos=rim
	dash.active_def.distance=30.0
	_check(out,dash.use_active(Vector2.DOWN) and dash.hero.can_stand(dash.hero.pos) and dash.hero.pos.y<52.5,"Actual dash escaped arrival rim")
	var mover := b._spawn("cultista_adaga",rim)
	b._enemy_move(mover,Vector2(0,30))
	_check(out,b.hero.can_stand(mover.pos,mover.radius) and mover.pos.y<52.5,"Enemy advance escaped rim")
	mover.pos=rim
	b.hero.pos=Vector2(30,50)
	b._apply_effects(mover,{"knock":30})
	_check(out,b.hero.can_stand(mover.pos,mover.radius),"Actual knockback escaped rim")
	mover.pos=rim
	mover.charge_t=1.0
	mover.charge_dir=Vector2.DOWN
	mover.charge_ab={"speed":30,"dice":"1d1"}
	b._enemy_step(mover,0.5)
	_check(out,b.hero.can_stand(mover.pos,mover.radius) and mover.pos.y<52.5,"Actual charge escaped rim")
	var neighbor := b._spawn("cultista_adaga",rim-Vector2(0,0.2))
	mover.pos=rim
	mover.charge_t=0.0
	mover.speed=0.0
	b._build_grid()
	b._enemy_step(mover,0.1)
	_check(out,not neighbor.dead and b.hero.can_stand(mover.pos,mover.radius),"Actual separation escaped rim")
	for radius in [0.3,0.4,0.8]:
		for i in 32:
			var swept := b.hero.sweep(Vector2(30,48),Vector2.from_angle(TAU*float(i)/32.0)*60.0,radius)
			_check(out,b.hero.can_stand(swept,radius),"Long diagonal displacement escaped root support")
	var before := b.enemies.size()
	b.hero.blockers=[Vector3(30,30,100)]
	var omitted := b._spawn("cultista_adaga",b._ring_pos())
	b._kill(omitted)
	_check(out,omitted.dead and b.enemies.size()==before and b.stats.kills==0,"Omitted spawn created debt or reward")
	b.hero.blockers.clear()
	for id in ["cultista_adaga","notivago","cultista_arqueiro","criatura_corrompida"]:
		var actual := b._spawn(id,Vector2(30,32))
		_check(out,not actual.dead and actual.mobility=="ground" and is_equal_approx(actual.radius,0.4 if id=="criatura_corrompida" else 0.3),"Wave body/ground contract changed: "+id)

	# Reproducible topology, widths and routing across 128 seeds. No combat RNG use.
	var seeds: Array = range(120)
	seeds.append_array([7502,7503,7504,7601,7602,7603,1000001,2147483647])
	var unique: Dictionary = {}
	var fallback_count := 0
	var base := TerrainLayout.root_definition("raiz_yggdrasil")
	for seed_value: int in seeds:
		var first := RootPathGenerator.new().generate(base,seed_value)
		var second := RootPathGenerator.new().generate(base,seed_value)
		_check(out,not first.is_empty() and first == second,"Seed is invalid/non-reproducible: %d" % seed_value)
		if first.is_empty():
			continue
		unique[JSON.stringify([first.nodes,first.edges])] = true
		fallback_count += int(first.generation.fallback)
		_check(out,RootPathGenerator.valid(first),"Generated geometry violates bounds/area/graph guards")
		for index in first.edges.size():
			var width := float(first.edges[index][2])
			_check(out,width>=7.0 and width<=8.0 if index<3 else width>=4.5 and width<=5.5,"Width outside approved range")
		# Exercise the actual eroded four-neighbor AI grid, not just graph theory.
		b.root_layout=first
		b.hero.root_layout=first
		b._root_grids.clear()
		b._root_fields.clear()
		for radius in [0.3,0.4,0.8,1.2]:
			var cells := b._root_grid(radius)
			var field := b._root_field(Vector2(30,12),radius)
			_check(out,not cells.is_empty() and field.size()==cells.size() and field.has(b._root_cell(Vector2(30,48),cells,b._root_grid_step(radius))),"Disconnected real AI grid seed %d radius %s" % [seed_value,radius])
	_check(out,unique.size()>=120 and fallback_count<=6,"Diversity/fallback contract failed")
	var first_battle := Battle.new(7502,"durvall","raiz_yggdrasil")
	var first_hash := JSON.stringify(first_battle.root_layout)
	var second_battle := Battle.new(7503,"durvall","raiz_yggdrasil")
	var abyss := Battle.new(7202,"durvall","reino_abissal")
	var city := Battle.new(7202,"durvall","domwieck")
	for i in 3:
		second_battle._root_field(Vector2(30,12),0.4)
		abyss._root_field(Vector2(30,15),0.4)
		_check(out,JSON.stringify(first_battle.root_layout)==first_hash and first_battle.root_layout!=second_battle.root_layout,"Battle geometry contaminated by other seed/map")
		_check(out,city.root_layout.is_empty() and abyss.root_layout.nodes.size()==18,"Geometry leaked into other stages")
	first_battle.load_stage("domwieck")
	_check(out,first_battle.root_layout.is_empty() and first_battle.hero.root_layout.is_empty(),"Root geometry survives a stage change")
	var combat_rng := RandomNumberGenerator.new()
	combat_rng.seed=7502
	var rng_state := combat_rng.state
	RootPathGenerator.new().generate(base,7502)
	_check(out,combat_rng.state==rng_state,"Generator consumed unrelated RNG")
	var malformed := base.duplicate(true)
	malformed.edges[0][1]=malformed.edges[0][0]
	_check(out,RootPathGenerator.new().generate(malformed,7502).is_empty(),"Unsafe fallback admitted malformed base")
	print("PATH_SEEDS=128 UNIQUE=%d FALLBACKS=%d" % [unique.size(),fallback_count])
	return out
