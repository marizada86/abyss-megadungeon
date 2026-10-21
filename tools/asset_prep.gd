extends SceneTree
## Preparação de fontes geradas (ChatGPT/ImageGen) para o runtime: tira o fundo (magenta, cinza ou preto), recorta,
## separa folhas em peças e redimensiona. Não instala nada, não toca em assets/ sem o job pedir.
## Uso: godot --headless --path . -s tools/asset_prep.gd -- <job.json>
## Job (JSON): lista de passos {"src","out","key":"magenta|gray|black|none","tol","crop":true,"size":[w,h],"fit":[w,h],
##   "pad":n,"split":"components|grid","cols":n,"rows":n,"out_dir","name","min_area","gap","sort":"row|col","trim":n}
## Todos os caminhos são relativos à raiz do projeto (res://). Cada passo imprime o que gravou.

const MAGENTA := Color(1, 0, 1)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("uso: -- <job.json>")
		quit(1)
		return
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	for job in jobs:
		_run(job)
	quit()

func _load(path: String) -> Image:
	var img := Image.load_from_file(ProjectSettings.globalize_path("res://" + path))
	if img == null:
		printerr("não abriu ", path)
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img

func _save(img: Image, path: String) -> void:
	var full := ProjectSettings.globalize_path("res://" + path)
	DirAccess.make_dir_recursive_absolute(full.get_base_dir())
	img.save_png(full)
	print("gravou ", path, " ", img.get_size())

func _run(job: Dictionary) -> void:
	if job.get("mode", "") == "nine_compose":
		_nine_compose(job)
		return
	if job.get("mode", "") == "sprite":
		_sprite_sheets(job)
		return
	var img := _load(String(job.src))
	if img == null:
		return
	var key := String(job.get("key", "none"))
	match key:
		"magenta": _key_magenta(img, float(job.get("tol", 0.22)))
		"gray": _key_flood(img, float(job.get("tol", 0.08)), float(job.get("sat", 0.06)))
		"black": _key_black(img, float(job.get("tol", 0.1)))
	if job.get("split", "") == "components":
		_split_components(img, job)
		return
	if job.get("split", "") == "grid":
		_split_grid(img, job)
		return
	img = _finish(img, job)
	_save(img, String(job.out))

## Recorta, margens e tamanho final de uma imagem já sem fundo.
func _finish(img: Image, job: Dictionary) -> Image:
	if bool(job.get("crop", true)) and String(job.get("key", "none")) != "none":
		var used := img.get_used_rect()
		if used.size.x > 0 and used.size.y > 0:
			img = img.get_region(used)
	var trim := int(job.get("trim", 0))
	if trim > 0 and img.get_width() > trim * 2 and img.get_height() > trim * 2:
		img = img.get_region(Rect2i(trim, trim, img.get_width() - trim * 2, img.get_height() - trim * 2))
	if job.has("size"):
		img.resize(int(job.size[0]), int(job.size[1]), Image.INTERPOLATE_LANCZOS)
	elif job.has("scale_w") or job.has("scale_h"):
		var sc := float(job.scale_w) / img.get_width() if job.has("scale_w") else float(job.scale_h) / img.get_height()
		img.resize(maxi(1, int(round(img.get_width() * sc))), maxi(1, int(round(img.get_height() * sc))), Image.INTERPOLATE_LANCZOS)
	elif job.has("fit"):
		var box := Vector2(float(job.fit[0]), float(job.fit[1]))
		var pad := float(job.get("pad", 0))
		var s := minf((box.x - pad * 2.0) / img.get_width(), (box.y - pad * 2.0) / img.get_height())
		img.resize(maxi(1, int(round(img.get_width() * s))), maxi(1, int(round(img.get_height() * s))), Image.INTERPOLATE_LANCZOS)
		var canvas := Image.create(int(box.x), int(box.y), false, Image.FORMAT_RGBA8)
		var at := Vector2i((int(box.x) - img.get_width()) / 2, int(box.y) - img.get_height() - int(pad) if job.get("anchor", "center") == "bottom" else (int(box.y) - img.get_height()) / 2)
		canvas.blend_rect(img, Rect2i(0, 0, img.get_width(), img.get_height()), at)
		img = canvas
	return img

