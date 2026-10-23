extends SceneTree
## Verificador somente leitura v3 (contrato r3). Roda fora do projeto, sem --path:
##   godot --headless --script r2_check_v3.gd -- <imagem.png> <magenta|gray> <figuras> <idle|walk3p|walk2|walk4|walk3|grid> [saida.json] [--crops pernas.png]
## Tipos: idle = fila de 3 (calibração: a 1ª) · walk3p = fila de 3 A, P1, P2 (calibração: P1)  [formato do contrato r3]
##        walk2 = fila de 2 A, P1 (s/n de herói simétrico) · grid = 2x2 de ataque/ativa/morte (calibração: a 1ª)
##        walk4 = grade 2x2 A, P1, B, P2 e walk3 = fila de 3 A, P, B (formatos antigos, só para reavaliar tentativas r1/r2)
## Mudanças em relação ao v2 (ver DIAGNOSTICO-E-PROPOSTA.md do walk SE r2):
##  - figuras agrupadas por ESPAÇO da imagem (quadrante, terço ou metade), não por vizinhança: o agrupamento do v2 fundia a fileira de cima com a de baixo
##  - figura que toca o limite do seu espaço reprova (o prompt pede margem)
##  - caminhada: critério de pés apoiados (necessário, não suficiente); removidos o 5b (A diferente de B) e o 5c por silhueta (falso positivo na v03)
##  - passagem (pé levantado ao lado da perna de apoio, joelho à frente) é SEMPRE decisão à vista: o veredito de uma caminhada nunca é PASSA, no máximo PASSA_COM_ITENS_A_VISTA
##  - pontos soltos: 0 PASSA, 1 a 6 INCERTO (listados com posição), mais de 6 FALHA
##  - grade de ação (grid): 5e poses diferentes (silhueta aos pares: PASSA >= 20%, FALHA < 6%, entre os dois INCERTO; PROVISÓRIO e não calibrado com dados de ação: a v03 do walk teria passado a 6%) e 5f gesto a olho; o veredito de uma grade nunca é PASSA (adicionado em 2026-10-22, caminhada pausada)
##  - informa o tremor horizontal do corpo (centro da caixa menos centróide do tronco), que a montagem deve eliminar alinhando pelo tronco
## Estados: PASSA, FALHA, INCERTO. Veredito: REPROVA se houver FALHA; PASSA_COM_ITENS_A_VISTA se houver INCERTO. Saída: 0 PASSA, 3 PASSA_COM_ITENS_A_VISTA, 1 REPROVA, 2 uso.
## Limites marcados PROVISÓRIO são calibrados na primeira imagem aceita pelo dono; não foram ajustados para aprovar nenhuma imagem.

const MIN_AREA := 4000
const BLOCK := 4
const DILATE_CELLS := 5
const TOL := 0.22
const LIM_SCALE := 0.06
const LIM_FEET := 0.03
const HALO_LO := 3
const HALO_HI := 4
const HALO_BASE_LO := 8
const HALO_BASE_HI := 10
const LIM_HALO_EXCESS_PP := 5.0   # PROVISÓRIO
const LIM_HALO_FAIL_PP := 10.0    # PROVISÓRIO
const PROD_HEIGHT := 400.0
const SPECK_MIN := 3.0
const SPECK_MAX := 60.0
const SPECK_UNCERTAIN_MAX := 6    # PROVISÓRIO: até aqui INCERTO; acima FALHA
const FEET_BAND := 0.06           # faixa mais baixa da figura (a espada não chega ali)
const FEET_GAP := 18
const FEET_MIN_W := 12
const STRIDE_MIN := 0.30          # PROVISÓRIO: afastamento mínimo dos pés no contato, em alturas da figura
const LIM_POSE_DIFF_FAIL := 0.06  # PROVISÓRIO: abaixo disto, duas figuras da grade são praticamente a mesma (ruído de mesma pose: ~5%)
const LIM_POSE_DIFF_PASS := 0.20  # PROVISÓRIO: a partir disto, passa sozinho; entre os dois, INCERTO (a v03 do walk, com quadros quase iguais, deu 11% a 18%)
const TORSO_LO := 0.15
const TORSO_HI := 0.50

