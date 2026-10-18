extends Node2D
## Owner-approved visual composition; authoritative support remains TerrainLayout.
const Layout = preload("res://core/terrain_layout.gd")
var config: Dictionary = {}
var textures: Dictionary = {}
var floor_material: ShaderMaterial
var floor_rect := Rect2()
var floor_layer: Node2D
var marker: Node2D
var _ground: Node2D
var _prepared := false
var _last_active := false

class FloorLayer extends Node2D:
	var composer: Node2D
	func _draw() -> void:
		draw_rect(composer.floor_rect,Color.WHITE)

class PassageMark extends Node2D:
	func _draw() -> void:
		var d: Dictionary = Layout.root_definition("raiz_yggdrasil")
		var at: Vector2 = Iso.to_screen(Layout.root_point(d.nodes.G))
		draw_arc(at+Vector2(0,-20),18.0,PI,TAU,28,Color("a380c1"),3.0,true)

func prepare() -> bool:
	if _prepared:
		return true
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/yggdrasil_art.json"))
	if not raw is Dictionary or not raw.has("textures"):
		return false
	config=raw
	if not ResourceLoader.exists(String(config.shader)):
		return false
	for id in config.textures:
		if not ResourceLoader.exists(String(config.textures[id])):
			return false
		var resource = load(String(config.textures[id]))
		if not resource is Texture2D:
			return false
		textures[id]=resource
	var d: Dictionary=Layout.root_definition("raiz_yggdrasil")
	if d.nodes.size()!=7 or d.edges.size()!=8 or d.revision!=config.geometry_revision:
		return false
	floor_material=ShaderMaterial.new()
	floor_material.shader=load(String(config.shader))
	var nodes:=PackedVector3Array()
	var edges:=PackedVector4Array()
	var widths:=PackedFloat32Array()
	var bounds:=Rect2(Iso.to_screen(Layout.root_point(d.arrival)),Vector2.ZERO)
	for raw_node: Array in d.nodes.values():
		nodes.append(Vector3(float(raw_node[0]),float(raw_node[1]),float(raw_node[2])))
		for i in 96:
			bounds=bounds.expand(Iso.to_screen(Layout.root_point(raw_node)+Vector2.from_angle(TAU*float(i)/96.0)*float(raw_node[2])))
	for edge: Array in d.edges:
		var a: Vector2=Layout.root_point(d.nodes[edge[0]])
		var b: Vector2=Layout.root_point(d.nodes[edge[1]])
		edges.append(Vector4(a.x,a.y,b.x,b.y))
		widths.append(Layout.root_edge_width(d,edge)*0.5)
	floor_material.set_shader_parameter("root_nodes",nodes)
	floor_material.set_shader_parameter("root_edges",edges)
	floor_material.set_shader_parameter("half_widths",widths)
	for id in ["ground","edge","detail"]:
		floor_material.set_shader_parameter(id+"_art",textures[id])
	for key in ["side_height_px","top_brightness","detail_opacity"]:
		floor_material.set_shader_parameter(key,float(config[key]))
	var rects:=PackedVector4Array()
	for r: Array in config.side_rects:
		rects.append(Vector4(float(r[0]),float(r[1]),float(r[2]),float(r[3]))/float(config.native_size))
	floor_material.set_shader_parameter("side_rects",rects)
	bounds.size.y+=float(config.side_height_px)
	floor_rect=bounds.grow(2.0)
	_prepared=true
	return true

func _ready() -> void:
	_ground=get_parent().get_node_or_null("Ground")
	if _ground==null or _ground.get("terrain_layout_id")!="raiz_yggdrasil" or not prepare():
		return
	z_index=-102
	texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	floor_layer=FloorLayer.new()
	floor_layer.composer=self
	floor_layer.material=floor_material
	floor_layer.z_index=3
	add_child(floor_layer)
	marker=PassageMark.new()
	marker.z_index=4
	add_child(marker)
	_refresh()

func is_active() -> bool:
	return _prepared and is_instance_valid(_ground) and bool(_ground.get("use_yggdrasil_art"))

func _process(_dt: float) -> void:
	_refresh()

func _refresh() -> void:
	var active:=is_active()
	visible=active
	if active!=_last_active:
		_ground.queue_redraw()
		_last_active=active

func _draw() -> void:
	if not _prepared:
		return
	var r: Array=config.background_rect
	draw_texture_rect(textures.trunk,Rect2(float(r[0]),float(r[1]),float(r[2]),float(r[3])),false,Color(config.background_tint))