# ------------------------------------------------------------------ fundos
func _key_magenta(img: Image, tol: float) -> void:
	var w := img.get_width()
	var h := img.get_height()
	for y in h:
		for x in w:
			var c := img.get_pixel(x, y)
			# distância ao magenta puro: verde baixo e vermelho/azul altos
			var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
			if d < tol:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			elif d < tol * 2.2:
				# borda suavizada: alfa proporcional e remoção do rosa que sobra
				var a := clampf((d - tol) / (tol * 1.2), 0.0, 1.0)
				var despill := Color(minf(c.r, c.g + 0.25), c.g, minf(c.b, c.g + 0.25), a)
				img.set_pixel(x, y, despill)

func _key_black(img: Image, tol: float) -> void:
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			var l := maxf(maxf(c.r, c.g), c.b)
			if l < tol:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			else:
				# preto aditivo: o brilho vira alfa, a cor se mantém
				var a := clampf(l * 1.15, 0.0, 1.0)
				img.set_pixel(x, y, Color(c.r / maxf(l, 0.001), c.g / maxf(l, 0.001), c.b / maxf(l, 0.001), a))

func _key_flood(img: Image, tol: float, sat_max: float) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var bg := (img.get_pixel(3, 3) + img.get_pixel(w - 4, 3) + img.get_pixel(3, h - 4) + img.get_pixel(w - 4, h - 4)) / 4.0
	var mask := PackedByteArray()
	mask.resize(w * h)
	var stack: Array[int] = []
	for x in w:
		stack.append(x)
		stack.append((h - 1) * w + x)
	for y in h:
		stack.append(y * w)
		stack.append(y * w + w - 1)
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
	# bolsões fechados (entre braços, etc.): cinza do fundo e dessaturado
	for y in h:
		for x in w:
			if mask[y * w + x] == 1:
				continue
			var c2 := img.get_pixel(x, y)
			var sat := maxf(maxf(c2.r, c2.g), c2.b) - minf(minf(c2.r, c2.g), c2.b)
			if maxf(maxf(absf(c2.r - bg.r), absf(c2.g - bg.g)), absf(c2.b - bg.b)) < tol * 1.1 and sat < sat_max:
				mask[y * w + x] = 1
	var out := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			if mask[y * w + x] == 1:
				continue
			var near := 0
			for oy in range(-1, 2):
				for ox in range(-1, 2):
					var xx := x + ox
					var yy := y + oy
					if xx >= 0 and yy >= 0 and xx < w and yy < h and mask[yy * w + xx] == 1:
						near += 1
			var c3 := img.get_pixel(x, y)
			c3.a = 1.0 if near == 0 else clampf(1.0 - float(near) / 6.0, 0.2, 1.0)
			out.set_pixel(x, y, c3)
	img.copy_from(out)

# ------------------------------------------------------------------ folhas
func _split_grid(img: Image, job: Dictionary) -> void:
	var cols := int(job.cols)
	var rows := int(job.get("rows", 1))
	var cw := img.get_width() / cols
	var ch := img.get_height() / rows
	var names: Array = job.names
	for r in rows:
		for c in cols:
			var idx := r * cols + c
			if idx >= names.size() or String(names[idx]) == "":
				continue
			var cell := img.get_region(Rect2i(c * cw, r * ch, cw, ch))
			var piece := _finish(cell, job)
			_save(piece, "%s/%s.png" % [String(job.out_dir), String(names[idx])])

