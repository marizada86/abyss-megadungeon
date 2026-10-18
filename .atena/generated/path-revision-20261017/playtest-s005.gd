extends SceneTree
## Local interactive entry; launched only after the PowerShell isolation probe.

var session_dir := ""
var verify := false
var returning := false
var selector: Control
var ygg_attempt := 0

func _init() -> void:
	call_deferred("_start")

func _argument(key: String) -> String:
	var args := OS.get_cmdline_user_args()
	var at := args.find(key)
	return args[at + 1] if at >= 0 and at + 1 < args.size() else ""

func _start() -> void:
	session_dir = _argument("--map-session")
	# Refuse standalone launches that bypass the isolated session wrapper.
	var user_dir := OS.get_user_data_dir().replace("\\", "/")
	if session_dir.is_empty() or not user_dir.begins_with(session_dir.replace("\\", "/") + "/"):
		printerr("Map playtest requires Testar-Mapas.cmd and an isolated session.")
		quit(1)
		return
	verify = OS.get_cmdline_user_args().has("--verify-launch")
	await process_frame
	await process_frame
	var game := root.get_node_or_null("Game")
	if game == null:
		printerr("Nao foi possivel iniciar o jogo. Confira o registro indicado pelo atalho.")
		quit(1)
		return
	var kit := root.get_node_or_null("Playtest")
	if kit != null:
		kit.call("_close_guide_modal")
	game.profile = Profile.new({})
	process_frame.connect(_watch_return)
	_show_selector()
	var requested := _argument("--map")
	if requested in ["reino_abissal", "domwieck", "raiz_yggdrasil"]:
		await _open_map(requested)

func _show_selector() -> void:
	paused = false
	returning = false
	selector = Control.new()
	selector.name = "MapPlaytestChoice"
	selector.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(selector)
	current_scene = selector
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	selector.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(620,0)
	center.add_child(panel)
	var margin := MarginContainer.new()
	for side in ["left","right","top","bottom"]:
		margin.add_theme_constant_override("margin_" + side,24)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",16)
	margin.add_child(column)
	var title := Label.new()
	title.text = "Teste dos mapas — protótipos"
	title.add_theme_font_size_override("font_size",26)
	column.add_child(title)
	var instructions := Label.new()
	instructions.text = "Escolha um mapa. Você jogará com Durvall e dados de teste separados.\n\nSobreviva, siga a seta e fique 3 segundos no círculo do destino.\nWASD/setas ou mouse: andar · Q/botão direito: habilidade · Esc: pausa.\n\nReino Abissal e Domwieck: arte aprovada.\nS-PATH-005 r2: caminhos, bordas e combate.\nYggdrasil alterna sementes 7502/7503/7504 ao reabrir."
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instructions.custom_minimum_size.x = 560
	column.add_child(instructions)
	var first: Button
	for pair in [["Reino Abissal — 6 minutos","reino_abissal"],["Domwieck — 7 minutos","domwieck"],["Raiz de Yggdrasil — 4 minutos · protótipo","raiz_yggdrasil"]]:
		var button := Button.new()
		button.text = pair[0]
		button.custom_minimum_size.y = 50
		button.pressed.connect(_open_map.bind(String(pair[1])))
		column.add_child(button)
		if first == null:
			first = button
	var close := Button.new()
	close.text = "Sair"
	close.custom_minimum_size.y = 42
	close.pressed.connect(func(): quit())
	column.add_child(close)
	first.grab_focus()

func _watch_return() -> void:
	if returning and current_scene != null and current_scene.scene_file_path == "res://ui/menu.tscn":
		current_scene.queue_free()
		current_scene = null
		_show_selector()

func _open_map(stage_id: String) -> void:
	if returning:
		return
	returning = true
	var game = root.get_node("Game")
	if not game.start_qa_run({"stage_id":stage_id,"hero_id":"durvall","target_state":"running","seed":_next_seed(stage_id)}):
		printerr(game.qa_error)
		quit(1)
		return
	if not verify:
		for i in 12:
			await process_frame
		var run = current_scene
		if run == null or run.get("battle") == null:
			printerr("S-PATH-005: run unavailable")
			quit(1)
			return
		var b: Battle = run.battle
		DisplayServer.window_set_title("S-PATH-005 r2 | " + stage_id)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(session_dir.path_join("mapa-aberto.png"))
		run.call("_toggle_pause")
		var file := FileAccess.open(session_dir.path_join("ready.json"),FileAccess.WRITE)
		file.store_string(JSON.stringify({"map":b.stage_id,"sandbox":game.qa_sandbox,"save_path":game._save_path,"user_data_dir":OS.get_user_data_dir(),"hero_position":[b.hero.pos.x,b.hero.pos.y],"paused":paused,"human_acceptance":"PENDING","seed":7502 + ((ygg_attempt-1)%3) if stage_id == "raiz_yggdrasil" else 4401},"\t"))
		file.close()
		return
	for i in 6:
		await process_frame
	var failures: Array[String] = []
	if current_scene == null or current_scene.get("battle") == null:
		failures.append("Mapa não carregou")
	else:
		var battle: Battle = current_scene.battle
		if battle.stage_id != stage_id or not game.qa_sandbox:
			failures.append("Destino ou sandbox incorreto")
		if not game._save_path.begins_with("user://qa-sandbox/"):
			failures.append("Perfil não está no sandbox")
		current_scene.set_physics_process(false)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(session_dir.path_join("mapa-aberto.png"))
		current_scene._return_to_menu()
		for i in 6:
			await process_frame
		if current_scene == null or current_scene.name != "MapPlaytestChoice":
			failures.append("Retorno não abriu seleção dos mapas")
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(session_dir.path_join("selecao-mapas.png"))
	var file := FileAccess.open(session_dir.path_join("launch-verification.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"map":stage_id,"failures":failures,"user_data_dir":OS.get_user_data_dir(),"session":session_dir},"\t"))
	file.close()
	quit(0 if failures.is_empty() else 1)

func _next_seed(stage_id: String) -> int:
	if stage_id != "raiz_yggdrasil":
		return 4401
	var result: int = [7502,7503,7504][ygg_attempt % 3]
	ygg_attempt += 1
	return result
