extends SceneTree
## Gera os jobs de asset_prep (modo vfx_atlas) para os 7 VFX de evolução, com âncoras medidas nas fontes.
func _centroid(img: Image, rect: Rect2i, power: float) -> Vector2:
	var sx := 0.0; var sy := 0.0; var sw := 0.0
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var c := img.get_pixel(x, y)
			var l := maxf(c.r, maxf(c.g, c.b))
			if l > 0.06:
				var w := pow(l, power)
				sx += x * w; sy += y * w; sw += w
	return Vector2(sx / sw - rect.position.x, sy / sw - rect.position.y)
func _init() -> void:
	var base := "assets_incoming/vfx-evolucoes-20261104-r1/sources/"
	var jobs: Array = []
	# projéteis: 4 voos (âncora comum = média dos centros de luz) + 4 impactos (âncora = núcleo mais brilhante de cada quadro)
	var proj := {"VE01": ["VE01_selo_da_retidao_v01.png", "selo_retidao_evo"], "VE02": ["VE02_cajado_dos_desejos_realizados_v01.png", "cajado_realizado_evo"],
		"VE03": ["VE03_lamina_do_eclipse_v01.png", "eclipse_evo"], "VE04": ["VE04_memoria_reescrita_v01.png", "memoria_reescrita_evo"]}
	for id in proj:
		var img := Image.load_from_file(ProjectSettings.globalize_path("res://" + base + proj[id][0]))
		img.convert(Image.FORMAT_RGBA8)
		var regions: Array = []
		var mean := Vector2.ZERO
		for c in 4:
			mean += _centroid(img, Rect2i(c * 384, 0, 384, 512), 2.0)
		mean /= 4.0
		for c in 4:
			regions.append([c * 384, 0, 384, 512, roundi(mean.x), roundi(mean.y)])
		for c in 4:
			var a := _centroid(img, Rect2i(c * 384, 512, 384, 512), 6.0)
			regions.append([c * 384, 512, 384, 512, roundi(a.x), roundi(a.y)])
		jobs.append({"id": id, "key": "black", "mode": "vfx_atlas", "regions": regions, "src": base + proj[id][0], "scale": 1, "anchor": [128, 128], "out": "tmp/evo_vfx/out/%s.png" % proj[id][1]})
	# pulsos e zona: 6 quadros em 3×2 de 512; os anéis são centrados na célula, a zona ancora o centro do anel de chão
	var areas := {"VE05": ["VE05_vigilia_perpetua_v01.png", "pulso_vigilia", [256, 256], [128, 128]], "VE07": ["VE07_ampulheta_do_tempo_parado_v01.png", "pulso_ampulheta_tempo", [256, 256], [128, 128]],
		"VE06": ["VE06_abraco_dos_tentaculos_v01.png", "abraco_laco", [252, 335], [128, 150]]}
	for id in areas:
		var regions: Array = []
		for r in 2:
			for c in 3:
				regions.append([c * 512, r * 512, 512, 512, areas[id][2][0], areas[id][2][1]])
		jobs.append({"id": id, "key": "black", "mode": "vfx_atlas", "regions": regions, "src": base + areas[id][0], "scale": 1, "anchor": areas[id][3], "out": "tmp/evo_vfx/out/%s.png" % areas[id][1]})
	var f := FileAccess.open(ProjectSettings.globalize_path("res://tmp/evo_vfx/jobs.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(jobs, "", false))
	f.close()
	print("jobs ok: ", jobs.size())
	quit()