func _split_components(img: Image, job: Dictionary) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var gap := int(job.get("gap", 6))
	var min_area := int(job.get("min_area", 400))
	# máscara sólida e versão dilatada por `gap` (junta peças próximas, como a gema e a coroa)
	var solid := PackedByteArray()
	solid.resize(w * h)
	for y in h:
		for x in w:
			solid[y * w + x] = 1 if img.get_pixel(x, y).a >= 0.2 else 0
	var tmp := PackedByteArray()
	tmp.resize(w * h)
	for y in h:   # dilatação horizontal
		var last := -100000
		for x in w:
			if solid[y * w + x] == 1:
				last = x
			tmp[y * w + x] = 1 if x - last <= gap else 0
		last = 100000
		for x in range(w - 1, -1, -1):
			if solid[y * w + x] == 1:
				last = x
			if last - x <= gap:
				tmp[y * w + x] = 1
	var dil := PackedByteArray()
	dil.resize(w * h)
	for x in w:   # dilatação vertical
		var lasty := -100000
		for y in h:
			if tmp[y * w + x] == 1:
				lasty = y
			dil[y * w + x] = 1 if y - lasty <= gap else 0
		lasty = 100000
		for y in range(h - 1, -1, -1):
			if tmp[y * w + x] == 1:
				lasty = y
			if lasty - y <= gap:
				dil[y * w + x] = 1
	var label := PackedInt32Array()
	label.resize(w * h)
	var boxes: Array = []
	var next_id := 1
	for y0 in h:
		for x0 in w:
			if dil[y0 * w + x0] == 0 or label[y0 * w + x0] != 0:
				continue
			var rect := Rect2i(-1, -1, 0, 0)
			var area := 0
			var stack: Array[int] = [y0 * w + x0]
			label[y0 * w + x0] = next_id
			while not stack.is_empty():
				var i: int = stack.pop_back()
				var px := i % w
				var py := i / w
				if solid[i] == 1:
					area += 1
					rect = Rect2i(px, py, 1, 1) if rect.position.x < 0 else rect.expand(Vector2i(px, py))
				for d in [-1, 1, -w, w]:
					var j: int = i + d
					if j < 0 or j >= w * h:
						continue
					if (d == -1 and px == 0) or (d == 1 and px == w - 1):
						continue
					if dil[j] == 1 and label[j] == 0:
						label[j] = next_id
						stack.append(j)
			if area >= min_area and rect.position.x >= 0:
				boxes.append({"id": next_id, "rect": Rect2i(rect.position, rect.size + Vector2i.ONE), "area": area})
			next_id += 1
	# fica com as N maiores (N = quantidade de nomes): descarta ruído de fundo que sobrou
	var wanted: int = (job.get("names", []) as Array).size()
	if wanted > 0 and boxes.size() > wanted:
		boxes.sort_custom(func(a, b): return int(a.area) > int(b.area))
		boxes = boxes.slice(0, wanted)
	var order := String(job.get("sort", "row"))
	boxes.sort_custom(func(a, b):
		var ra: Rect2i = a.rect
		var rb: Rect2i = b.rect
		if order == "col":
			return ra.position.x < rb.position.x
		# linhas: agrupa por centro em y (tolerância de meia altura média)
		var ya := ra.position.y + ra.size.y / 2
		var yb := rb.position.y + rb.size.y / 2
		if absi(ya - yb) > int(job.get("row_tol", 60)):
			return ya < yb
		return ra.position.x < rb.position.x)
	var names: Array = job.get("names", [])
	print("componentes ", boxes.size(), " em ", job.src)
	for i in boxes.size():
		var b: Dictionary = boxes[i]
		var piece := Image.create(b.rect.size.x, b.rect.size.y, false, Image.FORMAT_RGBA8)
		for y in b.rect.size.y:
			for x in b.rect.size.x:
				var sx: int = b.rect.position.x + x
				var sy: int = b.rect.position.y + y
				if img.get_pixel(sx, sy).a > 0.0:
					piece.set_pixel(x, y, img.get_pixel(sx, sy))
		var name := String(names[i]) if i < names.size() else "%s_%02d" % [String(job.get("name", "peca")), i + 1]
		if name == "":
			continue
		var jj := job.duplicate()
		jj["key"] = "none"
		if job.has("fits") and (job.fits as Dictionary).has(name):
			jj["fit"] = job.fits[name]
			jj.erase("scale_w")
			jj.erase("scale_h")
		piece = _finish(piece, jj)
		_save(piece, "%s/%s.png" % [String(job.out_dir), name])

