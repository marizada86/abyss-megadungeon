extends SceneTree
func _init() -> void:
	for f in ["A06_altar_do_limo_v01", "A07_altar_disputado_feng_tu_v01", "A08_pedra_runica_v01"]:
		var im := Image.load_from_file(ProjectSettings.globalize_path("res://assets_incoming/queue-20261104-r1/sources/%s.png" % f))
		var has_alpha := im.detect_alpha()
		im.convert(Image.FORMAT_RGBA8)
		var w := im.get_width(); var h := im.get_height()
		var tl := im.get_pixel(2, 2); var mid_bg := im.get_pixel(w - 3, h / 2)
		var minx := 9999; var miny := 9999; var maxx := -1; var maxy := -1; var semi := 0; var opaque := 0
		for y in h:
			for x in w:
				var c := im.get_pixel(x, y)
				if c.a > 0.5:
					opaque += 1
					minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
				elif c.a > 0.02:
					semi += 1
		print("ALP %s alpha=%s canto=%s lateral=%s bbox(a>.5)=x%d-%d y%d-%d opaco=%d semi=%d" % [f.left(3), str(has_alpha), str(tl), str(mid_bg), minx, maxx, miny, maxy, opaque, semi])
	for ref in ["trono_zuggtmoy", "arco_pedra", "altar_active", "limo_juiblex"]:
		var r := Image.load_from_file(ProjectSettings.globalize_path("res://assets/interactions/%s.png" % ref))
		print("REF %s %s" % [ref, str(r.get_size())])
	quit()
