extends SceneTree
var output: String
var reports: Array=[]
var failures: Array=[]

func _init() -> void:
	call_deferred("_run")

func _stats(values: Array) -> Dictionary:
	var sorted:=values.duplicate()
	sorted.sort()
	return {"samples":sorted.size(),"median_ms":sorted[sorted.size()/2],"p95_ms":sorted[int(ceil(sorted.size()*0.95))-1],"min_ms":sorted[0],"max_ms":sorted[-1]}

func _scenario(stage_key: String, seed_value: int, count: int) -> void:
	var game=root.get_node("Game")
	if not game.start_qa_run({"stage_id":stage_key,"hero_id":"durvall","target_state":"running","seed":seed_value}):
		failures.append("QA launch failed "+stage_key)
		return
	for i in 8:
		await process_frame
	var scene=current_scene
	scene.set_physics_process(false)
	scene.set_process(false)
	var b: Battle=scene.battle
	b.hero.max_hp=1.0e9
	b.hero.hp=b.hero.max_hp
	b.hero.weapons.clear()
	b.hero.pos=Vector2(30,30)
	b.stage.waves=[]
	b.stage.elites=[]
	b.stage.ambient=[]
	b.stage.prototype_no_interactions=true
	b.stage.prototype_no_breakables=true
	b.stage.interactions={}
	b.enemies.clear()
	b.interactions.clear()
	b.pickups.clear()
	b.projectiles.clear()
	b.zones.clear()
	b.time=90.0
	for i in count:
		var wanted:=b.hero.pos+Vector2.from_angle(TAU*float(i)/float(count))*(10.0+float(i%3))
		var spot:=b._root_resource_spot(wanted,0.4)
		var e:=b._spawn("cultista_arqueiro" if i%4==0 else "cultista_adaga",spot)
		e.max_hp=1.0e9
		e.hp=e.max_hp
	if b._combat_count()!=count:
		failures.append("Initial workload invalid "+stage_key)
	scene.camera.position=Iso.to_screen(b.hero.pos)
	scene.camera.zoom=Vector2.ONE
	RenderingServer.viewport_set_measure_render_time(root.get_viewport_rid(),true)
	var raw: Array=[]
	var simulation_cpu: Array=[]
	var total_script_cpu: Array=[]
	var render_cpu: Array=[]
	var render_gpu: Array=[]
	var frame_wall: Array=[]
	var min_count:=count
	var max_count:=count
	for frame in 630:
		var start:=Time.get_ticks_usec()
		b.step(Vector2.ZERO,1.0/60.0)
		var after_sim:=Time.get_ticks_usec()
		scene._sync()
		scene.hud.update_stats(b)
		var after_sync:=Time.get_ticks_usec()
		await process_frame
		await RenderingServer.frame_post_draw
		var wall:=float(Time.get_ticks_usec()-start)/1000.0
		var cpu:=RenderingServer.viewport_get_measured_render_time_cpu(root.get_viewport_rid())+RenderingServer.get_frame_setup_time_cpu()
		var gpu:=RenderingServer.viewport_get_measured_render_time_gpu(root.get_viewport_rid())
		var alive:=b._combat_count()
		min_count=mini(min_count,alive)
		max_count=maxi(max_count,alive)
		b.events.clear()
		if frame<30:
			continue
		var sim:=float(after_sim-start)/1000.0
		var script:=float(after_sync-start)/1000.0
		simulation_cpu.append(sim)
		total_script_cpu.append(script)
		render_cpu.append(cpu)
		render_gpu.append(gpu)
		frame_wall.append(wall)
		raw.append({"frame":frame-30,"simulation_cpu_ms":sim,"script_with_sync_ms":script,"render_cpu_ms":cpu,"render_gpu_ms":gpu,"frame_wall_ms":wall,"enemy_count":alive})
	if min_count!=count or max_count!=count:
		failures.append("Workload count drift "+stage_key)
	var report: Dictionary={"stage":stage_key,"seed":seed_value,"enemies":count,"min_enemies":min_count,"max_enemies":max_count,"warmup_frames":30,"measured_frames":600,"dt":1.0/60.0,"simulation_cpu":_stats(simulation_cpu),"script_with_sync":_stats(total_script_cpu),"render_cpu":_stats(render_cpu),"render_gpu":_stats(render_gpu),"frame_wall":_stats(frame_wall),"raw":raw}
	reports.append(report)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(stage_key+"-performance.png"))
	scene._return_to_menu()
	for i in 10:
		await process_frame

func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	output=args[args.find("--capture-dir")+1]
	await process_frame
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	root.get_node("Game").profile=Profile.new({})
	Engine.max_fps=0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	await _scenario("raiz_yggdrasil",7504,40)
	await _scenario("reino_abissal",7202,50)
	root.get_node("Sfx").stop_music(0.0)
	root.get_node("Sfx").stop_ambience(0.0)
	await create_timer(0.25).timeout
	var file:=FileAccess.open(output.path_join("performance.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"reports":reports,"environment":{"engine":Engine.get_version_info().string,"debug":OS.is_debug_build(),"renderer":RenderingServer.get_current_rendering_method(),"driver":RenderingServer.get_current_rendering_driver_name(),"gpu":RenderingServer.get_video_adapter_name(),"gpu_api":RenderingServer.get_video_adapter_api_version(),"processors":OS.get_processor_count(),"processor":OS.get_processor_name(),"resolution":root.size,"vsync":DisplayServer.window_get_vsync_mode(),"max_fps":Engine.max_fps},"fixture_only":"Fixed counts/high HP/no weapons; no waves/interactions. Same harness for baseline and candidate. GPU/render CPU measurements are Godot instrumentation; frame wall includes scheduling and synchronization."},"\t"))
	file.close()
	quit(0 if failures.is_empty() else 1)
