extends SceneTree
## Prepara os 3 sprites estáticos aceitos (A06, A07, A08): as fontes já têm alfa real; recorta a caixa útil, reduz com Lanczos
## a largura-alvo e devolve uma tela justa com margem transparente.
func _prep(src: String, out: String, width: int, pad: int) -> void:
	var im := Image.load_from_file(ProjectSettings.globalize_path("res://" + src))
	im.convert(Image.FORMAT_RGBA8)
	var minx := 99999
	var miny := 99999
	var maxx := -1
	var maxy := -1
	for y in im.get_height():
		for x in im.get_width():
			if im.get_pixel(x, y).a > 0.1:
				minx = mini(minx, x)
				miny = mini(miny, y)
				maxx = maxi(maxx, x)
				maxy = maxi(maxy, y)
	var crop := im.get_region(Rect2i(minx, miny, maxx - minx + 1, maxy - miny + 1))
	var s := float(width - pad * 2) / float(crop.get_width())
	var nw := width - pad * 2
	var nh := maxi(1, roundi(crop.get_height() * s))
	crop.resize(nw, nh, Image.INTERPOLATE_LANCZOS)
	var canvas := Image.create(width, nh + pad * 2, false, Image.FORMAT_RGBA8)
	canvas.blit_rect(crop, Rect2i(Vector2i.ZERO, crop.get_size()), Vector2i(pad, pad))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://tmp/evo_vfx/sprites"))
	canvas.save_png(ProjectSettings.globalize_path("res://" + out))
	print("PREP %s -> %s %s (caixa útil %dx%d, escala %.4f)" % [src.get_file(), out.get_file(), str(canvas.get_size()), maxx - minx + 1, maxy - miny + 1, s])
func _init() -> void:
	var b := "assets_incoming/queue-20261104-r1/sources/"
	_prep(b + "A06_altar_do_limo_v01.png", "tmp/evo_vfx/sprites/altar_do_limo.png", 208, 6)
	_prep(b + "A07_altar_disputado_feng_tu_v01.png", "tmp/evo_vfx/sprites/altar_disputado_feng_tu.png", 208, 6)
	_prep(b + "A08_pedra_runica_v01.png", "tmp/evo_vfx/sprites/montanha_runica_01.png", 208, 4)
	quit()
