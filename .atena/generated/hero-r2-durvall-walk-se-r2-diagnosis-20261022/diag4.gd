extends SceneTree
## Geometria dos pés por quadro: vão entre os pés (largura da faixa de baixo), altura relativa do pé mais baixo de cada lado e deslocamento do pé levantado.
## Somente leitura. Régua: tiras piloto do Durvall (assets/animations/heroes/durvall/move_se.png e move_e.png, 6 quadros de 512x512).
const ROOT := "F:/dev/abyss-megadungeon/"
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/v2out/feet_geometry.json"

func _init() -> void:
	var res := {}
	for name in ["move_se", "move_e", "move_ne", "move_s"]:
		var img := Image.load_from_file(ROOT + "assets/animations/heroes/durvall/" + name + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var frames := []
		for k in int(img.get_width() / 512):
			frames.append(_geom(img, Rect2i(k * 512, 0, 512, 512), false))
		res["piloto_" + name] = frames
	for v in ["v01", "v02", "v03"]:
		var img := Image.load_from_file(ROOT + "assets_incoming/hero-r2/durvall/durvall_walk_se_r2_" + v + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var frames := []
		for q in [Rect2i(0, 0, 768, 512), Rect2i(768, 0, 768, 512), Rect2i(0, 512, 768, 512), Rect2i(768, 512, 768, 512)]:
			frames.append(_geom(img, q, true))
		res["r2_" + v] = frames
	for v in ["v01", "v02"]:
		var img := Image.load_from_file(ROOT + "assets_incoming/hero-r2/durvall/durvall_walk_se_" + v + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var frames := []
		for k in 3:
			frames.append(_geom(img, Rect2i(k * 512, 0, 512, 1024), true))
		res["r1_" + v] = frames
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "  "))
	f.close()
	for k in res:
		var line := []
		for fr in res[k]:
			line.append("h=%d vão=%d(%.2f) esq_y=%.2f dir_y=%.2f" % [fr.h, fr.span, fr.span_rel, fr.left_low, fr.right_low])
		print(k, "\n  ", "\n  ".join(line))
	quit()

func _opaque(c: Color, keyed: bool) -> bool:
	if not keyed:
		return c.a > 0.06
	var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
	return d > 0.22 * 1.6

func _geom(img: Image, r: Rect2i, keyed: bool) -> Dictionary:
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in range(r.position.y, r.position.y + r.size.y):
		for x in range(r.position.x, r.position.x + r.size.x):
			if _opaque(img.get_pixel(x, y), keyed):
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	var h := maxy - miny + 1
	var y0 := maxy - int(h * 0.25)
	var lminx := 99999; var lmaxx := -1
	for y in range(y0, maxy + 1):
		for x in range(r.position.x, r.position.x + r.size.x):
			if _opaque(img.get_pixel(x, y), keyed):
				lminx = mini(lminx, x); lmaxx = maxi(lmaxx, x)
	var mid := (lminx + lmaxx) / 2
	var ll := 0  # pé mais baixo do lado esquerdo da faixa, medido a partir do topo da faixa
	var rl := 0
	for y in range(y0, maxy + 1):
		for x in range(lminx, lmaxx + 1):
			if _opaque(img.get_pixel(x, y), keyed):
				if x < mid:
					ll = maxi(ll, y - y0)
				else:
					rl = maxi(rl, y - y0)
	var band := float(maxy - y0 + 1)
	return {"h": h, "span": lmaxx - lminx + 1, "span_rel": snappedf(float(lmaxx - lminx + 1) / float(h), 0.01), "left_low": snappedf(float(ll) / band, 0.01), "right_low": snappedf(float(rl) / band, 0.01)}
