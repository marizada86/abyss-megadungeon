extends SceneTree
## Preparação das folhas temáticas dos golpes telegrafados de chefe (fontes de ImageGen, preto aditivo) para as folhas de
## 256 px por célula que o BossVfx lê. Segmenta os quadros pelo conteúdo (a fonte não garante grade exata), mede o centro e o
## raio reais de cada quadro e aplica UMA escala por folha, para o tamanho final bater com a folha neutra do mesmo golpe.
## Não instala nada e só grava onde o job manda.
## Uso:
##   godot --headless --path . -s tools/telegraph_prep.gd -- measure <atlas.png> <kind> <cells>
##   godot --headless --path . -s tools/telegraph_prep.gd -- <job.json>
## Job (JSON): lista de {"id","kind":"sweep|quad|mark|charge","src","out","ref":{atlas neutro p/ comprimento/altura},"radius":px}.
## Todos os caminhos são relativos à raiz do projeto.

const KEY_TOL := 0.045
const A_USED := 26        # alfa 0..255 que conta como conteúdo ao medir bordas
const A_CORE := 90        # alfa do corpo do efeito (faixa, anel, coluna)
const A_RING := 77        # alfa mínimo para um pixel contar como anel
const PAD := 22.0
const CHARGE_BASE := 198.5  # linha da base do corpo da carga nas folhas neutras (G05)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() >= 4 and args[0] == "measure":
		_measure_atlas(args[1], args[2], int(args[3]))
		quit()
		return
	if args.is_empty():
		printerr("uso: -- <job.json> | measure <atlas> <kind> <cells>")
		quit(1)
		return
	var report: Array = []
	for job in JSON.parse_string(FileAccess.get_file_as_string(args[0])):
		report.append(_run(job))
	print("REPORT ", JSON.stringify(report))
	quit()

# ------------------------------------------------------------------ E/S

func _path(p: String) -> String:
	return ProjectSettings.globalize_path("res://" + p)

func _load(p: String) -> Image:
	var img := Image.load_from_file(_path(p))
	if img == null:
		printerr("não abriu ", p)
		quit(1)
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img

## Preto aditivo: o brilho vira alfa e a cor se mantém (igual a tools/asset_prep.gd).
func _key_black(img: Image) -> void:
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			var l := maxf(maxf(c.r, c.g), c.b)
			if l < KEY_TOL:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			else:
				img.set_pixel(x, y, Color(c.r / l, c.g / l, c.b / l, clampf(l * 1.15, 0.0, 1.0)))

# ------------------------------------------------------------------ medidas

func _alpha(img: Image) -> PackedByteArray:
	var d := img.get_data()
	var a := PackedByteArray()
	a.resize(img.get_width() * img.get_height())
	for i in a.size():
		a[i] = d[i * 4 + 3]
	return a

func _bbox(a: PackedByteArray, w: int, h: int, thr: int, center := Vector2(-1, -1), max_r := -1.0) -> Rect2i:
	var x0 := w
	var y0 := h
	var x1 := -1
	var y1 := -1
	var r2 := max_r * max_r
	for y in h:
		for x in w:
			if a[y * w + x] < thr:
				continue
			if max_r > 0.0 and Vector2(x - center.x, y - center.y).length_squared() > r2:
				continue
			x0 = mini(x0, x)
			y0 = mini(y0, y)
			x1 = maxi(x1, x)
			y1 = maxi(y1, y)
	if x1 < 0:
		return Rect2i()
	return Rect2i(x0, y0, x1 - x0 + 1, y1 - y0 + 1)

## Raio mais externo onde pelo menos 60% dos ângulos têm anel.
func _ring_radius(a: PackedByteArray, w: int, h: int, c: Vector2, r_max: int) -> float:
	var best := 0.0
	for r in range(6, r_max):
		var hit := 0
		for k in 72:
			var ang := TAU * float(k) / 72.0
			for dr in [-1, 0, 1]:
				var x := int(round(c.x + cos(ang) * float(r + dr)))
				var y := int(round(c.y + sin(ang) * float(r + dr)))
				if x >= 0 and y >= 0 and x < w and y < h and a[y * w + x] >= A_RING:
					hit += 1
					break
		if hit >= 43:
			best = float(r)
	return best

## Centro e raio do anel de um quadro (por refinamento: o raio limita o que entra no centro).
func _ring(a: PackedByteArray, w: int, h: int) -> Dictionary:
	var box := _bbox(a, w, h, A_CORE)
	if not box.has_area():
		return {}
	var c := Vector2(box.position) + Vector2(box.size) * 0.5
	var r := 0.0
	for _i in 3:
		r = _ring_radius(a, w, h, c, int(maxf(box.size.x, box.size.y) * 0.5) + 4)
		var inner := _bbox(a, w, h, A_CORE, c, r * 1.06)
		if inner.has_area():
			c = Vector2(inner.position) + Vector2(inner.size) * 0.5
	return {"c": c, "r": r}

# ------------------------------------------------------------------ segmentação

