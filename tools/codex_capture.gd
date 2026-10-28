extends SceneTree
## PLAN-ABYSS-CODEX-LORE (S-C05): capturas da aba Personagens do Códex, em perfil e pasta de dados sintéticos.
## Uso: powershell -File tools/codex_render.ps1 [-Size 1920x1080]
const OUTPUT := "res://.atena/generated/codex-lore-20261027-r1/captures/"
const USER_ROOT := "res://.atena/generated/codex-lore-20261027-r1/synthetic/"
var tag := "1280x720"

func _init() -> void:
	call_deferred("_run")

func _shot(name: String) -> void:
	for i in 6: await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "%s-%s.png" % [name, tag]))

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		printerr("codex_capture: exige pasta de dados sintética e janela (não headless)")
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
	game._save_path = "user://codex-synthetic.json"
	var heroes: Dictionary = Data.table("heroes")
	var data := {"name": "Códex sintético", "welcome_seen": true, "achievements": {}, "hqs_seen": {}}
	for id in heroes:
		data.achievements["bio_" + id] = true
		if String(heroes[id].unlock).begins_with("ach:"):
			data.achievements[String(heroes[id].unlock).substr(4)] = true
	for id in Data.table("hqs"):
		data.hqs_seen[id] = true
	game.profile = Profile.new(data)
	game.profile.data.codex.enemies["zumbi"] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	var menu: Node = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	var tabs: TabContainer = menu.get_node("%Tabs")
	tabs.current_tab = tabs.get_tab_idx_from_control(tabs.get_node("Códex"))
	var variants := [["base", 100, false], ["g150", 150, false], ["g150-hc", 150, true]]
	# cenários: [nome, categoria, id, modo]. Modos: full (tudo liberado), inicio (herói em começo de jogo), enemy_start (inimigos vistos, sem chefe derrotado nem HQ)
	var all_enemies: Dictionary = Data.table("enemies")
	var scenarios := [
		["sylas-completo", 3, "sylas", "full"], ["durvall-inicio", 3, "durvall", "inicio"], ["bromnor-bloqueado", 3, "bromnor", "inicio"],
		["inimigo-zumbi", 0, "zumbi", "full"],
		["inimigo-sacerdote-inicio", 0, "sacerdote_mente_derretida", "enemy_start"], ["inimigo-sacerdote-completo", 0, "sacerdote_mente_derretida", "full"],
		["inimigo-kraken-completo", 0, "tentaculo_kraken", "full"], ["inimigo-sintese-completo", 0, "sintese_abissal", "full"],
		["quebravel-urna", 0, "urna_funeraria_quebravel", "full"],
		["item-martelo", 2, "martelo_da_gloria", "full"], ["arma-martelo-gloria", 1, "martelo_da_luz", "full"], ["item-amuleto", 2, "amuleto_da_luz", "full"],
		["arma-memoria-alterada", 1, "memoria_alterada", "full"], ["arma-constelacao", 1, "constelacao_de_silva", "full"], ["item-espelho", 2, "espelho_das_almas_desejantes", "full"]]
	for v in variants:
		game.set_ui_scale(v[1])
		game.set_high_contrast(v[2])
		for s in scenarios:
			if s[3] == "inicio":
				game.profile = Profile.new({"name": "Códex sintético", "welcome_seen": true, "achievements": {"bio_durvall": true}, "hqs_seen": {"hqn_01": true}})
			else:
				game.profile = Profile.new(data if s[3] == "full" else {"name": "Códex sintético", "welcome_seen": true})
				for wid in Data.table("weapons"):
					game.profile.data.codex.weapons[wid] = true
				for u in Data.table("items").uniques:
					game.profile.data.codex.items[String(u.id)] = true
				for eid in all_enemies:
					game.profile.data.codex.enemies[eid] = true
				if s[3] == "full":
					for sid in Data.table("stages"):
						var boss_id := String(Data.table("stages")[sid].get("boss", ""))
						if boss_id != "":
							game.profile.data.stats.boss_kills[boss_id] = 1
			menu.codex_cat.select(s[1])
			menu._fill_codex()
			var at: int = menu.codex_ids.find(s[2])
			menu.codex_list.select(at)
			menu._show_codex(at)
			await _shot("codex-%s-%s" % [s[0], v[0]])
	game.set_ui_scale(100)
	game.set_high_contrast(false)
	menu.queue_free()
	await process_frame
	quit(0)
