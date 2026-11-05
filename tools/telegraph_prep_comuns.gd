extends SceneTree
## Preparação dos avisos telegrafados dos inimigos COMUNS (T20 faixa de investida, T21 mira do atirador, T22 círculo de golpe em área):
## fontes de ImageGen em preto aditivo, quadros em tira horizontal, para folhas de 256 px por célula.
## Diferente de tools/telegraph_prep.gd (peles temáticas de chefe): aqui a cor sai NEUTRA (branco com o brilho no alfa), para o jogo
## tingir pelo tipo de dano (`warn.main`, modos de daltonismo). Segmenta os quadros pelo conteúdo (o canvas real não bate com o pedido),
## aplica UMA escala por folha e um centro medido por quadro, e mede o resultado (margens, laço, pulso, fatias de tampa/miolo).
## Não instala nada e só grava onde o job manda.
## Uso:
##   godot --headless --path <projeto> -s tools/telegraph_prep_comuns.gd -- <job.json> [--root <raiz do jogo>]
## Sem --root, os caminhos do job são relativos a res://. Com --root, são relativos a essa pasta (útil num projeto sintético sem autoloads).
## Job (JSON): lista de {"id","kind":"lane|aim|ring","src","out","cells":6|4,"size":px,"neutralize":0..1,"report":caminho}.
##   lane/aim: `size` = comprimento do corpo (núcleo) em px da célula; ring: `size` = raio do anel externo em px da célula.

const KEY_TOL := 0.045
const A_USED := 26        # alfa 0..255 que conta como conteúdo ao medir bordas
const A_CORE := 90        # alfa do corpo do efeito
const A_RING := 77        # alfa mínimo para um pixel contar como anel
const A_SEG := 60         # alfa que conta ao separar quadros: o halo fraco (alfa baixo) une quadros vizinhos
const PAD := 22.0
const CELL := 256
const MIN_RUN := 30       # corrida de colunas mais estreita que isto é faísca solta, não quadro
const FADE_START := 8.0   # px além do raio do anel em que o halo começa a desvanecer
const FADE_END := 32.0    # px além do raio do anel em que tudo é apagado (faíscas soltas); desvanecer evita uma borda nítida no halo
const CAP_L := Vector2i(24, 80)    # fatias da barra (BossVfx.BEAM): tampa esquerda, miolo esticável e tampa direita
const CAP_M := Vector2i(80, 176)
const CAP_R := Vector2i(176, 232)

var _root := ""

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("uso: -- <job.json> [--root <raiz>]")
		quit(1)
		return
	var i := args.find("--root")
	if i >= 0 and i + 1 < args.size():
		_root = String(args[i + 1])
	var report: Array = []
	for job in JSON.parse_string(FileAccess.get_file_as_string(args[0])):
		report.append(_run(job))
	print("REPORT_DONE ", report.size())
	quit()

# ------------------------------------------------------------------ E/S

func _path(p: String) -> String:
	return _root.path_join(p) if _root != "" else ProjectSettings.globalize_path("res://" + p)

func _load(p: String) -> Image:
	var img := Image.load_from_file(_path(p))
	if img == null:
		printerr("não abriu ", p)
		quit(1)
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img

## Preto aditivo: o brilho vira alfa. Cor NEUTRA: o matiz da fonte (âmbar) é descartado e o pixel vira branco; quem tinge é o jogo.
## Pixels sem luz ficam brancos e transparentes, para o redimensionamento não sangrar preto nas bordas.
func _key_neutral(img: Image, neutral: float) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var d := img.get_data()
	for i in w * h:
		var r: int = d[i * 4]
		var g: int = d[i * 4 + 1]
		var b: int = d[i * 4 + 2]
		var l := maxi(r, maxi(g, b))
		var lf := float(l) / 255.0
		if lf < KEY_TOL:
			d[i * 4] = 255
			d[i * 4 + 1] = 255
			d[i * 4 + 2] = 255
			d[i * 4 + 3] = 0
			continue
		var fl := float(l)
		d[i * 4] = roundi(lerpf(float(r) / fl, 1.0, neutral) * 255.0)
		d[i * 4 + 1] = roundi(lerpf(float(g) / fl, 1.0, neutral) * 255.0)
		d[i * 4 + 2] = roundi(lerpf(float(b) / fl, 1.0, neutral) * 255.0)
		d[i * 4 + 3] = roundi(clampf(lf * 1.15, 0.0, 1.0) * 255.0)
	img.set_data(w, h, false, Image.FORMAT_RGBA8, d)

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

