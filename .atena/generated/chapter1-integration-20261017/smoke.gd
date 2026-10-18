extends SceneTree
var failures: Array[String] = []
var captures: Array[String] = []
var output_dir := ""
var auto_read := true
var ticks := 0

func _init() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	if not ok: failures.append(message)

func _reader_tick() -> void:
	ticks += 1
	if not auto_read or ticks % 2 != 0: return
	for node in root.find_children("*", "Control", true, false):
		if node.get_script() == load("res://ui/hq_screen.gd") and not node.is_closed:
			node.advance()

func _capture(name_value: String) -> void:
	await create_timer(0.35).timeout
	await process_frame
	await RenderingServer.frame_post_draw
	var filename := output_dir.path_join(name_value + ".png")
	_check(root.get_texture().get_image().save_png(filename) == OK, "capture " + name_value)
	captures.append(filename)

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	output_dir = args[args.find("--capture-dir") + 1]
	await process_frame
	var game = root.get_node("Game")
	var kit = root.get_node("Playtest")
	kit.call("_close_guide_modal")
	game.profile = Profile.new()
	game.run_stage = "docas"
	game.run_hero = "durvall"
	process_frame.connect(_reader_tick)
	var scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	for i in 100: await process_frame
	_check(scene._campaign_ready and game.profile.data.hqs_seen.has("hqn_01"), "opening before gameplay")
	await scene._record_stage_cleared("docas", "stage_cleared")
	_check(game.profile.data.hqs_seen.has("hqn_17"), "Docas queue drain")
	scene.battle.load_stage("reino_abissal")
	scene._load_stage()
	scene.battle.time = 360.0
	scene.battle.hero.pos = scene.battle.objective_target()
	scene.battle.objective_presence = 3.0
	_check(scene.battle.complete_stage("objective"), "realm objective")
	await scene._process_hq_milestones()
	_check(game.profile.data.hqs_seen.has("hqn_18"), "realm HQ")
	_check(scene.battle.state == "running", "realm must offer continuation")
	scene.battle.enter_next_stage()
	scene._load_stage()
	_check(scene.battle.stage_id == "domwieck", "return transition")
	scene.battle.time = 420.0
	scene.battle.hero.pos = scene.battle.objective_target()
	scene.battle.objective_presence = 3.0
	_check(scene.battle.complete_stage("objective"), "Domwieck objective")
	await scene._process_hq_milestones()
	_check(game.profile.data.campaign_progress.milestones.has("chapter1_closed"), "chapter closure")
	_check(scene.battle.stats.bosses == 0, "objective fabricated boss")
	await scene._show_result()
	_check(scene.hud.result_panel.visible, "chapter result")
	auto_read = false
	await _capture("chapter1-result-1280x720")
	scene.queue_free()
	await process_frame
	for size in [Vector2i(1280,720), Vector2i(1920,1080)]:
		root.size = size
		root.content_scale_size = Vector2i(1280,720)
		root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		for id in ["hqn_15","hqn_16","hqn_17","hqn_18","hqn_03","hqn_14"]:
			var screen = load("res://ui/hq_screen.tscn").instantiate()
			root.add_child(screen)
			screen.start_hq(Data.table("hqs")[id])
			await _capture("%s-%dx%d" % [id,size.x,size.y])
			screen.queue_free()
			await process_frame
		var menu = load("res://ui/menu.tscn").instantiate()
		root.add_child(menu)
		await _capture("menu-%dx%d" % [size.x,size.y])
		menu.queue_free()
		await process_frame
	var file := FileAccess.open(output_dir.path_join("smoke-result.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"captures":captures,"user_data_dir":OS.get_user_data_dir()},"\t"))
	file.close()
	for failure in failures: printerr("SMOKE_FAIL ",failure)
	print("CHAPTER_SMOKE failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
