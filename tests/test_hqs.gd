extends RefCounted

const HQCatalog := preload("res://core/hq_catalog.gd")
const EXPECTED := {
	"hqn_01": {"type": "first_run"},
	"hqn_02": {"type": "stage_cleared", "stage": "docas"},
	"hqn_03": {"type": "stage_cleared", "stage": "domwieck"},
	"hqn_04": {"type": "stage_cleared", "stage": "shedaklah"},
	"hqn_05": {"type": "stage_cleared", "stage": "molor"},
	"hqn_06": {"type": "stage_cleared", "stage": "durao"},
	"hqn_07": {"type": "stage_cleared", "stage": "feng_tu"},
	"hqn_08": {"type": "stage_cleared", "stage": "shendilavri"},
	"hqn_09": {"type": "stage_cleared", "stage": "goranthis"},
	"hqn_10": {"type": "final_victory", "stage": "pilares"},
	"hqn_11": {"achievement": "cacador_de_chefes"},
	"hqn_12": {"achievement": "aluris"},
	"hqn_13": {"achievement": "mestre_de_camadas"},
	"hqn_14": {"achievement": "pilares_ativos"},
	"hqn_15": {"type": "stage_cleared", "stage": "docas"},
	"hqn_16": {"type": "stage_cleared", "stage": "docas"},
	"hqn_17": {"type": "stage_cleared", "stage": "docas"},
	"hqn_18": {"type": "stage_cleared", "stage": "reino_abissal"},
	"hqn_19": {"type": "chapter2_content", "milestone": "dagruve_resolution"},
	"hqn_20": {"type": "chapter2_content", "milestone": "yggdrasil_traversed"}
}

