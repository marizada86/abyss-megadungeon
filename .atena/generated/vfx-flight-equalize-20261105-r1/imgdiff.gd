extends SceneTree
## Compara duas imagens do mesmo tamanho: pixels diferentes, maior diferença por canal e brilho somado de cada uma, por faixa de colunas (8 quadros).
## Uso: Godot --headless --path <proj> -s res://imgdiff.gd -- <saida.json> <antes.png> <depois.png> [<antes2> <depois2> ...]
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var res: Dictionary = {}
	for p in range((args.size() - 1) / 2):
		var a := Image.load_from_file(String(args[1 + p * 2]))
		var b := Image.load_from_file(String(args[2 + p * 2]))
		a.convert(Image.FORMAT_RGBA8)
		b.convert(Image.FORMAT_RGBA8)
		var w := a.get_width()
		var h := a.get_height()
		var da := a.get_data()
		var db := b.get_data()
		var diff_px := 0
		var maxd := 0
		var tiles: Array = []
		for t in 8:
			tiles.append({"diff_px": 0, "sum_before": 0, "sum_after": 0, "row": t / 4, "col": t % 4})
		var tw := w / 4
		var th := h / 2
		for y in h:
			for x in w:
				var i := (y * w + x) * 4
				var d := maxi(absi(da[i] - db[i]), maxi(absi(da[i + 1] - db[i + 1]), absi(da[i + 2] - db[i + 2])))
				var t := (y / th) * 4 + mini(x / tw, 3)
				tiles[t]["sum_before"] += da[i] + da[i + 1] + da[i + 2]
				tiles[t]["sum_after"] += db[i] + db[i + 1] + db[i + 2]
				if d > 0:
					diff_px += 1
					tiles[t]["diff_px"] += 1
					maxd = maxi(maxd, d)
		res[String(args[1 + p * 2]).get_file()] = {"size": [w, h], "pixels_diferentes": diff_px, "de_total_pct": snappedf(100.0 * diff_px / float(w * h), 0.01), "maior_dif_canal": maxd, "quadros": tiles}
	var f := FileAccess.open(String(args[0]), FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "\t"))
	f.close()
	quit(0)
