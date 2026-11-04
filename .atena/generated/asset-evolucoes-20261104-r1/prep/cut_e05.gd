extends SceneTree
## Recorta a folha E05 em 4 regiões (ampulheta e esfera encostam: o separador por componentes as fundiu).
func _init() -> void:
	var img := Image.load_from_file(ProjectSettings.globalize_path("res://assets_incoming/E05_a_v01.png"))
	var cells := {"ampulheta_do_tempo_parado": Rect2i(0, 0, 768, 478), "lamina_do_eclipse": Rect2i(768, 0, 768, 478),
		"memoria_reescrita": Rect2i(0, 478, 768, 546), "pira_do_incendiario": Rect2i(768, 478, 768, 546)}
	for id in cells:
		var piece := img.get_region(cells[id])
		piece.save_png(ProjectSettings.globalize_path("res://tmp/evolucoes_icons/e05_%s.png" % id))
	quit()
