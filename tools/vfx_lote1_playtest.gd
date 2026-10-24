extends SceneTree
const OUTPUT := "res://.atena/generated/vfx-lote1-20261023-r1/"
var checks: Array[Dictionary] = []
func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("vfx ", id, ": ", passed)
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	var expected := ProjectSettings.globalize_path(OUTPUT + "synthetic/").replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed:
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://vfx-synthetic.json"
	game.profile = Profile.new({"name": "VFX synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "durvall"
	var scene: Node = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	if OS.get_cmdline_user_args().has("--interactive"):
		scene.battle.state = "running"
		paused = false
		scene.battle.hero.weapons = [Weapon.make("cera_fervente", 3), Weapon.make("inferno_de_cera", 3), Weapon.make("tocha_do_incendiario", 3), Weapon.make("golpe_do_juizo", 3)]
		for i in 4:
			scene.battle.spawn_for_test(["cultista_arqueiro", "esporo_voador", "cultista_thullgrime", "master_of_cruelties"][i % 4], scene.battle.hero.pos + Vector2.RIGHT.rotated(i * TAU / 8.0) * 7.0)
		scene.battle.hero.max_hp = 1000.0
		scene.battle.hero.hp = 1000.0
		scene.hud.toast("Teste VFX: cera, arcos e projéteis. Compare a opção Reduzir efeitos de impacto nas configurações.")
		if OS.get_cmdline_user_args().has("--verify-interactive"):
			for i in 30: await process_frame
			check("interactive_ready", scene.battle.hero.weapons.size() == 4 and game.qa_sandbox and scene.battle.state == "running")
			print("VFX_INTERACTIVE_LAUNCH_PASS")
			scene.queue_free()
			current_scene = null
			await process_frame
			quit()
		return
	scene.set_physics_process(false)
	scene.battle.state = "running"
	paused = false
	scene.battle.enemies.clear()
	scene.battle.projectiles.clear()
	scene.battle.zones.clear()
	scene.battle.hero.pos = Vector2(20,20)
	scene.hero_node.position = Iso.to_screen(scene.battle.hero.pos)
	scene.camera.position = scene.hero_node.position
	for i in 60:
		var family_id: String = ["cultista_arqueiro","esporo_voador","cultista_thullgrime","malcanthet"][i % 4]
		scene.battle.projectiles.append({"owner":"enemy","src":"death_tyrant" if i%5==0 else family_id,"ring":i%5==0,"pos":Vector2(20,20)+Vector2.RIGHT.rotated(i*TAU/60)* (2.0+float(i%3)), "dir":Vector2.RIGHT.rotated(i*TAU/60),"life":2.0,"p":{}})
	for i in 3:
		scene.battle.zones.append({"owner":"hero","kind":"zone","pos":Vector2(20,20)+Vector2(float(i-1)*3, 2),"radius":1.4,"life":20.0,"p":{"id":"inferno_de_cera" if i==1 else "cera_fervente","dtype":"fogo"}})
	var before_pr: Array = scene.battle.projectiles.duplicate(true)
	var before_zone: Array = scene.battle.zones.duplicate(true)
	var rng_state: int = scene.battle.rng.state
	Engine.max_fps = 120
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var summaries := {}
	for enabled in [false,true]:
		game.profile.data.settings.reduced_impact = not enabled
		for i in 45: await process_frame
		var stats := FrameStats.new()
		var previous := Time.get_ticks_usec()
		for i in 180:
			await process_frame
			var now := Time.get_ticks_usec()
			stats.add(float(now-previous)/1000000.0)
			previous=now
		summaries["sprites" if enabled else "procedural_reduced"] = stats.total()
		check("flight_count_enabled_" + str(enabled), scene._proj_vfx.size() == (60 if enabled else 0))
		check("wax_count_enabled_" + str(enabled), scene._wax_vfx.size() == (3 if enabled else 0))
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			var image := root.get_texture().get_image()
			image.save_png(ProjectSettings.globalize_path(OUTPUT + ("stress-sprites.png" if enabled else "stress-procedural.png")))
	check("projectile_unchanged", before_pr == scene.battle.projectiles)
	check("zone_unchanged", before_zone == scene.battle.zones)
	check("battle_rng_unchanged", rng_state == scene.battle.rng.state)
	# Exercise the view sync, rather than only the static limit predicate.
	for i in 40:
		var pr: Dictionary = before_pr[i % 60].duplicate(true)
		pr.pos += Vector2(1,1)
		scene.battle.projectiles.append(pr)
	scene._sync_projectile_vfx()
	check("flight_cap_80", scene._proj_vfx.size() == 80 and scene.over.visual_projectiles.size() == 80)
	scene.battle.projectiles.clear()
	scene._sync_projectile_vfx()
	check("impact_generated", get_nodes_in_group(&"projectile_vfx_impact").size() > 0)
	await create_timer(0.4).timeout
	check("impact_cleanup", get_nodes_in_group(&"projectile_vfx_impact").is_empty())
	# Montage in the actual stage: the 17 accepted sources routed through their consumers.
	scene.battle.zones.clear()
	scene._sync_wax_vfx()
	var origin := Vector2(20,20)
	for i in 5:
		var ev := {"pos":origin+Vector2(float(i-2)*2,-3),"dtype":["fisico","magico","fogo","radiante","fisico"][i],"crit":i==4,"tid":i,"tier":""}
		var effect := HitSparkVfx.create_effect(ev)
		if effect != null:
			scene.fx.add_child(effect)
			var sprite := effect.get_child(0) as AnimatedSprite2D
			sprite.stop()
			sprite.frame=2

	for i in 2:
		var ev := {"type":"swing","pos":origin+Vector2(float(i*5-2),0),"dir":Vector2.RIGHT,"range":2.0,"cone":60.0,"dtype":"radiante" if i==0 else "fogo","weapon":"golpe_do_juizo" if i==0 else "tocha_do_incendiario"}
		var effect := MeleeVfx.create_effect(ev,Color.WHITE) if i==0 else FireSwingVfx.create_effect(ev)
		if effect != null: scene.fx.add_child(effect)
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "consumer-samples.png"))
	# Contrast probe: same view sync on a synthetic light floor, with the stage art hidden.
	scene.stage_root.hide()
	var floor_node := Polygon2D.new()
	floor_node.polygon = PackedVector2Array([Vector2(-1800,-1200),Vector2(1800,-1200),Vector2(1800,1200),Vector2(-1800,1200)])
	floor_node.position = Iso.to_screen(origin)
	floor_node.color = Color(0.86,0.84,0.79)
	floor_node.z_index = -1000
	scene.add_child(floor_node)
	scene.battle.projectiles = before_pr
	scene.battle.zones = before_zone
	scene._sync_projectile_vfx()
	scene._sync_wax_vfx()
	for i in 2:
		var cast := WaxVfx.create_cast({"weapon":"cera_fervente" if i==0 else "inferno_de_cera","radius":1.4,"pos":origin+Vector2(float(i*5-2),-3)})
		if cast != null:
			scene.fx.add_child(cast)
			var sprite := cast.get_child(0) as AnimatedSprite2D
			sprite.stop()
			sprite.frame = 2
	for i in 4: await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "contrast-light.png"))
	var failures := checks.filter(func(c): return not c.passed)
	var file := FileAccess.open(OUTPUT+"playtest-verification.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks":checks,"failures":failures,"frame_stats":summaries,"renderer":RenderingServer.get_video_adapter_name(),"synthetic":true,"human_playtest":"PENDING"}, "	"))
	print("vfx integration: ",failures.size()," failures")
	scene.queue_free()
	current_scene = null
	await process_frame
	await process_frame
	quit(0 if failures.is_empty() else 1)



