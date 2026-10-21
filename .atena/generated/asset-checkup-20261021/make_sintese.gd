extends SceneTree
## Deriva sprites da Síntese Abissal a partir da referência CANON roxa (DEC-SINTESE-PURPLE-20261019-r1).
const SRC := "F:/dev/nottgard-vault/output/referencias-personagens/SINTESE-ABISSAL/roxo-r01/sintese-front-v01.png"

func _init() -> void:
	var out_dir := OS.get_environment("SINT_OUT")
	var img := Image.load_from_file(SRC)
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var corners := [img.get_pixel(2, 2), img.get_pixel(w - 3, 2), img.get_pixel(2, h - 3), img.get_pixel(w - 3, h - 3), img.get_pixel(w / 2, 2)]
	print("corners: ", corners)
	var bg := Color(0, 0, 0)
	for c in corners:
		bg += c
	bg = bg / float(corners.size())
	print("bg=", bg)
	var tol := 0.10
	var bgrow: Array[Color] = []
	for yy in range(h):
		bgrow.append((img.get_pixel(2, yy) + img.get_pixel(w - 3, yy)) / 2.0)
	var mask := PackedByteArray()
	mask.resize(w * h)  # 1 = fundo
	var stack: Array[int] = []
	for x in range(w):
		stack.append(x)
		stack.append((h - 1) * w + x)
	for y in range(h):
		stack.append(y * w)
		stack.append(y * w + w - 1)
	while not stack.is_empty():
		var i: int = stack.pop_back()
		if mask[i] == 1:
			continue
		var px := i % w
		var py := i / w
		var c := img.get_pixel(px, py)
		var b2: Color = bgrow[py]
		var d := maxf(maxf(absf(c.r - b2.r), absf(c.g - b2.g)), absf(c.b - b2.b))
		if d > tol:
			continue
		mask[i] = 1
		if px > 0: stack.append(i - 1)
		if px < w - 1: stack.append(i + 1)
		if py > 0: stack.append(i - w)
		if py < h - 1: stack.append(i + w)
	# bolsões de fundo fechados (entre tentáculos): cinza claro e dessaturado
	for yy in range(h):
		for xx in range(w):
			if mask[yy * w + xx] == 1:
				continue
			var cc := img.get_pixel(xx, yy)
			var b3: Color = bgrow[yy]
			var dd := maxf(maxf(absf(cc.r - b3.r), absf(cc.g - b3.g)), absf(cc.b - b3.b))
			var sat := maxf(maxf(cc.r, cc.g), cc.b) - minf(minf(cc.r, cc.g), cc.b)
			if dd < 0.13 and sat < 0.05:
				mask[yy * w + xx] = 1
	# alfa: fundo = 0; borda de 2 px suavizada
	var fig := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in range(h):
		for x in range(w):
			if mask[y * w + x] == 1:
				continue
			var near := 0
			for oy in range(-2, 3):
				for ox in range(-2, 3):
					var xx := x + ox
					var yy := y + oy
					if xx < 0 or yy < 0 or xx >= w or yy >= h:
						continue
					if mask[yy * w + xx] == 1:
						near += 1
			var c2 := img.get_pixel(x, y)
			c2.a = 1.0 if near == 0 else clampf(1.0 - float(near) / 12.0, 0.15, 1.0)
			fig.set_pixel(x, y, c2)
	var used := fig.get_used_rect()
	print("used rect: ", used)
	fig = fig.get_region(used)
	fig.save_png(out_dir + "/figure_full.png")
	# estático 320x480
	_fit(fig, Vector2i(320, 480), Vector2i(300, 456), 472).save_png(out_dir + "/static.png")
	# animações
	var base := _fit_figure(fig, 206)  # altura 206 px (x2 depois)
	var sheets := {
		"idle": _idle(), "move": _move(), "attack": _attack(), "death": _death(), "special": _special(),
	}
	for name in sheets:
		var frames: Array = sheets[name]
		var sheet := Image.create(256 * frames.size(), 384, false, Image.FORMAT_RGBA8)
		for k in range(frames.size()):
			sheet.blit_rect(_render(base, frames[k]), Rect2i(0, 0, 256, 384), Vector2i(256 * k, 0))
		sheet.save_png("%s/%s.png" % [out_dir, name])
	print("ok")
	quit()

