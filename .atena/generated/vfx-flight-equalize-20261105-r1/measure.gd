extends SceneTree
## Mede, por quadro 256x256 de um atlas RGBA, a energia aditiva (soma de alfa * max(R,G,B)), o alfa máximo e o limite de folga.
## Uso: Godot --headless --path <proj> -s res://measure.gd -- <saida.json> <atlas1.png> [<atlas2.png> ...]
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var res: Dictionary = {}
	for k in range(1, args.size()):
		var img := Image.load_from_file(String(args[k]))
		if img == null:
			res[String(args[k])] = "nao abriu"
			continue
		img.convert(Image.FORMAT_RGBA8)
		var data := img.get_data()
		var w := img.get_width()
		@warning_ignore("integer_division")
		var n := w / 256
		var frames: Array = []
		for c in n:
			var e := 0.0
			var amax := 0
			var a_sat := 0
			var vmax := 0
			var cnt := 0
			for y in 256:
				for x in 256:
					var i := (y * w + c * 256 + x) * 4
					var a: int = data[i + 3]
					if a == 0:
						continue
					var v := maxi(data[i], maxi(data[i + 1], data[i + 2]))
					e += float(a) * float(v) / 65025.0
					amax = maxi(amax, a)
					vmax = maxi(vmax, v)
					cnt += 1
					if a >= 250:
						a_sat += 1
			frames.append({"cell": c, "energy": snappedf(e, 0.01), "alpha_max": amax, "rgb_max": vmax, "px": cnt, "alpha_ge250": a_sat})
		res[String(args[k]).get_file()] = {"size": [w, img.get_height()], "frames": frames}
	var f := FileAccess.open(String(args[0]), FileAccess.WRITE)
	f.store_string(JSON.stringify(res, "\t"))
	f.close()
	quit(0)
