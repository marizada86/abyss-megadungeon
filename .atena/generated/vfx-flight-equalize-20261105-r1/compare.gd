extends SceneTree
## Compara original x equalizado: confere o que mudou e monta uma prévia aditiva sobre preto dos 4 quadros de voo.
## Uso: Godot --headless --path <proj> -s res://compare.gd -- <previa.png> <relatorio.json> <orig1> <novo1> [<orig2> <novo2> ...]
func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var pairs := (args.size() - 2) / 2
	var sheet := Image.create(1024, 256 * 2 * pairs, false, Image.FORMAT_RGBA8)
	sheet.fill(Color.BLACK)
	var report: Dictionary = {}
	for p in pairs:
		var a := Image.load_from_file(String(args[2 + p * 2]))
		var b := Image.load_from_file(String(args[3 + p * 2]))
		a.convert(Image.FORMAT_RGBA8)
		b.convert(Image.FORMAT_RGBA8)
		var da := a.get_data()
		var db := b.get_data()
		var w := a.get_width()
		var rgb_diff := 0
		var impact_diff := 0
		var alpha_zero_changed := 0
		var flight_alpha_changed := 0
		for y in 256:
			for x in w:
				var i := (y * w + x) * 4
				var cell := x / 256
				if da[i] != db[i] or da[i + 1] != db[i + 1] or da[i + 2] != db[i + 2]:
					rgb_diff += 1
				if cell >= 4 and da[i + 3] != db[i + 3]:
					impact_diff += 1
				if cell < 4 and da[i + 3] != db[i + 3]:
					flight_alpha_changed += 1
					if da[i + 3] == 0:
						alpha_zero_changed += 1
				if cell < 4:
					var ra := Color(da[i] / 255.0 * da[i + 3] / 255.0, da[i + 1] / 255.0 * da[i + 3] / 255.0, da[i + 2] / 255.0 * da[i + 3] / 255.0)
					var rb := Color(db[i] / 255.0 * db[i + 3] / 255.0, db[i + 1] / 255.0 * db[i + 3] / 255.0, db[i + 2] / 255.0 * db[i + 3] / 255.0)
					sheet.set_pixel(x, p * 512 + y, ra)
					sheet.set_pixel(x, p * 512 + 256 + y, rb)
		report[String(args[2 + p * 2]).get_file()] = {"size_equal": a.get_size() == b.get_size(), "rgb_pixels_changed_rows0_255": rgb_diff, "impact_alpha_pixels_changed": impact_diff, "flight_alpha_pixels_changed": flight_alpha_changed, "alpha0_became_visible": alpha_zero_changed}
	sheet.save_png(String(args[0]))
	var f := FileAccess.open(String(args[1]), FileAccess.WRITE)
	f.store_string(JSON.stringify(report, "\t"))
	f.close()
	quit(0)
