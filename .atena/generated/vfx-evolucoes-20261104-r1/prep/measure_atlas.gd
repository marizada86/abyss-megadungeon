extends SceneTree
## Caixa útil, centro de luz e margem de cada célula 256 de um atlas; gera montagem sobre fundo escuro.
func _init() -> void:
	var paths := ["res://tmp/evo_vfx/out/selo_retidao_evo.png", "res://tmp/evo_vfx/out/cajado_realizado_evo.png", "res://tmp/evo_vfx/out/eclipse_evo.png", "res://tmp/evo_vfx/out/memoria_reescrita_evo.png",
		"res://tmp/evo_vfx/out/pulso_vigilia.png", "res://tmp/evo_vfx/out/pulso_ampulheta_tempo.png", "res://tmp/evo_vfx/out/abraco_laco.png",
		"res://assets/vfx/orbe_radiante_evo.png", "res://assets/vfx/orbe_arcano_evo.png", "res://assets/vfx/onda_cortante_evo.png", "res://assets/vfx/pulso_evo.png", "res://assets/vfx/ampulheta_silencio.png", "res://assets/vfx/tentaculos_laco.png"]
	var sheet := Image.create(2048, 256 * paths.size(), false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.06, 0.05, 0.08))
	var row := 0
	for p in paths:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		var cells := img.get_width() / 256
		var line := ""
		for i in cells:
			var minx := 999; var maxx := -1; var miny := 999; var maxy := -1; var sx := 0.0; var sy := 0.0; var sw := 0.0
			for y in 256:
				for x in 256:
					var a := img.get_pixel(i * 256 + x, y).a
					if a > 0.15:
						minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
						sx += x * a; sy += y * a; sw += a
			line += " [%d: x%d-%d y%d-%d c(%.0f,%.0f)]" % [i, minx, maxx, miny, maxy, sx / maxf(sw, 1.0), sy / maxf(sw, 1.0)]
		print("ATL %s%s" % [p.get_file(), line])
		sheet.blend_rect(img, Rect2i(0, 0, img.get_width(), 256), Vector2i(0, row * 256))
		row += 1
	sheet.save_png(ProjectSettings.globalize_path("res://tmp/evo_vfx/montagem.png"))
	quit()
