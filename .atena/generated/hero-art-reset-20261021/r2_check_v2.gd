extends SceneTree
## Verificador somente leitura v2 (R2, contrato r2). Roda fora do projeto, sem --path:
##   godot --headless --script r2_check_v2.gd -- <imagem.png> <magenta|gray> <figuras> <idle|walk4|walk2|walk3|grid> [saida.json] [--noise-from idle.json] [--crops pernas.png]
## Tipos: idle = fila de 3 (calibração: a 1ª) · walk4 = grade 2x2 A,P1,B,P2 (calibração: P1) · walk2 = fila de 2 A,P1 (s/n de herói simétrico)
##        walk3 = fila de 3 A,P,B (formato antigo do contrato r1, só para reavaliar v01/v02) · grid = 2x2 de ataque/ativa/morte (calibração: a 1ª)
## Mudanças em relação ao v1 (ver DIAGNOSTICO.md do gate 1):
##  - halo: medido depois do recorte de produção (mesma lógica de tools/asset_prep.gd::_key_magenta), a partir de 3 px de profundidade
##  - pontos soltos: na escala de produção (figura a ~400 px de altura), só os que ainda apareceriam
##  - alternância de pernas: A x B e P1 x P2 comparados com o ruído de "mesma pose" (do idle da mesma série), com 3 estados
## Estados por critério: PASSA, FALHA, INCERTO (olhar os recortes --crops). O 5b (A diferente de B) nunca reprova sozinho: a métrica de cor só vê pixels sobrepostos. Veredito: REPROVA se houver FALHA; PASSA_COM_ITENS_A_VISTA se houver INCERTO.
## Opção --crops <png>: grava as pernas (metade de baixo) de A, B, P1 (e P2) lado a lado, sobre cinza, para decidir os itens INCERTO à vista.
## Código de saída: 0 PASSA, 3 PASSA_COM_ITENS_A_VISTA, 1 REPROVA, 2 erro de uso.
## Limites marcados PROVISÓRIO são calibrados na primeira imagem que o dono aceitar; não foram ajustados para aprovar nenhuma imagem.

const MIN_AREA := 4000
const BLOCK := 4
const DILATE_CELLS := 5
const TOL := 0.22                 # tolerância da chave, igual à de asset_prep
const LIM_SCALE := 0.06
const LIM_FEET := 0.03
const LIM_POSE_SIL := 0.08        # A x P1 e B x P1: diferença de silhueta mínima
const HALO_LO := 3                # a partir desta profundidade (px) o halo não pode mais existir
const HALO_HI := 4
const HALO_BASE_LO := 8
const HALO_BASE_HI := 10
const LIM_HALO_EXCESS_PP := 5.0   # PROVISÓRIO: até aqui PASSA
const LIM_HALO_FAIL_PP := 10.0    # PROVISÓRIO: acima daqui FALHA; entre os dois, INCERTO (olhar a franja a 400 px; a 64 px ela não aparece)
const PROD_HEIGHT := 400.0        # altura da figura na célula de produção
const SPECK_MIN := 3.0            # área mínima na escala de produção para o ponto ainda aparecer
const SPECK_MAX := 60.0
const LEGS_PASS := 1.6            # PROVISÓRIO: diferença das pernas / ruído
const SIL_PASS := 2.0             # PROVISÓRIO: diferença de silhueta P1xP2 / ruído
const SIL_FAIL := 1.3             # PROVISÓRIO
const NOISE_LEGS_DEFAULT := 34.0  # médio medido no idle v01/v02 do Durvall (31,6 a 36,7)
const NOISE_SIL_DEFAULT := 0.05   # idem (4,6% a 5,3%)

var W := 0
var H := 0
var rgba: PackedByteArray
var key_kind := "magenta"
var pm: PackedByteArray           # máscara de produção (1 = opaco depois do recorte)
var figs: Array = []

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() < 4:
		printerr("uso: -- <imagem> <magenta|gray> <figuras> <idle|walk4|walk2|walk3|grid> [saida.json] [--noise-from idle.json] [--crops pernas.png]")
		quit(2)
		return
	var path := a[0]
	key_kind = a[1]
	var expected := int(a[2])
	var kind := a[3]
	var out_path := ""
	var noise_from := ""
	var crops := ""
	var i := 4
	while i < a.size():
		if a[i] == "--noise-from" and i + 1 < a.size():
			noise_from = a[i + 1]
			i += 2
		elif a[i] == "--crops" and i + 1 < a.size():
			crops = a[i + 1]
			i += 2
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
	var report := _analyze(path, expected, kind, noise_from)
	if crops != "" and figs.size() >= 2:
		_write_crops(crops, kind)
	if out_path != "":
		var f := FileAccess.open(out_path, FileAccess.WRITE)
		f.store_string(JSON.stringify(report, "  "))
		f.close()
	var v: String = report.verdict
	quit(0 if v == "PASSA" else (3 if v == "PASSA_COM_ITENS_A_VISTA" else 1))

