extends SceneTree
## Diagnóstico somente leitura do gate 1 do Durvall. Escreve só derivados no scratchpad (identificados).
const D := "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/"
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/derived/"
const TOL := 0.22

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	var res := {}
	for name in ["durvall_idle_se_v01", "durvall_idle_se_v02", "durvall_walk_se_v01", "durvall_walk_se_v02"]:
		var img := Image.load_from_file(D + name + ".png")
		img.convert(Image.FORMAT_RGBA8)
		var raw: Image = img.duplicate()
		var keyed := _key_magenta_prod(img)
		keyed.save_png(OUT + "KEYED_" + name + ".png")
		res[name] = _halo(raw, keyed)
		res[name]["figuras"] = _figs(keyed, name)
	# A x B em cor (walk) contra o ruído de "mesma pose" (idle)
	for v in ["v01", "v02"]:
		var w := Image.load_from_file(OUT + "KEYED_durvall_walk_se_" + v + ".png")
		var i := Image.load_from_file(OUT + "KEYED_durvall_idle_se_" + v + ".png")
		res["colordiff_" + v] = {
			"walk_A_vs_B": _cdiff(w, 0, 2), "walk_A_vs_P": _cdiff(w, 0, 1), "walk_P_vs_B": _cdiff(w, 1, 2),
			"idle_1_vs_3 (mesma pose, referência de ruído)": _cdiff(i, 0, 2), "idle_1_vs_2": _cdiff(i, 0, 1)}
		_overlay(w, v)
	var f := FileAccess.open(OUT + "diag.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "  "))
	f.close()
	print(JSON.stringify(res, "  "))
	quit()

func _key_magenta_prod(src: Image) -> Image:
	# mesma lógica de tools/asset_prep.gd::_key_magenta (cópia, para medir o resultado de produção)
	var img: Image = src.duplicate()
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
			if d < TOL:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			elif d < TOL * 2.2:
				var a := clampf((d - TOL) / (TOL * 1.2), 0.0, 1.0)
				img.set_pixel(x, y, Color(minf(c.r, c.g + 0.25), c.g, minf(c.b, c.g + 0.25), a))
	return img

func _halo(raw: Image, keyed: Image) -> Dictionary:
	var w := keyed.get_width()
	var h := keyed.get_height()
	# profundidade (4-conexa) a partir de pixels transparentes, até 6
	var depth := PackedByteArray()
	depth.resize(w * h)
	var cur := PackedInt32Array()
	for i in w * h:
		if keyed.get_pixel(i % w, i / w).a < 0.5:
			depth[i] = 0
		else:
			depth[i] = 255
	for y in h:
		for x in w:
			var i := y * w + x
			if depth[i] == 255:
				for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
					var nx: int = x + d[0]
					var ny: int = y + d[1]
					if nx >= 0 and ny >= 0 and nx < w and ny < h and depth[ny * w + nx] == 0:
						depth[i] = 1
						cur.append(i)
						break
	for level in range(2, 7):
		var nxt := PackedInt32Array()
		for i in cur:
			var x := i % w
			var y := i / w
			for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
				var nx: int = x + d[0]
				var ny: int = y + d[1]
				if nx >= 0 and ny >= 0 and nx < w and ny < h and depth[ny * w + nx] == 255:
					depth[ny * w + nx] = level
					nxt.append(ny * w + nx)
		cur = nxt
	var tot := {}
	var mag := {}
	var semi := 0
	var raw_band := 0
	var raw_edge := 0
	for y in h:
		for x in w:
			var i := y * w + x
			var c := keyed.get_pixel(x, y)
			if c.a > 0.0 and c.a < 1.0:
				semi += 1
			var dp: int = depth[i]
			if dp >= 1 and dp <= 6:
				tot[dp] = tot.get(dp, 0) + 1
				var m := (minf(c.r, c.b) - c.g) * 255.0
				if m > 40.0:
					mag[dp] = mag.get(dp, 0) + 1
	# a métrica antiga do verificador (bruto, borda com 4 vizinhos de fundo, dist < 2,2*tol)
	var out := {"semitransparentes_apos_chave": semi, "profundidade": {}}
	for dp in range(1, 7):
		var t: int = tot.get(dp, 0)
		out.profundidade[str(dp)] = {"pixels": t, "magenta_residual_pct": snappedf(100.0 * float(mag.get(dp, 0)) / maxf(float(t), 1.0), 0.1)}
	return out

func _figs(keyed: Image, name: String) -> Array:
	var w := keyed.get_width()
	var h := keyed.get_height()
	var out := []
	var n := 3
	for k in n:
		var x0 := k * w / n
		var x1 := (k + 1) * w / n
		var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
		for y in h:
			for x in range(x0, x1):
				if keyed.get_pixel(x, y).a > 0.5:
					minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
		out.append([minx, miny, maxx, maxy])
	return out

func _bbox(img: Image, k: int) -> Rect2i:
	var w := img.get_width()
	var h := img.get_height()
	var x0 := k * w / 3
	var x1 := (k + 1) * w / 3
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in h:
		for x in range(x0, x1):
			if img.get_pixel(x, y).a > 0.5:
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	return Rect2i(minx, miny, maxx - minx + 1, maxy - miny + 1)

func _cdiff(img: Image, a: int, b: int) -> Dictionary:
	var ra := _bbox(img, a)
	var rb := _bbox(img, b)
	var hh := mini(ra.size.y, rb.size.y)
	var sum := 0.0
	var cnt := 0
	var sil := 0
	var uni := 0
	var ww := mini(ra.size.x, rb.size.x)
	# alinha pelo pé (base) e pelo centro horizontal da caixa
	for y in hh:
		for x in ww:
			var pa := Vector2i(ra.position.x + ra.size.x / 2 - ww / 2 + x, ra.position.y + ra.size.y - hh + y)
			var pb := Vector2i(rb.position.x + rb.size.x / 2 - ww / 2 + x, rb.position.y + rb.size.y - hh + y)
			var ca := img.get_pixel(pa.x, pa.y)
			var cb := img.get_pixel(pb.x, pb.y)
			var fa := ca.a > 0.5
			var fb := cb.a > 0.5
			if fa or fb:
				uni += 1
				if fa != fb:
					sil += 1
			if fa and fb:
				sum += (absf(ca.r - cb.r) + absf(ca.g - cb.g) + absf(ca.b - cb.b)) / 3.0
				cnt += 1
	return {"silhueta_xor_pct": snappedf(100.0 * sil / maxf(uni, 1.0), 0.1), "cor_media_abs_0a255": snappedf(255.0 * sum / maxf(cnt, 1.0), 0.1)}

func _overlay(img: Image, v: String) -> void:
	# derivado de inspeção: A (vermelho) e B (ciano) sobrepostos pelo pé; P à parte não entra
	var ra := _bbox(img, 0)
	var rb := _bbox(img, 2)
	var W := maxi(ra.size.x, rb.size.x) + 40
	var H := maxi(ra.size.y, rb.size.y) + 40
	var out := Image.create(W, H, false, Image.FORMAT_RGBA8)
	out.fill(Color(0.1, 0.1, 0.12, 1))
	for y in ra.size.y:
		for x in ra.size.x:
			var c := img.get_pixel(ra.position.x + x, ra.position.y + y)
			if c.a > 0.5:
				var ox := 20 + (W - 40 - ra.size.x) / 2 + x
				var oy := H - 20 - ra.size.y + y
				out.set_pixel(ox, oy, Color(1, 0.2, 0.2, 1))
	for y in rb.size.y:
		for x in rb.size.x:
			var c := img.get_pixel(rb.position.x + x, rb.position.y + y)
			if c.a > 0.5:
				var ox := 20 + (W - 40 - rb.size.x) / 2 + x
				var oy := H - 20 - rb.size.y + y
				var prev := out.get_pixel(ox, oy)
				out.set_pixel(ox, oy, Color(0.2, 1, 1, 1) if prev.r < 0.5 else Color(1, 1, 1, 1))
	out.save_png(OUT + "OVERLAY_A_vermelho_B_ciano_walk_" + v + ".png")