var W := 0
var H := 0
var rgba: PackedByteArray
var key_kind := "magenta"
var pm: PackedByteArray
var figs: Array = []
var slots: Array = []

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() < 4:
		printerr("uso: -- <imagem> <magenta|gray> <figuras> <idle|walk3p|walk2|walk4|walk3|grid> [saida.json] [--crops pernas.png]")
		quit(2)
		return
	var path := a[0]
	key_kind = a[1]
	var expected := int(a[2])
	var kind := a[3]
	var out_path := ""
	var crops := ""
	var i := 4
	while i < a.size():
		if a[i] == "--crops" and i + 1 < a.size():
			crops = a[i + 1]
			i += 2
		elif a[i] == "--noise-from" and i + 1 < a.size():
			i += 2   # aceito e ignorado: o v3 não usa ruído de mesma pose
		else:
			out_path = a[i]
			i += 1
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
	if crops != "" and figs.size() >= 2:
		_write_crops(crops, kind)
	if out_path != "":
		var f := FileAccess.open(out_path, FileAccess.WRITE)
		f.store_string(JSON.stringify(report, "  "))
		f.close()
	var v: String = report.verdict
	quit(0 if v == "PASSA" else (3 if v == "PASSA_COM_ITENS_A_VISTA" else 1))

# ---------------------------------------------------------------- cor
func _dist_key(i: int) -> float:
	var r := float(rgba[i * 4])
	var g := float(rgba[i * 4 + 1])
	var b := float(rgba[i * 4 + 2])
	if key_kind == "magenta":
		return sqrt(pow(r - 255.0, 2) + pow(g, 2) + pow(b - 255.0, 2)) / 441.7
	var d := sqrt(pow(r - 180.0, 2) + pow(g - 180.0, 2) + pow(b - 180.0, 2)) / 441.7
	var sat := (maxf(r, maxf(g, b)) - minf(r, minf(g, b))) / 255.0
	return d if sat < 0.06 else 1.0

func _prod_opaque(i: int) -> bool:
	var r := float(rgba[i * 4]) / 255.0
	var g := float(rgba[i * 4 + 1]) / 255.0
	var b := float(rgba[i * 4 + 2]) / 255.0
	return maxf(maxf(1.0 - r, g), 1.0 - b) > TOL * 1.6

func _magentaness(i: int) -> float:
	var r := float(rgba[i * 4]) / 255.0
	var g := float(rgba[i * 4 + 1]) / 255.0
	var b := float(rgba[i * 4 + 2]) / 255.0
	return (minf(minf(r, g + 0.25), minf(b, g + 0.25)) - g) * 255.0

func _slots(kind: String) -> Array:
	if kind in ["grid", "walk4"]:
		return [Rect2i(0, 0, W / 2, H / 2), Rect2i(W / 2, 0, W - W / 2, H / 2), Rect2i(0, H / 2, W / 2, H - H / 2), Rect2i(W / 2, H / 2, W - W / 2, H - H / 2)]
	if kind in ["idle", "walk3p", "walk3"]:
		return [Rect2i(0, 0, W / 3, H), Rect2i(W / 3, 0, W / 3, H), Rect2i(2 * (W / 3), 0, W - 2 * (W / 3), H)]
	return [Rect2i(0, 0, W / 2, H), Rect2i(W / 2, 0, W - W / 2, H)]

func _cal_index(kind: String) -> int:
	return 1 if kind in ["walk3p", "walk2", "walk4", "walk3"] else 0

