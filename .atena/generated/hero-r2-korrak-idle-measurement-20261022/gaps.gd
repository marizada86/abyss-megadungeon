extends SceneTree
func opaque(c: Color) -> bool:
	return maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b) > 0.22 * 1.6
func _init() -> void:
	var img := Image.load_from_file("F:/dev/abyss-megadungeon/assets_incoming/hero-r2/korrak/korrak_idle_se_v01.png")
	img.convert(Image.FORMAT_RGBA8)
	var occ := []
	for x in img.get_width():
		var any := false
		for y in img.get_height():
			if opaque(img.get_pixel(x, y)):
				any = true
				break
		occ.append(any)
	var runs := []
	var start := -1
	var minx := -1; var maxx := -1
	for x in occ.size():
		if occ[x]:
			if minx < 0: minx = x
			maxx = x
	for x in range(minx, maxx + 1):
		if not occ[x]:
			if start < 0: start = x
		else:
			if start >= 0:
				runs.append([start, x - 1, x - start])
				start = -1
	print("conteúdo de x=", minx, " a x=", maxx, " (largura ", maxx - minx + 1, ")")
	print("intervalos vazios entre as figuras (x_ini, x_fim, largura): ", runs)
	print("margem esquerda ", minx, " px, margem direita ", img.get_width() - 1 - maxx, " px")
	quit()