# ---------------------------------------------------------------- cor e máscaras
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

func _prod_opaque(i: int) -> bool:
	# asset_prep::_key_magenta: d = max(1-r, g, 1-b); alfa = clamp((d - tol) / (tol * 1.2)); opaco se alfa > 0,5
	var r := float(rgba[i * 4]) / 255.0
	var g := float(rgba[i * 4 + 1]) / 255.0
	var b := float(rgba[i * 4 + 2]) / 255.0
	var d := maxf(maxf(1.0 - r, g), 1.0 - b)
	return d > TOL * 1.6

func _magentaness(i: int) -> float:
	# depois do despill de produção: (min(r', b') - g) em 0..255, r' = min(r, g+0,25), b' = min(b, g+0,25)
	var r := float(rgba[i * 4]) / 255.0
	var g := float(rgba[i * 4 + 1]) / 255.0
	var b := float(rgba[i * 4 + 2]) / 255.0
	var rp := minf(r, g + 0.25)
	var bp := minf(b, g + 0.25)
	return (minf(rp, bp) - g) * 255.0

# ---------------------------------------------------------------- análise
func _analyze(path: String, expected: int, kind: String, noise_from: String) -> Dictionary:
	var tol := 0.22 if key_kind == "magenta" else 0.08
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
	for i in W * H:
		if bg[i] == 0:
			fg[i] = 1
	_find_clusters(fg, kind)
	# máscara de produção
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
		out_figs.append({"i": k + 1, "x": f.minx, "y": f.miny, "w": f.maxx - f.minx + 1, "h": f.maxy - f.miny + 1, "feet_y": f.maxy, "touches_edge": f.minx <= 0 or f.miny <= 0 or f.maxx >= W - 1 or f.maxy >= H - 1})
	# 1 figuras
	var edge := out_figs.any(func(o): return o.touches_edge)
	checks["1_figuras"] = "PASSA" if (figs.size() == expected and not edge) else "FALHA"
	if figs.size() != expected:
		notes.append("1_figuras: esperava %d, achei %d" % [expected, figs.size()])
	if edge:
		notes.append("1_figuras: há figura encostando na borda da imagem")
	var cal := _cal_index(kind)
	if figs.size() == expected and cal < figs.size():
		var ch: float = out_figs[cal].h
		var worst := 0.0
		var scale_applies := kind != "grid"
		for o in out_figs:
			worst = maxf(worst, absf(o.h - ch) / ch)
		if scale_applies:
			checks["3_escala"] = "PASSA" if worst <= LIM_SCALE else "FALHA"
			notes.append("3_escala: pior diferença de altura contra a calibração = %.1f%% (limite %.0f%%; o vaivém do corpo na caminhada é esperado)" % [worst * 100.0, LIM_SCALE * 100.0])
		else:
			notes.append("3_escala: não se aplica à grade de ação; a escala vem da calibração")
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
		checks["4_pes"] = "PASSA" if worst_feet <= LIM_FEET else "FALHA"
		notes.append("4_pes: variação da linha dos pés = %.1f%% da altura (limite %.0f%%)" % [worst_feet * 100.0, LIM_FEET * 100.0])
	else:
		checks["3_escala"] = "FALHA"
		checks["4_pes"] = "FALHA"
		notes.append("3 e 4 não avaliados: número de figuras diferente do esperado")
	# 2 fundo (halo depois do recorte de produção)
	var halo := _halo()
	if key_kind == "magenta":
		checks["2_fundo"] = "PASSA" if halo.excess_pp <= LIM_HALO_EXCESS_PP else ("FALHA" if halo.excess_pp > LIM_HALO_FAIL_PP else "INCERTO")
		notes.append("2_fundo: resíduo magenta a %d-%d px depois do recorte de produção = %.1f%%, linha de base (%d-%d px) = %.1f%%, excesso = %.1f pontos (PASSA <= %.0f, FALHA > %.0f, entre os dois = INCERTO)" % [HALO_LO, HALO_HI, halo.mid * 100.0, HALO_BASE_LO, HALO_BASE_HI, halo.base * 100.0, halo.excess_pp, LIM_HALO_EXCESS_PP, LIM_HALO_FAIL_PP])
	else:
		notes.append("2_fundo: informativo para chave cinza (cinza legítimo da figura se confunde com a chave); não avaliado")
	# 6 pontos soltos na escala de produção
	var sc := 1.0
	if cal < figs.size():
		sc = PROD_HEIGHT / float(figs[cal].maxy - figs[cal].miny + 1)
	var specks := _specks(sc)
	var total := 0
	for s in specks:
		total += s
	checks["6_pontos_soltos"] = "PASSA" if total == 0 else "FALHA"
	notes.append("6_pontos_soltos: %d na escala de produção (figura a %.0f px; contados os componentes de %.0f a %.0f px² nessa escala)" % [total, PROD_HEIGHT, SPECK_MIN, SPECK_MAX])
	for k in out_figs.size():
		out_figs[k]["specks_prod"] = specks[k] if k < specks.size() else 0
	# 5 movimento
	var noise := {"legs": NOISE_LEGS_DEFAULT, "sil": NOISE_SIL_DEFAULT, "fonte": "padrão provisório"}
	if noise_from != "":
		var js = JSON.parse_string(FileAccess.get_file_as_string(noise_from))
		if js is Dictionary and js.has("movimento") and js.movimento.has("noise"):
			noise = {"legs": float(js.movimento.noise.legs_color), "sil": float(js.movimento.noise.sil_xor), "fonte": noise_from}
		else:
			printerr("aviso: ", noise_from, " não tem movimento.noise (rode o idle da mesma série primeiro); usando o ruído padrão provisório")
	var motion := {}
	if figs.size() == expected:
		if kind == "idle" and figs.size() >= 3:
			motion["noise"] = {"legs_color": _legs_color(0, 2), "legs_color_01": _legs_color(0, 1), "sil_xor": _sil_xor(0, 2)}
			notes.append("idle: ruído de 'mesma pose' medido: pernas %.1f, silhueta %.1f%% (use --noise-from neste JSON nas caminhadas)" % [motion.noise.legs_color, motion.noise.sil_xor * 100.0])
		elif kind == "walk4" and figs.size() == 4:
			_motion_walk(checks, notes, motion, 0, 1, 2, 3, noise)
		elif kind == "walk2" and figs.size() == 2:
			var s := _sil_xor(0, 1)
			checks["5a_contato_x_passagem"] = "PASSA" if s >= LIM_POSE_SIL else "FALHA"
			notes.append("5a: A x P1 silhueta = %.1f%% (mínimo %.0f%%)" % [s * 100.0, LIM_POSE_SIL * 100.0])
			motion["sil_A_P1"] = s
		elif kind == "walk3" and figs.size() == 3:
			_motion_walk(checks, notes, motion, 0, 1, 2, -1, noise)
	var verdict := "PASSA"
	var has_uncertain := false
	for k in checks:
		if checks[k] == "FALHA":
			verdict = "REPROVA"
		elif checks[k] == "INCERTO":
			has_uncertain = true
	if verdict == "PASSA" and has_uncertain:
		verdict = "PASSA_COM_ITENS_A_VISTA"
	var res := {"arquivo": path, "tela": [W, H], "chave": key_kind, "tipo": kind, "esperadas": expected, "figuras": out_figs, "checagens": checks, "notas": notes, "halo": halo, "movimento": motion, "ruido_usado": noise, "verdict": verdict, "identidade_e_estilo": "decisão do dono (critérios 7 a 9)", "versao_verificador": "v2"}
	print("== ", path.get_file(), "  ", kind, "  ", W, "x", H, "  figuras ", figs.size(), "/", expected)
	for k in checks:
		print("  %-26s %s" % [k, checks[k]])
	for n in notes:
		print("    ", n)
	print("  veredito: ", verdict)
	return res

