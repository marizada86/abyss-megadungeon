extends SceneTree
## Oferta de item (Manter x Equipar) com e sem Shift (detalhes), em perfil e pasta de dados sintéticos.
## Uso: APPDATA e LOCALAPPDATA apontando para .atena/generated/offer-detail-20261027/synthetic, depois
##   godot --path . --resolution 1280x720 --rendering-method gl_compatibility --script tools/offer_detail_capture.gd -- <saida_png_prefixo> [escala]
const USER_ROOT := "res://.atena/generated/offer-detail-20261027/synthetic/"
var checks: Array[Dictionary] = []

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("offer ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _shot(path: String) -> void:
	for i in 8: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed or DisplayServer.get_name() == "headless":
		quit(1)
		return
	var args := OS.get_cmdline_user_args()
	var prefix: String = args[0] if args.size() > 0 else "offer"
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game._save_path = "user://offer-synthetic.json"
	game.profile = Profile.new({"name": "Offer synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "sylas"
	if args.size() > 1:
		game.set_ui_scale(int(args[1]))
	var scene: Node = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	var battle: Battle = scene.battle
	battle.state = "running"
	paused = false
	var current := {"id": "talisma", "name": "Talismã", "slot": "amuleto", "rarity": "comum", "mods": {"regen": 0.2}, "weapon": "", "level": 1}
	battle.hero.items["amuleto"] = current
	var found := {}
	for u in Data.table("items").uniques:
		if String(u.id) == "colar_dos_tentaculos":
			found = Items.unique(u)
	check("unique_found", not found.is_empty())
	battle.give_item(found, true)
	scene._refresh_offer()
	check("item_offer_open", battle.state == "item_offer" and scene.hud.levelup_panel.visible)
	await _shot(prefix + "-sem-shift.png")
	for c in scene.hud.offer_box.get_children():
		if c.has_method("show_detail"):
			c.call("show_detail", true)
	await _shot(prefix + "-shift.png")
	# nível: três cartões de arma, com e sem Shift
	battle.state = "running"
	battle.offer = [
		{"t": "weapon_new", "id": "espada_longa", "name": "NOVA: Espada Longa", "desc": "Golpe em arco.", "brief": "Golpe em arco, dano 4-8"},
		{"t": "weapon_up", "id": "espada_sombria", "name": "Espada Sombria → Nv 2", "desc": "Mais dano.", "brief": "Dano 5–9", "badge": {"text": "Nv 1 → 2"},
			"detail": {"columns": [], "rows": [], "footer": ["Nv 2: dano 5-9, recarga menor.", "Alcance maior."]}},
		{"t": "evolve", "id": "espada_sombria", "into": "espada_do_receptaculo", "name": "★ EVOLUÇÃO: Espada da Armadura Negra", "desc": "Arco enorme.", "brief": "Arco enorme"},
	]
	battle.offer_kind = "levelup"
	battle.state = "levelup"
	scene._refresh_offer()
	await _shot(prefix + "-nivel.png")
	for c in scene.hud.offer_box.get_children():
		if c.has_method("show_detail"):
			c.call("show_detail", true)
	await _shot(prefix + "-nivel-shift.png")
	var failures := checks.filter(func(c): return not c.passed).size()
	quit(1 if failures > 0 else 0)
