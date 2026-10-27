extends SceneTree
## Lote 3 (evoluções, detonação, tentáculos, indicador da Maré, brilho de XP): integração sintética no perfil isolado.
## Uso: powershell -File tools/vfx_lote1_render.ps1 -Script tools/vfx_lote3_playtest.gd -LogName playtest-lote3
const OUTPUT := "res://.atena/generated/vfx-lote3-20261027-r1/"
const USER_ROOT := "res://.atena/generated/vfx-lote1-20261023-r1/synthetic/"
var checks: Array[Dictionary] = []

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("vfx3 ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _count(group: StringName) -> int:
	return get_nodes_in_group(group).size()

func _unpause(scene: Node) -> void:
	if paused or scene._paused:
		paused = false
		scene._paused = false

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	check("isolated_user_dir", OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected))
	if not checks[0].passed:
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://vfx3-synthetic.json"
	game.profile = Profile.new({"name": "VFX3 synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
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
	battle.enemies.clear()
	battle.projectiles.clear()
	battle.zones.clear()
	battle.pickups.clear()
	var origin := Vector2(20, 20)
	battle.hero.pos = origin
	scene.hero_node.position = Iso.to_screen(origin)
	scene.camera.position = scene.hero_node.position
	battle.hero.max_hp = 100000.0
	battle.hero.hp = 100000.0
	var settings: Dictionary = game.profile.data.settings
	settings.reduced_impact = false
	for i in 40: await process_frame
	_unpause(scene)

	# ---- tentáculos: laço enquanto a zona vive, sem alterar a zona
	var zone := {"owner": "hero", "kind": "zone", "pos": origin + Vector2(-4, 3), "radius": 2.4, "life": 30.0, "tick": 0.6, "acc": 0.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico", "dice": "1d4", "attr": "inteligencia"}}
	battle.zones.append(zone)
	var zone_before := zone.duplicate(true)
	scene._sync_tentacle_vfx()
	check("tentacle_node", scene._tentacle_vfx.size() == 1 and scene.under.visual_tentacle_zones.size() == 1)
	check("tentacle_zone_unchanged", zone == zone_before)
	settings.reduced_impact = true
	scene._sync_tentacle_vfx()
	check("tentacle_reduced_falls_back", scene._tentacle_vfx.is_empty() and scene.under.visual_tentacle_zones.is_empty())
	settings.reduced_impact = false
	scene._sync_tentacle_vfx()
	check("tentacle_back", scene._tentacle_vfx.size() == 1)

	# ---- evolução: a Luz Mais Pura usa a arte própria; a base não
	for i in 5:
		battle.projectiles.append({"owner": "hero", "pos": origin + Vector2(float(i) * 1.6 - 3.0, -4), "dir": Vector2(1, 0), "speed": 10.0, "life": 5.0, "radius": 0.3, "hit": {}, "pierce": 1, "p": {"id": "luz_mais_pura" if i % 2 == 0 else "raio_de_luz", "dtype": "radiante"}})
	var rng_state: int = battle.rng.state
	scene._sync_projectile_vfx()
	var evolved := 0
	var base := 0
	for entry in scene._proj_vfx:
		if entry.family == &"orbe_radiante_evo": evolved += 1
		elif entry.family == &"orbe_radiante": base += 1
	check("evolved_family_in_use", evolved == 3 and base == 2)

	# ---- detonação física
	battle.events.append({"type": "boom", "pos": origin + Vector2(4, 4), "radius": 2.2, "affix": "", "dtype": "fisico"})
	battle.events.append({"type": "boom", "pos": origin + Vector2(-4, -3), "radius": 1.8, "affix": "", "dtype": "magico"})
	battle.events.append({"type": "boom", "pos": origin + Vector2(8, -2), "radius": 2.2, "affix": "explosivo", "dtype": "fisico"})
	scene._consume_events()
	check("detonation_fisica_only", _count(&"detonation_vfx") >= 1 and _count(&"detonation_vfx") <= 2)

	# ---- indicador da Maré e brilho da barra de XP
	battle._tide_buffs.append(battle.time + 10.0)
	battle._tide_buffs.append(battle.time + 10.0)
	scene.hud.hero_panel.update(battle)
	check("tide_indicator_visible", scene.hud.hero_panel.tide_label.visible and scene.hud.hero_panel.tide_label.text == "Maré +4%")
	battle._tide_buffs.clear()
	scene.hud.hero_panel.update(battle)
	check("tide_indicator_hidden", not scene.hud.hero_panel.tide_label.visible)
	battle.events.append({"type": "levelup"})
	scene._consume_events()
	check("xp_shine", _count(&"xp_shine") == 1)
	settings.reduced_impact = true
	scene.hud.hero_panel.shine_xp(true)
	check("xp_shine_reduced_adds_none", _count(&"xp_shine") == 1)
	settings.reduced_impact = false
	check("battle_rng_unchanged", rng_state == battle.rng.state)

	# ---- captura com tudo na tela
	battle._tide_buffs.append(battle.time + 30.0)
	battle._tide_buffs.append(battle.time + 30.0)
	scene.hud.hero_panel.update(battle)
	for i in 6: await process_frame
	_unpause(scene)
	scene.hud.show_pause(false)
	if DisplayServer.get_name() != "headless":
		for i in 8: await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "integration-lote3.png"))

	# ---- desempenho com várias zonas, evoluções e detonações
	for i in 3:
		battle.zones.append({"owner": "hero", "kind": "zone", "pos": origin + Vector2(float(i) * 3.0 - 3.0, 6), "radius": 2.0, "life": 60.0, "tick": 0.6, "acc": 0.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico", "dice": "1d4", "attr": "inteligencia"}})
	Engine.max_fps = 120
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var summaries := {}
	for enabled in [false, true]:
		settings.reduced_impact = not enabled
		_unpause(scene)
		for i in 30: await process_frame
		var stats := FrameStats.new()
		var previous := Time.get_ticks_usec()
		for i in 180:
			if i % 15 == 0:
				battle.events.append({"type": "boom", "pos": origin + Vector2(float(i % 9) - 4.0, 2.0), "radius": 2.0, "affix": "", "dtype": "fisico"})
			scene._consume_events()
			await process_frame
			var now := Time.get_ticks_usec()
			stats.add(float(now - previous) / 1000000.0)
			previous = now
		summaries["sprites" if enabled else "reduced"] = stats.total()
	check("detonation_cap_after_stress", _count(&"detonation_vfx") <= DetonationVfx.LIMIT)
	check("engine_time_scale_normal", Engine.time_scale == 1.0)
	var failures := checks.filter(func(c): return not c.passed)
	var file := FileAccess.open(OUTPUT + "playtest-lote3-verification.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks": checks, "failures": failures, "frame_stats": summaries, "renderer": RenderingServer.get_video_adapter_name(), "synthetic": true, "human_playtest": "PENDING"}, "	"))
	print("vfx3 integration: ", failures.size(), " failures")
	scene.queue_free()
	current_scene = null
	await process_frame
	await process_frame
	quit(0 if failures.is_empty() else 1)
