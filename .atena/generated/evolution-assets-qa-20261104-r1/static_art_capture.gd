extends SceneTree
## Arte estática integrada em jogo real: altares disputados (Shedaklah, Feng-tu) e montanhas rúnicas de Durao. Perfil sintético.
## Uso: powershell -File .atena/generated/evolution-assets-qa-20261104-r1/render.ps1 -Script static_art_capture.gd -LogName static
const OUTPUT := "res://.atena/generated/evolution-assets-qa-20261104-r1/captures/"
const USER_ROOT := "res://.atena/generated/evolution-assets-qa-20261104-r1/synthetic/"
var checks: Array[Dictionary] = []
var scene: Node
var battle: Battle
var game: Node

func check(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	print("staqa ", id, ": ", passed)

func _init() -> void:
	call_deferred("_run")

func _shot(name: String) -> void:
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + name + ".png"))

func _open_stage(stage: String) -> void:
	if scene != null:
		scene.queue_free()
		await process_frame
	game.run_stage = stage
	scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	battle = scene.battle
	battle.state = "running"
	paused = false
	battle.stage.waves = []
	battle.stage.elites = []
	battle.stage.duration = 99999
	battle._inter_t = 99999.0
	battle._breakable_t = 99999.0
	battle.enemies.clear()
	battle.hero.max_hp = 1.0e7
	battle.hero.hp = 1.0e7

func _put_hero(p: Vector2) -> void:
	battle.hero.pos = p
	scene.hero_node.position = Iso.to_screen(p)
	scene.camera.position = scene.hero_node.position

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
	game._save_path = "user://staqa-synthetic.json"
	game.profile = Profile.new({"name": "Static synthetic", "welcome_seen": true})
	for id in Data.table("hqs"):
		game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_hero = "durvall"

	# ---- A08: montanhas de Durao (escala real; o círculo de colisão é o de TerrainLayout.MOUNTAINS)
	await _open_stage("durao")
	var anchors: Array = TerrainLayout_anchors()
	check("durao_tem_4_montanhas", anchors.size() == 4)
	_put_hero(Vector2(11.0, 12.5))
	for i in 12:
		await process_frame
	await _shot("static-montanha-durao-1")
	_put_hero(Vector2(13.0, 30.0))
	for i in 12:
		await process_frame
	await _shot("static-montanha-durao-2")
	_put_hero(Vector2(30.0, 21.0))
	for i in 12:
		await process_frame
	await _shot("static-montanha-durao-3")
	# o herói empurrado contra a montanha para em cima do círculo de colisão (a arte não tem colisão própria)
	var m: Vector3 = anchors[0]
	_put_hero(Vector2(m.x + 5.0, m.y))
	for i in 400:
		battle.step(Vector2(-1, 0), 1.0 / 60.0)
	var d := battle.hero.pos.distance_to(Vector2(m.x, m.y))
	print("staqa hero parou a %.2f tiles do centro da montanha (raio %.2f)" % [d, m.z])
	check("colisao_inalterada", d >= m.z - 0.3 and d < m.z + 1.2)

	# ---- A06/A07: altares disputados
	for spec in [["shedaklah", "altar_disputado_shedaklah", "static-altar-do-limo"], ["feng_tu", "altar_disputado_feng_tu", "static-altar-disputado-feng-tu"]]:
		await _open_stage(spec[0])
		var def := {}
		for d2 in Data.table("stage_events")[spec[0]]:
			if String(d2.id) == spec[1]:
				def = d2.duplicate(true)
		check("evento_%s_existe" % spec[1], not def.is_empty())
		_put_hero(Vector2(20, 20))
		battle.happenings.fire(battle, def)
		var pts: Array = battle.interactions.filter(func(i): return String(i.kind) == "event_pact" and not i.used)
		check("altar_%s_criado_com_arte" % spec[1], pts.size() == 1 and String(pts[0].asset) != "")
		if pts.size() == 1:
			_put_hero(pts[0].pos + Vector2(-2.5, 2.5))
			for i in 90:   # a entrada do objeto dura 0,65 s de relógio da partida
				battle.hero.hp = battle.hero.max_hp
				battle.step(Vector2.ZERO, 1.0 / 60.0)
				scene._sync()
				await process_frame
			_put_hero(pts[0].pos + Vector2(-2.5, 2.5))
			scene._sync()
			for i in 20:
				await process_frame
			await _shot(spec[2])
	var failures := checks.filter(func(c): return not c.passed).size()
	print("staqa concluído, falhas: ", failures)
	quit(1 if failures > 0 else 0)

func TerrainLayout_anchors() -> Array:
	return preload("res://core/terrain_layout.gd").mountain_anchors("durao")
