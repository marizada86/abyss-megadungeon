extends SceneTree
## PLAN-ABYSS-QOL-A11Y-P1: capturas da interface com escala, contraste alto e daltonismo, em perfil e pasta de dados sintéticos.
## Uso: powershell -File tools/a11y_render.ps1 [-Size 1920x1080]
const OUTPUT := "res://.atena/generated/qol-a11y-p1-20261027-r1/captures/"
const USER_ROOT := "res://.atena/generated/qol-a11y-p1-20261027-r1/synthetic/"
var checks: Array[Dictionary] = []
var tag := "1280x720"

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("a11y ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _shot(name: String) -> void:
	for i in 6: await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "%s-%s.png" % [name, tag]))

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed or DisplayServer.get_name() == "headless":
		quit(1)
		return
	for a in OS.get_cmdline_user_args():
		if a.contains("x"):
			tag = a
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://a11y-synthetic.json"
	game.profile = Profile.new({"name": "A11y synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "sylas"

	# ---- Quartel, aba Opções (o painel é o mesmo da pausa)
	var menu: Node = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	var tabs: TabContainer = menu.get_node("%Tabs")
	tabs.current_tab = tabs.get_tab_idx_from_control(tabs.get_node("Opções"))
	for combo in [[100, false, "off"], [150, true, "tritanopia"]]:
		game.set_ui_scale(combo[0])
		game.set_high_contrast(combo[1])
		game.set_color_mode(combo[2])
		await _shot("quartel-opcoes-%d-hc%d" % [combo[0], int(combo[1])])
	menu.queue_free()
	game.set_ui_scale(100)
	game.set_high_contrast(false)
	game.set_color_mode("off")
	await process_frame

	# ---- corrida: HUD, números de dano, aviso e fala
	var scene: Node = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	var battle: Battle = scene.battle
	battle.state = "running"
	paused = false
	battle.enemies.clear()
	battle.projectiles.clear()
	var origin := Vector2(20, 20)
	battle.hero.pos = origin
	scene.hero_node.position = Iso.to_screen(origin)
	scene.camera.position = scene.hero_node.position
	battle.hero.max_hp = 100000.0
	battle.hero.hp = 100000.0
	var variants := [
		["base", 100, false, "off", "normal"],
		["g150", 150, false, "off", "normal"],
		["g125-hc", 125, true, "off", "normal"],
		["g150-hc-deut", 150, true, "deuteranopia", "longo"],
	]
	for v in variants:
		game.set_ui_scale(v[1])
		game.set_high_contrast(v[2])
		game.set_color_mode(v[3])
		game.set_speech_time(v[4])
		var i := 0
		for dtype in ["fisico", "fogo", "radiante", "magico"]:
			battle.events.append({"type": "hit", "pos": origin + Vector2(2 + i * 2.5, 2), "amount": 12 + i * 7, "dtype": dtype, "crit": i == 3, "tid": 100 + i})
			i += 1
		scene._consume_events()
		scene.hud.toast("Maré: abates seguidos dão XP extra. 3 s sem matar zera a sequência.", Color(0.9, 0.9, 0.7))
		scene.hud.toast("Espada longa [raro]", Items.rarity_color("raro"))
		scene._bark_now("entrada")
		await _shot("hud-" + String(v[0]))
	# ---- pausa: abas Jogo e Configurações (onde ficam as opções de acessibilidade)
	for v in [["base", 100, false], ["g150", 150, false], ["g150-hc", 150, true]]:
		game.set_ui_scale(v[1])
		game.set_high_contrast(v[2])
		game.set_color_mode("off")
		scene.hud.show_pause(true)
		scene.hud.pause_menu.set_tab(0)
		await _shot("pausa-jogo-" + String(v[0]))
		scene.hud.pause_menu.set_tab(2)
		await _shot("pausa-config-" + String(v[0]))
		scene.hud.show_pause(false)
		await process_frame
	game.set_ui_scale(100)
	game.set_high_contrast(false)
	game.set_color_mode("off")
	game.set_speech_time("normal")
	var failures := checks.filter(func(c): return not c.passed).size()
	print("a11y capturas concluídas, falhas: ", failures)
	quit(1 if failures > 0 else 0)
