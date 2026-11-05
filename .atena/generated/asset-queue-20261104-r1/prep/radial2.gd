extends SceneTree
func _init() -> void:
	for p in ["res://assets/vfx/habilidade_zynara.png", "res://assets/vfx/habilidade_maelor.png", "res://assets/vfx/habilidade_korrak.png", "res://assets/vfx/habilidade_arlindo.png", "res://tmp/evo_vfx/out/habilidade_arlindo.png"]:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		var line := ""
		var minm := 999
		for i in 6:
			var prof := PackedFloat32Array()
			prof.resize(170)
			var mass := 0.0
			var mnx := 999; var mxx := -1; var mny := 999; var mxy := -1
			for y in 256:
				for x in 256:
					var c := img.get_pixel(i * 256 + x, y)
					var l := c.a * maxf(c.r, maxf(c.g, c.b))
					var r := int(Vector2(x - 128, y - 128).length())
					if r < 170:
						prof[r] += l
					mass += l
					if c.a > 0.15:
						mnx = mini(mnx, x); mxx = maxi(mxx, x); mny = mini(mny, y); mxy = maxi(mxy, y)
			var best := 0
			for r in range(4, 170):
				if prof[r] > prof[best]:
					best = r
			minm = mini(minm, mini(mini(mnx, mny), mini(255 - mxx, 255 - mxy)))
			line += " f%d:r=%d massa=%.0f" % [i, best, mass]
		print("RAD %s margem_min=%d%s" % [p.get_file(), minm, line])
	quit()
