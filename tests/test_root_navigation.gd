extends RefCounted

func _check(out: Array, value: bool, message: String) -> void:
	if not value:
		out.append(message)

func run() -> Array:
	var out: Array = []
	var b := Battle.new(7202, "durvall", "reino_abissal")
	b.map_size = Vector2(60,60)
	b.hero.map_size = b.map_size
	b.hero.blockers.clear()
	b.hero.pos = Vector2(30,54)
	var d := b.root_layout
	_check(out,d.nodes.size()==18 and d.edges.size()==23 and d.edges.size()-d.nodes.size()+1==6,"Spiral graph contract")
	_check(out,b.objective_target()==Vector2(30,31) and int(b.stage.duration)==360 and int(b.stage.cap)==50,"Spiral objective/timing/cap changed")
	# Explicit IDs and per-battle fields cannot overwrite the accepted r2 mesh.
	var other := Battle.new(7503,"durvall","raiz_yggdrasil")
	other.hero.blockers.clear()
	for i in 3:
		_check(out,TerrainLayout.root_definition("raiz_yggdrasil").nodes.size()==12,"Yggdrasil definition unavailable")
		_check(out,TerrainLayout.root_definition().nodes.size()==18,"Default root definition contaminated")
		_check(out,b.hero.can_stand(Vector2(14,54)) and not other.hero.can_stand(Vector2(14,54)),"Root support IDs contaminated")
		_check(out,not b.hero.can_stand(Vector2(30,48)) and other.hero.can_stand(Vector2(30,48)),"Root arrival supports contaminated")
		other._root_field(Vector2(30,12),0.4)
		b._root_field(Vector2(30,54),0.4)
	_check(out,TerrainLayout.root_definition("unknown").is_empty(),"Unknown ID inherited root support")
	_check(out,not b.hero.dead and b.hero.pos == Vector2(30,54),"Root arrival initialization invalid")
	# Previous-stage scenery must be replaced, rather than reject a new arrival.
	b.hero.blockers = [Vector3(30,54,2)]
	b.load_stage("reino_abissal")
	_check(out,not b.hero.dead,"Previous map blockers rejected root stage")
	b.hero.blockers.clear()
	_check(out, d.air_ids.is_empty(), "No campaign enemy gains unapproved flight")
	_check(out, not b.hero.can_stand(Vector2(13,25)), "Void must have no ground support")
	_check(out, b.hero.can_stand(Vector2(13,25),0.4,true), "Synthetic flight may cross root void")
	_check(out, not b.hero.can_stand(Vector2(0.2,22),0.4,true), "Flight obeys outer bounds")
	b.hero.blockers = [Vector3(13,25,1)]
	_check(out, not b.hero.can_stand(Vector2(13,25),0.4,true), "Flight preserves object collisions")
	b.hero.blockers.clear()
	for radius in [0.15,0.3,0.4,0.8,1.2]:
		var field := b._root_field(Vector2(30,54),radius)
		var grid := b._root_grid(radius)
		for node: Array in d.nodes.values():
			_check(out, field.has(b._root_cell(TerrainLayout.root_point(node),grid,b._root_grid_step(radius))), "Disconnected node/radius %s %s" % [node,radius])
		for edge: Array in d.edges:
			var a := TerrainLayout.root_point(d.nodes[edge[0]])
			var z := TerrainLayout.root_point(d.nodes[edge[1]])
			_check(out, b.hero.sweep(a,z-a,radius).distance_to(z) < 0.001, "Blocked valid connection")
		# Both endpoints are on roots, but the direct line crosses the central void.
		var start := Vector2(7,25)
		var end := Vector2(19,25)
		var result := b.hero.sweep(start,end-start,radius)
		_check(out, result.x < 10.01-radius and b.hero.can_stand(result,radius), "Sweep crossed gap or left footprint unsupported")
		for i in 32:
			var delta := Vector2.from_angle(TAU*float(i)/32.0)*60.0
			var at := b.hero.sweep(Vector2(30,54),delta,radius)
			_check(out,b.hero.can_stand(at,radius),"Large diagonal swept move escaped roots")
		_check(out,not b.hero.can_stand(Vector2(10-radius+0.01,25),radius),"Center-only edge admission")
	# Input and push share the same swept path, including excessive dt.
	b.hero.pos = Vector2(7,25)
	b.hero.push = Vector2(50,0)
	b.hero.step(Vector2.ZERO,1.0)
	_check(out,b.hero.pos.x < 9.71 and b.hero.can_stand(b.hero.pos),"Push tunneled across gap")
	b.hero.push = Vector2.ZERO
	# Use the real dash ability with a long synthetic distance to cross both roots.
	var dash := Battle.new(7203,"sylas","reino_abissal")
	dash.hero.pos = Vector2(7,25)
	dash.active_def.distance = 30.0
	_check(out,dash.use_active(Vector2.RIGHT),"Dash ability did not execute")
	_check(out,dash.hero.pos.x < 9.71 and dash.hero.can_stand(dash.hero.pos),"Actual dash ability crossed void")
	# Production displacement consumers and explicit enemy admission.
	var enemy := b._spawn("cultista_adaga",Vector2(7,25))
	_check(out,not enemy.dead and enemy.mobility == "ground","Wave enemy should remain terrestrial")
	b._enemy_move(enemy,Vector2(30,0))
	_check(out,enemy.pos.x < 10 and b.hero.can_stand(enemy.pos,enemy.radius),"Enemy move tunneled")
	enemy.pos = Vector2(7,25)
	b.hero.pos = Vector2(6,25)
	b._apply_effects(enemy,{"knock":30})
	_check(out,enemy.pos.x < 10 and b.hero.can_stand(enemy.pos,enemy.radius),"Knockback escaped")
	enemy.pos = Vector2(7,25)
	enemy.charge_t = 1.0
	enemy.charge_dir = Vector2.RIGHT
	enemy.charge_ab = {"speed":30,"dice":"1d1"}
	b._enemy_step(enemy,0.5)
	_check(out,enemy.pos.x < 10 and b.hero.can_stand(enemy.pos,enemy.radius),"Charge escaped")
	var flying := Enemy.new()
	flying.pos = Vector2(7,25)
	flying.mobility = "air"
	b._enemy_move(flying,Vector2(12,0))
	_check(out,flying.pos.distance_to(Vector2(19,25)) < 0.001,"Synthetic flight blocked by void")
	var count := b.enemies.size()
	var denied := b._spawn("cultista_adaga",Vector2(13,25))
	_check(out,denied.dead and b.enemies.size() == count,"Secondary spawn admitted in void")
	b._kill(denied)
	_check(out,b.stats.kills == 0,"Rejected spawn generated kill")
	b.hero.blockers = [Vector3(30,30,100)]
	var no_spawn := b._ring_pos()
	_check(out,not no_spawn.is_finite() and b._spawn("cultista_adaga",no_spawn).dead and b.enemies.size() == count,"Failed sampling must omit spawn without unsafe fallback")
	b.hero.blockers.clear()
	for node: Array in d.nodes.values():
		b.hero.pos = TerrainLayout.root_point(node)
		for i in 32:
			var at := b._ring_pos()
			_check(out,at.is_finite() and b._root_spawn_valid(at,0.4),"Wave ring/fallback invalid")
	b._drop("gold",Vector2(13,25),7,"test")
	_check(out,b.pickups.size() == 1 and b.hero.can_stand(b.pickups[0].pos,0.15) and b.hero.gold == 0,"Airborne loot inaccessible or auto-paid")
	b.pickups[0].magnet = true
	b.hero.pos = Vector2(19,25)
	for i in 30:
		b._update_pickups(0.02)
		for p in b.pickups:
			_check(out,b.hero.can_stand(p.pos,0.15),"Magnet moved loot off root")
	# End-to-end detour around a void, with the actual enemy AI and body radius.
	var chaser := b._spawn("cultista_adaga",Vector2(7,25))
	b.hero.pos = Vector2(19,25)
	chaser.abilities = []
	chaser.speed = 3.0
	for i in 2400:
		b._enemy_step(chaser,0.02)
		_check(out,b.hero.can_stand(chaser.pos,chaser.radius),"Chaser body left root")
		if chaser.pos.distance_to(b.hero.pos) < 2.0:
			break
	_check(out,chaser.pos.distance_to(b.hero.pos) < 2.0,"Chaser stuck at void instead of detouring")
	# Surface restriction remains specific to Reino Abissal.
	b.hero.terrain_id = "domwieck"
	_check(out,b.hero.can_stand(Vector2(13,25)),"Root restriction leaked into Domwieck")
	return out