# ---------------------------------------------------------------- análise
func _analyze(path: String, expected: int, kind: String) -> Dictionary:
	var tol := 0.22 if key_kind == "magenta" else 0.08
	var bg := PackedByteArray()
	bg.resize(W * H)
	var stack := PackedInt32Array()
	for x in W:
		for y in [0, H - 1]:
			var i: int = y * W + x
			if bg[i] == 0 and _dist_key(i) < tol:
				bg[i] = 1
				stack.append(i)
	for y in H:
		for x in [0, W - 1]:
			var i: int = y * W + x
			if bg[i] == 0 and _dist_key(i) < tol:
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
			if bg[ni] == 0 and _dist_key(ni) < tol:
				bg[ni] = 1
				stack.append(ni)
	var fg := PackedByteArray()
	fg.resize(W * H)
	for i in W * H:
		if bg[i] == 0:
			fg[i] = 1
	slots = _slots(kind)
	figs = []
	var missing := 0
	for s in slots:
		var f := _largest_cluster(fg, s)
		if f.is_empty():
			missing += 1
		else:
			f["slot"] = s
			figs.append(f)
	pm = PackedByteArray()
	pm.resize(W * H)
	for i in W * H:
		if key_kind == "magenta":
			pm[i] = 1 if (fg[i] == 1 and _prod_opaque(i)) else 0
		else:
			pm[i] = fg[i]
	var checks := {}
	var notes := []
	var out_figs := []
	for k in figs.size():
		var f: Dictionary = figs[k]
		var s: Rect2i = f.slot
		var edge: bool = f.minx <= 0 or f.miny <= 0 or f.maxx >= W - 1 or f.maxy >= H - 1
		var slot_cross: bool = f.minx <= s.position.x or f.maxx >= s.end.x - 1 or f.miny <= s.position.y or f.maxy >= s.end.y - 1
		out_figs.append({"i": k + 1, "x": f.minx, "y": f.miny, "w": f.maxx - f.minx + 1, "h": f.maxy - f.miny + 1, "feet_y": f.maxy, "touches_edge": edge, "touches_slot": slot_cross})
	var any_bad := out_figs.any(func(o): return o.touches_edge or o.touches_slot)
	checks["1_figuras"] = "PASSA" if (missing == 0 and figs.size() == expected and not any_bad) else "FALHA"
	if missing > 0 or figs.size() != expected:
		notes.append("1_figuras: esperava %d figuras nos %d espaços, achei %d (espaços vazios: %d)" % [expected, slots.size(), figs.size(), missing])
	if any_bad:
		notes.append("1_figuras: há figura encostando na borda da imagem ou no limite do seu espaço (o prompt pede margem de 60 px)")
	var cal := _cal_index(kind)
	if missing == 0 and figs.size() == expected and cal < figs.size():
		var ch: float = out_figs[cal].h
		var worst := 0.0
		for o in out_figs:
			worst = maxf(worst, absf(o.h - ch) / ch)
		if kind != "grid":
			checks["3_escala"] = "PASSA" if worst <= LIM_SCALE else "FALHA"
			notes.append("3_escala: pior diferença de altura contra a calibração = %.1f%% (limite %.0f%%; o vaivém do corpo na caminhada é esperado)" % [worst * 100.0, LIM_SCALE * 100.0])
		else:
			notes.append("3_escala: não se aplica à grade de ação; a escala vem da calibração")
		var worst_feet := 0.0
		for r in _rows(out_figs):
			var lo := 99999
			var hi := -1
			var hmax := 1
			for o in r:
				lo = mini(lo, o.feet_y)
				hi = maxi(hi, o.feet_y)
				hmax = maxi(hmax, o.h)
			worst_feet = maxf(worst_feet, float(hi - lo) / float(hmax))
		checks["4_pes"] = "PASSA" if worst_feet <= LIM_FEET else "FALHA"
		notes.append("4_pes: variação da linha dos pés = %.1f%% da altura (limite %.0f%%)" % [worst_feet * 100.0, LIM_FEET * 100.0])
	else:
		checks["3_escala"] = "FALHA"
		checks["4_pes"] = "FALHA"
		notes.append("3 e 4 não avaliados: figuras ausentes ou em número diferente do esperado")
	var halo := _halo()
	if key_kind == "magenta":
		checks["2_fundo"] = "PASSA" if halo.excess_pp <= LIM_HALO_EXCESS_PP else ("FALHA" if halo.excess_pp > LIM_HALO_FAIL_PP else "INCERTO")
		notes.append("2_fundo: resíduo magenta a %d-%d px depois do recorte de produção = %.1f%%, linha de base = %.1f%%, excesso = %.1f pontos (PASSA <= %.0f, FALHA > %.0f, entre os dois INCERTO)" % [HALO_LO, HALO_HI, halo.mid * 100.0, halo.base * 100.0, halo.excess_pp, LIM_HALO_EXCESS_PP, LIM_HALO_FAIL_PP])
	else:
		notes.append("2_fundo: informativo para chave cinza; não avaliado")
	var sc := 1.0
	if cal < figs.size():
		sc = PROD_HEIGHT / float(figs[cal].maxy - figs[cal].miny + 1)
	var sp := _specks(sc)
	var total := 0
	var pos := []
	for k in sp.size():
		total += int(sp[k].count)
		for p in sp[k].pos:
			pos.append("fig %d (%d,%d)" % [k + 1, p.x, p.y])
	checks["6_pontos_soltos"] = "PASSA" if total == 0 else ("INCERTO" if total <= SPECK_UNCERTAIN_MAX else "FALHA")
	notes.append("6_pontos_soltos: %d na escala de produção (figura a %.0f px; %.0f a %.0f px²); posições: %s; fios de cabelo e o pomo da espada são tolerados à vista" % [total, PROD_HEIGHT, SPECK_MIN, SPECK_MAX, ", ".join(pos) if pos.size() > 0 else "nenhuma"])
	var motion := {}
	var is_walk := kind in ["walk3p", "walk2", "walk4", "walk3"]
	if missing == 0 and figs.size() == expected:
		var feet := []
		for k in figs.size():
			feet.append(_planted_feet(k))
		motion["pes_apoiados"] = feet
		if kind == "grid" and figs.size() == 4:
			var lowest := 1.0
			var which := ""
			var vals := []
			for p in range(4):
				for q in range(p + 1, 4):
					var d := _sil_xor(p, q)
					vals.append("%d-%d: %.1f%%" % [p + 1, q + 1, d * 100.0])
					if d < lowest:
						lowest = d
						which = "%d-%d" % [p + 1, q + 1]
			checks["5e_poses_diferentes"] = "PASSA" if lowest >= LIM_POSE_DIFF_PASS else ("FALHA" if lowest < LIM_POSE_DIFF_FAIL else "INCERTO")
			notes.append("5e: diferença de silhueta entre as figuras da grade, aos pares: %s; a menor é %s = %.1f%% (PASSA >= %.0f%%, FALHA < %.0f%%, entre os dois INCERTO: olhar as poses; PROVISÓRIO, calibrar na primeira grade de ação aceita)" % [", ".join(vals), which, lowest * 100.0, LIM_POSE_DIFF_PASS * 100.0, LIM_POSE_DIFF_FAIL * 100.0])
			motion["poses_xor"] = vals
			checks["5f_gesto_a_vista"] = "INCERTO"
			notes.append("5f: DECISÃO À VISTA: o gesto de cada pose (preparo, golpe, seguimento; ou impacto, queda, caído) lê como descrito na ficha do herói")
		if is_walk:
			var ia := 0
			var ip1 := 1
			var ip2 := -1
			if kind == "walk3p":
				ip2 = 2
			elif kind == "walk4":
				ip2 = 3
			var a_ok: bool = feet[ia].count == 2 and absf(float(feet[ia].x[1]) - float(feet[ia].x[0])) >= STRIDE_MIN
			checks["5a_contato_A_passada_larga"] = "PASSA" if a_ok else "FALHA"
			notes.append("5a: A tem %d pé(s) no chão em %s (exige 2, afastados >= %.2f da altura)" % [feet[ia].count, str(feet[ia].x), STRIDE_MIN])
			var p_ok: bool = feet[ip1].count == 1 and (ip2 < 0 or feet[ip2].count == 1)
			checks["5d_passagens_um_pe_no_chao"] = "PASSA" if p_ok else "FALHA"
			var ptxt := "P1 tem %d pé(s) no chão em %s" % [feet[ip1].count, str(feet[ip1].x)]
			if ip2 >= 0:
				ptxt += "; P2 tem %d pé(s) em %s" % [feet[ip2].count, str(feet[ip2].x)]
			notes.append("5d: " + ptxt + " (exige exatamente 1 em cada passagem: o outro pé está levantado). Necessário, não suficiente")
			checks["5c_passagem_a_vista"] = "INCERTO"
			notes.append("5c: DECISÃO À VISTA: em P1 e P2 o pé levantado fica ao lado da perna de apoio, na altura da canela, com o joelho à frente (não atrás nem longe à frente do corpo); use --crops e a prévia (make_walk_preview.ps1)")
		var jit := []
		for k in figs.size():
			jit.append(_torso_offset(k))
		var mn: float = jit.min()
		var mx: float = jit.max()
		motion["tremor_horizontal"] = {"por_quadro": jit.map(func(x): return snappedf(x, 0.001)), "amplitude": snappedf(mx - mn, 0.001), "px_a_64": snappedf((mx - mn) * 64.0, 0.1)}
		notes.append("tremor: (centro da caixa - tronco)/altura por figura = %s; amplitude %.3f = %.1f px a 64 px de altura se a montagem alinhasse pela caixa (a montagem deve alinhar pelo tronco)" % [str(motion.tremor_horizontal.por_quadro), motion.tremor_horizontal.amplitude, motion.tremor_horizontal.px_a_64])
	var verdict := "PASSA"
	var uncertain := false
	for k in checks:
		if checks[k] == "FALHA":
			verdict = "REPROVA"
		elif checks[k] == "INCERTO":
			uncertain = true
	if verdict == "PASSA" and uncertain:
		verdict = "PASSA_COM_ITENS_A_VISTA"
	var res := {"arquivo": path, "tela": [W, H], "chave": key_kind, "tipo": kind, "esperadas": expected, "figuras": out_figs, "checagens": checks, "notas": notes, "halo": halo, "movimento": motion, "verdict": verdict, "identidade_e_estilo": "decisão do dono (critérios 7 a 9)", "versao_verificador": "v3"}
	print("== ", path.get_file(), "  ", kind, "  ", W, "x", H, "  figuras ", figs.size(), "/", expected)
	for k in checks:
		print("  %-30s %s" % [k, checks[k]])
	for n in notes:
		print("    ", n)
	print("  veredito: ", verdict)
	return res

