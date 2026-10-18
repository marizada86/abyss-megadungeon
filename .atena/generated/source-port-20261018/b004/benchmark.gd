extends SceneTree
var game
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	game = root.get_node("Game")
	var args := OS.get_cmdline_user_args()
	var out: String = args[args.find("--benchmark-out") + 1]
	game.qa_sandbox = true
	game.qa_launch = {"seed": 8142}
	game.profile = Profile.new({"name": "Synthetic benchmark", "welcome_seen": true, "settings": {"hints": "off", "barks": false}})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.run_stage = "molor"
	game.run_hero = "durvall"
	Engine.max_fps = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var run = load("res://ui/run.tscn").instantiate()
	run.set_physics_process(false)
	root.add_child(run)
	current_scene = run
	run.set_physics_process(false)
	run.battle.enemies.clear()
	run.battle.events.clear()
	var center: Vector2 = run.battle.hero.pos
	for i in 32:
		var a := float(i) * TAU / 32.0
		run.battle.spawn_for_test("notivago", center + Vector2(cos(a), sin(a)) * (3.0 + float(i % 3)))
	run._sync()
	for i in 120: await process_frame
	var samples: Array[float] = []
	for i in 360:
		var start := Time.get_ticks_usec()
		await process_frame
		samples.append(float(Time.get_ticks_usec() - start) / 1000.0)
	samples.sort()
	var memory := OS.get_static_memory_usage()
	var objects := Performance.get_monitor(Performance.OBJECT_COUNT)
	var rendered: int = run.battle.enemies.size()
	run.queue_free()
	for i in 4: await process_frame
	var battle := Battle.new(8142, "durvall", "molor")
	battle.hero.max_hp = 999999.0
	var start := Time.get_ticks_usec()
	var steps := 0
	for i in 1800:
		battle.hero.hp = battle.hero.max_hp
		if battle.state in ["levelup", "altar", "item_offer"]: battle.choose(0)
		battle.step(Vector2.ZERO, 1.0 / 60.0)
		battle.events.clear()
		steps += 1
	var cpu_ms := float(Time.get_ticks_usec() - start) / 1000.0
	var result := {"render_median_ms": samples[180], "render_p95_ms": samples[341], "render_p99_ms": samples[355], "samples": samples.size(), "static_memory_bytes": memory, "objects": objects, "render_enemies": rendered, "cpu_total_ms": cpu_ms, "cpu_steps": steps, "cpu_enemies": battle.enemies.size(), "cpu_state": battle.state, "simulated_seconds": battle.time, "user_dir": OS.get_user_data_dir(), "resolution": str(root.size), "godot": Engine.get_version_info().string}
	var f := FileAccess.open(out, FileAccess.WRITE)
	f.store_string(JSON.stringify(result, "\t"))
	f.close()
	print("PORT_BENCHMARK: ", JSON.stringify(result))
	quit()

