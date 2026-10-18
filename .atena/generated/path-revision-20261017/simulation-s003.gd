extends SceneTree
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	var output:=args[args.find("--capture-dir")+1]
	var failures: Array=[]
	var b:=Battle.new(7202,"durvall","reino_abissal",{"qa_sandbox":true})
	b.hero.blockers.clear()
	b.hero.max_hp=1.0e9
	b.hero.hp=b.hero.max_hp
	b.hero.weapons.clear()
	var max_count:=0
	for i in 1440:
		b.step(Vector2.ZERO,0.25)
		max_count=maxi(max_count,b._combat_count())
		for e: Enemy in b.enemies:
			if not e.dead and not b.hero.can_stand(e.pos,e.radius,e.mobility=="air"):
				failures.append("Enemy outside support")
		for pickup in b.pickups:
			if not b.hero.can_stand(pickup.pos,0.15):
				failures.append("Pickup outside support")
	if max_count>50 or b.state!="running" or b.stage_cleared:
		failures.append("Duration/cap/early completion contract")
	b.hero.pos=b.objective_target()
	for i in 3:
		b.step(Vector2.ZERO,1.0)
	if not b.stage_cleared or b.state!="won":
		failures.append("Spiral objective could not complete")
	var file:=FileAccess.open(output.path_join("simulation-result.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"seed":7202,"seconds":360,"max_enemies":max_count,"arrival":b.root_layout.arrival,"target":b.root_layout.target,"completed":b.stage_cleared,"fixture_only":"High HP/no weapons in synthetic simulation; no human survival claim"},"\t"))
	file.close()
	root.get_node("Sfx").stop_music(0.0)
	root.get_node("Sfx").stop_ambience(0.0)
	await create_timer(0.25).timeout
	quit(0 if failures.is_empty() else 1)
