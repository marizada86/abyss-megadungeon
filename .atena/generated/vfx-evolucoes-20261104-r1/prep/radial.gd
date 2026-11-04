extends SceneTree
## Raio do anel luminoso dominante (máximo do perfil radial de brilho em torno do centro da célula) por quadro.
func _init() -> void:
	for p in ["res://assets/vfx/pulso_radiante.png", "res://assets/vfx/ampulheta_silencio.png", "res://assets/vfx/pulso_evo.png", "res://assets/vfx/pulso_vigilia.png", "res://assets/vfx/pulso_ampulheta_tempo.png"]:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		var line := ""
		for i in 6:
			var prof := PackedFloat32Array()
			prof.resize(160)
			var mass := 0.0
			for y in 256:
				for x in 256:
					var c := img.get_pixel(i * 256 + x, y)
					var l := c.a * maxf(c.r, maxf(c.g, c.b))
					var r := int(Vector2(x - 128, y - 128).length())
					if r < 160:
						prof[r] += l
					mass += l
			var best := 0
			for r in range(4, 160):
				if prof[r] > prof[best]:
					best = r
			line += " f%d:r=%d(massa %.0f)" % [i, best, mass]
		print("RAD %s%s" % [p.get_file(), line])
	quit()
