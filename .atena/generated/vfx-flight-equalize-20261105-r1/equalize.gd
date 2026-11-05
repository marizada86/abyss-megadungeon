extends SceneTree
## Equaliza a energia aditiva (soma de alfa * max(R,G,B)) dos 4 primeiros quadros (voo) de um atlas de 256 px por quadro.
## Só o alfa dos quadros de voo muda (ganho por quadro); RGB e quadros de impacto ficam byte a byte iguais.
## Alvo = média das energias originais dos 4 quadros. Ganho limitado a [GAIN_MIN, GAIN_MAX].
## Uso: Godot --headless --path <proj> -s res://equalize.gd -- <pasta_saida> <relatorio.json> <atlas1.png> [<atlas2.png> ...]
const FLIGHT := 4
const GAIN_MIN := 0.5
const GAIN_MAX := 1.8

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	DirAccess.make_dir_recursive_absolute(String(args[0]))
	var report: Dictionary = {}
	for k in range(2, args.size()):
		var path := String(args[k])
		var img := Image.load_from_file(path)
		img.convert(Image.FORMAT_RGBA8)
		var w := img.get_width()
		var data := img.get_data()
		var energies: Array = []
		for c in FLIGHT:
			energies.append(_energy(data, w, c, 1.0))
		var target := 0.0
		for e in energies:
			target += float(e)
		target /= float(FLIGHT)
		var rows: Array = []
		for c in FLIGHT:
			var lo := GAIN_MIN
			var hi := GAIN_MAX
			for _i in 40:
				var mid := (lo + hi) * 0.5
				if _energy(data, w, c, mid) < target:
					lo = mid
				else:
					hi = mid
			var gain := (lo + hi) * 0.5
			if absf(_energy(data, w, c, gain) - target) > target * 0.002:
				gain = hi if _energy(data, w, c, hi) < target else lo
			for y in 256:
				for x in 256:
					var i := (y * w + c * 256 + x) * 4
					var a: int = data[i + 3]
					if a > 0:
						data[i + 3] = clampi(roundi(float(a) * gain), 0, 255)
			rows.append({"cell": c, "energy_before": snappedf(float(energies[c]), 0.01), "gain": snappedf(gain, 0.0001), "energy_after": snappedf(_energy(data, w, c, 1.0), 0.01)})
		var out := Image.create_from_data(w, img.get_height(), false, Image.FORMAT_RGBA8, data)
		out.save_png(String(args[0]).path_join(path.get_file()))
		report[path.get_file()] = {"target": snappedf(target, 0.01), "frames": rows}
	var f := FileAccess.open(String(args[1]), FileAccess.WRITE)
	f.store_string(JSON.stringify(report, "\t"))
	f.close()
	quit(0)

func _energy(data: PackedByteArray, w: int, c: int, gain: float) -> float:
	var e := 0.0
	for y in 256:
		for x in 256:
			var i := (y * w + c * 256 + x) * 4
			var a: int = data[i + 3]
			if a == 0:
				continue
			var v := maxi(data[i], maxi(data[i + 1], data[i + 2]))
			e += float(clampi(roundi(float(a) * gain), 0, 255)) * float(v) / 65025.0
	return e
