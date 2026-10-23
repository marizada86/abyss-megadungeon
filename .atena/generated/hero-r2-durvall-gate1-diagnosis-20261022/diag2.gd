extends SceneTree
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/derived/"
func bbox(img: Image, k: int) -> Rect2i:
	var w := img.get_width(); var h := img.get_height()
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in h:
		for x in range(k * w / 3, (k + 1) * w / 3):
			if img.get_pixel(x, y).a > 0.5:
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	return Rect2i(minx, miny, maxx - minx + 1, maxy - miny + 1)
func region_diff(img: Image, a: int, b: int, y0: float, y1: float) -> float:
	var ra := bbox(img, a); var rb := bbox(img, b)
	var hh := mini(ra.size.y, rb.size.y); var ww := mini(ra.size.x, rb.size.x)
	var sum := 0.0; var cnt := 0
	for y in range(int(hh * y0), int(hh * y1)):
		for x in ww:
			var ca := img.get_pixel(ra.position.x + ra.size.x / 2 - ww / 2 + x, ra.position.y + ra.size.y - hh + y)
			var cb := img.get_pixel(rb.position.x + rb.size.x / 2 - ww / 2 + x, rb.position.y + rb.size.y - hh + y)
			if ca.a > 0.5 and cb.a > 0.5:
				sum += (absf(ca.r - cb.r) + absf(ca.g - cb.g) + absf(ca.b - cb.b)) / 3.0; cnt += 1
	return snappedf(255.0 * sum / maxf(cnt, 1.0), 0.1)
func _init() -> void:
	for v in ["v01", "v02"]:
		var w := Image.load_from_file(OUT + "KEYED_durvall_walk_se_" + v + ".png")
		var i := Image.load_from_file(OUT + "KEYED_durvall_idle_se_" + v + ".png")
		var o := {}
		for reg in [["pernas (60-100% da altura)", 0.6, 1.0], ["tronco e braços (25-60%)", 0.25, 0.6], ["cabeça (0-25%)", 0.0, 0.25]]:
			o[reg[0]] = {"walk A x B": region_diff(w, 0, 2, reg[1], reg[2]), "walk A x P": region_diff(w, 0, 1, reg[1], reg[2]), "idle 1 x 3 (mesma pose)": region_diff(i, 0, 2, reg[1], reg[2])}
		print(v, " ", JSON.stringify(o))
	quit()
