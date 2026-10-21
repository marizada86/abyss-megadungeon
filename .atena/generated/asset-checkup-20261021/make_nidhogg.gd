extends SceneTree
const SRC := "F:/dev/nottgard-vault/output/referencias-personagens/CNCR-r02/nidhogg/nidhogg-head-neck-hq-r03-v01.png"
func _init() -> void:
	var out_dir := OS.get_environment("SINT_OUT")
	var img := Image.load_from_file(SRC)
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	print("size ", w, "x", h, " corners ", img.get_pixel(3, 3), img.get_pixel(w - 4, h - 4), img.get_pixel(w - 4, 3))
	var bg := (img.get_pixel(3, 3) + img.get_pixel(w - 4, 3) + img.get_pixel(w - 4, h - 4) + img.get_pixel(3, h - 4)) / 4.0
	var tol := 0.07
	var mask := PackedByteArray()
	mask.resize(w * h)
	var stack: Array[int] = []
	for x in range(w):
		stack.append(x); stack.append((h - 1) * w + x)
	for y in range(h):
		stack.append(y * w); stack.append(y * w + w - 1)
	while not stack.is_empty():
		var i: int = stack.pop_back()
		if mask[i] == 1:
			continue
		var px := i % w
		var py := i / w
		var c := img.get_pixel(px, py)
		if maxf(maxf(absf(c.r - bg.r), absf(c.g - bg.g)), absf(c.b - bg.b)) > tol:
			continue
		mask[i] = 1
		if px > 0: stack.append(i - 1)
		if px < w - 1: stack.append(i + 1)
		if py > 0: stack.append(i - w)
		if py < h - 1: stack.append(i + w)
	for yy in range(h):
		for xx in range(w):
			if mask[yy * w + xx] == 1:
				continue
			var cc := img.get_pixel(xx, yy)
			var sat := maxf(maxf(cc.r, cc.g), cc.b) - minf(minf(cc.r, cc.g), cc.b)
			if maxf(maxf(absf(cc.r - bg.r), absf(cc.g - bg.g)), absf(cc.b - bg.b)) < 0.05 and sat < 0.04:
				mask[yy * w + xx] = 1
	var fig := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in range(h):
		for x in range(w):
			if mask[y * w + x] == 1:
				continue
			var near := 0
			for oy in range(-1, 2):
				for ox in range(-1, 2):
					var xx := x + ox
					var yy := y + oy
					if xx >= 0 and yy >= 0 and xx < w and yy < h and mask[yy * w + xx] == 1:
						near += 1
			var c2 := img.get_pixel(x, y)
			c2.a = 1.0 if near == 0 else clampf(1.0 - float(near) / 6.0, 0.2, 1.0)
			fig.set_pixel(x, y, c2)
	var used := fig.get_used_rect()
	fig = fig.get_region(used)
	var box := Vector2i(300, 456)
	var s := minf(float(box.x) / fig.get_width(), float(box.y) / fig.get_height())
	fig.resize(int(round(fig.get_width() * s)), int(round(fig.get_height() * s)), Image.INTERPOLATE_LANCZOS)
	var out := Image.create(320, 480, false, Image.FORMAT_RGBA8)
	out.blit_rect(fig, Rect2i(0, 0, fig.get_width(), fig.get_height()), Vector2i((320 - fig.get_width()) / 2, 472 - fig.get_height()))
	out.save_png(out_dir + "/nidhogg.png")
	print("ok ", fig.get_size())
	quit()
