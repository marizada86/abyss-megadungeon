extends RefCounted
## Lote 3: os atlas preparados de tools/asset_jobs/vfx_lote3_v01.json estão em assets/vfx com a geometria e as margens auditadas.
func run() -> Array[String]:
	var out: Array[String] = []
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string("res://tools/asset_jobs/vfx_lote3_v01.json"))
	if jobs.is_empty(): out.append("o job do Lote 3 está vazio")
	for job in jobs:
		var path := "res://assets/vfx/" + String(job.out).get_file()
		var texture := load(path) as Texture2D
		if texture == null:
			out.append("faltando " + path)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		if image.get_size() != Vector2i(job.regions.size() * 256, 256):
			out.append("geometria " + path)
			continue
		for index in job.regions.size():
			var box := image.get_region(Rect2i(index * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s quadro %d vazio ou sem margem" % [path, index])
	# o aceite do piloto cobre exatamente as folhas já integradas
	var acceptance: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/vfx-lote3-20261027-r1/pilot-acceptance-20261027.json"))
	var accepted := {}
	for item in acceptance.accepted: accepted[String(item.id)] = String(item.revision)
	for job in jobs:
		if not accepted.has(String(job.id)) or accepted[String(job.id)] != "v02": out.append("folha integrada sem aceite visual do piloto: " + String(job.id))
	return out
