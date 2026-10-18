extends SceneTree
var failures: Array[String] = []
var checks: Array[Dictionary] = []
var output := ""
var game

func _init() -> void:
	call_deferred("_run")

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	if not passed: failures.append(id)

func frames(n: int = 3) -> void:
	for i in n: await process_frame

func _run() -> void:
	game = root.get_node("Game")
	var args := OS.get_cmdline_user_args()
	output = args[args.find("--port-out") + 1]
	game.qa_sandbox = true
	game.qa_launch = {"seed": 8142}
	game.profile = Profile.new({"name": "Synthetic visual port", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.run_stage = "docas"
	game.run_hero = "durvall"
	var run = load("res://ui/run.tscn").instantiate()
	run.set_physics_process(false)
	root.add_child(run)
	current_scene = run
	await frames(12)
	var hero = run.hero_node
	for i in 8:
		hero.apply_hero("durvall")
		var dir := Vector2.RIGHT.rotated(i * TAU / 8.0)
		hero.sync_visual(Vector2.ZERO, false, false)
		hero.sync_visual(dir * 20.0, false, false)
		var animation: StringName = hero.directional_walk_animation(dir)
		check("durvall_direction_%d" % i, hero.sprite.animation == animation and not hero.sprite.flip_h)
		var region: AtlasTexture = hero.sprite.sprite_frames.get_frame_texture(animation, 0)
		check("durvall_cell_%d" % i, region.region.size == Vector2(512, 512) and region.region.end.x <= region.atlas.get_width())
	for id in ["zynara", "leoric"]:
		hero.apply_hero(id)
		for animation in [&"move_n", &"move_ne"]:
			var region: AtlasTexture = hero.sprite.sprite_frames.get_frame_texture(animation, 0)
			check(id + "_" + String(animation), region.region.size == Vector2(512, 512) and region.atlas.resource_path.begins_with("res://assets/animations/heroes/" + id + "/"))
	hero.apply_hero("durvall")
	var original_hp: float = run.battle.hero.hp
	var original_pos: Vector2 = run.battle.hero.pos
	var original_rng: int = run.battle.rng.state
	for kind in ["chest", "boss_chest"]:
		run._play_interaction({"kind": kind, "pos": original_pos})
		var sprite = run.fx.get_child(run.fx.get_child_count() - 1)
		var region: AtlasTexture = sprite.sprite_frames.get_frame_texture(&"activate", 0)
		check(kind + "_opening_cell", region.region.size == Vector2(256, 256) and sprite.offset == Vector2(0, -96))
		check(kind + "_distinct_opening", region.atlas.resource_path.ends_with("/boss_chest_open.png" if kind == "boss_chest" else "/chest_open.png"))
	var nova := {"type": "nova", "weapon": "sentenca_de_lliira", "dtype": "radiante", "pos": original_pos, "radius": 2.0}
	run.battle.events = [nova]
	run._consume_events()
	var pulse = run.fx.get_child(run.fx.get_child_count() - 1)
	check("nova_uses_admitted_sprite", pulse.get_child_count() == 1 and pulse.get_child(0) is AnimatedSprite2D)
	var bolt := {"owner": "hero", "pos": original_pos, "dir": Vector2.RIGHT, "life": 1.0, "p": {"id": "raio_de_luz", "dtype": "radiante"}}
	run.battle.projectiles = [bolt]
	run._sync_projectile_vfx()
	check("projectile_reader_connected", run._proj_vfx.size() == 1 and run._proj_vfx[0].node is AnimatedSprite2D)
	game.profile.data.settings.reduced_impact = true
	run._sync_projectile_vfx()
	check("reduced_impact_fallback", run._proj_vfx.is_empty())
	game.profile.data.settings.reduced_impact = false
	run.battle.projectiles.clear()
	run._active_dir = Vector2.RIGHT
	run.battle.events = [{"type": "active", "pos": original_pos, "ability_id": "ruptura_sombria", "dtype": "fisico", "radius": 3.2, "name": "Synthetic", "hero_id": "durvall"}]
	run._consume_events()
	var active = run.fx.get_child(run.fx.get_child_count() - 1)
	check("active_reader_connected", active.get_child_count() == 1 and active.get_child(0) is AnimatedSprite2D)
	check("presentation_preserves_hp_position_rng", run.battle.hero.hp == original_hp and run.battle.hero.pos == original_pos and run.battle.rng.state == original_rng)
	check("new_gameplay_definitions", Data.table("enemies").has("totem_de_chefe") and Data.table("weapons").has("raio_da_ruina"))
	for retained in ["npc_grazzt_aliado", "ruina_durao", "ruina_shendilavri", "ruina_goranthis"]:
		check("retained_idle_" + retained, not InteractionAnim.has(retained))
	check("retained_totem_death", not ResourceLoader.exists("res://assets/animations/enemies/totem_de_chefe/death.png"))
	# Render the actual overlay with visual metadata and animation tables, not a mock.
	run.battle.interactions = [{"kind": "loja", "pos": original_pos + Vector2(-1, 0), "used": false, "born_at": -1.0}, {"kind": "event_target", "asset": "arco_pedra", "name": "Synthetic arch", "pos": original_pos + Vector2(1, 0), "used": false, "born_at": -1.0}]
	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		await frames(8)
		await RenderingServer.frame_post_draw
		var error := root.get_texture().get_image().save_png(output.path_join("runtime-%dx%d.png" % [size.x, size.y]))
		check("render_%dx%d" % [size.x, size.y], error == OK)
	var report := FileAccess.open(output.path_join("runtime-probe.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify({"checks": checks, "failures": failures, "synthetic": true, "human_acceptance": false}, "\t"))
	report.close()
	run.queue_free()
	await frames(3)
	for id in failures: printerr("PORT_VISUAL_FAILED: ", id)
	print("PORT_VISUALS: %d checks; %d failures" % [checks.size(), failures.size()])
	quit(0 if failures.is_empty() else 1)

