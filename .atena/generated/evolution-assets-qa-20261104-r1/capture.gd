extends SceneTree
## QA visual dos assets das evoluções (plano de 2026-11-04): ícones na UI real (oferta, ficha, HUD) e VFX em combate real.
## Perfil e pasta de dados sintéticos (APPDATA/LOCALAPPDATA apontando para ./synthetic): nunca o save real.
## Uso: powershell -File .atena/generated/evolution-assets-qa-20261104-r1/render.ps1
const OUTPUT := "res://.atena/generated/evolution-assets-qa-20261104-r1/captures/"
const USER_ROOT := "res://.atena/generated/evolution-assets-qa-20261104-r1/synthetic/"
var checks: Array[Dictionary] = []
var scene: Node
var battle: Battle
var game: Node

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("evoqa ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _save(img: Image, name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	img.save_png(ProjectSettings.globalize_path(OUTPUT + name + ".png"))

func _frame() -> Image:
	await process_frame
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()

func _shot(name: String) -> void:
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	_save(root.get_texture().get_image(), name)

## Ficha de ícones com o resolvedor real do jogo (Items.weapon_icon / caminho das passivas).
func _icon_sheet(name: String, title: String, rows: Array, size: int) -> void:
	var layer := Control.new()
	layer.size = Vector2(1280, 720)
	var bg := ColorRect.new()
	bg.color = Color(0.10, 0.09, 0.12)
	bg.size = Vector2(1280, 720)
	layer.add_child(bg)
	var t := Label.new()
	t.text = title
	t.position = Vector2(16, 8)
	t.add_theme_font_size_override("font_size", 20)
	layer.add_child(t)
	var y := 44
	for row in rows:
		var x := 12
		for entry in row.items:
			var tr := TextureRect.new()
			tr.texture = load(String(entry.path)) as Texture2D
			tr.custom_minimum_size = Vector2(size, size)
			tr.size = Vector2(size, size)
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.position = Vector2(x, y)
			layer.add_child(tr)
			var l := Label.new()
			l.text = String(entry.label)
			l.position = Vector2(x, y + size)
			l.size = Vector2(size + 4, 30)
			l.add_theme_font_size_override("font_size", 9)
			l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
			layer.add_child(l)
			x += size + 6
		var cap := Label.new()
		cap.text = String(row.name)
		cap.position = Vector2(12, y - 16)
		cap.add_theme_font_size_override("font_size", 11)
		layer.add_child(cap)
		y += size + 44
	root.add_child(layer)
	await _shot(name)
	layer.queue_free()
	await process_frame

func _weapon_entry(id: String) -> Dictionary:
	return {"path": Items.weapon_icon(id), "label": id}

func _quiet_battle() -> void:
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

## Um caso de combate: arma única, alvos imóveis; devolve um recorte por instante pedido.
func _case(weapon_id: String, offsets: Array, shots: Array, crop: Rect2i, passive := "", slow := false) -> Array:
	_quiet_battle()
	Engine.time_scale = 0.25 if slow else 1.0
	battle.hero.weapons = [Weapon.make(weapon_id)]
	battle.hero.weapons[0].timer = 0.01
	battle.hero.passives.clear()
	if passive != "":
		battle.hero.passives[passive] = 1
	for a in ["forca", "inteligencia", "constituicao", "carisma"]:
		battle.hero.base_attrs[a] = 18
	battle.hero.recalc()
	for off in offsets:
		var e: Enemy = battle.spawn_for_test("zumbi", battle.hero.pos + off)
		e.max_hp = 1.0e9
		e.hp = 1.0e9
		e.stun_t = 999.0
	var out: Array = []
	var done := 0
	for target in shots:
		await _tick(int(target) - done)
		done = int(target)
		var img := await _frame()
		out.append(img.get_region(crop))
	Engine.time_scale = 1.0
	battle.enemies.clear()
	battle.projectiles.clear()
	battle.zones.clear()
	await _tick(50)
	return out

func _montage(name: String, rows: Array, tile: Vector2i) -> void:
	var cols: int = rows[0].size()
	var sheet := Image.create(cols * tile.x, rows.size() * tile.y, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0, 0, 0, 1))
	for r in rows.size():
		for c in cols:
			sheet.blit_rect(rows[r][c], Rect2i(Vector2i.ZERO, tile), Vector2i(c * tile.x, r * tile.y))
	_save(sheet, name)

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed or DisplayServer.get_name() == "headless":
		quit(1)
		return
	await process_frame
	await process_frame
	game = root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game._save_path = "user://evoqa-synthetic.json"
	game.profile = Profile.new({"name": "Evoqa synthetic", "welcome_seen": true})
	for id in Data.table("hqs"):
		game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "sylas"

	var only_area := OS.get_cmdline_user_args().has("area")
	# ---- A. fichas de ícones (resolvedor real)
	var bases := {"estocada_transfixante": "estocada_mistica", "vigilia_perpetua": "vela_sagrada", "selo_da_retidao": "marca_da_retidao", "chicote_da_cobica": "chicote_avarento",
		"machado_devorador": "machado_de_xargath", "abraco_dos_tentaculos": "colar_dos_tentaculos", "lamina_dissolvente": "lamina_da_digestao", "cajado_dos_desejos_realizados": "cajado_dos_desejos",
		"ampulheta_do_tempo_parado": "ampulheta", "lamina_do_eclipse": "lamina_de_sombra", "memoria_reescrita": "memoria_alterada", "pira_do_incendiario": "tocha_do_incendiario"}
	var top: Array = []
	var bottom: Array = []
	for evo in bases:
		top.append(_weapon_entry(bases[evo]))
		bottom.append(_weapon_entry(evo))
	var half := 6
	await _icon_sheet("01-icones-armas-antes-depois", "Armas base (acima) e evoluções novas (abaixo), ícone próprio de 128 px",
		[{"name": "base (1-6)", "items": top.slice(0, half)}, {"name": "evolução (1-6)", "items": bottom.slice(0, half)}, {"name": "base (7-12)", "items": top.slice(half)}, {"name": "evolução (7-12)", "items": bottom.slice(half)}], 112)
	var new_passives := ["precisao", "sede_de_sangue", "brasa", "ponta_certeira", "olhar_abissal", "acido", "ventura", "tempo_suspenso", "veu_de_sombras", "memoria_viva", "furia_sombria", "fe_radiante", "presenca_dominante"]
	var old_passives := ["forca", "inteligencia", "constituicao", "carisma", "cota_de_malha", "robe_arcano", "botas_leves"]
	var np: Array = []
	for id in new_passives:
		np.append({"path": "res://assets/icons/passives/%s.png" % id, "label": id})
	var op: Array = []
	for id in old_passives:
		op.append({"path": "res://assets/icons/passives/%s.png" % id, "label": id})
	await _icon_sheet("02-icones-passivas-novas-e-referencia", "Passivas novas (13) e referência das existentes (7)",
		[{"name": "novas (1-7)", "items": np.slice(0, 7)}, {"name": "novas (8-13)", "items": np.slice(7)}, {"name": "existentes (referência)", "items": op}], 112)

	# ---- cena de corrida real
	scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	battle = scene.battle
	_quiet_battle()

	# ---- B. ofertas de nível (cartões reais)
	var wd := Data.table("weapons")
	var pd := Data.table("passives")
	var evo_offer: Array = []
	for pair in [["marca_da_retidao", "selo_da_retidao"], ["cajado_dos_desejos", "cajado_dos_desejos_realizados"], ["memoria_alterada", "memoria_reescrita"]]:
		evo_offer.append({"t": "evolve", "id": pair[0], "into": pair[1], "name": "★ EVOLUÇÃO: %s" % wd[pair[1]].name, "desc": wd[pair[1]].desc, "weight": 9.0, "role": "synergy"})
	battle.offer = evo_offer
	battle.offer_kind = "levelup"
	battle.state = "levelup"
	battle._decorate_offers()
	scene._refresh_offer()
	await _shot("03-oferta-evolucoes")
	var pas_offer: Array = []
	for pid in ["ponta_certeira", "olhar_abissal", "furia_sombria"]:
		pas_offer.append({"t": "passive", "id": pid, "name": "NOVA: %s" % pd[pid].name, "desc": pd[pid].desc, "weight": 9.0, "role": "synergy"})
	battle.offer = pas_offer
	battle._decorate_offers()
	scene._refresh_offer()
	await _shot("04-oferta-passivas-novas")
	var mix: Array = []
	for pid in ["fe_radiante", "memoria_viva", "presenca_dominante"]:
		mix.append({"t": "passive", "id": pid, "name": "NOVA: %s" % pd[pid].name, "desc": pd[pid].desc, "weight": 9.0, "role": "synergy"})
	battle.offer = mix
	battle._decorate_offers()
	scene._refresh_offer()
	await _shot("05-oferta-passivas-novas-2")
	battle.state = "running"
	battle.offer.clear()
	scene._refresh_offer()
	await process_frame

	# ---- C/D. ficha (armas, passivas) e HUD com as armas evoluídas
	_quiet_battle()
	battle.hero.weapons = [Weapon.make("estocada_transfixante"), Weapon.make("selo_da_retidao"), Weapon.make("vigilia_perpetua"), Weapon.make("cajado_dos_desejos_realizados")]
	for id in ["lamina_do_eclipse", "memoria_reescrita", "abraco_dos_tentaculos"]:
		var g := Weapon.make(id)
		g.granted = true
		battle.hero.weapons.append(g)
	battle.hero.passives = {"ponta_certeira": 2, "precisao": 1, "ventura": 3, "veu_de_sombras": 2, "olhar_abissal": 1}
	battle.hero.recalc()
	scene.hud.update_stats(battle)
	await process_frame
	await _shot("06-hud-com-evolucoes")
	scene.hud.show_items_panel(battle)
	scene.hud.items_panel.set_tab(0)
	await _shot("07-ficha-armas-evoluidas")
	scene.hud.items_panel.set_tab(2)
	await _shot("08-ficha-passivas-novas")
	scene.hud.items_panel.hide_sheet()
	await process_frame

	# ---- E. VFX em combate (recortes por instante)
	var bolt_offsets := [Vector2(3.5, 0), Vector2(5.0, 1.0), Vector2(5.0, -1.0), Vector2(6.5, 0), Vector2(4.2, 2.2), Vector2(4.2, -2.2)]
	var ring6 := [Vector2(2.6, 0), Vector2(-2.6, 0), Vector2(0, 2.6), Vector2(0, -2.6), Vector2(1.8, 1.8), Vector2(-1.8, -1.8)]
	var ring_big := [Vector2(4.5, 0), Vector2(-4.5, 0), Vector2(0, 4.5), Vector2(0, -4.5), Vector2(3.2, 3.2), Vector2(-3.2, -3.2), Vector2(3.2, -3.2), Vector2(-3.2, 3.2)]
	var bolt_crop := Rect2i(560, 270, 440, 330)
	var area_crop := Rect2i(390, 160, 500, 400)
	var wide_crop := Rect2i(240, 90, 800, 540)
	var tile_b := Vector2i(440, 330)
	var shots_b := [6, 14, 22, 30]
	var pairs := [["marca_da_retidao", "selo_da_retidao", "dos projéteis do Selo"], ["cajado_dos_desejos", "cajado_dos_desejos_realizados", "do Cajado"],
		["lamina_de_sombra", "lamina_do_eclipse", "da Lâmina do Eclipse"], ["memoria_alterada", "memoria_reescrita", "da Memória"]]
	for pair in pairs:
		var evo_frames: Array = await _case(pair[1], bolt_offsets, shots_b, bolt_crop)
		var base_frames: Array = await _case(pair[0], bolt_offsets, shots_b, bolt_crop)
		await _montage("vfx-%s" % pair[1], [base_frames, evo_frames], tile_b)
	# pulso da Vigília (e Vela como referência), ampulheta evolvida (e base), zona do Abraço (e Colar)
	var shots_p := [8, 18, 30, 44]
	var ring_small := [Vector2(1.6, 0), Vector2(-1.6, 0), Vector2(0, 1.6), Vector2(0, -1.6), Vector2(1.1, 1.1), Vector2(-1.1, -1.1)]
	var ring_mid := [Vector2(3.0, 0), Vector2(-3.0, 0), Vector2(0, 3.0), Vector2(0, -3.0), Vector2(2.1, 2.1), Vector2(-2.1, -2.1), Vector2(2.1, -2.1), Vector2(-2.1, 2.1)]
	var tile_a := Vector2i(500, 400)
	var vela: Array = await _case("vela_sagrada", ring_small, shots_p, area_crop, "", true)
	var vigil: Array = await _case("vigilia_perpetua", ring_small, shots_p, area_crop, "", true)
	await _montage("vfx-vigilia_perpetua", [vela, vigil], tile_a)
	var hg_base: Array = await _case("ampulheta", ring_mid, shots_p, wide_crop, "", true)
	var hg_evo: Array = await _case("ampulheta_do_tempo_parado", ring_big, shots_p, wide_crop, "", true)
	await _montage("vfx-ampulheta_do_tempo_parado", [hg_base, hg_evo], Vector2i(800, 540))
	var shots_z := [10, 24, 60, 120]   # a zona usa tempo real: sem câmera lenta
	var colar: Array = await _case("colar_dos_tentaculos", ring6, shots_z, area_crop)
	var abraco: Array = await _case("abraco_dos_tentaculos", ring_big, shots_z, wide_crop)
	await _montage("vfx-abraco_dos_tentaculos-colar", [colar], tile_a)
	await _montage("vfx-abraco_dos_tentaculos", [abraco], Vector2i(800, 540))
	var failures := checks.filter(func(c): return not c.passed).size()
	print("evoqa capturas concluídas, falhas: ", failures)
	quit(1 if failures > 0 else 0)
