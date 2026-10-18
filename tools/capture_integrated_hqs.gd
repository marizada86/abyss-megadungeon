extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var game := root.get_node("Game")
	game.profile.data.name = "Synthetic HQ integration check"
	game.profile.data.welcome_seen = true
	var args := OS.get_cmdline_user_args()
	var output := args[args.find("--capture-dir") + 1]
	var reader = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(reader)
	var count := 0
	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		for id in ["hqn_21", "hqn_04"]:
			var hq: Dictionary = Data.table("hqs")[id]
			for index in range(hq.panels.size()):
				reader.start_hq(hq, index)
				await process_frame
				await process_frame
				await RenderingServer.frame_post_draw
				var shot := root.get_texture().get_image()
				var path := output.path_join("%s-q%d-%dx%d.png" % [id, index + 1, size.x, size.y])
				if shot == null or shot.save_png(path) != OK:
					printerr("CAPTURE_FAILED ", path)
					quit(1)
					return
				count += 1
	reader.free()
	await process_frame
	print("CAPTURES_PASS=", count)
	quit()
