extends SceneTree
## Auditoria técnica das 7 fontes VFX de evolução (fundo preto, composição aditiva). Somente leitura.
## Uso: Godot --headless --path <projeto sintético> -s res://audit.gd -- <pasta_fontes> <saida.json>
const T_LOW := 16
const T_HIGH := 48
const SEAM := 3
const MARGIN_RULE := 21.0 / 256.0
const SHEETS := [
	{"id": "VE01", "file": "VE01_selo_da_retidao_v01.png", "kind": "projectile", "cols": 4, "rows": 2},
	{"id": "VE02", "file": "VE02_cajado_dos_desejos_realizados_v01.png", "kind": "projectile", "cols": 4, "rows": 2},
	{"id": "VE03", "file": "VE03_lamina_do_eclipse_v01.png", "kind": "projectile", "cols": 4, "rows": 2},
	{"id": "VE04", "file": "VE04_memoria_reescrita_v01.png", "kind": "projectile", "cols": 4, "rows": 2},
	{"id": "VE05", "file": "VE05_vigilia_perpetua_v01.png", "kind": "pulse_once", "cols": 3, "rows": 2},
	{"id": "VE06", "file": "VE06_abraco_dos_tentaculos_v01.png", "kind": "loop", "cols": 3, "rows": 2},
	{"id": "VE07", "file": "VE07_ampulheta_do_tempo_parado_v01.png", "kind": "pulse_once", "cols": 3, "rows": 2},
]

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		printerr("uso: -- <pasta_fontes> <saida.json>")
		quit(2)
		return
	var report: Array = []
	for s in SHEETS:
		report.append(_audit(String(args[0]).path_join(String(s.file)), s))
	var f := FileAccess.open(String(args[1]), FileAccess.WRITE)
	f.store_string(JSON.stringify({"thresholds": {"low": T_LOW, "high": T_HIGH, "seam_px": SEAM, "margin_rule_lote3": MARGIN_RULE}, "sheets": report}, "\t"))
	f.close()
	quit(0)

