extends SceneTree
## Capturas do jardim de Ailalore em Domwieck (escala do cenário). Janela real; rodar com perfil/APPDATA sintéticos.
## Uso: godot --path . --resolution 1280x720 -s tools/capture_domwieck.gd -- --controller-profile <json> --capture-dir <pasta>

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	var output := args[args.find("--capture-dir") + 1]
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var kit := root.get_node_or_null("Playtest")
	if kit != null:
		kit.call("_close_guide_modal")
	game.profile = Profile.new({})
	if not game.start_qa_run({"stage_id": "domwieck", "hero_id": "durvall", "target_state": "running", "seed": 4401}):
		printerr("CAPTURE_FAILED ", game.qa_error)
		quit(1)
		return
	for i in 6:
		await process_frame
	var scene := current_scene
	var battle: Battle = scene.battle
	var art_config: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/domwieck_art.json"))
	var center := Vector2(float(art_config.garden_center[0]), float(art_config.garden_center[1]))
	var radius := float(art_config.tree_radius)
	scene.set_physics_process(false)
	var spots := {
		"1-aproximacao": center + Vector2(0.0, radius + 9.0),
		"2-entrada": center + Vector2(0.0, radius),
		"3-cristal": center + Vector2(0.0, 2.5),
		"4-predio": Vector2(float(art_config.building_anchors[1][0]), float(art_config.building_anchors[1][1])) + Vector2(2.5, 2.5),
	}
	var size := root.get_visible_rect().size
	var count := 0
	for key in spots:
		battle.hero.pos = spots[key]
		scene.hero_node.position = Iso.to_screen(spots[key])
		scene.camera.position = scene.hero_node.position
		for i in 12:
			await process_frame
		await RenderingServer.frame_post_draw
		var shot := root.get_texture().get_image()
		var path := output.path_join("domwieck-%s-%dx%d.png" % [key, int(size.x), int(size.y)])
		if shot == null or shot.save_png(path) != OK:
			printerr("CAPTURE_FAILED ", path)
			quit(1)
			return
		count += 1
	print("CAPTURES_PASS=", count)
	quit()
