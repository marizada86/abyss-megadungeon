extends SceneTree
## Jobs de asset_prep (vfx_atlas) para o projétil e a habilidade do Arlindo, com âncoras medidas nas fontes aceitas.
func _centroid(img: Image, rect: Rect2i, power: float) -> Vector2:
	var sx := 0.0
	var sy := 0.0
	var sw := 0.0
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var c := img.get_pixel(x, y)
			var l := maxf(c.r, maxf(c.g, c.b))
			if l > 0.06:
				var w := pow(l, power)
				sx += x * w
				sy += y * w
				sw += w
	return Vector2(sx / sw - rect.position.x, sy / sw - rect.position.y)
func _edge_light(img: Image, rect: Rect2i) -> float:
	var m := 0.0
	for x in range(rect.position.x, rect.end.x):
		for y in [rect.position.y, rect.end.y - 1]:
			var c := img.get_pixel(x, y)
			m = maxf(m, maxf(c.r, maxf(c.g, c.b)))
	for y in range(rect.position.y, rect.end.y):
		for x in [rect.position.x, rect.end.x - 1]:
			var c := img.get_pixel(x, y)
			m = maxf(m, maxf(c.r, maxf(c.g, c.b)))
	return m
func _bbox(img: Image, rect: Rect2i) -> Rect2i:
	var minx := 99999
	var miny := 99999
	var maxx := -1
	var maxy := -1
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var c := img.get_pixel(x, y)
			if maxf(c.r, maxf(c.g, c.b)) > 0.06:
				minx = mini(minx, x)
				miny = mini(miny, y)
				maxx = maxi(maxx, x)
				maxy = maxi(maxy, y)
	return Rect2i(minx - rect.position.x, miny - rect.position.y, maxx - minx + 1, maxy - miny + 1)
func _init() -> void:
	var base := "assets_incoming/queue-20261104-r1/sources/"
	var jobs: Array = []
	# projétil: 4 voos (âncora comum) + 4 impactos (núcleo), células de 384x512 numa fonte de 1536x1024
	var img := Image.load_from_file(ProjectSettings.globalize_path("res://" + base + "memoria_projetil_v01.png"))
	img.convert(Image.FORMAT_RGBA8)
	var regions: Array = []
	var mean := Vector2.ZERO
	for c in 4:
		mean += _centroid(img, Rect2i(c * 384, 0, 384, 512), 2.0)
		print("PROJ voo %d caixa %s luz-na-borda %.2f" % [c, str(_bbox(img, Rect2i(c * 384, 0, 384, 512))), _edge_light(img, Rect2i(c * 384, 0, 384, 512))])
	mean /= 4.0
	for c in 4:
		regions.append([c * 384, 0, 384, 512, roundi(mean.x), roundi(mean.y)])
	for c in 4:
		var a := _centroid(img, Rect2i(c * 384, 512, 384, 512), 6.0)
		regions.append([c * 384, 512, 384, 512, roundi(a.x), roundi(a.y)])
		print("PROJ impacto %d caixa %s âncora (%.0f,%.0f) luz-na-borda %.2f" % [c, str(_bbox(img, Rect2i(c * 384, 512, 384, 512))), a.x, a.y, _edge_light(img, Rect2i(c * 384, 512, 384, 512))])
	jobs.append({"id": "orbe_memoria", "key": "black", "mode": "vfx_atlas", "regions": regions, "src": base + "memoria_projetil_v01.png", "scale": 1, "anchor": [128, 128], "out": "tmp/evo_vfx/out/orbe_memoria.png"})
	# habilidade: 6 quadros de 362x724 lado a lado (círculo visto de cima centrado em cada célula)
	var hab := Image.load_from_file(ProjectSettings.globalize_path("res://" + base + "memoria_habilidade_v01.png"))
	hab.convert(Image.FORMAT_RGBA8)
	var hr: Array = []
	var seps := [0, 327, 688, 1074, 1465, 1818, 2172]   # vales de luz medidos entre os 6 quadros (as células não têm largura uniforme)
	for i in 6:
		var rect := Rect2i(seps[i], 0, seps[i + 1] - seps[i], 724)
		var bb := _bbox(hab, rect)
		var cx := bb.position.x + bb.size.x * 0.5
		var cy := bb.position.y + bb.size.y * 0.5
		print("HAB q%d segmento %d..%d caixa %s centro (%.0f,%.0f) luz-na-borda %.2f" % [i + 1, seps[i], seps[i + 1], str(bb), cx, cy, _edge_light(hab, rect)])
		hr.append([seps[i], 0, seps[i + 1] - seps[i], 724, roundi(cx), roundi(cy)])
	jobs.append({"id": "habilidade_arlindo", "key": "black", "mode": "vfx_atlas", "regions": hr, "src": base + "memoria_habilidade_v01.png", "scale": 1, "anchor": [128, 128], "out": "tmp/evo_vfx/out/habilidade_arlindo.png"})
	var f := FileAccess.open(ProjectSettings.globalize_path("res://tmp/evo_vfx/jobs_arlindo.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(jobs, "", false))
	f.close()
	quit()