func _fit_figure(fig: Image, target_h: int) -> Image:
	var f := fig.duplicate()
	var s := float(target_h * 2) / float(f.get_height())
	var nw := int(round(f.get_width() * s))
	if nw > 440:
		s = 440.0 / float(f.get_width())
		nw = 440
	f.resize(nw, int(round(f.get_height() * s)), Image.INTERPOLATE_LANCZOS)
	return f

func _fit(fig: Image, size: Vector2i, box: Vector2i, bottom: int) -> Image:
	var f := fig.duplicate()
	var s := minf(float(box.x) / f.get_width(), float(box.y) / f.get_height())
	f.resize(int(round(f.get_width() * s)), int(round(f.get_height() * s)), Image.INTERPOLATE_LANCZOS)
	var out := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	out.blit_rect(f, Rect2i(0, 0, f.get_width(), f.get_height()), Vector2i((size.x - f.get_width()) / 2, bottom - f.get_height()))
	return out

# p: dx, dy, sx, sy, rot(graus), alpha, tint(0..1)
func _render(base: Image, p: Dictionary) -> Image:
	var W := 512
	var H := 768
	var canvas := Image.create(W, H, false, Image.FORMAT_RGBA8)
	var bw := base.get_width()
	var bh := base.get_height()
	var pivot := Vector2(W / 2.0, 344.0 * 2.0)  # pés
	var pos := pivot + Vector2(p.get("dx", 0.0), p.get("dy", 0.0)) * 2.0
	var sx: float = p.get("sx", 1.0)
	var sy: float = p.get("sy", 1.0)
	var rot := deg_to_rad(p.get("rot", 0.0))
	var alpha: float = p.get("alpha", 1.0)
	var tint: float = p.get("tint", 0.0)
	var cs := cos(rot)
	var sn := sin(rot)
	var tcol := Color(0.75, 0.35, 1.0)
	# caixa de varredura
	var R := 480
	for y in range(maxi(0, int(pos.y) - R), mini(H, int(pos.y) + 240)):
		for x in range(maxi(0, int(pos.x) - R), mini(W, int(pos.x) + R)):
			var d := Vector2(x, y) - pos
			# inverso da rotação
			var u := d.x * cs + d.y * sn
			var v := -d.x * sn + d.y * cs
			u /= sx
			v /= sy
			var ix := int(round(u + bw / 2.0))
			var iy := int(round(v + bh))
			if ix < 0 or iy < 0 or ix >= bw or iy >= bh:
				continue
			var c := base.get_pixel(ix, iy)
			if c.a <= 0.0:
				continue
			if tint > 0.0:
				c = c.lerp(Color(tcol.r, tcol.g, tcol.b, c.a), tint * 0.3)
			c.a *= alpha
			canvas.set_pixel(x, y, c)
	canvas.resize(256, 384, Image.INTERPOLATE_LANCZOS)
	return canvas

func _idle() -> Array:
	var a := []
	for k in range(4):
		var t := TAU * k / 4.0
		a.append({"dy": -3.0 * sin(t), "sy": 1.0 + 0.012 * sin(t), "sx": 1.0 - 0.006 * sin(t)})
	return a

func _move() -> Array:
	var a := []
	for k in range(6):
		var t := TAU * k / 6.0
		a.append({"dy": -5.0 * absf(sin(t)), "rot": 2.5 * sin(t), "dx": 2.0 * sin(t)})
	return a

func _attack() -> Array:
	return [
		{"dx": -6.0, "rot": -4.0, "sy": 0.97},
		{"dx": 10.0, "rot": 3.0, "sx": 1.04, "sy": 1.03, "dy": -4.0},
		{"dx": 24.0, "rot": 6.0, "sx": 1.06, "sy": 1.0, "tint": 0.5},
		{"dx": 8.0, "rot": 1.0},
	]

func _death() -> Array:
	var a := []
	var rots := [0.0, 6.0, 20.0, 45.0, 70.0, 86.0]
	for k in range(6):
		var r: float = rots[k]
		var sr := sin(deg_to_rad(r))
		a.append({"rot": r, "dx": -103.0 * sr, "dy": -46.0 * sr, "tint": 0.2 + 0.2 * sr, "sy": 1.0 - 0.08 * sr, "alpha": 1.0 - 0.12 * sr})
	return a

func _special() -> Array:
	var a := []
	var s := [0.0, 0.3, 0.7, 1.0, 0.6, 0.2]
	for k in range(6):
		a.append({"sx": 1.0 + 0.06 * s[k], "sy": 1.0 + 0.06 * s[k], "tint": s[k], "dy": -4.0 * s[k]})
	return a