# ---------------------------------------------------------------- figuras por espaço
func _largest_cluster(fg: PackedByteArray, r: Rect2i) -> Dictionary:
	var lw := (W + BLOCK - 1) / BLOCK
	var lh := (H + BLOCK - 1) / BLOCK
	var low := PackedByteArray()
	low.resize(lw * lh)
	for y in range(r.position.y, r.end.y):
		for x in range(r.position.x, r.end.x):
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
	for y in range(r.position.y, r.end.y):
		for x in range(r.position.x, r.end.x):
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
	var best := {}
	for l in cl:
		if cl[l].area >= MIN_AREA and (best.is_empty() or cl[l].area > best.area):
			best = cl[l]
	return best

func _rows(out_figs: Array) -> Array:
	var rows := {}
	for o in out_figs:
		var r: int = 0 if o.y + o.h / 2 < H / 2 else 1
		if not rows.has(r):
			rows[r] = []
		rows[r].append(o)
	return rows.values()

# ---------------------------------------------------------------- pés apoiados e tremor
func _planted_feet(k: int) -> Dictionary:
	var f: Dictionary = figs[k]
	var h: int = f.maxy - f.miny + 1
	var y0: int = f.maxy - int(h * FEET_BAND)
	var cols := []
	for x in range(f.minx, f.maxx + 1):
		for y in range(y0, f.maxy + 1):
			if pm[y * W + x] == 1:
				cols.append(x)
				break
	var blobs := []
	var start := -1
	var prev := -1
	for x in cols:
		if start < 0:
			start = x
		elif x - prev > FEET_GAP:
			blobs.append([start, prev])
			start = x
		prev = x
	if start >= 0:
		blobs.append([start, prev])
	var cx: float = (f.minx + f.maxx) / 2.0
	var xs := []
	for b in blobs:
		if b[1] - b[0] >= FEET_MIN_W:
			xs.append(snappedf(((b[0] + b[1]) / 2.0 - cx) / float(h), 0.01))
	return {"count": xs.size(), "x": xs}

