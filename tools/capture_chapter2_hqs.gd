extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var game := root.get_node("Game")
	game.profile.data.name = "Synthetic visual check"
	game.profile.data.welcome_seen = true
	var args := OS.get_cmdline_user_args()
	var output := args[args.find("--capture-dir") + 1]
	var reader = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(reader)
	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		for request in [["hqn_19", 3], ["hqn_19", 4], ["hqn_19", 11], ["hqn_20", 1], ["hqn_20", 4], ["hqn_20", 6]]:
			reader.start_hq(Data.table("hqs")[request[0]], request[1])
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var image := root.get_texture().get_image()
			var path := output.path_join("%s-q%d-%dx%d.png" % [request[0], request[1] + 1, size.x, size.y])
			if image == null or image.save_png(path) != OK:
				printerr("CAPTURE_FAILED ", path)
				quit(1)
				return
	reader.free()
	await process_frame
	print("CAPTURES_PASS=12")
	quit()
