extends SceneTree
## Arlindo Orlando em jogo real: projétil da Memória Alterada, habilidade Modify Memory e a evolução (CAR 15). Perfil sintético.
## Uso: powershell -File .atena/generated/evolution-assets-qa-20261104-r1/render.ps1 -Script arlindo_capture.gd
const OUTPUT := "res://.atena/generated/evolution-assets-qa-20261104-r1/captures/"
const USER_ROOT := "res://.atena/generated/evolution-assets-qa-20261104-r1/synthetic/"
var checks: Array[Dictionary] = []
var scene: Node
var battle: Battle

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("arlqa ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _save(img: Image, name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	img.save_png(ProjectSettings.globalize_path(OUTPUT + name + ".png"))

func _frame() -> Image:
	await process_frame
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()

func _quiet() -> void:
	battle.state = "running"
	paused = false
	battle.stage.waves = []
	battle.stage.elites = []
	battle.stage.duration = 99999
	battle._inter_t = 99999.0
	battle._breakable_t = 99999.0
	battle.enemies.clear()
	battle.projectiles.clear()
	battle.zones.clear()
	battle.hero.pos = Vector2(20, 20)
	scene.hero_node.position = Iso.to_screen(Vector2(20, 20))
	scene.camera.position = scene.hero_node.position
	battle.hero.max_hp = 1.0e7
	battle.hero.hp = 1.0e7

func _tick(n: int) -> void:
	for i in n:
		paused = false
		battle.hero.hp = battle.hero.max_hp
		battle.step(Vector2.ZERO, 1.0 / 60.0)
		scene._sync()
		scene._consume_events()
		await process_frame

func _spawn(offsets: Array) -> void:
	for off in offsets:
		var e: Enemy = battle.spawn_for_test("zumbi", battle.hero.pos + off)
		e.max_hp = 1.0e9
		e.hp = 1.0e9
		e.stun_t = 999.0

func _clear() -> void:
	Engine.time_scale = 1.0
	battle.enemies.clear()
	battle.projectiles.clear()
	battle.zones.clear()
	await _tick(50)

func _montage(name: String, rows: Array, tile: Vector2i) -> void:
	var cols: int = rows[0].size()
	var sheet := Image.create(cols * tile.x, rows.size() * tile.y, false, Image.FORMAT_RGBA8)
	for r in rows.size():
		for c in cols:
			sheet.blit_rect(rows[r][c], Rect2i(Vector2i.ZERO, tile), Vector2i(c * tile.x, r * tile.y))
	_save(sheet, name)

func _bolt_case(weapon_id: String, shots: Array, crop: Rect2i, offsets: Array) -> Array:
	_quiet()
	battle.hero.weapons = [Weapon.make(weapon_id)]
	battle.hero.weapons[0].timer = 0.01
	battle.hero.recalc()
	_spawn(offsets)
	var out: Array = []
	var done := 0
	for target in shots:
		await _tick(int(target) - done)
		done = int(target)
		out.append((await _frame()).get_region(crop))
	await _clear()
	return out

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed or DisplayServer.get_name() == "headless":
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game._save_path = "user://arlqa-synthetic.json"
	game.profile = Profile.new({"name": "Arlindo synthetic", "welcome_seen": true})
	for id in Data.table("hqs"):
		game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "arlindo"
	scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	battle = scene.battle
	_quiet()
	check("heroi_arlindo", battle.hero.id == "arlindo" and battle.hero.weapons[0].id == "memoria_alterada")

	# 1) projétil: Raio Enfraquecedor (orbe arcano, referência) acima; Memória Alterada nova arte abaixo
	var offs := [Vector2(3.5, 0), Vector2(5.0, 1.0), Vector2(5.0, -1.0), Vector2(6.5, 0), Vector2(4.2, 2.2), Vector2(4.2, -2.2)]
	var crop := Rect2i(560, 270, 440, 330)
	var shots := [6, 14, 22, 30]
	var ref: Array = await _bolt_case("raio_enfraquecedor", shots, crop, offs)
	var mem: Array = await _bolt_case("memoria_alterada", shots, crop, offs)
	await _montage("arlindo-projetil-memoria-alterada", [ref, mem], Vector2i(440, 330))

	# 2) habilidade Modify Memory (pulso de 4 tiles), câmera lenta para pegar o pico
	_quiet()
	battle.hero.weapons.clear()
	var ring := [Vector2(2.6, 0), Vector2(-2.6, 0), Vector2(0, 2.6), Vector2(0, -2.6), Vector2(1.8, 1.8), Vector2(-1.8, -1.8), Vector2(3.4, 1.0), Vector2(-3.4, -1.0)]
	_spawn(ring)
	battle.hero.cds_reset_for_test() if battle.hero.has_method("cds_reset_for_test") else null
	Engine.time_scale = 0.25
	battle.use_active(Vector2(1, 0))
	var area := Rect2i(300, 130, 680, 460)
	var frames: Array = []
	var done := 0
	for target in [4, 14, 26, 40, 58, 80]:
		await _tick(int(target) - done)
		done = int(target)
		frames.append((await _frame()).get_region(area))
	await _clear()
	await _montage("arlindo-habilidade-modify-memory", [frames.slice(0, 3), frames.slice(3, 6)], Vector2i(680, 460))

	# 3) evolução com CAR 15: Nv 5 + Memória Viva => a oferta traz a evolução; escolher troca a arma
	_quiet()
	var w: Weapon = battle.hero.weapons[0] if not battle.hero.weapons.is_empty() else Weapon.make("memoria_alterada")
	battle.hero.weapons = [Weapon.make("memoria_alterada", Weapon.MAX_LEVEL)]
	battle.hero.passives = {"memoria_viva": 1}
	battle.hero.recalc()
	check("arlindo_carisma_15", battle.hero.attr("carisma") == 15)
	var seen := false
	for i in 40:
		for o in battle._build_offer():
			if String(o.t) == "evolve":
				seen = true
	check("evolucao_na_oferta_com_car15", seen)
	battle.offer = [{"t": "evolve", "id": "memoria_alterada", "into": "memoria_reescrita", "name": "★ EVOLUÇÃO: Memória Reescrita", "desc": Data.table("weapons")["memoria_reescrita"].desc, "weight": 9.0, "role": "synergy"}]
	battle.offer_kind = "levelup"
	battle.state = "levelup"
	battle._decorate_offers()
	scene._refresh_offer()
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	_save(root.get_texture().get_image(), "arlindo-oferta-evolucao")
	battle.choose(0)
	for i in 4:
		await process_frame
	check("arma_evoluiu", battle.hero.weapons[0].id == "memoria_reescrita")
	# deixa a cinemática de evolução correr e volta ao jogo
	var saw_cine := false
	for i in 600:
		paused = false
		battle.step(Vector2.ZERO, 1.0 / 60.0)
		scene._sync()
		saw_cine = saw_cine or battle.state == "evolve_cine"
		await process_frame
		if saw_cine and battle.state == "running":
			break
	check("cinematica_de_evolucao_rodou_e_terminou", saw_cine and battle.state == "running")
	scene.hud.hide_evolution()
	scene._refresh_offer()
	for i in 6:
		await process_frame
	var evo: Array = await _bolt_case("memoria_reescrita", [6, 14, 22, 30], crop, offs)
	await _montage("arlindo-projetil-memoria-reescrita", [mem, evo], Vector2i(440, 330))
	var failures := checks.filter(func(c): return not c.passed).size()
	print("arlqa concluído, falhas: ", failures)
	quit(1 if failures > 0 else 0)