func _torso_offset(k: int) -> float:
	var f: Dictionary = figs[k]
	var h: int = f.maxy - f.miny + 1
	var sum := 0.0
	var cnt := 0
	for y in range(f.miny + int(h * TORSO_LO), f.miny + int(h * TORSO_HI) + 1):
		for x in range(f.minx, f.maxx + 1):
			if pm[y * W + x] == 1:
				sum += x
				cnt += 1
	return ((f.minx + f.maxx) / 2.0 - sum / maxf(float(cnt), 1.0)) / float(h)

# ---------------------------------------------------------------- halo
func _halo() -> Dictionary:
	if key_kind != "magenta":
		return {"excess_pp": 0.0, "mid": 0.0, "base": 0.0, "por_profundidade_pct": {}}
	var depth := PackedByteArray()
	depth.resize(W * H)
	var frontier := PackedInt32Array()
	for i in W * H:
		depth[i] = 0 if pm[i] == 0 else 255
	for y in H:
		for x in W:
			var i := y * W + x
			if depth[i] == 255:
				for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
					var nx: int = x + d[0]
					var ny: int = y + d[1]
					if nx >= 0 and ny >= 0 and nx < W and ny < H and depth[ny * W + nx] == 0:
						depth[i] = 1
						frontier.append(i)
						break
	var tot := {}
	var mag := {}
	for lv in range(1, HALO_BASE_HI + 1):
		tot[lv] = 0
		mag[lv] = 0
		if lv > 1:
			var nxt := PackedInt32Array()
			for i in frontier:
				var x := i % W
				var y := i / W
				for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
					var nx: int = x + d[0]
					var ny: int = y + d[1]
					if nx >= 0 and ny >= 0 and nx < W and ny < H and depth[ny * W + nx] == 255:
						depth[ny * W + nx] = lv
						nxt.append(ny * W + nx)
			frontier = nxt
		for i in frontier:
			tot[lv] += 1
			if _magentaness(i) > 40.0:
				mag[lv] += 1
	var by := {}
	for lv in range(1, HALO_BASE_HI + 1):
		by[str(lv)] = snappedf(100.0 * float(mag[lv]) / maxf(float(tot[lv]), 1.0), 0.1)
	var mt := 0
	var mm := 0
	for lv in range(HALO_LO, HALO_HI + 1):
		mt += tot[lv]
		mm += mag[lv]
	var bt := 0
	var bm := 0
	for lv in range(HALO_BASE_LO, HALO_BASE_HI + 1):
		bt += tot[lv]
		bm += mag[lv]
	var mid := float(mm) / maxf(float(mt), 1.0)
	var base := float(bm) / maxf(float(bt), 1.0)
	return {"excess_pp": snappedf(maxf(0.0, (mid - base) * 100.0), 0.1), "mid": mid, "base": base, "por_profundidade_pct": by}

