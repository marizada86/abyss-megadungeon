extends SceneTree
func _init() -> void:
	call_deferred("_capture")
func _shot(name: String, out: String, waits := 20) -> void:
	for i in waits:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join("%s.png" % name))
	print("shot ", name)
func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	var out: String = args[args.find("--capture-dir") + 1]
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var kit := root.get_node_or_null("Playtest")
	if kit != null:
		kit.call("_close_guide_modal")
	game.profile = Profile.new({})
	change_scene_to_file("res://ui/title.tscn")
	await _shot("title", out, 40)
	change_scene_to_file("res://ui/menu.tscn")
	await _shot("menu-0", out, 40)
	var tabs: TabContainer = current_scene.get_node("%Tabs")
	for i in range(1, tabs.get_tab_count()):
		tabs.current_tab = i
		await _shot("menu-%d-%s" % [i, tabs.get_tab_title(i).replace(" ", "_")], out, 30)
	quit()