## Recompõe uma moldura de nove fatias em outro tamanho: cantos e bordas vêm da fonte, o miolo vem de uma faixa lisa
## ("center_from" = fração x0,y0,x1,y1 da fonte), para o enfeite da janela do cartão não ser esticado.
func _nine_compose(job: Dictionary) -> void:
	var src := _load(String(job.src))
	if src == null:
		return
	var m := int(job.margin)
	var tw := int(job.size[0])
	var th := int(job.size[1])
	var sw := src.get_width()
	var sh := src.get_height()
	var out := Image.create(tw, th, false, Image.FORMAT_RGBA8)
	var cf: Array = job.get("center_from", [0.0, 0.5, 1.0, 0.9])
	var center := src.get_region(Rect2i(int(sw * float(cf[0])) + m, int(sh * float(cf[1])), int(sw * float(cf[2]) - sw * float(cf[0])) - m * 2, int(sh * float(cf[3]) - sh * float(cf[1]))))
	center.resize(tw - m * 2, th - m * 2, Image.INTERPOLATE_LANCZOS)
	out.blit_rect(center, Rect2i(0, 0, center.get_width(), center.get_height()), Vector2i(m, m))
	var top := src.get_region(Rect2i(m, 0, sw - m * 2, m))
	top.resize(tw - m * 2, m, Image.INTERPOLATE_LANCZOS)
	out.blit_rect(top, Rect2i(0, 0, top.get_width(), top.get_height()), Vector2i(m, 0))
	var bottom := src.get_region(Rect2i(m, sh - m, sw - m * 2, m))
	bottom.resize(tw - m * 2, m, Image.INTERPOLATE_LANCZOS)
	out.blit_rect(bottom, Rect2i(0, 0, bottom.get_width(), bottom.get_height()), Vector2i(m, th - m))
	var left := src.get_region(Rect2i(0, m, m, sh - m * 2))
	left.resize(m, th - m * 2, Image.INTERPOLATE_LANCZOS)
	out.blit_rect(left, Rect2i(0, 0, left.get_width(), left.get_height()), Vector2i(0, m))
	var right := src.get_region(Rect2i(sw - m, m, m, sh - m * 2))
	right.resize(m, th - m * 2, Image.INTERPOLATE_LANCZOS)
	out.blit_rect(right, Rect2i(0, 0, right.get_width(), right.get_height()), Vector2i(tw - m, m))
	for corner in [Vector2i(0, 0), Vector2i(sw - m, 0), Vector2i(0, sh - m), Vector2i(sw - m, sh - m)]:
		var piece := src.get_region(Rect2i(corner.x, corner.y, m, m))
		var at := Vector2i(0 if corner.x == 0 else tw - m, 0 if corner.y == 0 else th - m)
		out.blit_rect(piece, Rect2i(0, 0, m, m), at)
	_save(out, String(job.out))

# ------------------------------------------------------------------ sprites de inimigo a partir de poses
## Monta as folhas de animação de um inimigo a partir de poucas poses (idle, attack, special, death, walk).
## Todas as poses usam a mesma escala (a do idle, para a altura visível ficar igual à do sheet antigo), pés alinhados
## embaixo e centro horizontal do idle. Os quadros intermediários são trocas de pose com fusão suave e pequenos
## balanços; é um acabamento de transição até existir animação desenhada quadro a quadro.
func _pose(path: String, tol: float) -> Image:
	var img := _load(path)
	if img == null:
		return null
	_key_flood(img, tol, 0.07)
	var used := img.get_used_rect()
	return img.get_region(used)

