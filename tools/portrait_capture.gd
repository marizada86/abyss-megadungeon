extends SceneTree
## PLAN-ABYSS-HERO-PORTRAITS-20261027: prints do HUD da run e da Ficha (C) de um herói, em perfil e pasta de dados sintéticos.
## Uso: powershell -File tools/portrait_render.ps1 -Hero durvall -Tag antes
const OUTPUT := "res://.atena/generated/hero-portraits-20261027-r1/captures/"
const USER_ROOT := "res://.atena/generated/hero-portraits-20261027-r1/synthetic/"
var hero := "durvall"
var tag := "depois"
var size := "1920x1080"
var failures := 0

func _init() -> void:
	call_deferred("_run")

func _shot(name: String, region: Rect2i = Rect2i()) -> void:
	for i in 6: await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	var img := root.get_texture().get_image()
	if region.size != Vector2i.ZERO:
		img = img.get_region(region)
	img.save_png(ProjectSettings.globalize_path(OUTPUT + "%s-%s-%s.png" % [name, hero, tag]))

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		push_error("portrait_capture: diretório de usuário não é o sintético ou sem janela")
		quit(1)
		return
	var user_args := OS.get_cmdline_user_args()
	if user_args.size() > 0: hero = String(user_args[0])
	if user_args.size() > 1: tag = String(user_args[1])
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://portraits-synthetic.json"
	game.profile = Profile.new({"name": "Portraits synthetic", "welcome_seen": true})
	for id in Data.table("hqs"): game.profile.data.hqs_seen[id] = true
	game.qa_sandbox = true
	game.qa_launch = {"seed": 230610, "target_state": "running"}
	game.run_stage = "dagruve"
	game.run_hero = hero
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
	await _shot("hud")
	# recorte do painel do herói (canto superior esquerdo), ampliado para conferir o retrato
	var panel: Control = scene.hud.hero_panel
	var r := Rect2i(panel.get_global_rect().position, panel.get_global_rect().size).grow(8)
	await _shot("hud-painel", r)
	scene.hud.items_panel.show_sheet(battle)
	await _shot("ficha")
	var col: Control = scene.hud.items_panel._portrait
	var cr := Rect2i(col.get_global_rect().position, col.get_global_rect().size).grow(40)
	await _shot("ficha-retrato", cr)
	print("portrait_capture ", hero, " ", tag, " ok")
	quit(0)
