extends SceneTree
## Teste da definição proposta para o critério 1 (separação por componentes com folga de 6 px, como o asset_prep). SOMENTE LEITURA; não altera o verificador.
##   godot --headless --script sep_check.gd
## Para cada imagem: máscara de produção (mesmo recorte do verificador), dilatação de 3 px (folga de 6 px entre componentes),
## componentes com área original >= 4000 px, e menor margem entre o conteúdo e a borda da imagem.
const ROOT := "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/"
const OUT := "F:/dev/abyss-megadungeon/.atena/generated/hero-r2-korrak-idle-measurement-20261022/sep_check_resultado.json"
const R := 3
const MIN_AREA := 4000
const CASES := [
	["durvall/durvall_idle_se_v01.png", 3], ["durvall/durvall_idle_se_v02.png", 3], ["korrak/korrak_idle_se_v01.png", 3],
	["durvall/durvall_walk_se_r3_E1_v01.png", 3], ["durvall/durvall_walk_se_r2_v01.png", 4], ["durvall/durvall_walk_se_r2_v02.png", 4], ["durvall/durvall_walk_se_r2_v03.png", 4],
	["durvall/durvall_attack_se_v02.png", 4], ["durvall/durvall_active_se_v02.png", 4], ["durvall/durvall_death_se_v03.png", 4],
	["durvall/durvall_walk_se_v01.png", 3], ["durvall/durvall_walk_se_v02.png", 3],
]

func _init() -> void:
	var res := []
	for c in CASES:
		var img := Image.load_from_file(ROOT + String(c[0]))
		if img == null:
			res.append({"arquivo": c[0], "erro": "não abriu"})
			continue
		img.convert(Image.FORMAT_RGBA8)
		var w := img.get_width()
		var h := img.get_height()
		var data := img.get_data()
		var m := PackedByteArray()
		m.resize(w * h)
		var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
		for y in h:
			for x in w:
				var i := (y * w + x) * 4
				var r := float(data[i]) / 255.0
				var g := float(data[i + 1]) / 255.0
				var b := float(data[i + 2]) / 255.0
				if maxf(maxf(1.0 - r, g), 1.0 - b) > 0.22 * 1.6:
					m[y * w + x] = 1
					minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
		# dilatação separável por raio R
		var t := PackedByteArray()
		t.resize(w * h)
		for y in h:
			var last := -99999
			for x in w:
				if m[y * w + x] == 1:
					last = x
				t[y * w + x] = 1 if x - last <= R else 0
			last = 99999
			for x in range(w - 1, -1, -1):
				if m[y * w + x] == 1:
					last = x
				if last - x <= R:
					t[y * w + x] = 1
		var d := PackedByteArray()
		d.resize(w * h)
		for x in w:
			var last := -99999
			for y in h:
				if t[y * w + x] == 1:
					last = y
				d[y * w + x] = 1 if y - last <= R else 0
			last = 99999
			for y in range(h - 1, -1, -1):
				if t[y * w + x] == 1:
					last = y
				if last - y <= R:
					d[y * w + x] = 1
		var label := PackedInt32Array()
		label.resize(w * h)
		var areas := {}
		var n := 0
		for s in w * h:
			if d[s] == 1 and label[s] == 0:
				n += 1
				label[s] = n
				var st := PackedInt32Array([s])
				var orig := 0
				while not st.is_empty():
					var cur: int = st[st.size() - 1]
					st.resize(st.size() - 1)
					if m[cur] == 1:
						orig += 1
					var cx := cur % w
					var cy := cur / w
					for dd in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
						var nx: int = cx + dd[0]
						var ny: int = cy + dd[1]
						if nx < 0 or ny < 0 or nx >= w or ny >= h:
							continue
						var ni: int = ny * w + nx
						if d[ni] == 1 and label[ni] == 0:
							label[ni] = n
							st.append(ni)
				areas[n] = orig
		var big := 0
		for k in areas:
			if areas[k] >= MIN_AREA:
				big += 1
		var margin := mini(mini(minx, miny), mini(w - 1 - maxx, h - 1 - maxy))
		res.append({"arquivo": c[0], "esperadas": c[1], "componentes_grandes": big, "separadas": big == int(c[1]), "menor_margem_da_imagem_px": margin})
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "  "))
	f.close()
	for r in res:
		print("%-44s esperadas %s  componentes %s  %s  margem %s px" % [r.arquivo, str(r.get("esperadas")), str(r.get("componentes_grandes")), "SEPARADAS" if r.get("separadas", false) else "NÃO SEPARADAS", str(r.get("menor_margem_da_imagem_px"))])
	quit()
