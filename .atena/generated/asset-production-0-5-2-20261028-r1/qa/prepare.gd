extends SceneTree

var report: Dictionary = {"status": "PASS", "method": "find transparent gaps near five source columns; crop margins using alpha >= 0.1 bounds; uniform isotropic scale per strip; align each cell bottom to y=432 and center to x=256; preserve alpha within crops; original sources untouched", "sources": [], "outputs": []}
var workspace_root: String
var incoming: String

func _init() -> void:
	workspace_root = OS.get_cmdline_user_args()[0].replace("\\", "/")
	incoming = workspace_root + "/assets_incoming/beta-0-5-2-20261028-r1/"
	prepare_icon()
	prepare_strip("carga_da_legiao_quebravel", "caixote_quebravel")
	prepare_strip("urna_elfica_quebravel", "urna_funeraria_quebravel")
	var file := FileAccess.open(workspace_root + "/.atena/generated/asset-production-0-5-2-20261028-r1/qa.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	print(JSON.stringify(report))
	quit(0 if report.status == "PASS" else 1)

func inspect(img: Image) -> Dictionary:
	var rect := img.get_used_rect()
	return {"width": img.get_width(), "height": img.get_height(), "alpha": img.detect_alpha(), "bounds": [rect.position.x, rect.position.y, rect.size.x, rect.size.y]}

func visible_rect(img: Image) -> Rect2i:
	var low := img.get_size()
	var high := Vector2i(-1, -1)
	for y in img.get_height():
		for x in img.get_width():
			if img.get_pixel(x, y).a >= 0.1:
				low.x = mini(low.x, x)
				low.y = mini(low.y, y)
				high.x = maxi(high.x, x)
				high.y = maxi(high.y, y)
	return Rect2i(low, high - low + Vector2i.ONE)

func record_output(img: Image, path: String) -> void:
	assert(img.save_png(path) == OK)
	var loaded := Image.load_from_file(path)
	var info := inspect(loaded)
	info.path = path.trim_prefix(workspace_root + "/")
	info.sha256 = FileAccess.get_sha256(path)
	info.file_bytes = FileAccess.get_file_as_bytes(path).size()
	if loaded.detect_alpha() == Image.ALPHA_NONE or loaded.is_empty():
		report.status = "FAIL"
	report.outputs.append(info)

func prepare_icon() -> void:
	var source := Image.load_from_file(incoming + "sources/docas_puddles_v01.png")
	assert(source != null and source.get_width() == source.get_height())
	var info := inspect(source)
	info.id = "docas_puddles"
	info.sha256 = FileAccess.get_sha256(incoming + "sources/docas_puddles_v01.png")
	report.sources.append(info)
	source.resize(128, 128, Image.INTERPOLATE_LANCZOS)
	record_output(source, incoming + "prepared/docas_puddles.png")

func prepare_strip(id: String, reference: String) -> void:
	var path := incoming + "sources/" + id + "_death_v01.png"
	var source := Image.load_from_file(path)
	assert(source != null)
	var info := inspect(source)
	info.id = id
	info.sha256 = FileAccess.get_sha256(path)
	var cells: Array[Image] = []
	var bboxes: Array = []
	var max_width := 0
	var max_height := 0
	var cuts: Array[int] = [0]
	for split in range(1, 5):
		var target := roundi(split * source.get_width() / 5.0)
		var best_x := target
		var best_cost := INF
		for x in range(target - 80, target + 81):
			var cost := absf(x - target) * 0.001
			for y in source.get_height():
				if source.get_pixel(x, y).a >= 0.1:
					cost += 1.0
			if cost < best_cost:
				best_cost = cost
				best_x = x
		cuts.append(best_x)
	cuts.append(source.get_width())
	info.source_column_cuts = cuts
	for index in 5:
		var left := cuts[index]
		var right := cuts[index + 1]
		var source_cell_width := right - left
		var cell := source.get_region(Rect2i(left, 0, source_cell_width, source.get_height()))
		var bbox := visible_rect(cell)
		assert(bbox.size.x > 0 and bbox.size.y > 0)
		# Reject a source that visibly hits a cell seam: no hidden inter-cell overlap.
		if bbox.position.x <= 0 or bbox.end.x >= source_cell_width:
			report.status = "FAIL"
		bboxes.append([bbox.position.x, bbox.position.y, bbox.size.x, bbox.size.y])
		cells.append(cell.get_region(bbox))
		max_width = maxi(max_width, bbox.size.x)
		max_height = maxi(max_height, bbox.size.y)
	var ref := Image.load_from_file(workspace_root + "/assets/animations/enemies/" + reference + "/death.png")
	var ref_height := ref.get_region(Rect2i(0, 0, 512, 512)).get_used_rect().size.y
	var scale_factor := minf(float(ref_height) / cells[0].get_height(), minf(424.0 / max_width, 352.0 / max_height))
	info.source_cells = bboxes
	info.reference_first_frame_height = ref_height
	info.uniform_scale = scale_factor
	report.sources.append(info)
	var strip := Image.create(2560, 512, false, Image.FORMAT_RGBA8)
	var prepared_bounds: Array = []
	for index in 5:
		var cell: Image = cells[index]
		cell.resize(maxi(1, roundi(cell.get_width() * scale_factor)), maxi(1, roundi(cell.get_height() * scale_factor)), Image.INTERPOLATE_LANCZOS)
		var position := Vector2i(index * 512 + (512 - cell.get_width()) / 2, 432 - cell.get_height())
		strip.blit_rect(cell, Rect2i(Vector2i.ZERO, cell.get_size()), position)
		prepared_bounds.append([position.x - index * 512, position.y, cell.get_width(), cell.get_height()])
	info.prepared_cells = prepared_bounds
	var out_dir := incoming + "prepared/" + id
	DirAccess.make_dir_recursive_absolute(out_dir)
	record_output(strip, out_dir + "/death.png")
	record_output(strip.get_region(Rect2i(0, 0, 512, 512)), out_dir + "/static.png")