func run() -> Array:
	var out: Array[String] = []
	var hqs: Dictionary = Data.table("hqs")
	if hqs.size() != EXPECTED.size():
		out.append("catálogo deveria conter as %d HQs previstas" % EXPECTED.size())
	for hq_id in EXPECTED:
		if not hqs.has(hq_id):
			out.append("catálogo sem %s" % hq_id)
			continue
		var hq: Dictionary = hqs[hq_id]
		var expected: Dictionary = EXPECTED[hq_id]
		if expected.has("achievement"):
			if String(hq.get("achievement", "")) != String(expected.achievement):
				out.append("conquista incorreta para %s" % hq_id)
		else:
			if hq.get("trigger", {}) != expected:
				out.append("gatilho incorreto para %s: %s" % [hq_id, str(hq.get("trigger", {}))])
		var panels: Array = hq.get("panels", [])
		var expected_panel_count := int({"hqn_01":8,"hqn_02":5,"hqn_03":6,"hqn_14":5,"hqn_15":5,"hqn_16":5,"hqn_17":4,"hqn_18":8,"hqn_19":12,"hqn_20":7}.get(hq_id,4))
		if panels.size() != expected_panel_count:
			out.append("%s deveria ter %d quadros" % [hq_id, expected_panel_count])
		for panel in panels:
			var path := String(panel.get("image", ""))
			if not ResourceLoader.exists(path):
				out.append("imagem ausente em %s: %s" % [hq_id, path])
			else:
				var texture := ResourceLoader.load(path) as Texture2D
				if texture == null:
					out.append("image failed to import: %s" % path)
				elif absf(float(texture.get_width()) / float(texture.get_height()) - 16.0 / 9.0) > 0.0021:
					out.append("imagem fora da proporção-fonte aproximada 16:9 em %s: %dx%d" % [path, texture.get_width(), texture.get_height()])
			if String(panel.get("text", "")).is_empty():
				out.append("legenda vazia em %s" % hq_id)

	var fresh := Profile.new()
	if not HQCatalog.unlocked_ids(fresh.data).is_empty():
		out.append("perfil novo não deveria liberar HQ antes dos marcos")
	if HQCatalog.newly_triggered_ids(fresh.data, "first_run") != ["hqn_01"]:
		out.append("primeira run deveria acionar HQN-01")
	var legacy := Profile.new({"stats": {"runs": 1, "reached": {"shedaklah": true}}, "cleared": {"docas": true}})
	if not HQCatalog.newly_triggered_ids(legacy.data, "first_run").is_empty():
		out.append("save existente não deveria reproduzir HQN-01 retroativamente")
	var legacy_early_save := Profile.new({"coins": 25})
	if not HQCatalog.newly_triggered_ids(legacy_early_save.data, "first_run").is_empty():
		out.append("save antigo com moedas mas sem estatísticas não deveria reproduzir HQN-01 retroativamente")
	if not HQCatalog.is_unlocked(legacy.data, "hqn_01") or not HQCatalog.is_unlocked(legacy.data, "hqn_02") or not HQCatalog.is_unlocked(legacy.data, "hqn_03"):
		out.append("progresso antigo deveria liberar HQs correspondentes no Diário")
	if HQCatalog.newly_triggered_ids(fresh.data, "stage_cleared", "docas") != ["hqn_02", "hqn_15", "hqn_16", "hqn_17"]:
		out.append("Docas deve acionar fila ordenada")
	if not HQCatalog.newly_earned_ids(["aluris", "pilares_ativos"]).is_empty():
		out.append("conquistas novas não reativam seleção histórica")
	var old_achievement_unlocks := Profile.new({"achievements": {"aluris": true, "pilares_ativos": true}})
	if not HQCatalog.is_unlocked(old_achievement_unlocks.data, "hqn_12") or not HQCatalog.is_unlocked(old_achievement_unlocks.data, "hqn_14"):
		out.append("conquistas existentes deveriam continuar liberando HQN-12 e HQN-14")

	var scene := load("res://ui/hq_screen.tscn") as PackedScene
	if scene == null:
		out.append("cena do leitor de HQ não carrega")
		return out
	var tree := Engine.get_main_loop() as SceneTree
	var screen = scene.instantiate()
	screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(screen)
	screen.call("start_hq", hqs["hqn_01"])
	var panel_image: TextureRect = screen.get_node("%PanelImage")
	if panel_image.texture == null:
		out.append("reader did not load first panel texture")
	if panel_image.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		out.append("reader must preserve panel aspect ratio")
	for viewport_size in [Vector2(1280, 720), Vector2(1920, 1080)]:
		var available: Vector2 = viewport_size - Vector2(16, 16)
		var scale_factor: float = minf(available.x / float(panel_image.texture.get_width()), available.y / float(panel_image.texture.get_height()))
		var drawn_size: Vector2 = Vector2(panel_image.texture.get_size()) * scale_factor
		if drawn_size.x > available.x + 0.01 or drawn_size.y > available.y + 0.01:
			out.append("imagem seria cortada em %dx%d" % [int(viewport_size.x), int(viewport_size.y)])
	for panel_index in range(8):
		if bool(screen.get("is_closed")) or bool(screen.get("completed")):
			out.append("HQ01 não deve concluir antes do avanço após o oitavo quadro")
		if String(screen.get_node("%PanelCounter").text) != "Quadro %d de 8" % (panel_index + 1):
			out.append("contador incorreto na HQ01, quadro %d" % (panel_index + 1))
		var expected_panel: Dictionary = hqs["hqn_01"]["panels"][panel_index]
		if String(screen.get_node("%Caption").text) != String(expected_panel.text):
			out.append("legenda incorreta na HQ01, quadro %d" % (panel_index + 1))
		var right_caption: Label = screen.get_node("%CaptionRight")
		if panel_index == 1:
			if not right_caption.visible or right_caption.text != "Helion: Procure Gilly.":
				out.append("fala de Helion deve aparecer na metade direita do quadro 2")
			if String(screen.get_node("%Caption").text) != "Zynara: Investigue as docas.":
				out.append("fala de Zynara deve permanecer na metade esquerda do quadro 2")
			if screen.get_node("%Caption").anchor_right >= 0.5 or right_caption.anchor_left <= 0.5:
				out.append("as duas falas devem ocupar metades separadas do quadro 2")
		elif right_caption.visible or not right_caption.text.is_empty() or not is_equal_approx(screen.get_node("%Caption").anchor_right, 0.945):
			out.append("quadros sem fala à direita devem restaurar a legenda única")
		if panel_image.texture == null or panel_image.texture.resource_path != String(expected_panel.image):
			out.append("imagem incorreta na HQ01, quadro %d" % (panel_index + 1))
		screen.call("advance")
	if not bool(screen.get("is_closed")) or not bool(screen.get("completed")):
		out.append("leitor deve registrar conclusão após o oitavo quadro da HQ01")

	screen.free()

	var hq02_screen = scene.instantiate()
	hq02_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(hq02_screen)
	hq02_screen.call("start_hq", hqs["hqn_02"])
	for panel_index in range(5):
		if bool(hq02_screen.get("is_closed")) or bool(hq02_screen.get("completed")):
			out.append("HQ02 concluiu antes do quinto quadro")
		var expected_hq02: Dictionary = hqs["hqn_02"]["panels"][panel_index]
		if String(hq02_screen.get_node("%PanelCounter").text) != "Quadro %d de 5" % (panel_index + 1):
			out.append("contador incorreto na HQ02")
		if String(hq02_screen.get_node("%Caption").text) != String(expected_hq02.text):
			out.append("legenda incorreta na HQ02")
		var hq02_image: TextureRect = hq02_screen.get_node("%PanelImage")
		if hq02_image.texture == null or hq02_image.texture.resource_path != String(expected_hq02.image):
			out.append("imagem incorreta na HQ02")
		if hq02_screen.get_node("%CaptionRight").visible:
			out.append("HQ02 deve usar legenda única")
		hq02_screen.call("advance")
	if not bool(hq02_screen.get("is_closed")) or not bool(hq02_screen.get("completed")):
		out.append("HQ02 deve concluir após quinto quadro")
	hq02_screen.free()

	var skip_screen = scene.instantiate()
	skip_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(skip_screen)
	skip_screen.call("start_hq", hqs["hqn_14"])
	var esc := InputEventKey.new()
	esc.pressed = true
	esc.keycode = KEY_ESCAPE
	skip_screen.call("_input", esc)
	if not bool(skip_screen.get("is_closed")) or bool(skip_screen.get("completed")):
		out.append("Esc deveria pular a HQ sem contar leitura completa")
	skip_screen.free()

	var note_screen = scene.instantiate()
	note_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(note_screen)
	note_screen.call("start_hq", hqs["hqn_11"])
	Playtest.open_note()
	var space := InputEventKey.new()
	space.pressed = true
	space.keycode = KEY_SPACE
	note_screen.call("_input", space)
	if int(note_screen.get("panel_index")) != 0:
		out.append("espaço digitado no bloco de notas (F5) não pode avançar a HQ")
	var click := InputEventMouseButton.new()
	click.pressed = true
	click.button_index = MOUSE_BUTTON_LEFT
	note_screen.call("_input", click)
	if int(note_screen.get("panel_index")) != 0:
		out.append("clique no bloco de notas (F5) não pode avançar a HQ")
	Playtest.close_note()
	note_screen.call("_input", space)
	if int(note_screen.get("panel_index")) != 1:
		out.append("com o bloco de notas fechado o espaço deve voltar a avançar a HQ")
	note_screen.free()
	return out