func _motion_walk(checks: Dictionary, notes: Array, motion: Dictionary, ia: int, ip: int, ib: int, ip2: int, noise: Dictionary) -> void:
	var sa := _sil_xor(ia, ip)
	var sb := _sil_xor(ib, ip)
	checks["5a_contato_x_passagem"] = "PASSA" if (sa >= LIM_POSE_SIL and sb >= LIM_POSE_SIL) else "FALHA"
	notes.append("5a: silhueta A x P1 = %.1f%%, B x P1 = %.1f%% (mínimo %.0f%%)" % [sa * 100.0, sb * 100.0, LIM_POSE_SIL * 100.0])
	var lab := _legs_color(ia, ib)
	var ratio: float = lab / float(noise.legs)
	# A cor só é comparada onde as duas figuras têm pixel opaco; num par correto isso pode dar pouco. Por isso o 5b nunca reprova sozinho.
	var state := "PASSA" if ratio >= LEGS_PASS else "INCERTO"
	checks["5b_A_diferente_de_B"] = state
	notes.append("5b: cor das pernas A x B = %.1f, ruído de mesma pose = %.1f, razão = %.2f (PASSA >= %.2f; abaixo disso INCERTO: nunca reprova sozinho, decidir pelo recorte --crops das pernas)" % [lab, float(noise.legs), ratio, LEGS_PASS])
	motion["legs_A_B"] = lab
	motion["legs_ratio"] = ratio
	motion["sil_A_P1"] = sa
	motion["sil_B_P1"] = sb
	if ip2 >= 0:
		var sp := _sil_xor(ip, ip2)
		var r2: float = sp / float(noise.sil)
		var st2 := "INCERTO"
		if r2 >= SIL_PASS:
			st2 = "PASSA"
		elif r2 <= SIL_FAIL:
			st2 = "FALHA"
		checks["5c_P1_diferente_de_P2"] = st2
		notes.append("5c: silhueta P1 x P2 = %.1f%%, ruído = %.1f%%, razão = %.2f (PASSA >= %.1f, FALHA <= %.1f)" % [sp * 100.0, float(noise.sil) * 100.0, r2, SIL_PASS, SIL_FAIL])
		motion["sil_P1_P2"] = sp
		motion["sil_ratio"] = r2

