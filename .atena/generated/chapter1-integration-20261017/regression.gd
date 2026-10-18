extends SceneTree
const Flow := preload("res://core/chapter_flow.gd")
const HQ := preload("res://core/hq_catalog.gd")
var failures: Array[String] = []
var output_dir := ""
var phase := ""
var fixtures: Array = []
var input_checks := 0
var pause_checks := 0
var diary_checks := 0

func _init() -> void:
	call_deferred("_run")

func check(ok: bool, label: String) -> void:
	if not ok: failures.append(label)

func write_json(path: String, value: Variant) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	check(file != null, "write " + path)
	if file:
		file.store_string(JSON.stringify(value))
		file.close()

func read_json(path: String) -> Variant:
	return JSON.parse_string(FileAccess.get_file_as_string(path))

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	output_dir = args[args.find("--capture-dir") + 1]
	phase = args[args.find("--phase") + 1]
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	if phase == "writer":
		_write_fixtures()
	else:
		_read_fixtures()
		_legacy_matrix()
		await _inputs_and_pause()
		await create_timer(1.0).timeout
		for tick in 4: await process_frame
	write_json(output_dir.path_join("regression-" + phase + ".json"), {"phase":phase,"failures":failures,"fixtures":fixtures.size(),"input_checks":input_checks,"pause_checks":pause_checks,"diary_checks":diary_checks,"legacy_cases":7 if phase == "reader" else 0,"user_data_dir":OS.get_user_data_dir()})
	for failure in failures: printerr("REGRESSION_FAIL ", failure)
	print("REGRESSION ",phase," failures=",failures.size()," fixtures=",fixtures.size())
	quit(0 if failures.is_empty() else 1)

func _write_fixtures() -> void:
	var game = root.get_node("Game")
	var ids: Array = Flow.contract().main_hq_order.duplicate()
	ids.append("hqn_14")
	for id in ids:
		for index in Data.table("hqs")[id].panels.size():
			var p := Profile.new()
			Flow.enqueue(p.data, [id, "hqn_04"])
			Flow.cursor(p.data, id, index)
			game.profile = p
			game.save()
			check(game.persisted, "atomic save %s/%d" % [id,index])
			var path := output_dir.path_join("resume-%s-%d.json" % [id,index])
			# Copy the actual atomic save output, not the in-memory dictionary.
			var args := OS.get_cmdline_user_args()
			var save_path: String = args[args.find("--controller-profile") + 1]
			check(DirAccess.copy_absolute(save_path,path) == OK, "copy durable fixture")
			fixtures.append({"id":id,"index":index,"path":path})
	write_json(output_dir.path_join("resume-fixtures.json"),fixtures)

func _read_fixtures() -> void:
	fixtures = read_json(output_dir.path_join("resume-fixtures.json"))
	check(fixtures.size() == 46, "46 persisted panels")
	var game = root.get_node("Game")
	for row in fixtures:
		var p := Profile.new(read_json(row.path))
		var queue: Array = p.data.campaign_progress.pending_hqs
		check(queue.size() == 2 and queue[0].id == row.id and int(queue[0].panel_index) == int(row.index) and queue[1].id == "hqn_04", "restored queue " + row.path)
		var screen = load("res://ui/hq_screen.tscn").instantiate()
		root.add_child(screen)
		screen.start_hq(Data.table("hqs")[row.id],int(queue[0].panel_index))
		check(screen.panel_index == int(row.index) and screen.panel_image.texture.resource_path == Data.table("hqs")[row.id].panels[int(row.index)].image, "restored reader " + row.path)
		screen.free()
		var dismissed := Profile.new(p.data.duplicate(true))
		Flow.resolve(dismissed.data,row.id,false)
		check(dismissed.coins() == p.coins() and not dismissed.data.hqs_seen.has(row.id), "dismiss has no reward " + row.path)
		Flow.enqueue(dismissed.data,[row.id])
		check(dismissed.data.campaign_progress.pending_hqs.size() == 1, "dismiss repeat " + row.path)
		p.mark_hq_seen(row.id)
		Flow.resolve(p.data,row.id,true)
		var coins := p.coins()
		var earned: Dictionary = p.data.achievements.duplicate(true)
		p.mark_hq_seen(row.id)
		Flow.enqueue(p.data,[row.id])
		Flow.resolve(p.data,row.id,true)
		check(p.coins() == coins and p.data.achievements == earned and p.data.campaign_progress.pending_hqs.size() == 1, "reward/queue idempotence " + row.path)
	# Verify the last profile also survived the process boundary at the real Game I/O path.
	check(game.profile.data.campaign_progress.pending_hqs[0].id == "hqn_14" and int(game.profile.data.campaign_progress.pending_hqs[0].panel_index) == 4, "Game startup resumed saved queue")

