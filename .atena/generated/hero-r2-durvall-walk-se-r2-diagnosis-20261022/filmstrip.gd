extends SceneTree
## Derivados de análise (somente leitura das fontes): tira dos quadros na ordem do ciclo + guia de pose de exemplo.
const ROOT := "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/"
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/derived/"
const TH := 300

func opaque(c: Color) -> bool:
	var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
	return d > 0.22 * 1.6

func crop_fig(img: Image, r: Rect2i) -> Image:
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in range(r.position.y, r.position.y + r.size.y):
		for x in range(r.position.x, r.position.x + r.size.x):
			if opaque(img.get_pixel(x, y)):
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	var out := Image.create(maxx - minx + 1, maxy - miny + 1, false, Image.FORMAT_RGBA8)
	for y in range(miny, maxy + 1):
		for x in range(minx, maxx + 1):
			var c := img.get_pixel(x, y)
			if opaque(c):
				out.set_pixel(x - minx, y - miny, Color(c.r, c.g, c.b, 1))
	return out

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	var rows := []
	var quads := [Rect2i(0, 0, 768, 512), Rect2i(768, 0, 768, 512), Rect2i(0, 512, 768, 512), Rect2i(768, 512, 768, 512)]
	for v in ["v01", "v02", "v03"]:
		var img := Image.load_from_file(ROOT + "durvall_walk_se_r2_" + v + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var cells := []
		for q in quads:
			var f := crop_fig(img, q)
			f.resize(int(round(f.get_width() * float(TH) / f.get_height())), TH, Image.INTERPOLATE_LANCZOS)
			cells.append(f)
		rows.append(cells)
	var cw := 360
	var strip := Image.create(cw * 4, (TH + 40) * 3, false, Image.FORMAT_RGBA8)
	strip.fill(Color(0.4, 0.4, 0.44, 1))
	for r in rows.size():
		for c in 4:
			var f: Image = rows[r][c]
			var ox: int = c * cw + (cw - f.get_width()) / 2
			var oy: int = r * (TH + 40) + 20
			strip.fill_rect(Rect2i(c * cw, oy + TH, cw, 1), Color(1, 0.9, 0.1, 0.8))
			strip.blend_rect(f, Rect2i(0, 0, f.get_width(), f.get_height()), Vector2i(ox, oy))
	strip.save_png(OUT + "TIRA_ciclo_A_P1_B_P2_r2_v01_v02_v03.png")
	# guia de pose de exemplo: A, P1, P2 (3/4, andando para a direita da tela); vermelho = perna do lado direito da tela, azul = lado esquerdo
	var g := Image.create(1536, 512, false, Image.FORMAT_RGBA8)
	g.fill(Color(0.75, 0.75, 0.75, 1))
	var poses := [
		{"hip": Vector2(256, 270), "r": [Vector2(300, 370), Vector2(330, 470)], "b": [Vector2(215, 380), Vector2(190, 470)], "head": Vector2(262, 110)},
		{"hip": Vector2(768, 250), "r": [Vector2(772, 360), Vector2(768, 470)], "b": [Vector2(790, 330), Vector2(758, 385)], "head": Vector2(772, 90)},
		{"hip": Vector2(1280, 250), "r": [Vector2(1305, 330), Vector2(1272, 385)], "b": [Vector2(1276, 360), Vector2(1280, 470)], "head": Vector2(1284, 90)},
	]
	for p in poses:
		var hip: Vector2 = p.hip
		line(g, p.head + Vector2(0, 30), hip, 14, Color(0.2, 0.2, 0.2, 1))
		disc(g, p.head, 26, Color(0.2, 0.2, 0.2, 1))
		line(g, hip, p.r[0], 16, Color(0.9, 0.1, 0.1, 1))
		line(g, p.r[0], p.r[1], 16, Color(0.9, 0.1, 0.1, 1))
		line(g, hip, p.b[0], 16, Color(0.1, 0.2, 0.9, 1))
		line(g, p.b[0], p.b[1], 16, Color(0.1, 0.2, 0.9, 1))
		g.fill_rect(Rect2i(int(p.hip.x) - 240, 470, 480, 2), Color(0.2, 0.6, 0.2, 1))
	g.save_png(OUT + "GUIA_DE_POSE_exemplo_A_P1_P2.png")
	quit()

func disc(img: Image, c: Vector2, r: int, col: Color) -> void:
	for y in range(int(c.y) - r, int(c.y) + r + 1):
		for x in range(int(c.x) - r, int(c.x) + r + 1):
			if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height() and Vector2(x, y).distance_to(c) <= r:
				img.set_pixel(x, y, col)

func line(img: Image, a: Vector2, b: Vector2, w: int, col: Color) -> void:
	var n := int(a.distance_to(b))
	for i in range(n + 1):
		disc(img, a.lerp(b, float(i) / maxf(n, 1)), w / 2, col)
