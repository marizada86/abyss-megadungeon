extends SceneTree
func _init() -> void:
	var img := Image.load_from_file(ProjectSettings.globalize_path("res://assets_incoming/queue-20261104-r1/sources/memoria_habilidade_v01.png"))
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var col := PackedFloat32Array()
	col.resize(w)
	for x in w:
		var s := 0.0
		for y in img.get_height():
			var c := img.get_pixel(x, y)
			s += maxf(c.r, maxf(c.g, c.b))
		col[x] = s
	# vales de luz perto das fronteiras esperadas (i*362)
	for i in range(1, 6):
		var best := i * 362
		for x in range(i * 362 - 50, i * 362 + 50):
			if col[x] < col[best]:
				best = x
		print("SEP entre q%d e q%d: x=%d (luz da coluna %.1f; luz mediana %.1f)" % [i, i + 1, best, col[best], col[i * 362 - 120]])
	quit()
