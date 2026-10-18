extends SceneTree

var failures: Array = []
var output := ""

func _init() -> void:
	call_deferred("_run")

func _frame() -> void:
	await process_frame
	await RenderingServer.frame_post_draw

func _root_regression() -> Dictionary:
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

func _percentiles(samples: Array) -> Dictionary:
	var ordered:=samples.duplicate()
	ordered.sort()
	return {"median_ms":float(ordered[ordered.size()/2])/1000.0,"p95_ms":float(ordered[int(ordered.size()*0.95)])/1000.0,"max_ms":float(ordered[-1])/1000.0}

func _perf(art_enabled: bool) -> Dictionary:
	var game = root.get_node("Game")
	if not game.start_qa_run({"stage_id":"domwieck","hero_id":"durvall","target_state":"running","seed":7204}):
		failures.append("Performance QA failed")
	for i in 6:
		await process_frame
	var scene = current_scene
	scene.set_process(false)
	scene.set_physics_process(false)
	paused=false
	var ground=scene.stage_root.get_node("Ground")
	ground.use_domwieck_art=art_enabled
	var b: Battle=scene.battle
	b.hero.max_hp=1.0e9
	b.hero.hp=b.hero.max_hp
	b.hero.weapons.clear()
	b.stage.waves=[]
	b.stage.elites=[]
	b._inter_t=99999.0
	b._breakable_t=99999.0
	b._fog_rules_off=true
	for i in 54:
		b._spawn("cultista_adaga",b._ring_pos())
	scene.camera.position=Iso.to_screen(b.hero.pos)
	var cpu: Array=[]
	var frame: Array=[]
	for i in 630:
		var start:=Time.get_ticks_usec()
		b.step(Vector2.ZERO,1.0/60.0)
		var simulation:=Time.get_ticks_usec()-start
		scene._sync()
		scene.hud.update_stats(b)
		b.events.clear()
		await _frame()
		if i>=30:
			cpu.append(simulation)
			frame.append(Time.get_ticks_usec()-start)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join("perf-art-%s.png"%str(art_enabled)))
	var result: Dictionary={"art_enabled":art_enabled,"frames":600,"dt":1.0/60.0,"seed":7204,"population":b.enemies.size(),"simulation":_percentiles(cpu),"frame_loop":_percentiles(frame)}
	scene._return_to_menu()
	for i in 6:
		await process_frame
	return result

func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	output=args[args.find("--capture-dir")+1]
	await process_frame
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	root.size=Vector2i(1280,720)
	root.content_scale_size=Vector2i(1280,720)
	var mask: Dictionary=await _root_regression()
	var baseline: Dictionary=await _perf(false)
	var candidate: Dictionary=await _perf(true)
	var ratio:=float(candidate.frame_loop.median_ms)/maxf(0.001,float(baseline.frame_loop.median_ms))
	var report: Dictionary={"failures":failures,"mask":mask,"baseline":baseline,"candidate":candidate,"frame_median_ratio":ratio,"measurement":"Offscreen OpenGL frame loop with vsync disabled; includes simulation, UI sync, scheduling and render dispatch; not GPU timestamps or a certified gameplay FPS","user_data_dir":OS.get_user_data_dir()}
	var file:=FileAccess.open(output.path_join("smoke-result.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print("DOMWIECK_RENDER_AUDIT ",JSON.stringify(report))
	quit(0 if failures.is_empty() else 1)
