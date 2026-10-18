extends SceneTree
var game
var output := ""
var failures: Array[String] = []
var count := 0
func _init() -> void:
	call_deferred("_run")
func check(id: String, passed: bool) -> void:
	count += 1
	if not passed: failures.append(id)
func frames() -> void:
	for i in 8: await process_frame
func shot(name: String) -> void:
	await frames()
	await RenderingServer.frame_post_draw
	check(name, root.get_texture().get_image().save_png(output.path_join(name + ".png")) == OK)
func _run() -> void:
	game = root.get_node("Game")
	var args := OS.get_cmdline_user_args()
	output = args[args.find("--port-out") + 1]
	game.qa_sandbox = true
	game.profile = Profile.new({"name": "Synthetic UI port", "welcome_seen": true})
	var old_progress: Dictionary = game.profile.data.campaign_progress.duplicate(true)
	var menu = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	current_scene = menu
	await frames()
	var panel = menu.options_panel
	var tabs: TabContainer = menu.get_node("Tabs")
	var options: ScrollContainer = tabs.get_node("Opções")
	tabs.current_tab = options.get_index()
	panel.refresh()
	check("desktop_controls_enabled", not panel.aim.disabled and not panel.display_mode.disabled and not panel.resolution.disabled)
	check("new_options_connected", panel.visual.item_count >= 2 and panel.atmosphere.item_count == 2 and panel.title_font.item_count >= 1)
	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		options.scroll_vertical = 0
		await shot("options-top-%dx%d" % [size.x, size.y])
		options.ensure_control_visible(panel.title_font)
		await shot("options-new-%dx%d" % [size.x, size.y])
		check("options_font_in_view_%d" % size.x, options.get_global_rect().intersects(panel.title_font.get_global_rect()))
	panel.visual.item_selected.emit(1)
	check("filter_preference_saved", game.profile.data.settings.visual_filter != "off")
	panel.atmosphere.item_selected.emit(0)
	check("atmosphere_preference_saved", game.profile.data.settings.atmosphere == "off")
	panel.hints.item_selected.emit(1)
	check("hints_preference_saved", game.profile.data.settings.hints == "off")
	check("options_preserve_campaign", game.profile.data.campaign_progress == old_progress)
	check("touch_stays_disabled", not game.touch_controls_enabled())
	menu.queue_free()
	await frames()
	var f := FileAccess.open(output.path_join("ui-probe.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify({"checks": count, "failures": failures, "synthetic": true, "human_acceptance": false}, "\t"))
	f.close()
	for id in failures: printerr("PORT_VISUAL_FAILED: ", id)
	print("PORT_VISUALS: %d checks; %d failures" % [count, failures.size()])
	quit(0 if failures.is_empty() else 1)

