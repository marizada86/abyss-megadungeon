extends SceneTree
## Auditoria geométrica das folhas de avisos telegrafados (preto aditivo, quadros em tira horizontal). Somente leitura.
## Segmenta os quadros pelo conteúdo (colunas com luz), então não depende do tamanho real do arquivo.
## Uso: Godot --headless --path <proj> -s res://tele.gd -- <saida.json> <arquivo.png> [...]
const T_LOW := 16
const T_HIGH := 48
const GAP := 12

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var res: Dictionary = {}
	for k in range(1, args.size()):
		res[String(args[k]).get_file()] = _analyze(String(args[k]))
	var f := FileAccess.open(String(args[0]), FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "\t"))
	f.close()
	quit(0)

func _luma(data: PackedByteArray, w: int, x: int, y: int) -> int:
	var i := (y * w + x) * 4
	return maxi(data[i], maxi(data[i + 1], data[i + 2]))

func _analyze(path: String) -> Dictionary:
	var img := Image.load_from_file(path)
	if img == null:
		return {"error": "nao abriu"}
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var data := img.get_data()
	var col_high := PackedInt32Array(); col_high.resize(w)
	var bg_sum := 0
	var bg_n := 0
	var bg_max := 0
	var bright := 0
	var magenta := 0
	var rs := 0.0
	var gs := 0.0
	var bs := 0.0
	var nb := 0
	var gby0 := h
	var gby1 := -1
	for y in h:
		for x in w:
			var i := (y * w + x) * 4
			var r: int = data[i]
			var g: int = data[i + 1]
			var b: int = data[i + 2]
			var v := maxi(r, maxi(g, b))
			if (x < 16 or x >= w - 16) and (y < 16 or y >= h - 16):
				bg_sum += v
				bg_n += 1
				bg_max = maxi(bg_max, v)
			if v > T_HIGH:
				col_high[x] += 1
				bright += 1
				gby0 = mini(gby0, y)
				gby1 = maxi(gby1, y)
				if r - g > 40 and b - g > 40:
					magenta += 1
				if v > 128:
					rs += r
					gs += g
					bs += b
					nb += 1
	var clusters: Array = []
	var x := 0
	while x < w:
		if col_high[x] > 0:
			var x0 := x
			var last := x
			while x < w and x - last < GAP:
				if col_high[x] > 0:
					last = x
				x += 1
			clusters.append([x0, last])
		else:
			x += 1
	var frames: Array = []
	var sparks := 0
	for c in clusters:
		var x0: int = c[0]
		var x1: int = c[1]
		if x1 - x0 + 1 < 30:
			sparks += 1
			continue
		var miny := h
		var maxy := -1
		var minxl := w
		var maxxl := -1
		var e := 0.0
		var sx := 0.0
		var sy := 0.0
		for yy in h:
			for xx in range(maxi(0, x0 - GAP), mini(w, x1 + GAP + 1)):
				var v := _luma(data, w, xx, yy)
				if v > T_LOW:
					e += v
					sx += float(v * xx)
					sy += float(v * yy)
					minxl = mini(minxl, xx)
					maxxl = maxi(maxxl, xx)
				if v > T_HIGH:
					miny = mini(miny, yy)
					maxy = maxi(maxy, yy)
		var fr := {"x0": x0, "x1": x1, "w": x1 - x0 + 1, "core_y": [miny, maxy], "core_h": maxy - miny + 1, "glow_x": [minxl, maxxl], "energy": snappedf(e / 1000.0, 1.0), "centroid": [snappedf(sx / maxf(e, 1.0), 0.1), snappedf(sy / maxf(e, 1.0), 0.1)], "center_x": (x0 + x1) / 2}
		frames.append(fr)
	var res := {
		"size": [w, h], "bg_mean_corners": snappedf(float(bg_sum) / maxf(1.0, float(bg_n)), 0.01), "bg_max_corners": bg_max,
		"bright_px": bright, "magenta_like_px": magenta, "magenta_like_pct": snappedf(100.0 * magenta / maxf(1.0, float(bright)), 0.001),
		"mean_rgb_of_bright": [snappedf(rs / maxf(1.0, float(nb)), 0.1), snappedf(gs / maxf(1.0, float(nb)), 0.1), snappedf(bs / maxf(1.0, float(nb)), 0.1)],
		"content_y": [gby0, gby1], "frame_count": frames.size(), "spark_clusters_ignored": sparks, "frames": frames,
	}
	if frames.size() >= 2:
		var cxs: Array = []
		var es: Array = []
		for f in frames:
			cxs.append(f.center_x)
			es.append(f.energy)
		var gaps: Array = []
		for i in range(cxs.size() - 1):
			gaps.append(int(cxs[i + 1]) - int(cxs[i]))
		res["center_spacing"] = gaps
		res["energy_min_max"] = snappedf(float(es.min()) / float(es.max()), 0.01)
		var diffs: Array = []
		for i in range(frames.size()):
			var j := (i + 1) % frames.size()
			diffs.append(snappedf(_pair_diff(data, w, frames, i, j, gby0, gby1), 0.0001))
		res["adjacent_diffs_incl_wrap"] = diffs
		var adj := 0.0
		for i in range(diffs.size() - 1):
			adj += float(diffs[i])
		adj /= float(diffs.size() - 1)
		res["wrap_diff"] = diffs[diffs.size() - 1]
		res["adjacent_mean_diff"] = snappedf(adj, 0.0001)
		res["wrap_ratio"] = snappedf(float(diffs[diffs.size() - 1]) / maxf(adj, 0.00001), 0.01)
	# faixa/mira: espessura e uniformidade do miolo de cada quadro
	var strips: Array = []
	for f in frames:
		var xa: int = int(f.x0) + int(float(f.w) * 0.35)
		var xb: int = int(f.x0) + int(float(f.w) * 0.65)
		var prof: Array = []
		var th_high_sum := 0
		for xx in range(xa, xb + 1):
			var colsum := 0
			var rows_high := 0
			for yy in range(int(f.core_y[0]), int(f.core_y[1]) + 1):
				var v := _luma(data, w, xx, yy)
				colsum += v
				if v > T_HIGH:
					rows_high += 1
			prof.append(colsum)
			th_high_sum += rows_high
		var mean := 0.0
		for p in prof:
			mean += float(p)
		mean /= float(prof.size())
		var varsum := 0.0
		for p in prof:
			varsum += (float(p) - mean) * (float(p) - mean)
		strips.append({"mid_cols": prof.size(), "mid_mean_col_luma": snappedf(mean, 1.0), "mid_cv": snappedf(sqrt(varsum / float(prof.size())) / maxf(mean, 1.0), 0.001), "mid_thickness_avg": snappedf(float(th_high_sum) / float(prof.size()), 0.1)})
	res["mid_section"] = strips
	# anéis: raios e marcas angulares
	var rings: Array = []
	for f in frames:
		var cy := (int(f.core_y[0]) + int(f.core_y[1])) / 2
		var cx := int(f.center_x)
		var maxr := mini(int(f.w), int(f.core_h)) / 2 + 20
		var rprof: Array = []
		for r in range(0, maxr):
			var s := 0.0
			var n := 0
			for a in 180:
				var ang := float(a) * 2.0 * PI / 180.0
				var px := cx + int(round(cos(ang) * r))
				var py := cy + int(round(sin(ang) * r))
				if px >= 0 and px < w and py >= 0 and py < h:
					s += float(_luma(data, w, px, py))
					n += 1
			rprof.append(s / maxf(1.0, float(n)))
		var peaks: Array = []
		var rmax := 0.0
		for v in rprof:
			rmax = maxf(rmax, float(v))
		for r in range(2, rprof.size() - 2):
			if rprof[r] >= rprof[r - 1] and rprof[r] > rprof[r + 1] and rprof[r] > rmax * 0.35 and rprof[r] >= rprof[r - 2] and rprof[r] >= rprof[r + 2]:
				peaks.append(r)
		var r_out := 0
		if peaks.size() > 0:
			r_out = int(peaks[peaks.size() - 1])
		var ticks: Array = []
		if r_out > 0:
			var aprof: Array = []
			for a in 720:
				var ang := float(a) * 2.0 * PI / 720.0
				var m := 0
				for r in range(r_out + 3, r_out + 11):
					var px := cx + int(round(cos(ang) * r))
					var py := cy + int(round(sin(ang) * r))
					if px >= 0 and px < w and py >= 0 and py < h:
						m = maxi(m, _luma(data, w, px, py))
				aprof.append(m)
			var amax := 0
			for v in aprof:
				amax = maxi(amax, int(v))
			var used: Array = []
			var order: Array = range(720)
			order.sort_custom(func(p, q): return aprof[p] > aprof[q])
			for idx in order:
				if aprof[idx] < int(amax * 0.75):
					break
				var ok := true
				for u in used:
					var d := absi(int(u) - int(idx))
					d = mini(d, 720 - d)
					if d < 30:
						ok = false
						break
				if ok:
					used.append(idx)
			used.sort()
			for u in used:
				ticks.append(snappedf(float(u) * 0.5, 0.5))
		rings.append({"center": [cx, cy], "radial_peaks": peaks, "outer_ring_r": r_out, "tick_angles_deg": ticks})
	res["rings"] = rings
	return res

func _pair_diff(data: PackedByteArray, w: int, frames: Array, a: int, b: int, y0: int, y1: int) -> float:
	var wa: int = int(frames[a].w)
	var wb: int = int(frames[b].w)
	var half := maxi(wa, wb) / 2 + 10
	var cxa: int = int(frames[a].center_x)
	var cxb: int = int(frames[b].center_x)
	var sum := 0
	var n := 0
	for yy in range(y0, y1 + 1, 2):
		for dx in range(-half, half + 1, 2):
			var xa := cxa + dx
			var xb := cxb + dx
			if xa < 0 or xa >= w or xb < 0 or xb >= w:
				continue
			sum += absi(_luma(data, w, xa, yy) - _luma(data, w, xb, yy))
			n += 1
	return float(sum) / float(maxi(n, 1)) / 255.0
