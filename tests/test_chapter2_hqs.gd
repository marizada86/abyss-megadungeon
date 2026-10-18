extends RefCounted

func run() -> Array:
	var failures: Array[String] = []
	var catalog = preload("res://core/hq_catalog.gd")
	var saved_qa: bool = Game.qa_sandbox
	Game.qa_sandbox = false
	var fresh := Profile.new()
	var reader_scene := load("res://ui/hq_screen.tscn") as PackedScene
	var tree := Engine.get_main_loop() as SceneTree
	for id in ["hqn_19", "hqn_20"]:
		var hq: Dictionary = Data.table("hqs")[id]
		if catalog.is_unlocked(fresh.data, id):
			failures.append("HQ2 não deve liberar sem marco: " + id)
		fresh.data.campaign_progress.milestones.chapter1_closed = true
		if catalog.is_unlocked(fresh.data, id):
			failures.append("fechar capítulo 1 não antecipa resolução de Dagruve: " + id)
		fresh.data.campaign_progress.milestones[hq.trigger.milestone] = true
		if not catalog.is_unlocked(fresh.data, id):
			failures.append("marco próprio deve permitir leitura: " + id)
		fresh.data.campaign_progress.milestones.erase(hq.trigger.milestone)
		Game.qa_sandbox = true
		if not catalog.is_unlocked(fresh.data, id):
			failures.append("QA deve permitir conferir conteúdo admitido: " + id)
		Game.qa_sandbox = false
		var reader = reader_scene.instantiate()
		tree.root.add_child(reader)
		reader.start_hq(hq)
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
		reader.free()
	var segments: Array = Data.table("hqs").hqn_19.presentation_segments
	if segments.size() != 2 or segments[0].panel_count != 4 or segments[1].first_panel != 4 or segments[1].panel_count != 8:
		failures.append("HQ19 deve manter divisão Q1–4/Q5–12 em uma entrada")
	if not catalog.newly_triggered_ids(fresh.data, "stage_cleared", "dagruve").is_empty():
		failures.append("conteúdo admitido não deve inventar gatilho de campanha pendente")
	Game.qa_sandbox = saved_qa
	return failures
