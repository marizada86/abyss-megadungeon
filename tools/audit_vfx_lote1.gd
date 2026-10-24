extends SceneTree
func _init() -> void:
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string("res://tools/asset_jobs/vfx_lote1_v01.json"))
	var report: Array = []
	var failures: Array[String] = []
	for job in jobs:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://" + String(job.out)))
		var cells := int(job.regions.size())
		if image == null or image.get_size() != Vector2i(cells * 256, 256):
			failures.append(String(job.id) + " geometry")
			continue
		var frames: Array = []
		for index in cells:
			var box := image.get_region(Rect2i(index * 256, 0, 256, 256)).get_used_rect()
			var valid := box.has_area() and box.position.x >= 21 and box.position.y >= 21 and box.end.x <= 235 and box.end.y <= 235
			if not valid: failures.append("%s/%d margin or empty: %s" % [job.id, index, box])
			frames.append({"index": index, "bounds": [box.position.x, box.position.y, box.size.x, box.size.y], "pass": valid})
		report.append({"id": job.id, "path": job.out, "frames": frames})
	var out := FileAccess.open("res://.atena/generated/vfx-lote1-20261023-r1/preparation-audit.json", FileAccess.WRITE)
	out.store_string(JSON.stringify({"sheets": report, "failures": failures}, "	"))
	print("preparation: ", jobs.size(), " sheets; ", failures.size(), " failures")
	for failure in failures: printerr(failure)
	quit(0 if failures.is_empty() else 1)