# ---------------------------------------------------------------- figuras
func _find_clusters(fg: PackedByteArray, kind: String) -> void:
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
	figs = []
	for l in cl:
		if cl[l].area >= MIN_AREA:
			figs.append(cl[l])
	if kind == "grid" or kind == "walk4":
		var rows := [[], []]
		for f in figs:
			rows[0 if (f.miny + f.maxy) / 2 < H / 2 else 1].append(f)
		var out := []
		for r in rows:
			r.sort_custom(func(a, b): return a.minx < b.minx)
			out.append_array(r)
		figs = out
	else:
		figs.sort_custom(func(a, b): return a.minx < b.minx)

func _cal_index(kind: String) -> int:
	return 1 if kind in ["walk4", "walk2", "walk3"] else 0

func _rows(out_figs: Array) -> Array:
	var rows := {}
	for o in out_figs:
		var r: int = 0 if o.y + o.h / 2 < H / 2 else 1
		if not rows.has(r):
			rows[r] = []
		rows[r].append(o)
	return rows.values()

# ---------------------------------------------------------------- halo (depois do recorte de produção)
func _halo() -> Dictionary:
	if key_kind != "magenta":
		return {"excess_pp": 0.0, "mid": 0.0, "base": 0.0, "por_profundidade": {}}
	var depth := PackedByteArray()
	depth.resize(W * H)
	var frontier := PackedInt32Array()
	for y in H:
		for x in W:
			var i := y * W + x
			if pm[i] == 0:
				depth[i] = 0
			else:
				depth[i] = 255
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
	var counts := []
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
								if pm[ni] == 1 and not seen.has(ni):
									seen[ni] = true
									st.append(ni)
					comps.append(area)
		comps.sort()
		comps.reverse()
		var n := 0
		for k in range(1, comps.size()):
			if comps[k] >= a_min and comps[k] <= a_max:
				n += 1
		counts.append(n)
	return counts

# ---------------------------------------------------------------- comparações entre figuras (alinhadas pelo pé e pelo centro da caixa)
func _legs_color(a: int, b: int) -> float:
	var fa: Dictionary = figs[a]
	var fb: Dictionary = figs[b]
	var ha: int = fa.maxy - fa.miny + 1
	var hb: int = fb.maxy - fb.miny + 1
	var wa: int = fa.maxx - fa.minx + 1
	var wb: int = fb.maxx - fb.minx + 1
	var hh := mini(ha, hb)
	var ww := mini(wa, wb)
	var sum := 0.0
	var cnt := 0
	for y in range(int(hh * 0.6), hh):
		for x in ww:
			var xa: int = fa.minx + wa / 2 - ww / 2 + x
			var ya: int = fa.maxy - hh + 1 + y
			var xb: int = fb.minx + wb / 2 - ww / 2 + x
			var yb: int = fb.maxy - hh + 1 + y
			var ia: int = ya * W + xa
			var ib: int = yb * W + xb
			if pm[ia] == 1 and pm[ib] == 1:
				sum += (absf(float(rgba[ia * 4]) - float(rgba[ib * 4])) + absf(float(rgba[ia * 4 + 1]) - float(rgba[ib * 4 + 1])) + absf(float(rgba[ia * 4 + 2]) - float(rgba[ib * 4 + 2]))) / 3.0
				cnt += 1
	return snappedf(sum / maxf(float(cnt), 1.0), 0.1)

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

func _write_crops(path: String, kind: String) -> void:
	# A, B, depois as passagens; metade de baixo de cada figura, na escala original, sobre cinza
	var order := [0, 2, 1] if kind in ["walk3"] else ([0, 2, 1, 3] if kind == "walk4" else [0, 1])
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
