extends RefCounted
func run() -> Array[String]:
	var out: Array[String] = []
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string("res://tools/asset_jobs/vfx_lote1_v01.json"))
	for job in jobs:
		var path := "res://assets/vfx/" + String(job.out).get_file()
		var texture := load(path) as Texture2D
		if texture == null:
			out.append("missing " + path)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		if image.get_size() != Vector2i(job.regions.size() * 256, 256): out.append("geometry " + path)
		for index in job.regions.size():
			var box := image.get_region(Rect2i(index * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235: out.append("%s frame %d margin" % [path,index])
	for id in MeleeVfx.RADIANT_WEAPONS:
		if MeleeVfx.shape_for(id,"radiante") != "arco_radiante" or MeleeVfx.shape_for(id,"fisico") != "": out.append("radiant allowlist " + id)
	if MeleeVfx.shape_for("romper_armadura","radiante") != "": out.append("physical regression")
	var event := {"type":"swing","weapon":"tocha_do_incendiario","dtype":"fogo","pos":Vector2.ZERO,"dir":Vector2.RIGHT,"range":2.0,"cone":60.0}
	var fire := FireSwingVfx.create_effect(event)
	if fire == null or fire.get_child_count() != 1: out.append("fire atlas not adopted")
	if fire != null: fire.free()
	return out
