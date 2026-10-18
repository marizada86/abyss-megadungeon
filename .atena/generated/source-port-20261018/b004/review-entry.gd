extends SceneTree
func _init() -> void:
	call_deferred("_start")
func _start() -> void:
	var args := OS.get_cmdline_user_args()
	var session: String = args[args.find("--review-session") + 1]
	if not OS.get_user_data_dir().replace("\\", "/").begins_with(session.replace("\\", "/") + "/"):
		printerr("Review isolation not confirmed")
		quit(1)
		return
	var game = root.get_node("Game")
	game.profile = Profile.new({"name": "Avaliação da portagem", "welcome_seen": true})
	game.goto_menu()
	for i in 8: await process_frame
	var kit = root.get_node("Playtest")
	kit._close_guide_modal()
	kit._open_qa_browser()
	if args.has("--verify-review"):
		for i in 6: await process_frame
		var failures: Array[String] = []
		if current_scene == null or current_scene.get("options_panel") == null: failures.append("Quartel não abriu")
		if not kit.get("_qa_open"): failures.append("Seletor de cenários não abriu")
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(session.path_join("review-ready.png"))
		var f := FileAccess.open(session.path_join("launch-verification.json"), FileAccess.WRITE)
		f.store_string(JSON.stringify({"failures": failures, "user_dir": OS.get_user_data_dir(), "human_acceptance": false}, "\t"))
		f.close()
		print("REVIEW_READY: ", failures.size(), " failures")
		quit(0 if failures.is_empty() else 1)
