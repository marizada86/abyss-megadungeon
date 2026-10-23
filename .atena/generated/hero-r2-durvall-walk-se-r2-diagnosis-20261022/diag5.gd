extends SceneTree
## Pés apoiados na faixa mais baixa de cada figura (a espada não chega ali): quantos blobs e onde (x relativo ao centro da figura / altura).
const ROOT := "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/"
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/v2out/planted_feet.json"
const BAND := 0.06
const GAP := 18

func opaque(c: Color) -> bool:
	var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
	return d > 0.22 * 1.6

func analyze(img: Image, r: Rect2i) -> Dictionary:
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in range(r.position.y, r.position.y + r.size.y):
		for x in range(r.position.x, r.position.x + r.size.x):
			if opaque(img.get_pixel(x, y)):
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	var h := maxy - miny + 1
	var y0 := maxy - int(h * BAND)
	var cols := []
	for x in range(r.position.x, r.position.x + r.size.x):
		var any := false
		for y in range(y0, maxy + 1):
			if opaque(img.get_pixel(x, y)):
				any = true
				break
		if any:
			cols.append(x)
	var blobs := []
	var start := -1
	var prev := -1
	for x in cols:
		if start < 0:
			start = x
		elif x - prev > GAP:
			blobs.append([start, prev])
			start = x
		prev = x
	if start >= 0:
		blobs.append([start, prev])
	var cx := (minx + maxx) / 2
	var out := []
	for b in blobs:
		if b[1] - b[0] >= 12:
			out.append(snappedf(float((b[0] + b[1]) / 2 - cx) / float(h), 0.01))
	return {"h": h, "pes_apoiados": out.size(), "x_rel": out}

func _init() -> void:
	var res := {}
	for v in ["v01", "v02", "v03"]:
		var img := Image.load_from_file(ROOT + "durvall_walk_se_r2_" + v + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var f := []
		for q in [Rect2i(0, 0, 768, 512), Rect2i(768, 0, 768, 512), Rect2i(0, 512, 768, 512), Rect2i(768, 512, 768, 512)]:
			f.append(analyze(img, q))
		res["r2_" + v] = f
	for v in ["v01", "v02"]:
		var img := Image.load_from_file(ROOT + "durvall_walk_se_" + v + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var f := []
		for k in 3:
			f.append(analyze(img, Rect2i(k * 512, 0, 512, 1024)))
		res["r1_" + v] = f
	var fa := FileAccess.open(OUT, FileAccess.WRITE)
	fa.store_string(JSON.stringify(res, "  "))
	fa.close()
	for k in res:
		var line := []
		for fr in res[k]:
			line.append("%d pé(s) %s" % [fr.pes_apoiados, str(fr.x_rel)])
		print(k, ":  ", "  |  ".join(line))
	quit()
