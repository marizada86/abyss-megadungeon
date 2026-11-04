extends SceneTree
## Mede o centro de luz (média ponderada por brilho) e a caixa útil de cada região das fontes dos VFX de evolução.
func _lum(c: Color) -> float:
	return maxf(c.r, maxf(c.g, c.b))
func _measure(img: Image, rect: Rect2i) -> Dictionary:
	var sx := 0.0; var sy := 0.0; var sw := 0.0
	var minx := 99999; var miny := 99999; var maxx := -1; var maxy := -1
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var l := _lum(img.get_pixel(x, y))
			if l > 0.06:
				var w := l * l
				sx += x * w; sy += y * w; sw += w
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	if sw <= 0.0:
		return {}
	return {"cx": sx / sw - rect.position.x, "cy": sy / sw - rect.position.y, "bbox": Rect2i(minx - rect.position.x, miny - rect.position.y, maxx - minx + 1, maxy - miny + 1)}
func _init() -> void:
	var base := "res://assets_incoming/vfx-evolucoes-20261104-r1/sources/"
	var specs := {
		"VE01_selo_da_retidao_v01.png": [4, 2, 384, 512], "VE02_cajado_dos_desejos_realizados_v01.png": [4, 2, 384, 512],
		"VE03_lamina_do_eclipse_v01.png": [4, 2, 384, 512], "VE04_memoria_reescrita_v01.png": [4, 2, 384, 512],
		"VE05_vigilia_perpetua_v01.png": [3, 2, 512, 512], "VE06_abraco_dos_tentaculos_v01.png": [3, 2, 512, 512],
		"VE07_ampulheta_do_tempo_parado_v01.png": [3, 2, 512, 512]}
	for f in specs:
		var img := Image.load_from_file(ProjectSettings.globalize_path(base + f))
		img.convert(Image.FORMAT_RGBA8)
		var s: Array = specs[f]
		var out := []
		for r in s[1]:
			for c in s[0]:
				var m := _measure(img, Rect2i(c * s[2], r * s[3], s[2], s[3]))
				var bb: Rect2i = m.bbox
				print("SRC %s cel(%d,%d) centro=(%.0f,%.0f) bbox=x%d..%d y%d..%d (margem esq %d dir %d cima %d baixo %d)" % [f.left(4), c, r, m.cx, m.cy, bb.position.x, bb.end.x, bb.position.y, bb.end.y, bb.position.x, s[2] - bb.end.x, bb.position.y, s[3] - bb.end.y])
	quit()
