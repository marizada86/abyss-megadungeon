extends SceneTree
## Linha mais larga e largura do anel de chão (mesma medida usada para GROUND_ROW e RING_PX).
func _init() -> void:
	for p in ["res://assets/vfx/tentaculos_laco.png", "res://tmp/evo_vfx/out/abraco_laco.png"]:
		var img := Image.load_from_file(ProjectSettings.globalize_path(p))
		img.convert(Image.FORMAT_RGBA8)
		for i in 6:
			var best_row := -1; var best_span := 0; var best_sum := 0.0; var sum_row := -1
			for y in 256:
				var mn := 999; var mx := -1; var s := 0.0
				for x in 256:
					var a := img.get_pixel(i * 256 + x, y).a
					if a > 0.15:
						mn = mini(mn, x); mx = maxi(mx, x)
					s += a
				if mx - mn > best_span:
					best_span = mx - mn; best_row = y
				if s > best_sum:
					best_sum = s; sum_row = y
			print("RING %s frame %d: linha de maior largura=%d (span %d) | linha de maior massa=%d" % [p.get_file(), i, best_row, best_span, sum_row])
	quit()