func _audit(path: String, spec: Dictionary) -> Dictionary:
	var img := Image.load_from_file(path)
	if img == null:
		return {"id": spec.id, "error": "nao abriu: " + path}
	var alpha_mode := int(img.detect_alpha())
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var cols := int(spec.cols)
	var rows := int(spec.rows)
	@warning_ignore("integer_division")
	var cw := w / cols
	@warning_ignore("integer_division")
	var ch := h / rows
	var n := cols * rows
	var data := img.get_data()
	var lminx := PackedInt32Array(); lminx.resize(n); lminx.fill(1 << 30)
	var lminy := PackedInt32Array(); lminy.resize(n); lminy.fill(1 << 30)
	var lmaxx := PackedInt32Array(); lmaxx.resize(n); lmaxx.fill(-1)
	var lmaxy := PackedInt32Array(); lmaxy.resize(n); lmaxy.fill(-1)
	var hminx := lminx.duplicate()
	var hminy := lminy.duplicate()
	var hmaxx := lmaxx.duplicate()
	var hmaxy := lmaxy.duplicate()
	var cnt := PackedInt32Array(); cnt.resize(n)
	var energy := PackedFloat64Array(); energy.resize(n)
	var sx := PackedFloat64Array(); sx.resize(n)
	var sy := PackedFloat64Array(); sy.resize(n)
	var maxd2 := PackedFloat64Array(); maxd2.resize(n)
	var alpha_min := 255
	var bg_sum := 0
	var bg_n := 0
	var bg_max := 0
	var seam_v := 0
	var seam_h := 0
	for y in h:
		@warning_ignore("integer_division")
		var cy := y / ch
		var base := y * w * 4
		var ly := y - cy * ch
		for x in w:
			var i := base + x * 4
			var a: int = data[i + 3]
			var v := maxi(data[i], maxi(data[i + 1], data[i + 2]))
			if a < 255:
				v = v * a / 255
				if a < alpha_min:
					alpha_min = a
			if (x < 16 or x >= w - 16) and (y < 16 or y >= h - 16):
				bg_sum += v
				bg_n += 1
				bg_max = maxi(bg_max, v)
			if v <= T_LOW:
				continue
			@warning_ignore("integer_division")
			var cx := x / cw
			var c := cy * cols + cx
			var lx := x - cx * cw
			lminx[c] = mini(lminx[c], lx); lmaxx[c] = maxi(lmaxx[c], lx)
			lminy[c] = mini(lminy[c], ly); lmaxy[c] = maxi(lmaxy[c], ly)
			cnt[c] += 1
			energy[c] += v
			sx[c] += float(v * lx)
			sy[c] += float(v * ly)
			if v > T_HIGH:
				hminx[c] = mini(hminx[c], lx); hmaxx[c] = maxi(hmaxx[c], lx)
				hminy[c] = mini(hminy[c], ly); hmaxy[c] = maxi(hmaxy[c], ly)
				var dx := lx - cw * 0.5
				var dy := ly - ch * 0.5
				maxd2[c] = maxf(maxd2[c], dx * dx + dy * dy)
				if (lx < SEAM and cx > 0) or (lx >= cw - SEAM and cx < cols - 1):
					seam_v += 1
				if (ly < SEAM and cy > 0) or (ly >= ch - SEAM and cy < rows - 1):
					seam_h += 1
	var cells: Array = []
	for c in n:
		@warning_ignore("integer_division")
		var d := {"cell": c, "row": c / cols, "col": c % cols, "px_glow": cnt[c], "energy": snappedf(energy[c], 1.0)}
		d["core_bbox"] = _box(hminx[c], hminy[c], hmaxx[c], hmaxy[c])
		d["glow_bbox"] = _box(lminx[c], lminy[c], lmaxx[c], lmaxy[c])
		d["core_margin_px"] = _margins(hminx[c], hminy[c], hmaxx[c], hmaxy[c], cw, ch)
		d["glow_margin_px"] = _margins(lminx[c], lminy[c], lmaxx[c], lmaxy[c], cw, ch)
		var mc := _min_margin(hminx[c], hminy[c], hmaxx[c], hmaxy[c], cw, ch)
		var mg := _min_margin(lminx[c], lminy[c], lmaxx[c], lmaxy[c], cw, ch)
		d["core_margin_min_pct"] = snappedf(mc * 100.0, 0.1)
		d["glow_margin_min_pct"] = snappedf(mg * 100.0, 0.1)
		d["pass_core_margin"] = mc >= MARGIN_RULE
		d["pass_glow_margin"] = mg >= MARGIN_RULE
		var cxm := -1.0
		var cym := -1.0
		if energy[c] > 0.0:
			cxm = snappedf(sx[c] / energy[c], 0.1)
			cym = snappedf(sy[c] / energy[c], 0.1)
		d["centroid"] = [cxm, cym]
		d["max_radius_core"] = snappedf(sqrt(maxd2[c]), 0.1)
		cells.append(d)
	var groups: Array = []
	if String(spec.kind) == "projectile":
		groups = [[0, 1, 2, 3], [4, 5, 6, 7]]
	else:
		groups = [range(n)]
	var diffs: Array = []
	for g in groups:
		var seq: Array = []
		for k in range(g.size() - 1):
			seq.append(snappedf(_cell_diff(data, w, cw, ch, cols, int(g[k]), int(g[k + 1])), 0.0001))
		diffs.append(seq)
	var res := {
		"id": spec.id, "kind": spec.kind, "size": [w, h], "cell": [cw, ch], "alpha_mode": alpha_mode, "alpha_min": alpha_min,
		"bg_mean_corners": snappedf(float(bg_sum) / maxf(1.0, float(bg_n)), 0.01), "bg_max_corners": bg_max,
		"seam_core_px_vertical": seam_v, "seam_core_px_horizontal": seam_h,
		"cells": cells, "adjacent_diffs_by_group": diffs,
	}
	if String(spec.kind) == "loop":
		var adj_mean := 0.0
		for v in diffs[0]:
			adj_mean += float(v)
		adj_mean /= float(diffs[0].size())
		var wrap := _cell_diff(data, w, cw, ch, cols, n - 1, 0)
		res["loop_wrap_diff"] = snappedf(wrap, 0.0001)
		res["loop_adjacent_mean_diff"] = snappedf(adj_mean, 0.0001)
		res["loop_wrap_ratio"] = snappedf(wrap / maxf(adj_mean, 0.00001), 0.01)
	return res

func _box(x0: int, y0: int, x1: int, y1: int) -> Array:
	if x1 < 0:
		return []
	return [x0, y0, x1 - x0 + 1, y1 - y0 + 1]

func _margins(x0: int, y0: int, x1: int, y1: int, cw: int, ch: int) -> Array:
	if x1 < 0:
		return []
	return [x0, y0, cw - 1 - x1, ch - 1 - y1]

func _min_margin(x0: int, y0: int, x1: int, y1: int, cw: int, ch: int) -> float:
	if x1 < 0:
		return -1.0
	return minf(minf(float(x0) / cw, float(cw - 1 - x1) / cw), minf(float(y0) / ch, float(ch - 1 - y1) / ch))

func _cell_diff(data: PackedByteArray, w: int, cw: int, ch: int, cols: int, a: int, b: int) -> float:
	var ax := (a % cols) * cw
	@warning_ignore("integer_division")
	var ay := (a / cols) * ch
	var bx := (b % cols) * cw
	@warning_ignore("integer_division")
	var by := (b / cols) * ch
	var sum := 0
	var k := 0
	for y in range(0, ch, 4):
		for x in range(0, cw, 4):
			var ia := ((ay + y) * w + ax + x) * 4
			var ib := ((by + y) * w + bx + x) * 4
			var va := maxi(data[ia], maxi(data[ia + 1], data[ia + 2]))
			var vb := maxi(data[ib], maxi(data[ib + 1], data[ib + 2]))
			sum += absi(va - vb)
			k += 1
	return float(sum) / float(k) / 255.0
