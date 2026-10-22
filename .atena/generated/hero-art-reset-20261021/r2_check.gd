extends SceneTree
## Verificador somente leitura das imagens do R2 (critérios 1 a 6 do contrato). Roda fora do projeto:
##   godot --headless --script r2_check.gd -- <imagem.png> <magenta|gray> <figuras> <walk|idle|grid> [saida.json]
## walk: fila de 2 ou 3 figuras (calibração = a figura P, a do meio; com 2 figuras, a 2ª).
## idle: fila de 3, calibração = a 1ª. grid: 2x2, calibração = a 1ª (canto superior esquerdo).
## Não escreve nada além do JSON opcional; não abre o projeto.

const MIN_AREA := 4000          # px de uma figura (cluster) para contar como figura
const SPECK_MAX := 120          # px de um componente solto
const DILATE_CELLS := 5         # em células de 4 px: une partes da mesma figura (ex.: fios de cabelo, arma)
const BLOCK := 4
const LIM_SCALE := 0.06
const LIM_FEET := 0.03
const LIM_DIFF := 0.08
const LIM_HALO := 0.02

var W := 0
var H := 0
var rgba: PackedByteArray
var key_kind := "magenta"

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() < 4:
		printerr("uso: -- <imagem> <magenta|gray> <figuras> <walk|idle|grid> [saida.json]")
		quit(2)
		return
	var path := a[0]
	key_kind = a[1]
	var expected := int(a[2])
	var kind := a[3]
	var img := Image.load_from_file(path)
	if img == null:
		printerr("não abriu ", path)
		quit(2)
		return
	img.convert(Image.FORMAT_RGBA8)
	W = img.get_width()
	H = img.get_height()
	rgba = img.get_data()
	var report := _analyze(path, expected, kind)
	if a.size() >= 5:
		var f := FileAccess.open(a[4], FileAccess.WRITE)
		f.store_string(JSON.stringify(report, "  "))
		f.close()
	quit(0 if report.verdict == "PASSA" else 1)

func _dist_key(i: int) -> float:
	var r := float(rgba[i * 4])
	var g := float(rgba[i * 4 + 1])
	var b := float(rgba[i * 4 + 2])
	if key_kind == "magenta":
		return sqrt(pow(r - 255.0, 2) + pow(g, 2) + pow(b - 255.0, 2)) / 441.7
	var d := sqrt(pow(r - 180.0, 2) + pow(g - 180.0, 2) + pow(b - 180.0, 2)) / 441.7
	var sat := (maxf(r, maxf(g, b)) - minf(r, minf(g, b))) / 255.0
	return d if sat < 0.06 else 1.0

func _bg_like(i: int, tol: float) -> bool:
	return _dist_key(i) < tol

