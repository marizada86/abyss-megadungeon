extends RefCounted
## Lote 2: os 22 atlas preparados de tools/asset_jobs/vfx_lote2_v01.json estão em assets/vfx com a geometria e as margens auditadas.
func run() -> Array[String]:
	var out: Array[String] = []
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string("res://tools/asset_jobs/vfx_lote2_v01.json"))
	if jobs.size() != 22: out.append("o job do Lote 2 deveria ter 22 folhas (%d)" % jobs.size())
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
	# a aceitação cobre exatamente as 19 candidatas escolhidas mais as 3 do piloto
	var acceptance: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/vfx-lote2-20261023-r1/remaining-acceptance-20261024.json"))
	if (acceptance.accepted as Array).size() != 19: out.append("o aceite deveria cobrir 19 folhas")
	for item in acceptance.accepted:
		if not bool(item.hash_verified) or String(item.human_visual_acceptance) != "APPROVED_OWNER_20261024": out.append("aceite sem hash conferido: " + String(item.id))
	return out
