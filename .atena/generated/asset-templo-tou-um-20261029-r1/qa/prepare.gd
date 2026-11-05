extends SceneTree

func _init() -> void:
	var root := OS.get_cmdline_user_args()[0].replace("\\", "/")
	var folder := root + "/assets_incoming/templo-tou-um-20261029-r1/"
	var source_path := folder + "sources/templo_de_tou_um_v01.png"
	var output_path := folder + "prepared/templo_de_tou_um_v01.png"
	var source := Image.load_from_file(source_path)
	assert(source != null and source.detect_alpha() != Image.ALPHA_NONE)
	var bounds := source.get_used_rect()
	var sprite := source.get_region(bounds)
	var scale_factor := minf(240.0 / bounds.size.x, 284.0 / bounds.size.y)
	sprite.resize(maxi(1, roundi(bounds.size.x * scale_factor)), maxi(1, roundi(bounds.size.y * scale_factor)), Image.INTERPOLATE_LANCZOS)
	var output := Image.create(256, 300, false, Image.FORMAT_RGBA8)
	output.fill(Color.TRANSPARENT)
	output.blit_rect(sprite, Rect2i(Vector2i.ZERO, sprite.get_size()), Vector2i((256 - sprite.get_width()) / 2, 292 - sprite.get_height()))
	assert(output.save_png(output_path) == OK)
	var verified := Image.load_from_file(output_path)
	assert(verified.get_size() == Vector2i(256, 300) and verified.detect_alpha() != Image.ALPHA_NONE)
	assert(verified.get_pixel(0, 0).a == 0.0)
	var report := {"status": "PASS", "source_size": [source.get_width(), source.get_height()], "source_bounds": [bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y], "source_sha256": FileAccess.get_sha256(source_path), "output_size": [256, 300], "output_sha256": FileAccess.get_sha256(output_path), "alpha": "real transparency preserved", "method": "crop alpha bounds; isotropic Lanczos resize within 240x284; transparent 256x300 canvas; bottom y=292; original untouched", "human_acceptance": "PENDING", "runtime_modified": false}
	var file := FileAccess.open(root + "/.atena/generated/asset-templo-tou-um-20261029-r1/qa.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	print(JSON.stringify(report))
	quit(0)