func _analyze(path: String, expected: int, kind: String) -> Dictionary:
	var tol := 0.22 if key_kind == "magenta" else 0.08
	# fundo = pixels parecidos com a chave ligados à borda
	var bg := PackedByteArray()
	bg.resize(W * H)
	var stack := PackedInt32Array()
	for x in W:
		for y in [0, H - 1]:
			var i: int = y * W + x
			if bg[i] == 0 and _bg_like(i, tol):
				bg[i] = 1
				stack.append(i)
	for y in H:
		for x in [0, W - 1]:
			var i: int = y * W + x
			if bg[i] == 0 and _bg_like(i, tol):
				bg[i] = 1
				stack.append(i)
	while not stack.is_empty():
		var cur: int = stack[stack.size() - 1]
		stack.resize(stack.size() - 1)
		var cx := cur % W
		var cy := cur / W
		for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
			var nx: int = cx + d[0]
			var ny: int = cy + d[1]
			if nx < 0 or ny < 0 or nx >= W or ny >= H:
				continue
			var ni: int = ny * W + nx
			if bg[ni] == 0 and _bg_like(ni, tol):
				bg[ni] = 1
				stack.append(ni)
	var fg := PackedByteArray()
	fg.resize(W * H)
	var fg_total := 0
	for i in W * H:
		if bg[i] == 0:
			fg[i] = 1
			fg_total += 1
	# clusters em baixa resolução com dilatação
	var lw := (W + BLOCK - 1) / BLOCK
	var lh := (H + BLOCK - 1) / BLOCK
	var low := PackedByteArray()
	low.resize(lw * lh)
	for y in H:
		for x in W:
			if fg[y * W + x] == 1:
				low[(y / BLOCK) * lw + (x / BLOCK)] = 1
	var dil := PackedByteArray()
	dil.resize(lw * lh)
	for y in lh:
		for x in lw:
			if low[y * lw + x] == 1:
				for dy in range(-DILATE_CELLS, DILATE_CELLS + 1):
					for dx in range(-DILATE_CELLS, DILATE_CELLS + 1):
						var nx := x + dx
						var ny := y + dy
						if nx >= 0 and ny >= 0 and nx < lw and ny < lh:
							dil[ny * lw + nx] = 1
	var label := PackedInt32Array()
	label.resize(lw * lh)
	var n_labels := 0
	for s in lw * lh:
		if dil[s] == 1 and label[s] == 0:
			n_labels += 1
			label[s] = n_labels
			var st := PackedInt32Array([s])
			while not st.is_empty():
				var c: int = st[st.size() - 1]
				st.resize(st.size() - 1)
				var cx := c % lw
				var cy := c / lw
				for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
					var nx: int = cx + d[0]
					var ny: int = cy + d[1]
					if nx < 0 or ny < 0 or nx >= lw or ny >= lh:
						continue
					var ni: int = ny * lw + nx
					if dil[ni] == 1 and label[ni] == 0:
						label[ni] = n_labels
						st.append(ni)
	var cl := {}
	for y in H:
		for x in W:
			if fg[y * W + x] == 1:
				var l: int = label[(y / BLOCK) * lw + (x / BLOCK)]
				if not cl.has(l):
					cl[l] = {"minx": x, "maxx": x, "miny": y, "maxy": y, "area": 0}
				var c: Dictionary = cl[l]
				c.minx = mini(c.minx, x)
				c.maxx = maxi(c.maxx, x)
				c.miny = mini(c.miny, y)
				c.maxy = maxi(c.maxy, y)
				c.area += 1
	var figs := []
	var tiny := 0
	for l in cl:
		if cl[l].area >= MIN_AREA:
			var f: Dictionary = cl[l]
			f["label"] = l
			figs.append(f)
		else:
			tiny += 1
	figs = _order(figs, kind)
	var out_figs := []
	var halo_edge := 0
	var halo_hit := 0
	for y in range(1, H - 1):
		for x in range(1, W - 1):
			var i := y * W + x
			if fg[i] == 1 and (bg[i - 1] == 1 or bg[i + 1] == 1 or bg[i - W] == 1 or bg[i + W] == 1):
				halo_edge += 1
				if _dist_key(i) < tol * 2.2:
					halo_hit += 1
	# componentes soltos por figura (pixel-a-pixel 8-conexo), fora do maior
	var specks := _specks(fg, figs)
	for k in figs.size():
		var f: Dictionary = figs[k]
		var h: int = f.maxy - f.miny + 1
		var w: int = f.maxx - f.minx + 1
		out_figs.append({"i": k + 1, "x": f.minx, "y": f.miny, "w": w, "h": h, "feet_y": f.maxy, "cx": (f.minx + f.maxx) / 2, "area": f.area, "touches_edge": f.minx <= 0 or f.miny <= 0 or f.maxx >= W - 1 or f.maxy >= H - 1, "specks": specks[k]})
	var checks := {}
	var notes := []
	checks["1_figuras"] = figs.size() == expected and not out_figs.any(func(o): return o.touches_edge)
	if figs.size() != expected:
		notes.append("esperava %d figuras, achei %d (clusters pequenos ignorados: %d)" % [expected, figs.size(), tiny])
	if out_figs.any(func(o): return o.touches_edge):
		notes.append("há figura encostando na borda da imagem")
	var cal := _cal_index(kind, figs.size())
	if figs.size() > 0 and cal < figs.size():
		var ch: float = out_figs[cal].h
		var worst := 0.0
		for o in out_figs:
			if kind == "grid" and o.i - 1 != cal:
				continue   # em grade, as poses de ação variam de altura; a escala sai da calibração
			worst = maxf(worst, absf(o.h - ch) / ch)
		checks["3_escala"] = worst <= LIM_SCALE if kind != "grid" else true
		out_figs[cal]["calibration"] = true
		notes.append("3_escala: pior diferença de altura contra a calibração = %.1f%%%s" % [worst * 100.0, " (não aplicável à grade; a escala vem da calibração)" if kind == "grid" else ""])
		# linha dos pés: por linha de figuras
		var rows := _rows(out_figs)
		var worst_feet := 0.0
		for r in rows:
			var lo := 99999
			var hi := -1
			var hmax := 1
			for o in r:
				lo = mini(lo, o.feet_y)
				hi = maxi(hi, o.feet_y)
				hmax = maxi(hmax, o.h)
			worst_feet = maxf(worst_feet, float(hi - lo) / float(hmax))
		checks["4_pes"] = worst_feet <= LIM_FEET
		notes.append("4_pes: variação da linha dos pés = %.1f%% da altura" % (worst_feet * 100.0))
	else:
		checks["3_escala"] = false
		checks["4_pes"] = false
	var halo_ratio := float(halo_hit) / maxf(float(halo_edge), 1.0)
	checks["2_fundo"] = halo_ratio <= LIM_HALO
	notes.append("2_fundo: %.1f%% das bordas ainda parecem a cor de fundo" % (halo_ratio * 100.0))
	var total_specks := 0
	for s in specks:
		total_specks += s
	checks["6_pontos_soltos"] = total_specks == 0
	notes.append("6_pontos_soltos: %d" % total_specks)
	if kind == "walk" and figs.size() >= 2:
		var diffs := _walk_diffs(fg, figs, cal)
		checks["5_caminhada"] = diffs.min >= LIM_DIFF
		notes.append("5_caminhada: diferença de A e B contra P = %s (mínimo exigido %.0f%%)" % [str(diffs.values), LIM_DIFF * 100.0])
		out_figs.append({"walk_diffs": diffs.values})
	else:
		checks["5_caminhada"] = true
	var all_ok := true
	for k in checks:
		if not checks[k]:
			all_ok = false
	var res := {"arquivo": path, "tela": [W, H], "chave": key_kind, "tipo": kind, "esperadas": expected, "figuras": out_figs, "checagens": checks, "notas": notes, "verdict": "PASSA" if all_ok else "REPROVA", "identidade_e_estilo": "decisão do dono (critérios 7 a 9)"}
	print("== ", path.get_file(), "  ", kind, "  ", W, "x", H, "  figuras ", figs.size(), "/", expected)
	for k in checks:
		print("  ", "OK  " if checks[k] else "FALHA", k)
	for n in notes:
		print("    ", n)
	print("  veredito: ", res.verdict)
	return res

