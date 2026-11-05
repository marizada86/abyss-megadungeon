extends SceneTree
## Captura, no jogo, os avisos dos inimigos comuns (faixa de investida, mira do atirador, círculo de golpe em área) com a arte nova e com o
## desenho por código, por tipo de dano, modo de daltonismo e "Impacto reduzido". Perfil sintético isolado, nunca o save real.
## Uso: defina APPDATA/LOCALAPPDATA para a pasta sintética e rode com --script tools/telegraph_comuns_capture.gd -- <pasta_sintetica> <saida res://.../>
## Cenas montadas direto no estado do Battle (sem `step`): só o que o Overlay desenha.

const CROP := Rect2i(240, 120, 800, 480)

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var synthetic := String(args[0]).replace(String.chr(92), "/")
	var output := String(args[1])
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(synthetic):
		printerr("perfil não isolado: ", OS.get_user_data_dir())
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://telegraph-comuns-synthetic.json"
	game.profile = Profile.new({"name": "Telegraph comuns synthetic", "welcome_seen": true})
	for id in Data.table("hqs"):
		game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230611, "target_state": "running", "prelude_seconds": 0.1}
	game.run_stage = "dagruve"
	game.run_hero = "durvall"
	var scene: Node = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	var battle: Battle = scene.battle
	battle.state = "running"
	paused = false
	for i in 4:
		battle.step(Vector2.ZERO, 0.05)
	var origin := Vector2(20, 20)
	battle.hero.max_hp = 100000.0
	battle.hero.hp = 100000.0
	battle.hero.pos = origin
	scene.hero_node.position = Iso.to_screen(origin)
	scene.camera.position = Iso.to_screen(origin + Vector2(1.5, 0.5))
	var enemy_id := String(Data.table("enemies").keys()[0])
	var runner := Enemy.make(enemy_id, origin + Vector2(-4.5, -2.0))
	var shooter := Enemy.make(enemy_id, origin + Vector2(2.0, -5.5))
	runner.radius = 0.6
	scene._boss_intro_panel.visible = false
	scene.hud.modal_overlay = false

	var cases := [
		{"name": "fisico-50", "dtype": "fisico", "progress": 0.5},
		{"name": "magico-50", "dtype": "magico", "progress": 0.5},
		{"name": "fogo-50", "dtype": "fogo", "progress": 0.5},
		{"name": "radiante-50", "dtype": "radiante", "progress": 0.5},
		{"name": "fisico-15", "dtype": "fisico", "progress": 0.15},
		{"name": "fisico-90", "dtype": "fisico", "progress": 0.9},
		{"name": "magico-protanopia", "dtype": "magico", "progress": 0.5, "color_mode": "protanopia"},
		{"name": "magico-tritanopia", "dtype": "magico", "progress": 0.5, "color_mode": "tritanopia"},
		{"name": "magico-impacto-reduzido", "dtype": "magico", "progress": 0.5, "reduced": true},
	]
	for mode in ["arte", "codigo"]:
		for shot in cases:
			if mode == "codigo" and not ["fisico-50", "magico-50"].has(String(shot.name)):
				continue
			TelegraphArt._textures.clear()
			if mode == "codigo":
				for kind in TelegraphArt.KINDS:
					TelegraphArt._textures[kind] = null
			game.set_color_mode(String(shot.get("color_mode", "off")))
			game.profile.data.settings.reduced_impact = bool(shot.get("reduced", false))
			var progress := float(shot.progress)
			var dtype := String(shot.dtype)
			battle.enemies.clear()
			battle.zones.clear()
			runner.windup_total = 1.0
			runner.windup = 1.0 - progress
			runner.charge_dir = Vector2(1.0, 0.45).normalized()
			runner.charge_ab = {"dist": 5.0, "dtype": dtype}
			shooter.shoot_wind = 0.4 * (1.0 - progress)
			shooter.shoot_dir = (origin - shooter.pos).normalized()
			shooter.shoot_ab = {"range": 6.0, "dtype": dtype}
			battle.enemies.append(runner)
			battle.enemies.append(shooter)
			battle.zones.append({"owner": "enemy", "kind": "telegraph", "pos": origin + Vector2(3.5, 3.5), "radius": 1.6, "delay": 1.0 * (1.0 - progress), "total": 1.0, "life": 99.0, "dtype": dtype, "src": shooter.pos})
			for i in 10:
				if scene._paused:
					scene._toggle_pause()
				await process_frame
			await RenderingServer.frame_post_draw
			var image := root.get_texture().get_image().get_region(CROP)
			var file := "%s%s-%s.png" % [output, mode, String(shot.name)]
			image.save_png(ProjectSettings.globalize_path(file))
			print("shot ", mode, " ", shot.name)
	quit()