## Limites entre quadros: ponto médio do vazio entre dois grupos vizinhos. Faíscas soltas (corrida estreita) ficam com o quadro mais próximo.
func _segment(img: Image, cells: int) -> Dictionary:
	var w := img.get_width()
	var h := img.get_height()
	var a := _alpha(img)
	var prof := PackedInt32Array()
	prof.resize(w)
	for y in h:
		for x in w:
			if a[y * w + x] >= A_SEG:
				prof[x] += 1
	var big: Array = []
	var sparks := 0
	for run in _runs(prof, 8):
		if int(run[1]) - int(run[0]) + 1 >= MIN_RUN:
			big.append(run)
		else:
			sparks += 1
	var exact := big.size() == cells
	var xs: Array = [0]
	if exact:
		for i in cells - 1:
			xs.append((int(big[i][1]) + int(big[i + 1][0])) / 2 + 1)
	else:
		for i in range(1, cells):
			xs.append(w * i / cells)
	xs.append(w)
	var rects: Array[Rect2i] = []
	for i in cells:
		rects.append(Rect2i(xs[i], 0, xs[i + 1] - xs[i], h))
	return {"rects": rects, "exact": exact, "sparks": sparks}

# ------------------------------------------------------------------ preparação

func _run(job: Dictionary) -> Dictionary:
	var kind := String(job.kind)
	var cells := int(job.cells)
	var img := _load(String(job.src))
	if img == null:
		return {}
	_key_neutral(img, float(job.get("neutralize", 1.0)))
	var seg := _segment(img, cells)
	var frames: Array = []
	for rect in seg.rects:
		var part := img.get_region(rect)
		var w := part.get_width()
		var h := part.get_height()
		var a := _alpha(part)
		var f := {"part": part, "rect": rect}
		var core := _bbox(a, w, h, A_CORE)
		f["anchor"] = Vector2(core.position) + Vector2(core.size) * 0.5
		f["size"] = float(core.size.x)
		f["anchor_source"] = "box"
		if kind == "ring":
			var ring := _ring(a, w, h)
			if not ring.is_empty() and ring.r > 0.0:
				f["ring_r"] = ring.r
				f["ring_c"] = ring.c
		frames.append(f)
	if kind == "ring":
		_pick_ring_centers(frames)
		for f in frames:
			if f.has("ring_r"):
				_fade_outside(f.part, f.anchor, float(f.ring_r) + FADE_START, float(f.ring_r) + FADE_END)
				f["size"] = float(f.ring_r)
	var wanted := float(job.size)
	var mean := 0.0
	for f in frames:
		mean += float(f.size)
	mean /= float(frames.size())
	var scale := wanted / mean
	var target := Vector2(128, 128)
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
	var atlas := Image.create(CELL * frames.size(), CELL, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(1, 1, 1, 0))
	for i in frames.size():
		var f: Dictionary = frames[i]
		var part: Image = f.part
		var used := part.get_used_rect()
		var piece := part.get_region(used)
		var at := Vector2i((target + (Vector2(used.position) - (f.anchor as Vector2)) * final_scale).round())
		piece.resize(maxi(1, roundi(piece.get_width() * final_scale)), maxi(1, roundi(piece.get_height() * final_scale)), Image.INTERPOLATE_LANCZOS)
		atlas.blit_rect(piece, Rect2i(Vector2i.ZERO, piece.get_size()), at + Vector2i(i * CELL, 0))
	var out := _path(String(job.out))
	DirAccess.make_dir_recursive_absolute(out.get_base_dir())
	atlas.save_png(out)
	var report := _measure(atlas, kind, frames.size())
	report["id"] = job.id
	report["out"] = job.out
	report["source_size"] = [img.get_width(), img.get_height()]
	report["scale"] = snappedf(final_scale, 0.0001)
	report["wanted_scale"] = snappedf(scale, 0.0001)
	report["capped_by_margin"] = capped
	report["segmentation_exact"] = seg.exact
	report["spark_runs_ignored"] = seg.sparks
	report["neutralize"] = float(job.get("neutralize", 1.0))
	var src_frames: Array = []
	for f in frames:
		src_frames.append({"rect": [f.rect.position.x, f.rect.position.y, f.rect.size.x, f.rect.size.y], "anchor": [snappedf(f.anchor.x, 0.1), snappedf(f.anchor.y, 0.1)], "size": snappedf(f.size, 0.1), "anchor_source": f.anchor_source})
	report["source_frames"] = src_frames
	if job.has("report"):
		var rp := _path(String(job.report))
		DirAccess.make_dir_recursive_absolute(rp.get_base_dir())
		var fh := FileAccess.open(rp, FileAccess.WRITE)
		fh.store_string(JSON.stringify(report, "\t"))
		fh.close()
	print("gravou ", job.out, " ", atlas.get_size(), " escala ", snappedf(final_scale, 0.0001), " (desejada ", snappedf(scale, 0.0001), ")", " CAPADA" if capped else "", "" if seg.exact else " SEGMENTACAO_POR_GRADE")
	return report