func _legacy_matrix() -> void:
	var cases := [
		{"coins":25},
		{"stats":{"runs":1,"deaths":1}},
		{"cleared":{"dagruve":true}},
		{"cleared":{"docas":true},"stats":{"reached":{"shedaklah":true}}},
		{"cleared":{"shedaklah":true,"molor":true,"durao":true,"feng_tu":true,"shendilavri":true,"goranthis":true,"pilares":true}},
		{"achievements":{"aluris":true,"cacador_de_chefes":true,"mestre_de_camadas":true},"hqs_seen":{"hqn_12":true}},
		{"upgrades":{"vida":2},"codex":{"enemies":{"zumbi":2}},"settings":{"volume":0.3}}
	]
	for i in cases.size():
		var source: Dictionary = cases[i].duplicate(true)
		source.custom_future = {"value":42}
		var p := Profile.new(source)
		check(p.coins() == int(source.get("coins",0)), "legacy coins %d" % i)
		check(p.data.campaign_progress.pending_hqs.is_empty() and not p.stage_unlocked("domwieck"), "legacy no fabricated chapter progress %d" % i)
		for field in ["achievements","hqs_seen","upgrades"]:
			check(p.data[field] == source.get(field,{}), "legacy preserve %s/%d" % [field,i])
		for id in Flow.contract().legacy_stages:
			var req: String = Flow.contract().legacy_stages[id].unlock
			var expected: bool = id == "docas" or req == "start" or source.get("cleared",{}).has(req) or (req == "docas" and source.get("cleared",{}).has("dagruve"))
			check(p.stage_unlocked(id) == expected, "legacy access %d/%s" % [i,id])
		var again := Profile.new(JSON.parse_string(JSON.stringify(p.data)))
		# JSON numbers reload as floats; compare both sides at the serialized boundary.
		check(JSON.parse_string(JSON.stringify(again.data)) == JSON.parse_string(JSON.stringify(p.data)) and int(again.data.custom_future.value) == 42, "legacy migration idempotence %d" % i)
		if i == 5:
			for id in ["hqn_11","hqn_12","hqn_13"]: check(HQ.is_unlocked(p.data,id),"legacy archive " + id)

func _key(code: int, echo: bool = false, pressed: bool = true) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = code
	event.pressed = pressed
	event.echo = echo
	return event

func _joy(button: int, pressed: bool = true) -> InputEventJoypadButton:
	var event := InputEventJoypadButton.new()
	event.button_index = button
	event.device = 0
	event.pressed = pressed
	return event