func _order(figs: Array, kind: String) -> Array:
	if kind == "grid":
		var rows := [[], []]
		for f in figs:
			rows[0 if (f.miny + f.maxy) / 2 < H / 2 else 1].append(f)
		var out := []
		for r in rows:
			r.sort_custom(func(a, b): return a.minx < b.minx)
			out.append_array(r)
		return out
	figs.sort_custom(func(a, b): return a.minx < b.minx)
	return figs

func _cal_index(kind: String, n: int) -> int:
	if kind == "walk":
		return 1 if n >= 2 else 0
	return 0

func _rows(out_figs: Array) -> Array:
	var rows := {}
	for o in out_figs:
		var r: int = 0 if o.y + o.h / 2 < H / 2 else 1
		if not rows.has(r):
			rows[r] = []
		rows[r].append(o)
	return rows.values()

func _specks(fg: PackedByteArray, figs: Array) -> Array:
	var counts := []
	for f in figs:
		var seen := {}
		var comps := []
		for y in range(f.miny, f.maxy + 1):
			for x in range(f.minx, f.maxx + 1):
				var i := y * W + x
				if fg[i] == 1 and not seen.has(i):
					var st := [i]
					seen[i] = true
					var area := 0
					while not st.is_empty():
						var c: int = st.pop_back()
						area += 1
						var cx := c % W
						var cy := c / W
						for dy in [-1, 0, 1]:
							for dx in [-1, 0, 1]:
								var nx: int = cx + dx
								var ny: int = cy + dy
								if nx < f.minx or nx > f.maxx or ny < f.miny or ny > f.maxy:
									continue
								var ni: int = ny * W + nx
								if fg[ni] == 1 and not seen.has(ni):
									seen[ni] = true
									st.append(ni)
					comps.append(area)
		comps.sort()
		comps.reverse()
		var n := 0
		for k in range(1, comps.size()):
			if comps[k] <= SPECK_MAX:
				n += 1
		counts.append(n)
	return counts

func _mask_of(fg: PackedByteArray, f: Dictionary) -> Image:
	var w: int = f.maxx - f.minx + 1
	var h: int = f.maxy - f.miny + 1
	var data := PackedByteArray()
	data.resize(w * h)
	for y in h:
		for x in w:
			data[y * w + x] = 255 if fg[(f.miny + y) * W + f.minx + x] == 1 else 0
	return Image.create_from_data(w, h, false, Image.FORMAT_L8, data)

func _walk_diffs(fg: PackedByteArray, figs: Array, cal: int) -> Dictionary:
	var p: Dictionary = figs[cal]
	var target_h: int = p.maxy - p.miny + 1
	var cw := 700
	var base := _canvas(_mask_of(fg, p), target_h, cw)
	var vals := []
	var mn := 1.0
	for k in figs.size():
		if k == cal:
			continue
		var m := _mask_of(fg, figs[k])
		var cv := _canvas(m, target_h, cw)
		var inter := 0
		var uni := 0
		for i in cw * target_h:
			var a: bool = base[i] > 0
			var b: bool = cv[i] > 0
			if a or b:
				uni += 1
				if a != b:
					inter += 1
		var r := float(inter) / maxf(float(uni), 1.0)
		vals.append(snappedf(r, 0.001))
		mn = minf(mn, r)
	return {"values": vals, "min": mn}

func _canvas(m: Image, target_h: int, cw: int) -> PackedByteArray:
	var s := float(target_h) / float(m.get_height())
	var nw := maxi(1, int(round(m.get_width() * s)))
	var mm := m.duplicate()
	mm.resize(nw, target_h, Image.INTERPOLATE_NEAREST)
	var out := PackedByteArray()
	out.resize(cw * target_h)
	var ox := (cw - nw) / 2
	var src: PackedByteArray = mm.get_data()
	for y in target_h:
		for x in nw:
			var dx := ox + x
			if dx >= 0 and dx < cw:
				out[y * cw + dx] = src[y * nw + x]
	return out
