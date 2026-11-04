extends SceneTree
## Captura, no jogo, os golpes telegrafados com a pele de cada chefe (perfil sintético isolado, nunca o save real).
## Uso: defina APPDATA/LOCALAPPDATA para a pasta sintética e rode com --script tools/telegraph_skin_capture.gd -- <pasta_sintetica> <saida>
const SHOTS := [
	{"id": "molydeus_chefe", "name": "molydeus"},
	{"id": "sintese_abissal", "name": "sintese"},
	{"id": "discipulo_pestilento", "name": "discipulo"},
	{"id": "malcanthet", "name": "malcanthet"},
]

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var synthetic := String(args[0]).replace(String.chr(92), "/")
	var output := String(args[1])
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(synthetic):
		printerr("perfil não isolado: ", OS.get_user_data_dir())
		quit(1)
		return
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	var playtest := root.get_node("Playtest")
	playtest.call("_close_guide_modal")
	game._save_path = "user://telegraph-synthetic.json"
	game.profile = Profile.new({"name": "Telegraph synthetic", "welcome_seen": true})
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
	var boss: Enemy = battle.boss
	var mech: BossMechanics = battle.boss_mech
	mech._verbs.clear()
	battle.hero.max_hp = 100000.0
	battle.hero.hp = 100000.0
	battle.enemies.erase(boss)
	var origin := Vector2(20, 20)
	battle.hero.pos = origin
	boss.pos = origin + Vector2(0, -3)
	scene.hero_node.position = Iso.to_screen(origin)
	scene.camera.position = Iso.to_screen(origin + Vector2(0, -1))
	game.profile.data.settings.reduced_impact = false
	for shot in SHOTS:
		boss.id = shot.id
		mech.sweep.clear(); mech.quad.clear(); mech.mark.clear(); mech.cast.clear()
		mech.armor_t = 0.0
		scene._sync_boss_vfx()
		await process_frame
		var feixe: bool = String(shot.id) == "malcanthet"
		mech.sweep = {"origin": boss.pos, "a": 0.5, "a0": 0.5, "sign": 1.0, "arc": 1.0, "warn": 0.2 if feixe else 5.0, "dur": 9.0, "t": 1.0, "len": 7.0, "dice": "1d4", "offsets": [0.0, PI] if String(shot.id) == "molydeus_chefe" else [0.0]}
		mech.mark = {"pos": origin + Vector2(-5, 3), "follow": 1.0, "lock": 5.0, "t": 0.5, "radius": 2.5, "dice": "1d4", "slow": 0.0, "puddle": false}
		mech.quad = {"center": origin + Vector2(5, 3), "sectors": [0, 2], "t": 2.0, "total": 3.0, "radius": 4.0, "dice": "1d4", "puddle": false}
		mech.cast = {"name": "Teste", "t": 1.5, "total": 2.5, "dice": "1d4", "stun": 2.0, "effect": "heavy", "armor_s": 6.0}
		scene._sync_boss_vfx()
		scene._boss_intro_panel.visible = false
		scene.hud.modal_overlay = false
		for i in 12:
			if scene._paused:
				scene._toggle_pause()   # a janela oculta perde o foco e o jogo pausa sozinho
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(output + "shot-" + String(shot.name) + ".png"))
		print("shot ", shot.name)
	quit()
