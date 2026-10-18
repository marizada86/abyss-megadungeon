extends RefCounted

func run() -> Array:
	var out: Array = []
	var config: Dictionary = Data.table("root_art").reino_abissal
	var ground = load("res://ui/ground.gd").new()
	if not ground._prepare_root_art():
		out.append("Root art resources failed to prepare")
		ground.free()
		return out
	var mat: ShaderMaterial = ground._root_art_material
	var d := TerrainLayout.root_definition()
	var nodes: PackedVector3Array = mat.get_shader_parameter("root_nodes")
	var edges: PackedVector4Array = mat.get_shader_parameter("root_edges")
	if nodes.size() != d.nodes.size() or edges.size() != d.edges.size() or float(mat.get_shader_parameter("half_width")) != float(d.width)*0.5:
		out.append("Art support does not use authoritative geometry")
	var i := 0
	for raw: Array in d.nodes.values():
		if nodes[i] != Vector3(float(raw[0]),float(raw[1]),float(raw[2])):
			out.append("Art junction changed radius or position")
		i += 1
	i = 0
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		if edges[i] != Vector4(a.x,a.y,b.x,b.y):
			out.append("Art passage changed endpoints")
		i += 1
	var bytes := 0
	for id in config.textures:
		var texture: Texture2D = load(String(config.textures[id]))
		var expected: Array = config.import_sizes[id]
		if texture.get_width()!=int(expected[0]) or texture.get_height()!=int(expected[1]):
			out.append("Texture import size differs from budget: "+id)
		bytes += texture.get_width()*texture.get_height()*4
		var cfg := ConfigFile.new()
		if cfg.load(String(config.textures[id])+".import") != OK or int(cfg.get_value("params","process/size_limit",0)) != 1024 or bool(cfg.get_value("params","mipmaps/generate",true)):
			out.append("Import limit/mipmaps invalid: "+id)
	if bytes > 14*1024*1024:
		out.append("Imported RGBA8 budget exceeds 14 MiB")
	if ground._root_art_rect.size.y <= 0 or float(config.depth_height_px) < float(config.side_height_px) or config.side_rows.size()!=5:
		out.append("Side/depth parameters invalid")
	var previous := -1.0
	for boundary in config.side_rows:
		if float(boundary)<=previous:
			out.append("Atlas side rows overlap/reverse")
		previous=float(boundary)
	# Approved source bytes stay exact; source images are not resized/repainted.
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/root-art-20261017/kit-r1/manifest.json"))
	for asset in manifest.assets:
		if FileAccess.get_sha256(String(config.textures[asset.id])) != String(asset.sha256):
			out.append("Admitted PNG differs from approved source: "+asset.id)
	ground.free()
	return out