func _sprite_sheets(job: Dictionary) -> void:
	var cell := Vector2i(int(job.cell[0]), int(job.cell[1]))
	var feet := int(job.feet)
	var tol := float(job.get("tol", 0.08))
	var poses := {}
	for k in job.poses:
		var p := _pose(String(job.poses[k]), tol)
		if p == null:
			return
		poses[k] = p
	var idle: Image = poses.idle
	# altura alvo: a do idle antigo, se existir, senão a do job
	var target_h := float(job.get("height", 300))
	var old_path := String(job.out_anim) + "/idle.png"
	if bool(job.get("match_old", true)) and FileAccess.file_exists(ProjectSettings.globalize_path("res://" + old_path)):
		var old := _load(old_path)
		var first := old.get_region(Rect2i(0, 0, cell.x, cell.y))
		var ur := first.get_used_rect()
		if ur.size.y > 0:
			target_h = float(ur.size.y)
	var scale := target_h / float(idle.get_height())
	var max_w := float(job.get("max_w", cell.x - 8))
	for k in poses:
		scale = minf(scale, max_w / float(poses[k].get_width()))
		scale = minf(scale, float(cell.y - 12) / float(poses[k].get_height()))
	var scaled := {}
	for k in poses:
		var im: Image = poses[k].duplicate()
		im.resize(maxi(1, int(round(im.get_width() * scale))), maxi(1, int(round(im.get_height() * scale))), Image.INTERPOLATE_LANCZOS)
		scaled[k] = im
	print(job.id, ": escala ", scale, " altura ", scaled.idle.get_height())
	var states: Dictionary = job.states
	var sheets := {}
	for state in states:
		var n := int(states[state])
		var frames: Array = _frame_plan(String(state), n, poses.has("walk"), poses.has("special"))
		var sheet := Image.create(cell.x * n, cell.y, false, Image.FORMAT_RGBA8)
		for i in n:
			var f: Dictionary = frames[i]
			var frame := Image.create(cell.x, cell.y, false, Image.FORMAT_RGBA8)
			var layers: Array = f.layers
			for layer in layers:
				var src_img: Image = scaled.get(layer.pose, scaled.idle)
				var w: int = src_img.get_width()
				var h: int = src_img.get_height()
				var sx: float = layer.get("sx", 1.0)
				var sy: float = layer.get("sy", 1.0)
				var piece: Image = src_img
				if sx != 1.0 or sy != 1.0:
					piece = src_img.duplicate()
					piece.resize(maxi(1, int(round(w * sx))), maxi(1, int(round(h * sy))), Image.INTERPOLATE_BILINEAR)
				var at := Vector2i(cell.x / 2 - piece.get_width() / 2 + int(f.get("dx", 0)), feet - piece.get_height() + int(f.get("dy", 0)))
				if layer.get("a", 1.0) < 1.0:
					var faded := piece.duplicate()
					for y in faded.get_height():
						for x in faded.get_width():
							var c: Color = faded.get_pixel(x, y)
							c.a *= float(layer.a)
							faded.set_pixel(x, y, c)
					piece = faded
				frame.blend_rect(piece, Rect2i(0, 0, piece.get_width(), piece.get_height()), at)
			sheet.blit_rect(frame, Rect2i(0, 0, cell.x, cell.y), Vector2i(cell.x * i, 0))
		sheets[state] = sheet
		_save(sheet, "%s/%s.png" % [String(job.out_anim), String(state)])
	if job.has("out_static"):
		var box := Vector2(float(job.static_size[0]), float(job.static_size[1]))
		var si: Image = poses.idle.duplicate()
		var ss := minf((box.x - 16.0) / si.get_width(), (box.y - 24.0) / si.get_height())
		si.resize(maxi(1, int(round(si.get_width() * ss))), maxi(1, int(round(si.get_height() * ss))), Image.INTERPOLATE_LANCZOS)
		var canvas := Image.create(int(box.x), int(box.y), false, Image.FORMAT_RGBA8)
		canvas.blend_rect(si, Rect2i(0, 0, si.get_width(), si.get_height()), Vector2i((int(box.x) - si.get_width()) / 2, int(box.y) - 8 - si.get_height()))
		_save(canvas, String(job.out_static))

func _frame_plan(state: String, n: int, has_walk: bool, has_special: bool) -> Array:
	var out: Array = []
	for i in n:
		var t := float(i) / float(maxi(1, n - 1))
		var ph := TAU * float(i) / float(n)
		match state:
			"idle":
				out.append({"dy": int(round(-1.5 * sin(ph))), "layers": [{"pose": "idle", "sy": 1.0 + 0.012 * sin(ph), "sx": 1.0 - 0.006 * sin(ph)}]})
			"move":
				var pose := "walk" if has_walk else "idle"
				out.append({"dy": int(round(-4.0 * absf(sin(ph)))), "dx": int(round(2.0 * sin(ph))), "layers": [{"pose": pose, "sy": 1.0 + 0.01 * sin(ph * 2.0)}]})
			"attack":
				# antecipação (idle recuado), golpe, golpe, recuperação: troca seca de pose, sem fusão (a fusão deixa fantasma)
				out.append({"dx": [-4, 3, 9, 3][mini(i, 3)], "layers": [{"pose": ["idle", "attack", "attack", "idle"][mini(i, 3)], "sx": [0.99, 1.02, 1.04, 1.0][mini(i, 3)]}]})
			"special":
				var sp := "special" if has_special else "attack"
				out.append({"dy": [0, -2, -3, -3, -2, 0][mini(i, 5)], "layers": [{"pose": ["idle", sp, sp, sp, sp, "idle"][mini(i, 5)], "sx": [1.0, 1.01, 1.03, 1.03, 1.01, 1.0][mini(i, 5)], "sy": [1.0, 1.01, 1.03, 1.03, 1.01, 1.0][mini(i, 5)]}]})
			"death":
				var fade: float = [1.0, 1.0, 1.0, 1.0, 0.9, 0.75][mini(i, 5)]
				out.append({"dx": [0, -1, 2, 0, 0, 0][mini(i, 5)], "layers": [{"pose": ["idle", "idle", "death", "death", "death", "death"][mini(i, 5)], "a": fade, "sy": [1.0, 0.98, 1.0, 1.0, 1.0, 0.98][mini(i, 5)]}]})
	return out
