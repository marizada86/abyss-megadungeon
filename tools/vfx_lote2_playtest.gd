extends SceneTree
## Lote 2 (coleta, morte, chefes): integração sintética no perfil isolado de vfx_lote1_render.ps1.
## Uso: powershell -File tools/vfx_lote1_render.ps1 -Script tools/vfx_lote2_playtest.gd -LogName playtest-lote2
const OUTPUT := "res://.atena/generated/vfx-lote2-20261023-r1/"
const USER_ROOT := "res://.atena/generated/vfx-lote1-20261023-r1/synthetic/"
var checks: Array[Dictionary] = []

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("vfx2 ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _count(group: StringName) -> int:
	return get_nodes_in_group(group).size()

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
	game._save_path = "user://vfx2-synthetic.json"
	game.profile = Profile.new({"name": "VFX2 synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "boss", "prelude_seconds": 0.1}
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
	for i in 20:
		battle.step(Vector2.ZERO, 0.05)
		if battle.boss != null and battle.boss_mech != null:
			break
	check("boss_with_mechanics", battle.boss != null and battle.boss_mech != null)
	if battle.boss == null or battle.boss_mech == null:
		quit(1)
		return
	battle.boss_mech._verbs.clear()
	battle.hero.max_hp = 100000.0
	battle.hero.hp = 100000.0
	battle.enemies.erase(battle.boss)
	var boss: Enemy = battle.boss
	var origin := Vector2(20, 20)
	battle.hero.pos = origin
	boss.pos = origin + Vector2(0, -6)
	scene.hero_node.position = Iso.to_screen(origin)
	scene.camera.position = scene.hero_node.position
	var settings: Dictionary = game.profile.data.settings
	settings.reduced_impact = false

	# ---- coleta
	for kind in ["xp", "gold", "potion", "magnet"]:
		battle.events.append({"type": "pickup", "kind": kind, "pos": battle.hero.pos})
	scene._consume_events()
	check("pickup_effects", _count(&"pickup_vfx") == 4)
	settings.reduced_impact = true
	for kind in ["xp", "gold", "potion", "magnet"]:
		battle.events.append({"type": "pickup", "kind": kind, "pos": battle.hero.pos})
	scene._consume_events()
	check("pickup_reduced_adds_none", _count(&"pickup_vfx") == 4)
	settings.reduced_impact = false
	var fx_before: int = scene.fx.get_child_count()
	battle.events.append({"type": "levelup"})
	scene._consume_events()
	check("levelup_effect", scene.fx.get_child_count() > fx_before)

	# ---- maré
	var tide_before: float = battle.tide_xp_bonus()
	battle._tide_buffs.append(battle.time + 10.0)
	for i in 30: scene._sync_tide_aura(0.1)
	check("tide_aura_on", scene._tide_aura != null and is_instance_valid(scene._tide_aura) and scene._tide_aura.modulate.a > 0.3)
	battle._tide_buffs.clear()
	for i in 30: scene._sync_tide_aura(0.1)
	check("tide_aura_off", scene._tide_aura == null)

	# ---- morte
	for i in 30:
		var enemy := battle._spawn("zumbi", origin + Vector2(float(i % 10) - 5.0, 3.0 + float(i / 10)))
		battle.events.append({"type": "kill", "pos": enemy.pos, "enemy": enemy})
	scene._consume_events()
	check("death_cap", _count(&"death_vfx") > 0 and _count(&"death_vfx") <= DeathVfx.LIMIT)
	var soul := battle._spawn("alma_penada", origin + Vector2(-8, 3))
	var crate := battle._spawn("caixote_quebravel", origin + Vector2(8, 3))
	battle.events.append({"type": "boom", "pos": origin + Vector2(0, 6), "radius": 2.2, "affix": "explosivo"})
	scene._consume_events()
	check("explosion_on_boom", _count(&"death_vfx") > 0)
	soul.hp = 0.0
	crate.hp = 0.0

	# ---- chefe: mecânicas e detonações
	var mech: BossMechanics = battle.boss_mech
	mech.sweep = {"origin": boss.pos, "a": 1.2, "a0": 1.2, "sign": 1.0, "arc": 1.0, "warn": 5.0, "dur": 1.0, "t": 1.0, "len": 9.0, "dice": "1d4", "offsets": [0.0, PI]}
	mech.quad = {"center": origin + Vector2(2, 0), "sectors": [0, 2], "t": 2.0, "total": 3.0, "radius": 5.0, "dice": "1d4", "puddle": false}
	mech.mark = {"pos": origin + Vector2(-5, 3), "follow": 1.0, "lock": 5.0, "t": 2.0, "radius": 2.5, "dice": "1d4", "slow": 0.0, "puddle": false}
	mech.cast = {"name": "Teste", "t": 1.5, "total": 2.5, "dice": "1d4", "stun": 2.0, "effect": "heavy", "armor_s": 6.0}
	mech.armor_t = 20.0
	var sweep_before := mech.sweep.duplicate(true)
	var quad_before := mech.quad.duplicate(true)
	var mark_before := mech.mark.duplicate(true)
	var cast_before := mech.cast.duplicate(true)
	var rng_state: int = battle.rng.state
	scene._sync_boss_vfx()
	check("boss_nodes", scene._boss_vfx.size() == 6)
	check("boss_state_unchanged", mech.sweep == sweep_before and mech.quad == quad_before and mech.mark == mark_before and mech.cast == cast_before and battle.rng.state == rng_state)
	var keep_nodes := {}
	for key in scene._boss_vfx: keep_nodes[key] = scene._boss_vfx[key].node
	scene._sync_boss_vfx()
	var same := true
	for key in keep_nodes:
		if not scene._boss_vfx.has(key) or scene._boss_vfx[key].node != keep_nodes[key]: same = false
	check("boss_nodes_reused", same)
	var before_count: int = _count(&"boss_vfx")
	battle.events.append({"type": "telegraph_burst", "pos": mech.quad.center, "verb": "quad", "sectors": [0, 2], "radius": 5.0})
	battle.events.append({"type": "telegraph_burst", "pos": origin + Vector2(-5, 3), "verb": "mark", "radius": 2.5})
	battle.events.append({"type": "telegraph_burst", "pos": boss.pos, "verb": "cast"})
	battle.events.append({"type": "cast_interrupt", "pos": boss.pos})
	battle.events.append({"type": "boss_phase", "pos": boss.pos, "text": "Fase"})
	scene._consume_events()
	check("boss_bursts", _count(&"boss_vfx") >= before_count + 5)
	if DisplayServer.get_name() != "headless":
		scene._boss_intro_panel.visible = false
		scene.hud.modal_overlay = false
		for i in 5: await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "integration-bosses.png"))
	# impacto reduzido: nenhum nó de arte; o contorno continua por BossMechanics.draw_fx
	settings.reduced_impact = true
	scene._sync_boss_vfx()
	await process_frame
	check("boss_reduced_no_art", scene._boss_vfx.is_empty())
	settings.reduced_impact = false
	scene._sync_boss_vfx()
	check("boss_back_after_reduced", scene._boss_vfx.size() == 6)
	mech.shield = 0.0
	mech.armor_t = 0.0
	scene._sync_boss_vfx()
	check("shield_break_effect", not scene._boss_vfx.has("shield") and _count(&"boss_vfx") > 0)
	mech.sweep.clear(); mech.quad.clear(); mech.mark.clear(); mech.cast.clear()
	scene._sync_boss_vfx()
	check("boss_nodes_cleaned", scene._boss_vfx.is_empty())

	# ---- queda do chefe: câmera lenta e flash
	settings.reduced_impact = true
	battle.events.append({"type": "kill", "pos": boss.pos, "enemy": boss})
	scene._consume_events()
	check("slowmo_respects_reduced", Engine.time_scale == 1.0)
	settings.reduced_impact = false
	scene._hit_stop_last_ms = -100000
	battle.events.append({"type": "kill", "pos": boss.pos, "enemy": boss})
	scene._consume_events()
	check("slowmo_on", is_equal_approx(Engine.time_scale, BossVfx.SLOWMO_SCALE))
	check("flash_on", _count(&"boss_flash") == 1)
	await create_timer(BossVfx.SLOWMO_SECONDS + 0.25, true, false, true).timeout
	check("slowmo_restored", Engine.time_scale == 1.0)
	await create_timer(BossVfx.FLASH_SECONDS + 0.2, true, false, true).timeout
	check("flash_cleaned", _count(&"boss_flash") == 0)

	# ---- estresse: 100 cristais no chão e abates em sequência, com e sem arte
	battle.pickups.clear()
	for i in 100:
		battle.pickups.append({"kind": "xp" if i % 4 != 0 else "gold", "pos": origin + Vector2.RIGHT.rotated(float(i) * 0.37) * (2.0 + float(i % 7)), "value": 1.0, "magnet": false, "src": ""})
	Engine.max_fps = 120
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var summaries := {}
	for enabled in [false, true]:
		settings.reduced_impact = not enabled
		_unpause(scene)   # a janela oculta perde o foco e o jogo pausa sozinho
		for i in 30: await process_frame
		var stats := FrameStats.new()
		var previous := Time.get_ticks_usec()
		for i in 180:
			if i % 6 == 0:
				var e := battle._spawn("zumbi", origin + Vector2(float(i % 12) - 6.0, 4.0))
				battle.events.append({"type": "kill", "pos": e.pos, "enemy": e})
				battle.events.append({"type": "pickup", "kind": "xp", "pos": battle.hero.pos})
			scene._consume_events()
			await process_frame
			var now := Time.get_ticks_usec()
			stats.add(float(now - previous) / 1000000.0)
			previous = now
		summaries["sprites" if enabled else "reduced"] = stats.total()
		_unpause(scene)
		for i in 3: await process_frame
		if enabled and DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "integration-stress.png"))
	check("death_cap_after_stress", _count(&"death_vfx") <= DeathVfx.LIMIT)
	check("pickup_cap_after_stress", _count(&"pickup_vfx") <= PickupVfx.LIMIT)
	check("engine_time_scale_normal", Engine.time_scale == 1.0)
	var failures := checks.filter(func(c): return not c.passed)
	var file := FileAccess.open(OUTPUT + "playtest-lote2-verification.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks": checks, "failures": failures, "frame_stats": summaries, "renderer": RenderingServer.get_video_adapter_name(), "synthetic": true, "human_playtest": "PENDING"}, "	"))
	print("vfx2 integration: ", failures.size(), " failures")
	scene.queue_free()
	current_scene = null
	await process_frame
	await process_frame
	quit(0 if failures.is_empty() else 1)

func _unpause(scene: Node) -> void:
	if paused or scene._paused:
		paused = false
		scene._paused = false
		scene.hud.show_pause(false)