## O centro do anel só vale quando o raio bate com o dos quadros e o centro não foge da caixa do corpo; senão fica a caixa.
func _pick_ring_centers(frames: Array) -> void:
	var radii: Array = []
	for f in frames:
		if float(f.get("ring_r", 0.0)) > 0.0:
			radii.append(float(f.ring_r))
	radii.sort()
	var median := float(radii[radii.size() / 2]) if not radii.is_empty() else 0.0
	for f in frames:
		if not f.has("ring_c") or median <= 0.0:
			continue
		if absf(float(f.ring_r) - median) > median * 0.15:
			f.erase("ring_r")
			continue
		if (f.ring_c as Vector2).distance_to(f.anchor) > 12.0:
			continue
		f["anchor"] = f.ring_c
		f["anchor_source"] = "ring"

## Desvanece o alfa entre `r0` e `r1` do centro e apaga além de `r1`: faíscas soltas que obrigariam a encolher o anel somem, sem borda nítida no halo.
func _fade_outside(part: Image, center: Vector2, r0: float, r1: float) -> void:
	var w := part.get_width()
	var h := part.get_height()
	var d := part.get_data()
	for y in h:
		for x in w:
			var dist := Vector2(float(x) - center.x, float(y) - center.y).length()
			if dist <= r0:
				continue
			var i := (y * w + x) * 4
			if dist >= r1:
				d[i] = 255
				d[i + 1] = 255
				d[i + 2] = 255
				d[i + 3] = 0
			else:
				var t := (dist - r0) / (r1 - r0)
				d[i + 3] = roundi(float(d[i + 3]) * (1.0 - t * t * (3.0 - 2.0 * t)))
	part.set_data(w, h, false, Image.FORMAT_RGBA8, d)

# ------------------------------------------------------------------ medição do resultado

func _cell_alpha(a: PackedByteArray, w: int, i: int) -> PackedByteArray:
	var cell := PackedByteArray()
	cell.resize(CELL * CELL)
	for y in CELL:
		for x in CELL:
			cell[y * CELL + x] = a[y * w + i * CELL + x]
	return cell

