extends SceneTree
## QA dos ícones preparados: alfa, caixa útil, resíduo de fundo cinza e montagem para inspeção visual.
func _init() -> void:
	var files: Array = []
	for d in ["passives", "weapons"]:
		var dir := DirAccess.open("res://tmp/evolucoes_icons/" + d)
		for f in dir.get_files():
			if f.ends_with(".png"):
				files.append("res://tmp/evolucoes_icons/%s/%s" % [d, f])
	files.sort()
	var cols := 9
	var rows := int(ceil(files.size() / float(cols)))
	var sheet := Image.create(cols * 132, rows * 132, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.13, 0.12, 0.16))
	var i := 0
	for p in files:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		var minx := 999; var miny := 999; var maxx := -1; var maxy := -1; var gray := 0; var opaque := 0; var edge := 0
		for y in img.get_height():
			for x in img.get_width():
				var c := img.get_pixel(x, y)
				if c.a > 0.1:
					opaque += 1
					minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
					if absf(c.r - c.g) < 0.03 and absf(c.g - c.b) < 0.03 and c.r > 0.55 and c.r < 0.75:
						gray += 1
					if x == 0 or y == 0 or x == 127 or y == 127:
						edge += 1
		print("QA %-34s bbox=(%d,%d)-(%d,%d) opaco=%d cinza_residual=%d borda=%d" % [p.get_file(), minx, miny, maxx, maxy, opaque, gray, edge])
		sheet.blend_rect(img, Rect2i(0, 0, 128, 128), Vector2i((i % cols) * 132 + 2, (i / cols) * 132 + 2))
		i += 1
	sheet.save_png(ProjectSettings.globalize_path("res://tmp/evolucoes_icons/montagem.png"))
	quit()
