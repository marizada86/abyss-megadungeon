extends SceneTree
# uso: -- <saida.png> <celW> <celH> <cols> <arquivo1> <arquivo2> ...
func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var out := a[0]
	var cw := int(a[1]); var ch := int(a[2]); var cols := int(a[3])
	var files := a.slice(4)
	var rows := int(ceil(float(files.size()) / cols))
	var sheet := Image.create(cw * cols, ch * rows, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.16, 0.16, 0.2, 1))
	for i in files.size():
		var img := Image.load_from_file(files[i])
		if img == null:
			continue
		img.convert(Image.FORMAT_RGBA8)
		var s := minf(float(cw - 4) / img.get_width(), float(ch - 4) / img.get_height())
		img.resize(maxi(1, int(img.get_width() * s)), maxi(1, int(img.get_height() * s)), Image.INTERPOLATE_LANCZOS)
		sheet.blend_rect(img, Rect2i(0, 0, img.get_width(), img.get_height()), Vector2i((i % cols) * cw + (cw - img.get_width()) / 2, (i / cols) * ch + (ch - img.get_height()) / 2))
	sheet.save_png(out)
	quit()
