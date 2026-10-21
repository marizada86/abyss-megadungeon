extends SceneTree
func _init() -> void:
	call_deferred("_capture")

func _shot(name: String, out: String, waits := 10) -> void:
	for i in waits:
		await process_frame
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	img.save_png(out.path_join("%s.png" % name))
	print("shot ", name, " ", img.get_size())

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
	for target in ["running", "levelup", "altar", "chest", "victory", "defeat"]:
		var req := {"stage_id": "dagruve", "hero_id": "durvall", "target_state": target, "seed": 4401}
		if target == "levelup":
			req["level"] = 6
			req["weapons"] = ["espada_sombria", "golpe_atordoante"]
		if not game.start_qa_run(req):
			printerr("FAIL ", target, " ", game.qa_error)
			continue
		await _shot("run-" + target, out, 40)
		game.end_qa_sandbox()
	quit()