## Corridas de coluna/linha com conteúdo; corridas separadas por menos de `merge` px viram uma.
func _runs(profile: PackedInt32Array, merge: int) -> Array:
	var runs: Array = []
	var start := -1
	for i in profile.size():
		if profile[i] >= 2:
			if start < 0:
				start = i
		elif start >= 0:
			runs.append([start, i - 1])
			start = -1
	if start >= 0:
		runs.append([start, profile.size() - 1])
	var merged: Array = []
	for run in runs:
		if not merged.is_empty() and int(run[0]) - int(merged[-1][1]) < merge:
			merged[-1][1] = run[1]
		else:
			merged.append(run)
	return merged

func _col_profile(a: PackedByteArray, w: int, y0: int, y1: int) -> PackedInt32Array:
	var p := PackedInt32Array()
	p.resize(w)
	for y in range(y0, y1):
		for x in w:
			if a[y * w + x] >= A_USED:
				p[x] += 1
	return p

func _row_profile(a: PackedByteArray, w: int, h: int) -> PackedInt32Array:
	var p := PackedInt32Array()
	p.resize(h)
	for y in h:
		for x in w:
			if a[y * w + x] >= A_USED:
				p[y] += 1
	return p

## Limites entre grupos: ponto médio do vazio entre dois grupos vizinhos.
func _splits(groups: Array, total: int, count: int) -> Array:
	var out: Array = [0]
	if groups.size() == count:
		for i in count - 1:
			out.append((int(groups[i][1]) + int(groups[i + 1][0])) / 2 + 1)
	else:
		for i in range(1, count):
			out.append(total * i / count)
	out.append(total)
	return out

func _segment(img: Image, layout: String) -> Dictionary:
	var w := img.get_width()
	var h := img.get_height()
	var a := _alpha(img)
	var rects: Array[Rect2i] = []
	var exact := true
	if layout == "strip6":
		var groups := _runs(_col_profile(a, w, 0, h), 12)
		exact = groups.size() == 6
		var xs := _splits(groups, w, 6)
		for i in 6:
			rects.append(Rect2i(xs[i], 0, xs[i + 1] - xs[i], h))
	else:
		var rows := _runs(_row_profile(a, w, h), 40)
		var ys := _splits(rows, h, 2)
		exact = rows.size() == 2
		for r in 2:
			var groups := _runs(_col_profile(a, w, ys[r], ys[r + 1]), 12)
			exact = exact and groups.size() == 4
			var xs := _splits(groups, w, 4)
			for i in 4:
				rects.append(Rect2i(xs[i], ys[r], xs[i + 1] - xs[i], ys[r + 1] - ys[r]))
	return {"rects": rects, "exact": exact}

# ------------------------------------------------------------------ medir uma folha pronta

func _measure_atlas(path: String, kind: String, cells: int) -> void:
	var img := _load(path)
	if img == null:
		return
	var a := _alpha(img)
	var w := img.get_width()
	var rows: Array = []
	for i in cells:
		var cell := PackedByteArray()
		cell.resize(256 * 256)
		for y in 256:
			for x in 256:
				cell[y * 256 + x] = a[y * w + i * 256 + x]
		rows.append(_frame_metrics(cell, kind))
	print("MEASURE ", path, " ", JSON.stringify(rows))

func _frame_metrics(a: PackedByteArray, kind: String) -> Dictionary:
	var used := _bbox(a, 256, 256, A_USED)
	var core := _bbox(a, 256, 256, A_CORE)
	var m := {"used": [used.position.x, used.position.y, used.end.x, used.end.y], "core": [core.position.x, core.position.y, core.end.x, core.end.y]}
	if kind == "sweep":
		var lo := 999
		var hi := 0
		for x in range(80, 177):
			var n := 0
			for y in 256:
				if a[y * 256 + x] >= A_CORE:
					n += 1
			lo = mini(lo, n)
			hi = maxi(hi, n)
		m["mid"] = [lo, hi]
	if kind == "quad" or kind == "mark":
		var ring := _ring(a, 256, 256)
		if not ring.is_empty():
			m["c"] = [snappedf(ring.c.x, 0.1), snappedf(ring.c.y, 0.1)]
			m["r"] = ring.r
	return m

# ------------------------------------------------------------------ preparação

