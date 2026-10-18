extends RefCounted

func run() -> Array:
	var out: Array=[]
	var art=load("res://ui/yggdrasil_art.gd").new()
	if not art.prepare():
		art.free()
		return ["Yggdrasil approved resources failed to prepare"]
	var d: Dictionary=TerrainLayout.root_definition("raiz_yggdrasil")
	var nodes: PackedVector3Array=art.floor_material.get_shader_parameter("root_nodes")
	var edges: PackedVector4Array=art.floor_material.get_shader_parameter("root_edges")
	var widths: PackedFloat32Array=art.floor_material.get_shader_parameter("half_widths")
	if nodes.size()!=32 or edges.size()!=32 or widths.size()!=32 or int(art.floor_material.get_shader_parameter("node_count"))!=12 or int(art.floor_material.get_shader_parameter("edge_count"))!=17:
		out.append("Visual geometry array dimensions differ from approved r4")
	var i:=0
	for raw: Array in d.nodes.values():
		if nodes[i]!=Vector3(float(raw[0]),float(raw[1]),float(raw[2])):
			out.append("Visual node differs from support")
		i+=1
	i=0
	for edge: Array in d.edges:
		var a:=TerrainLayout.root_point(d.nodes[edge[0]])
		var b:=TerrainLayout.root_point(d.nodes[edge[1]])
		if edges[i]!=Vector4(a.x,a.y,b.x,b.y) or not is_equal_approx(widths[i],TerrainLayout.root_edge_width(d,edge)*0.5):
			out.append("Visual edge endpoints/width differ from support")
		i+=1
	var manifest: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/yggdrasil-art-20261017/kit-r1/manifest.json"))
	var bytes:=0
	for e: Dictionary in manifest.entries:
		var p:=String(art.config.textures[e.id])
		if FileAccess.get_sha256(p)!=String(e.sha256):
			out.append("Admitted image differs from owner-approved bytes: "+String(e.id))
		var tex: Texture2D=art.textures[e.id]
		if tex.get_width()>1024 or tex.get_height()>1024:
			out.append("Texture exceeds import cap")
		bytes+=tex.get_width()*tex.get_height()*4
		var cfg:=ConfigFile.new()
		if cfg.load(p+".import")!=OK or int(cfg.get_value("params","process/size_limit",0))!=1024 or bool(cfg.get_value("params","mipmaps/generate",true)):
			out.append("Import cap/mipmap policy differs")
	if bytes>16*1024*1024 or float(art.config.side_height_px)!=20.0:
		out.append("Memory/side-height budget exceeded")
	var stage: Node2D=load("res://ui/stages/raiz_yggdrasil.tscn").instantiate()
	if stage.get_node_or_null("YggdrasilArt")==null or not stage.get_node("Ground").use_yggdrasil_art:
		out.append("Stage art not attached/enabled")
	if stage.get_node("Sorted/Hero").position!=Iso.to_screen(Vector2(30,48)):
		out.append("Arrival moved")
	stage.free()
	var other=load("res://ui/yggdrasil_art.gd").new()
	other.root_layout=RootPathGenerator.new().generate(d,7503)
	if not other.prepare() or other.floor_material==art.floor_material or int(other.floor_material.get_shader_parameter("edge_count"))!=other.root_layout.edges.size():
		out.append("Per-instance material/geometry unavailable")
	other.free()
	art.free()
	return out