func _inputs_and_pause() -> void:
	var game = root.get_node("Game")
	game.profile = Profile.new()
	game.controls.focused = true
	game.controls.active_device = 0
	game.controls.disconnected = false
	game.ensure_input_actions()
	var screen = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(screen)
	for code in [KEY_ENTER,KEY_SPACE,KEY_KP_ENTER]:
		screen.start_hq(Data.table("hqs").hqn_18)
		screen._input(_key(code,true))
		check(screen.panel_index == 0,"keyboard echo ignored")
		screen._input(_key(code,false,false))
		check(screen.panel_index == 0,"keyboard release ignored")
		screen._input(_key(code))
		check(screen.panel_index == 1,"keyboard single advance")
		input_checks += 3
	screen._input(_key(KEY_ESCAPE))
	check(screen.is_closed and not screen.completed,"keyboard dismiss")
	input_checks += 1
	for preset in ["standard","legacy"]:
		game.profile.data.settings.controller = {"preset":preset}
		game.ensure_input_actions()
		game.controls._held.clear()
		game.controls._blocked.clear()
		screen.start_hq(Data.table("hqs").hqn_18)
		var accept: int = game.controls.action_button("ui_accept")
		var cancel: int = game.controls.action_button("ui_cancel")
		screen._input(_joy(accept))
		check(screen.panel_index == 1,"joy advance " + preset)
		screen._input(_joy(accept))
		check(screen.panel_index == 1,"held joy cannot skip " + preset)
		game.controls._input(_joy(accept,false))
		screen._input(_joy(accept))
		check(screen.panel_index == 2,"released joy rearms " + preset)
		game.controls._input(_joy(accept,false))
		screen._input(_joy(cancel))
		check(screen.is_closed and not screen.completed,"joy dismiss " + preset)
		input_checks += 4
	game.controls._held.clear()
	game.controls._blocked.clear()
	screen.start_hq(Data.table("hqs").hqn_18)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	screen._input(click)
	check(screen.panel_index == 1,"mouse advance")
	game.controls.focused = false
	screen._input(_key(KEY_ENTER))
	check(screen.panel_index == 1,"focus loss blocks advance")
	game.controls.focused = true
	root.get_node("Playtest").open_note()
	screen._input(_key(KEY_SPACE))
	screen._input(click)
	check(screen.panel_index == 1,"note overlay consumes typing and clicks")
	root.get_node("Playtest").close_note()
	input_checks += 3
	screen.free()
	# Exercise production run presenter and its persistence/pause restoration.
	game.run_stage = "docas"
	game.run_hero = "durvall"
	game.qa_sandbox = true
	var scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await process_frame
	game.qa_sandbox = false
	for prior_pause in [false,true]:
		for complete in [false,true]:
			game.profile = Profile.new()
			Flow.enqueue(game.profile.data,["hqn_15"])
			paused = prior_pause
			scene._present_hq("hqn_15",2,true)
			await process_frame
			await process_frame
			var active = scene.hud.get_children().filter(func(node): return node.get_script() == load("res://ui/hq_screen.gd"))[0]
			check(paused and active.panel_index == 2,"presenter paused at resume cursor")
			if complete:
				while not active.is_closed: active.advance()
			else: active.finish()
			for tick in 3: await process_frame
			check(paused == prior_pause,"restore original pause")
			check(game.profile.data.hqs_seen.has("hqn_15") == complete,"read marker matches completion")
			game.load_profile()
			check(game.profile.data.campaign_progress.pending_hqs.is_empty() and game.profile.data.campaign_progress.presentation_done.hqn_15 == ("read" if complete else "dismissed"),"resolved queue persisted")
			pause_checks += 1
	paused = false
	scene.queue_free()
	await process_frame
	game.profile = Profile.new()
	Flow.enqueue(game.profile.data,["hqn_14"])
	Flow.cursor(game.profile.data,"hqn_14",3)
	var menu = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	for replay in 2:
		menu._fill_hqs()
		var index: int = menu.hq_ids.find("hqn_14")
		check(index >= 0,"complementary HQ selectable in diary")
		menu.hq_list.select(index)
		menu._open_selected_hq()
		await process_frame
		await process_frame
		var active = menu.get_children().filter(func(node): return node.get_script() == load("res://ui/hq_screen.gd"))[0]
		check(active.panel_index == (3 if replay == 0 else 0),"diary resumes pending / replay starts at zero")
		var coins: int = game.profile.coins()
		while not active.is_closed: active.advance()
		for tick in 3: await process_frame
		check(game.profile.data.campaign_progress.pending_hqs.is_empty() and game.profile.data.hqs_seen.has("hqn_14"),"diary resolves and records full reading")
		if replay == 1: check(game.profile.coins() == coins,"diary replay grants no duplicate rewards")
		diary_checks += 1
	menu.queue_free()
	await process_frame