# ---------------------------------------------------------------- pontos soltos na escala de produção
func _specks(sc: float) -> Array:
	var out := []
	var a_min := SPECK_MIN / (sc * sc)
	var a_max := SPECK_MAX / (sc * sc)
	for f in figs:
		var seen := {}
		var comps := []
		for y in range(f.miny, f.maxy + 1):
			for x in range(f.minx, f.maxx + 1):
				var i := y * W + x
				if pm[i] == 1 and not seen.has(i):
					var st := [i]
					seen[i] = true
					var area := 0
					var sx := 0
					var sy := 0
					while not st.is_empty():
						var c: int = st.pop_back()
						area += 1
						var cx := c % W
						var cy := c / W
						sx += cx
						sy += cy
						for dy in [-1, 0, 1]:
							for dx in [-1, 0, 1]:
								var nx: int = cx + dx
								var ny: int = cy + dy
								if nx < f.minx or nx > f.maxx or ny < f.miny or ny > f.maxy:
									continue
								var ni: int = ny * W + nx
								if pm[ni] == 1 and not seen.has(ni):
									seen[ni] = true
									st.append(ni)
					comps.append([area, sx / area, sy / area])
		comps.sort_custom(func(a, b): return a[0] > b[0])
		var count := 0
		var pos := []
		for k in range(1, comps.size()):
			if comps[k][0] >= a_min and comps[k][0] <= a_max:
				count += 1
				pos.append(Vector2i(comps[k][1], comps[k][2]))
		out.append({"count": count, "pos": pos})
	return out