func _run(job: Dictionary) -> Dictionary:
	var kind := String(job.kind)
	var layout := "grid8" if kind == "quad" or kind == "mark" else "strip6"
	var img := _load(String(job.src))
	if img == null:
		return {}
	_key_black(img)
	var seg := _segment(img, layout)
	var rects: Array = seg.rects
	var frames: Array = []
	for rect in rects:
		var part := img.get_region(rect)
		var a := _alpha(part)
		var w := part.get_width()
		var h := part.get_height()
		var f := {"part": part, "rect": rect, "w": w, "h": h}
		match kind:
			"sweep":
				var core := _bbox(a, w, h, A_CORE)
				f["anchor"] = Vector2(core.position) + Vector2(core.size) * 0.5
				f["size"] = core.size.x
			"charge":
				var body := _bbox(a, w, h, A_CORE)
				f["anchor"] = Vector2(body.position.x + body.size.x * 0.5, body.end.y)
				f["size"] = body.size.y
			_:
				var core := _bbox(a, w, h, A_CORE)
				var box_c := Vector2(core.position) + Vector2(core.size) * 0.5
				var ring := _ring(a, w, h)
				f["ring_r"] = ring.get("r", 0.0)
				f["anchor"] = box_c
				if not ring.is_empty() and ring.r > 0.0:
					f["ring_c"] = ring.c
				f["size"] = float(core.size.x + core.size.y) * 0.25
		frames.append(f)
	if kind == "quad" or kind == "mark":
		_pick_centers(frames)
	var wanted := float(job.get("size", 0.0))
	if wanted <= 0.0:
		wanted = _reference_size(job)
	var mean := 0.0
	var count := 0
	for i in frames.size():
		if kind == "quad" or kind == "mark":
			if i >= 4:
				continue   # a escala sai dos quadros de repouso; a detonação cresce a partir dela
		mean += float(frames[i].size)
		count += 1
	mean /= float(maxi(count, 1))
	var scale := wanted / mean
	var target := Vector2(128, CHARGE_BASE) if kind == "charge" else Vector2(128, 128)
	var fit := 100.0
	for f in frames:
		var used := (f.part as Image).get_used_rect()
		var anchor: Vector2 = f.anchor
		fit = minf(fit, (target.x - PAD) / maxf(anchor.x - used.position.x, 1.0))
		fit = minf(fit, (256.0 - PAD - target.x) / maxf(used.end.x - anchor.x, 1.0))
		fit = minf(fit, (target.y - PAD) / maxf(anchor.y - used.position.y, 1.0))
		fit = minf(fit, (256.0 - PAD - target.y) / maxf(used.end.y - anchor.y, 1.0))
	var capped := fit < scale
	var final_scale := minf(scale, fit)
	var atlas := Image.create(256 * frames.size(), 256, false, Image.FORMAT_RGBA8)
	for i in frames.size():
		var f: Dictionary = frames[i]
		var part: Image = f.part
		var used := part.get_used_rect()
		var piece := part.get_region(used)
		var at := Vector2i((target + (Vector2(used.position) - (f.anchor as Vector2)) * final_scale).round())
		piece.resize(maxi(1, roundi(piece.get_width() * final_scale)), maxi(1, roundi(piece.get_height() * final_scale)), Image.INTERPOLATE_LANCZOS)
		atlas.blit_rect(piece, Rect2i(Vector2i.ZERO, piece.get_size()), at + Vector2i(i * 256, 0))
	var out := _path(String(job.out))
	DirAccess.make_dir_recursive_absolute(out.get_base_dir())
	atlas.save_png(out)
	var info: Array = []
	for f in frames:
		info.append({"rect": [f.rect.position.x, f.rect.position.y, f.rect.size.x, f.rect.size.y], "anchor": [snappedf(f.anchor.x, 0.1), snappedf(f.anchor.y, 0.1)], "size": snappedf(f.size, 0.1), "center": f.get("center_source", "")})
	print("gravou ", job.out, " ", atlas.get_size(), " escala ", snappedf(final_scale, 0.0001), " (desejada ", snappedf(scale, 0.0001), ")", " CAPADA" if capped else "", "" if seg.exact else " SEGMENTACAO_POR_GRADE")
	return {"id": job.id, "out": job.out, "scale": final_scale, "wanted_scale": scale, "capped": capped, "segmentation_exact": seg.exact, "frames": info}

## Tamanho de referência (px finais) da folha neutra do mesmo golpe, quando o job não fixa `size`.
func _reference_size(job: Dictionary) -> float:
	match String(job.kind):
		"quad":
			return 72.0
		"mark":
			return 73.5
	var ref := _load(String(job.ref))
	if ref == null:
		return 100.0
	var a := _alpha(ref)
	var w := ref.get_width()
	var total := 0.0
	for i in w / 256:
		var cell := PackedByteArray()
		cell.resize(256 * 256)
		for y in 256:
			for x in 256:
				cell[y * 256 + x] = a[y * w + i * 256 + x]
		total += float(_bbox(cell, 256, 256, A_CORE).size.y)
	return total / float(w / 256)

## O centro do anel só vale quando o raio bate com o dos quadros de repouso e o centro não foge da caixa do corpo; senão fica a caixa.
func _pick_centers(frames: Array) -> void:
	var radii: Array = []
	for i in 4:
		if float(frames[i].get("ring_r", 0.0)) > 0.0:
			radii.append(float(frames[i].ring_r))
	radii.sort()
	var median := float(radii[radii.size() / 2]) if not radii.is_empty() else 0.0
	for f in frames:
		f["center_source"] = "box"
		if not f.has("ring_c") or median <= 0.0:
			continue
		if absf(float(f.ring_r) - median) > median * 0.15:
			continue
		if (f.ring_c as Vector2).distance_to(f.anchor) > 12.0:
			continue
		f["anchor"] = f.ring_c
		f["center_source"] = "ring"
