extends SceneTree
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/derived/"
func crop_fig(img: Image, k: int) -> Image:
	var w := img.get_width(); var h := img.get_height()
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in h:
		for x in range(k * w / 3, (k + 1) * w / 3):
			if img.get_pixel(x, y).a > 0.5:
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	return img.get_region(Rect2i(minx, miny, maxx - minx + 1, maxy - miny + 1))
func scaled(im: Image, h: int) -> Image:
	var c: Image = im.duplicate()
	c.resize(int(round(c.get_width() * float(h) / c.get_height())), h, Image.INTERPOLATE_LANCZOS)
	return c
func panel(fig: Image, bg: Color, w: int, h: int, zoom: int) -> Image:
	var p := Image.create(w, h, false, Image.FORMAT_RGBA8)
	p.fill(bg)
	var f: Image = fig.duplicate()
	if zoom > 1:
		f.resize(f.get_width() * zoom, f.get_height() * zoom, Image.INTERPOLATE_NEAREST)
	p.blend_rect(f, Rect2i(0, 0, f.get_width(), f.get_height()), Vector2i((w - f.get_width()) / 2, h - f.get_height() - 10))
	return p
func _init() -> void:
	var panels := []
	for v in ["v01", "v02"]:
		var k := Image.load_from_file(OUT + "KEYED_durvall_walk_se_" + v + ".png")
		var fig := crop_fig(k, 1)
		panels.append(panel(scaled(fig, 400), Color(0.35, 0.35, 0.4), 330, 420, 1))
		panels.append(panel(scaled(fig, 64), Color(0.35, 0.35, 0.4), 330, 420, 6))
		panels.append(panel(scaled(fig, 64), Color(0.78, 0.78, 0.75), 330, 420, 6))
	var out := Image.create(330 * 6, 420, false, Image.FORMAT_RGBA8)
	for i in panels.size():
		out.blit_rect(panels[i], Rect2i(0, 0, 330, 420), Vector2i(i * 330, 0))
	out.save_png(OUT + "HALO_escala_jogo_v01_v02.png")
	quit()
