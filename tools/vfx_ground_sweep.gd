extends SceneTree
## Varredura das âncoras de chão dos efeitos (VfxAtlas.GROUND_ROW): cada efeito nasce sobre o herói, com a elipse de referência
## (verde) e o ponto do chão (amarelo) por cima; o anel da arte tem de ficar concêntrico à elipse. Saída: um quadro de contato.
## Uso: powershell -File tools/vfx_ground_sweep.ps1
const OUTPUT := "res://.atena/generated/vfx-ground-anchor-20261027-r1/sweep.png"
const USER_ROOT := "res://.atena/generated/vfx-ground-anchor-20261027-r1/synthetic/"
const CELL := Vector2i(300, 260)
var scene: Node
var dbg: Node2D
var zpos := Vector2(22, 22)
var dbg_radius := 0.0
var shots: Array[Image] = []
var labels: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _hold() -> void:
	paused = false
	scene._paused = false
	scene.hud.show_pause(false)   # perder o foco da janela pausa o jogo e abre o menu por cima da captura
	scene.hero_node.position = Iso.to_screen(zpos)
	scene.battle.hero.pos = zpos
	scene.camera.position = Iso.to_screen(zpos)
	dbg.queue_redraw()

func _shoot(label: String, make: Callable, seconds: float, radius: float) -> void:
	dbg_radius = radius
	var node: Node = make.call()
	if node == null:
		print("sweep sem nó: ", label)
		return
	scene.fx.add_child(node)
	var started := Time.get_ticks_msec()
	while Time.get_ticks_msec() - started < int(seconds * 500.0):   # metade da vida: perto do pico da folha
		_hold()
		await process_frame
	_hold()
	await process_frame
	await RenderingServer.frame_post_draw
	shots.append(root.get_texture().get_image().get_region(Rect2i(640 - CELL.x / 2, 360 - 190, CELL.x, CELL.y)))
	labels.append(label)
	if is_instance_valid(node):
		node.queue_free()
	for i in 4: await process_frame

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		print("sweep: precisa de janela e do diretório sintético isolado")
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game._save_path = "user://vfx-ground-synthetic.json"
	game.profile = Profile.new({"name": "VFX ground synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = "durvall"
	scene = load("res://ui/run.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await process_frame
	scene.set_physics_process(false)
	var battle: Battle = scene.battle
	battle.state = "running"
	battle.enemies.clear()
	dbg = Node2D.new()
	dbg.z_index = 4000
	scene.fx.add_child(dbg)
	dbg.draw.connect(func():
		var c := Iso.to_screen(zpos)
		dbg.draw_circle(c, 2.0, Color(1, 1, 0, 1))
		var rx := 44.0 if dbg_radius <= 0.0 else Iso.TILE_W * dbg_radius * sqrt(2.0) * 0.5
		var ry := 22.0 if dbg_radius <= 0.0 else Iso.TILE_H * dbg_radius * sqrt(2.0) * 0.5
		var pts := PackedVector2Array()
		for k in 49:
			var a := TAU * float(k) / 48.0
			pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
		dbg.draw_polyline(pts, Color(0.2, 1, 0.2, 1), 1.0))
	for i in 20:
		_hold()
		await process_frame
	var ground := zpos
	var zone := {"owner": "hero", "kind": "zone", "pos": ground, "radius": 2.4, "life": 60.0, "tick": 0.6, "acc": 0.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico", "dice": "1d4", "attr": "inteligencia"}}
	await _shoot("poção", func(): return PickupVfx.create_collect("potion", ground, false, 0, Time.get_ticks_msec() + 100000), 0.45, 0.0)
	await _shoot("subida de nível", func(): return PickupVfx.create_levelup(ground), 0.9, 0.0)
	await _shoot("aura da Maré", func():
		var aura := PickupVfx.create_tide_aura()
		aura.modulate.a = PickupVfx.TIDE_ALPHA
		return aura, 0.9, 0.0)
	await _shoot("detonação mágica", func(): return DetonationVfx.create_effect(2.4, ground, "magico"), 0.5, 2.4)
	await _shoot("detonação física", func(): return DetonationVfx.create_effect(2.4, ground, "fisico"), 0.5, 2.4)
	await _shoot("bola de fogo", func(): return FireBurstVfx.create_sprite_effect({"type": "nova", "dtype": "fogo", "radius": 2.4, "pos": ground}), 0.6, 2.4)
	await _shoot("estouro de fase do chefe", func(): return BossVfx.create_phase_burst(ground, 1.0), 0.8, 0.0)
	await _shoot("morte de chefe", func(): return DeathVfx._build(&"chefe", ground, 0.95, Color.WHITE), 1.1, 0.0)
	await _shoot("morte de alma", func(): return DeathVfx._build(&"alma", ground, 0.70, Color.WHITE), 1.2, 0.0)
	await _shoot("colar (emersão)", func(): return TentacleVfx.create_cast({"owner": "hero", "weapon": "colar_dos_tentaculos", "radius": 2.4, "pos": ground}), 0.6, 2.4)
	var entry := TentacleVfx.create_zone(zone)
	entry.born = int(entry.born) - 2000
	await _shoot("colar (laço)", func():
		TentacleVfx.update(entry)
		return entry.sprite, 0.9, 2.4)
	var columns := 4
	var sheet := Image.create(CELL.x * columns, CELL.y * int(ceil(float(shots.size()) / columns)), false, Image.FORMAT_RGBA8)
	for i in shots.size():
		sheet.blit_rect(shots[i], Rect2i(Vector2i.ZERO, CELL), Vector2i((i % columns) * CELL.x, (i / columns) * CELL.y))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT).get_base_dir())
	sheet.save_png(ProjectSettings.globalize_path(OUTPUT))
	print("sweep ordem: ", labels)
	quit(0)
