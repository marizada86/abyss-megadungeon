extends SceneTree
## Alpha 0.1.0: capturas do ícone de regra "destino" no HUD de Reino Abissal e Domwieck, a 100% e 150% de escala de interface.
## Perfil e pasta de dados sintéticos (nunca o save real). Uso: powershell -File tools/destino_render.ps1
const OUTPUT := "res://.atena/generated/alpha-destino-20261117-r1/captures/"
const USER_ROOT := "res://.atena/generated/alpha-destino-20261117-r1/synthetic/"
var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _shot(name: String, crop: Rect2i = Rect2i()) -> void:
	for i in 6: await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	var img := root.get_texture().get_image()
	if crop.size != Vector2i.ZERO:
		img = img.get_region(crop)
		img.resize(img.get_width() * 4, img.get_height() * 4, Image.INTERPOLATE_NEAREST)
	img.save_png(ProjectSettings.globalize_path(OUTPUT + name + ".png"))

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		printerr("destino_capture: diretório de usuário não isolado ou sem janela")
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://destino-synthetic.json"
	game.profile = Profile.new({"name": "Destino synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_hero = "sylas"
	for stage_id in ["reino_abissal", "domwieck", "docas"]:
		game.run_stage = stage_id
		var scene: Node = load("res://ui/run.tscn").instantiate()
		root.add_child(scene)
		current_scene = scene
		await process_frame
		scene.set_physics_process(false)
		scene.battle.state = "running"
		paused = false
		for pct in [100, 150]:
			game.set_ui_scale(pct)
			var hud = scene.hud
			hud.update_stats(scene.battle)
			await process_frame
			var icon: TextureRect = hud.stage_rule_icon
			var has_tex := icon.texture != null
			print("destino ", stage_id, " ", pct, "% textura=", has_tex, " visivel=", icon.is_visible_in_tree(), " rect=", icon.get_global_rect())
			if stage_id != "docas" and not has_tex:
				failures.append("%s %d%%: sem textura" % [stage_id, pct])
			var r := icon.get_global_rect()
			var crop := Rect2i(Vector2i(maxf(r.position.x - 60.0, 0.0), maxf(r.position.y - 20.0, 0.0)), Vector2i(220, 70))
			await _shot("%s-%d-hud" % [stage_id, pct])
			await _shot("%s-%d-icone-x4" % [stage_id, pct], crop)
		game.set_ui_scale(100)
		scene.queue_free()
		await process_frame
	print("destino_capture: ", "PASS" if failures.is_empty() else "FAIL " + str(failures))
	quit(0 if failures.is_empty() else 1)
