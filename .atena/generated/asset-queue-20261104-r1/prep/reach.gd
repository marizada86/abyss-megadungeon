extends SceneTree
func _init() -> void:
	for p in ["res://assets/vfx/habilidade_zynara.png", "res://assets/vfx/habilidade_maelor.png", "res://assets/vfx/habilidade_korrak.png", "res://assets/vfx/habilidade_bromnor.png", "res://tmp/evo_vfx/out/habilidade_arlindo.png"]:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		var out := ""
		for i in 6:
			var reach := 0.0
			var reach_bright := 0.0
			for y in 256:
				for x in 256:
					var c := img.get_pixel(i * 256 + x, y)
					var d := Vector2(x - 128, y - 128).length()
					if c.a > 0.15:
						reach = maxf(reach, d)
					if c.a * maxf(c.r, maxf(c.g, c.b)) > 0.35:
						reach_bright = maxf(reach_bright, d)
			out += " f%d:alcance=%.0f(brilho>0.35:%.0f)" % [i, reach, reach_bright]
		print("REACH %s%s" % [p.get_file(), out])
	quit()