# ---------------------------------------------------------------- diferença de silhueta entre duas figuras (alinhadas pelo pé e pelo centro da caixa)
func _sil_xor(a: int, b: int) -> float:
	var fa: Dictionary = figs[a]
	var fb: Dictionary = figs[b]
	var ha: int = fa.maxy - fa.miny + 1
	var hb: int = fb.maxy - fb.miny + 1
	var wa: int = fa.maxx - fa.minx + 1
	var wb: int = fb.maxx - fb.minx + 1
	var hh := mini(ha, hb)
	var ww := mini(wa, wb)
	var diff := 0
	var uni := 0
	for y in hh:
		for x in ww:
			var xa: int = fa.minx + wa / 2 - ww / 2 + x
			var ya: int = fa.maxy - hh + 1 + y
			var xb: int = fb.minx + wb / 2 - ww / 2 + x
			var yb: int = fb.maxy - hh + 1 + y
			var pa: bool = pm[ya * W + xa] == 1
			var pb: bool = pm[yb * W + xb] == 1
			if pa or pb:
				uni += 1
				if pa != pb:
					diff += 1
	return snappedf(float(diff) / maxf(float(uni), 1.0), 0.001)

# ---------------------------------------------------------------- recorte das pernas
func _write_crops(path: String, kind: String) -> void:
	var order: Array = [0, 1, 2]
	if kind == "walk4":
		order = [0, 2, 1, 3]
	elif kind == "walk2":
		order = [0, 1]
	var cw := 0
	var ch := 0
	for k in order:
		if k >= figs.size():
			continue
		var f: Dictionary = figs[k]
		cw += f.maxx - f.minx + 1 + 20
		ch = maxi(ch, (f.maxy - f.miny + 1) / 2 + 20)
	var out := Image.create(cw, ch, false, Image.FORMAT_RGBA8)
	out.fill(Color(0.45, 0.45, 0.48, 1))
	var ox := 10
	for k in order:
		if k >= figs.size():
			continue
		var f: Dictionary = figs[k]
		var h: int = f.maxy - f.miny + 1
		var y0: int = f.miny + h / 2
		for y in range(y0, f.maxy + 1):
			for x in range(f.minx, f.maxx + 1):
				var i := y * W + x
				if pm[i] == 1:
					out.set_pixel(ox + x - f.minx, ch - 10 - (f.maxy - y), Color8(rgba[i * 4], rgba[i * 4 + 1], rgba[i * 4 + 2], 255))
		ox += f.maxx - f.minx + 1 + 20
	out.save_png(path)