func _measure(atlas: Image, kind: String, n: int) -> Dictionary:
	var w := atlas.get_width()
	var a := _alpha(atlas)
	var data := atlas.get_data()
	var min_channel := 255
	for i in a.size():
		if a[i] >= A_USED:
			min_channel = mini(min_channel, mini(int(data[i * 4]), mini(int(data[i * 4 + 1]), int(data[i * 4 + 2]))))
	var rows: Array = []
	var energies: Array = []
	var cells_a: Array = []
	for i in n:
		var cell := _cell_alpha(a, w, i)
		cells_a.append(cell)
		var used := _bbox(cell, CELL, CELL, A_USED)
		var core := _bbox(cell, CELL, CELL, A_CORE)
		var border := 0
		for k in CELL:
			border = maxi(border, maxi(int(cell[k]), maxi(int(cell[(CELL - 1) * CELL + k]), maxi(int(cell[k * CELL]), int(cell[k * CELL + CELL - 1])))))
		var e := 0.0
		for v in cell:
			e += float(v)
		energies.append(e)
		var row := {"frame": i + 1, "used": [used.position.x, used.position.y, used.end.x, used.end.y], "core": [core.position.x, core.position.y, core.end.x, core.end.y],
			"margin_min": mini(mini(used.position.x, used.position.y), mini(CELL - used.end.x, CELL - used.end.y)), "border_alpha_max": border, "energy_k": snappedf(e / 1000.0, 1.0)}
		if kind == "lane" or kind == "aim":
			row.merge(_strip_metrics(cell, core))
		else:
			var ring := _ring(cell, CELL, CELL)
			if not ring.is_empty():
				row["ring_center"] = [snappedf(ring.c.x, 0.1), snappedf(ring.c.y, 0.1)]
				row["ring_radius"] = ring.r
		rows.append(row)
	var mean_e := 0.0
	for e in energies:
		mean_e += float(e)
	mean_e /= float(n)
	var freeze := 0
	for i in n:
		if absf(float(energies[i]) - mean_e) < absf(float(energies[freeze]) - mean_e):
			freeze = i
	var diffs: Array = []
	for i in n:
		diffs.append(snappedf(_alpha_diff(cells_a[i], cells_a[(i + 1) % n]), 0.0001))
	var adj := 0.0
	for i in n - 1:
		adj += float(diffs[i])
	adj /= float(maxi(n - 1, 1))
	return {"size": [atlas.get_width(), atlas.get_height()], "neutral_min_channel_of_visible": min_channel, "frames": rows,
		"energy_min_max": snappedf(float(energies.min()) / float(energies.max()), 0.01),
		"freeze_frame_index": freeze, "freeze_frame_note": "quadro de energia mais próxima da média; sugestão para 'Impacto reduzido'",
		"adjacent_diffs_incl_wrap": diffs, "wrap_ratio": snappedf(float(diffs[n - 1]) / maxf(adj, 0.00001), 0.01)}

func _alpha_diff(a: PackedByteArray, b: PackedByteArray) -> float:
	var sum := 0
	var k := 0
	for y in range(0, CELL, 2):
		for x in range(0, CELL, 2):
			sum += absi(int(a[y * CELL + x]) - int(b[y * CELL + x]))
			k += 1
	return float(sum) / float(k) / 255.0

## Fatias da barra (esquerda, miolo, direita) e espessura/uniformidade do miolo, para o BossVfx.BEAM e a escala `k` na integração.
## Espessura = extensão vertical visível (alfa >= A_USED) do miolo, média das colunas; é a largura que o golpe parece ter (inclui o halo).
func _strip_metrics(cell: PackedByteArray, core: Rect2i) -> Dictionary:
	var e_l := 0.0
	var e_m := 0.0
	var e_r := 0.0
	var e_out := 0.0
	for y in CELL:
		for x in CELL:
			var v := float(cell[y * CELL + x])
			if v <= 0.0:
				continue
			if x >= CAP_M.x and x < CAP_M.y:
				e_m += v
			elif x >= CAP_L.x and x < CAP_L.y:
				e_l += v
			elif x >= CAP_R.x and x < CAP_R.y:
				e_r += v
			else:
				e_out += v
	var total := maxf(1.0, e_l + e_m + e_r + e_out)
	var cols: Array = []
	var lo := 999
	var hi := 0
	var th_sum := 0
	for x in range(CAP_M.x, CAP_M.y):
		var s := 0
		var first := -1
		var last := -1
		for y in CELL:
			var v := int(cell[y * CELL + x])
			s += v
			if v >= A_USED:
				if first < 0:
					first = y
				last = y
		var n := (last - first + 1) if first >= 0 else 0
		cols.append(s)
		lo = mini(lo, n)
		hi = maxi(hi, n)
		th_sum += n
	var mean := 0.0
	for s in cols:
		mean += float(s)
	mean /= float(cols.size())
	var v2 := 0.0
	for s in cols:
		v2 += (float(s) - mean) * (float(s) - mean)
	return {"energy_share": {"tampa_esq": snappedf(e_l / total, 0.001), "miolo": snappedf(e_m / total, 0.001), "tampa_dir": snappedf(e_r / total, 0.001), "fora_das_fatias": snappedf(e_out / total, 0.001)},
		"mid_span_px": [lo, hi], "mid_span_avg": snappedf(float(th_sum) / float(cols.size()), 0.1), "mid_cv": snappedf(sqrt(v2 / float(cols.size())) / maxf(mean, 1.0), 0.001),
		"body_center_y": snappedf(float(core.position.y + core.end.y) * 0.5, 0.1)}
