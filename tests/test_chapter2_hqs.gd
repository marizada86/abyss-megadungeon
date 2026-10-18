extends RefCounted

func run() -> Array:
	var failures: Array[String] = []
	var catalog = preload("res://core/hq_catalog.gd")
	var saved_qa: bool = Game.qa_sandbox
	Game.qa_sandbox = false
	var fresh := Profile.new()
	var reader_scene := load("res://ui/hq_screen.tscn") as PackedScene
	var tree := Engine.get_main_loop() as SceneTree
	for id in ["hqn_19", "hqn_20", "hqn_21", "hqn_04"]:
		var hq: Dictionary = Data.table("hqs")[id]
		var content_gate: bool = hq.trigger.type == "chapter2_content"
		if catalog.is_unlocked(fresh.data, id):
			failures.append("HQ2 não deve liberar sem marco: " + id)
		fresh.data.campaign_progress.milestones.chapter1_closed = true
		if catalog.is_unlocked(fresh.data, id):
			failures.append("fechar capítulo 1 não antecipa resolução de Dagruve: " + id)
		if content_gate:
			fresh.data.campaign_progress.milestones[hq.trigger.milestone] = true
		else:
			fresh.data.campaign_progress.legacy_hq_access[id] = true
		if not catalog.is_unlocked(fresh.data, id):
			failures.append("marco próprio deve permitir leitura: " + id)
		if content_gate:
			fresh.data.campaign_progress.milestones.erase(hq.trigger.milestone)
		else:
			fresh.data.campaign_progress.legacy_hq_access.erase(id)
		Game.qa_sandbox = true
		if content_gate and not catalog.is_unlocked(fresh.data, id):
			failures.append("QA deve permitir conferir conteúdo admitido: " + id)
		Game.qa_sandbox = false
		var reader = reader_scene.instantiate()
		tree.root.add_child(reader)
		reader.start_hq(hq)
		if id in ["hqn_21", "hqn_04"] and not is_equal_approx(reader.panel_image.anchor_bottom, 0.7):
			failures.append("novas composições devem terminar acima da faixa de legenda: " + id)
		for index in range(hq.panels.size()):
			if reader.is_closed or reader.completed:
				failures.append("leitor concluiu antes do último quadro: " + id)
			if reader.panel_image.texture == null or reader.panel_image.texture.resource_path != hq.panels[index].image:
				failures.append("textura não carregou: %s/%d" % [id, index])
			if reader.caption_label.text != hq.panels[index].text:
				failures.append("legenda incorreta: %s/%d" % [id, index])
			if reader.panel_counter.text != "Quadro %d de %d" % [index + 1, hq.panels.size()]:
				failures.append("contador incorreto: %s/%d" % [id, index])
			reader.advance()
		if not reader.completed or not reader.is_closed:
			failures.append("leitor não concluiu: " + id)
		reader.start_hq(hq, 4)
		if reader.panel_index != 4:
			failures.append("retomada perdeu cursor: " + id)
		reader.finish()
		if reader.completed:
			failures.append("fechar não deve registrar leitura completa: " + id)
		reader.start_hq(Data.table("hqs").hqn_01)
		if not is_equal_approx(reader.panel_image.anchor_bottom, 1.0):
			failures.append("leitor deve restaurar enquadramento das demais HQs")
		reader.free()
	var segments: Array = Data.table("hqs").hqn_19.presentation_segments
	if catalog.ORDER.find("hqn_21") != catalog.ORDER.find("hqn_20") + 1 or catalog.ORDER.find("hqn_04") != catalog.ORDER.find("hqn_21") + 1:
		failures.append("HQ21 deve ficar entre HQ20 e HQ04 no Diário")
	fresh.data.hqs_seen.hqn_21 = true
	if not catalog.is_unlocked(fresh.data, "hqn_21"):
		failures.append("HQ21 lida deve manter acesso")
	fresh.data.hqs_seen.erase("hqn_21")
	if segments.size() != 2 or segments[0].panel_count != 4 or segments[1].first_panel != 4 or segments[1].panel_count != 8:
		failures.append("HQ19 deve manter divisão Q1–4/Q5–12 em uma entrada")
	if not catalog.newly_triggered_ids(fresh.data, "stage_cleared", "dagruve").is_empty():
		failures.append("conteúdo admitido não deve inventar gatilho de campanha pendente")
	Game.qa_sandbox = saved_qa
	return failures
