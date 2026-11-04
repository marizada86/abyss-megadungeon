extends SceneTree
## Auditoria de padrões dos assets das evoluções (ícones e VFX), somente leitura. Saída: linhas OK / FALHA / INFO.
var fails := 0

func ok(cond: bool, msg: String) -> void:
	if cond:
		print("OK    ", msg)
	else:
		fails += 1
		print("FALHA ", msg)

func _img(path: String) -> Image:
	var tex := load(path) as Texture2D
	if tex == null:
		return null
	var im := tex.get_image()
	if im.is_compressed():
		im.decompress()
	im.convert(Image.FORMAT_RGBA8)
	return im

func _init() -> void:
	var weapons: Dictionary = Data.table("weapons")
	var passives: Dictionary = Data.table("passives")
	var new_weapons := ["estocada_transfixante", "vigilia_perpetua", "selo_da_retidao", "chicote_da_cobica", "machado_devorador", "abraco_dos_tentaculos", "lamina_dissolvente", "cajado_dos_desejos_realizados", "ampulheta_do_tempo_parado", "lamina_do_eclipse", "memoria_reescrita", "pira_do_incendiario"]
	var new_passives := ["precisao", "sede_de_sangue", "brasa", "ponta_certeira", "olhar_abissal", "acido", "ventura", "tempo_suspenso", "veu_de_sombras", "memoria_viva", "furia_sombria", "fe_radiante", "presenca_dominante"]
	print("INFO ícones novos: %d armas, %d passivas" % [new_weapons.size(), new_passives.size()])
	# ---- ícones: todos os ids do jogo têm ícone próprio; os novos seguem 128x128 RGBA com alfa limpo
	var missing_w: Array = []
	for w in weapons:
		if not ResourceLoader.exists("res://assets/icons/weapons/%s.png" % w):
			missing_w.append(String(w))
	ok(missing_w.is_empty(), "toda arma tem PNG próprio em assets/icons/weapons (sem: %s)" % ",".join(missing_w))
	var missing_p: Array = []
	for p in passives:
		if not ResourceLoader.exists("res://assets/icons/passives/%s.png" % p):
			missing_p.append(String(p))
	ok(missing_p.is_empty(), "toda passiva tem PNG em assets/icons/passives (sem: %s)" % ",".join(missing_p))
	var rows: Array = []
	for kind in [["weapons", new_weapons], ["passives", new_passives]]:
		for id in kind[1]:
			var path := "res://assets/icons/%s/%s.png" % [kind[0], id]
			var im := _img(path)
			if im == null:
				ok(false, "%s existe e carrega" % path)
				continue
			ok(im.get_size() == Vector2i(128, 128), "%s/%s tem 128x128 (%s)" % [kind[0], id, im.get_size()])
			var minx := 999
			var miny := 999
			var maxx := -1
			var maxy := -1
			var opaque := 0
			var gray := 0
			var edge_a := 0
			for y in 128:
				for x in 128:
					var c := im.get_pixel(x, y)
					if c.a > 0.1:
						opaque += 1
						minx = mini(minx, x)
						miny = mini(miny, y)
						maxx = maxi(maxx, x)
						maxy = maxi(maxy, y)
						if absf(c.r - c.g) < 0.03 and absf(c.g - c.b) < 0.03 and c.r > 0.55 and c.r < 0.75 and c.a > 0.9:
							gray += 1
						if x == 0 or y == 0 or x == 127 or y == 127:
							edge_a += 1
			var corner := im.get_pixel(0, 0).a + im.get_pixel(127, 0).a + im.get_pixel(0, 127).a + im.get_pixel(127, 127).a
			ok(corner == 0.0 and edge_a == 0, "%s/%s: cantos e borda transparentes" % [kind[0], id])
			ok(minx >= 3 and miny >= 3 and maxx <= 124 and maxy <= 124, "%s/%s: margem >= 3 px (caixa %d,%d-%d,%d)" % [kind[0], id, minx, miny, maxx, maxy])
			ok(opaque > 1500 and float(gray) / maxf(1.0, float(opaque)) < 0.02, "%s/%s: preenchimento %d px e cinza residual %.2f%%" % [kind[0], id, opaque, 100.0 * float(gray) / maxf(1.0, float(opaque))])
			rows.append([id, opaque])
	var ref := 0.0
	var n := 0
	for w in ["espada_do_receptaculo", "maca_demolidora", "luz_mais_pura", "tempestade", "inferno_de_cera", "julgamento_da_gloria"]:
		var im := _img("res://assets/icons/weapons/%s.png" % w)
		var c := 0
		for y in 128:
			for x in 128:
				if im.get_pixel(x, y).a > 0.1:
					c += 1
		ref += c
		n += 1
	var mean_new := 0.0
	for r in rows:
		mean_new += r[1]
	print("INFO ocupação média: existentes %.0f px, novos %.0f px" % [ref / n, mean_new / rows.size()])
	for id in new_weapons:
		ok(not weapons[id].has("icon_like") and Items.weapon_icon(id) == "res://assets/icons/weapons/%s.png" % id, "%s resolve o ícone próprio (sem icon_like)" % id)
	# ---- VFX
	var vfx := {"selo_retidao_evo": 8, "cajado_realizado_evo": 8, "eclipse_evo": 8, "memoria_reescrita_evo": 8, "pulso_vigilia": 6, "pulso_ampulheta_tempo": 6, "abraco_laco": 6}
	for name in vfx:
		var path := "res://assets/vfx/%s.png" % name
		var im := _img(path)
		if im == null:
			ok(false, path + " carrega")
			continue
		var cells: int = vfx[name]
		ok(im.get_size() == Vector2i(256 * cells, 256), "%s tem %dx256 (%s)" % [name, 256 * cells, im.get_size()])
		var masses: Array = []
		var worst_margin := 999
		var border_alpha := 0.0
		for i in cells:
			var mass := 0.0
			var minx := 999
			var miny := 999
			var maxx := -1
			var maxy := -1
			for y in 256:
				for x in 256:
					var c := im.get_pixel(i * 256 + x, y)
					mass += c.a * maxf(c.r, maxf(c.g, c.b))
					if c.a > 0.15:
						minx = mini(minx, x)
						maxx = maxi(maxx, x)
						miny = mini(miny, y)
						maxy = maxi(maxy, y)
					if x == 0 or y == 0 or x == 255 or y == 255:
						border_alpha = maxf(border_alpha, c.a)
			masses.append(mass)
			worst_margin = mini(worst_margin, mini(mini(minx, miny), mini(255 - maxx, 255 - maxy)))
		ok(worst_margin >= 20, "%s: margem mínima %d px por célula (>= 20)" % [name, worst_margin])
		ok(border_alpha == 0.0, "%s: borda das células com alfa 0" % name)
		if cells == 8:
			ok(masses[7] < masses[5] * 0.5 and masses[7] > 0.0, "%s: impacto desvanece (massa q8 %.0f < metade de q6 %.0f)" % [name, masses[7], masses[5]])
			var fl: Array = masses.slice(0, 4)
			var mx: float = fl.max()
			var mn: float = fl.min()
			ok(mn > mx * 0.7, "%s: voo estável (massa %.0f..%.0f)" % [name, mn, mx])
		elif name != "abraco_laco":
			var peak := 0
			for i in cells:
				if masses[i] > masses[peak]:
					peak = i
			ok(masses[cells - 1] < masses[peak] * 0.35, "%s: pico no quadro %d e dissipação no último" % [name, peak + 1])
		else:
			var mx2: float = masses.max()
			var mn2: float = masses.min()
			ok(mn2 > mx2 * 0.85, "%s: laço estável entre quadros (massa %.0f..%.0f)" % [name, mn2, mx2])
	# roteamento e fallback (código)
	for id in ["selo_da_retidao", "cajado_dos_desejos_realizados", "lamina_do_eclipse", "memoria_reescrita"]:
		var pr := {"owner": "hero", "pos": Vector2(1, 1), "dir": Vector2(1, 0), "life": 1.0, "p": {"id": id, "dtype": String(weapons[id].dtype)}}
		var fam := ProjectileVfx.evolved_family_for(pr)
		ok(fam != &"" and ProjectileVfx.family_for(pr) != &"", "%s: família evoluída %s e fallback %s" % [id, fam, ProjectileVfx.family_for(pr)])
	ok(RadiantPulseVfx.supports({"type": "nova", "weapon": "vigilia_perpetua", "dtype": "radiante", "radius": 3.6}), "Vigília roteada ao pulso radiante")
	ok(HourglassVfx.supports({"type": "nova", "weapon": "ampulheta_do_tempo_parado", "dtype": "magico", "radius": 6.5}), "Ampulheta evoluída roteada ao VFX da ampulheta")
	ok(TentacleVfx.supports({"owner": "hero", "weapon": "abraco_dos_tentaculos", "radius": 4.2}), "Abraço roteado ao VFX da zona")
	ok(VfxAtlas.GROUND_ROW.has("abraco_laco"), "abraco_laco registrado em VfxAtlas.GROUND_ROW")
	print("RESUMO falhas=%d" % fails)
	quit(1 if fails > 0 else 0)
