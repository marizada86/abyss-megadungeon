@tool
extends Node2D
## Chão isométrico texturizado. Cores continuam servindo de fallback no editor.

const TerrainLayout := preload("res://core/terrain_layout.gd")

@export var map_size := Vector2i(40, 40): set = _set_size
@export var color_a := Color(0.13, 0.12, 0.14): set = _set_a
@export var color_b := Color(0.17, 0.15, 0.16): set = _set_b
## Um atlas é uma malha compacta de losangos 64x32. Ele só é ativado por cena
## depois que a arte for aprovada; o piso legado continua aceito como textura única.
@export var use_modular_atlas := false: set = _set_modular_atlas
@export var atlas_tile_size := Vector2i(64, 32): set = _set_atlas_tile_size
@export var atlas_columns := 4: set = _set_atlas_columns
@export var atlas_variants := 4: set = _set_atlas_variants
@export var visual_seed := 0: set = _set_visual_seed
## Útil em cenas de avaliação que exibem mais de um bioma.
@export var stage_visual_id := "": set = _set_stage_visual_id
## Ativa composição de macroterreno sem depender de um atlas único.
@export var terrain_layout_id := "": set = _set_terrain_layout_id
@export var use_stage_texture := true: set = _set_use_stage_texture
## Permite promover uma versão do atlas sem sobrescrever o piso legado.
@export_file("*.png") var terrain_texture_path := "": set = _set_terrain_texture_path
## Chão assado em uma imagem contínua (tools/bake_ground.gd, PLAN-054): substitui a malha de losangos.
@export_file("*.png") var baked_texture_path := "": set = _set_baked_texture_path
var _texture: Texture2D
var _texture_path := ""
var _baked: Texture2D
var _baked_path := ""
## Owner-approved root kit; reversible fallback for QA and missing resources.
@export var use_root_art := true: set = _set_root_art
@export var use_domwieck_art := true
var _root_art_material: ShaderMaterial
var _root_art_rect := Rect2()

func _set_root_art(v: bool) -> void:
	use_root_art = v
	queue_redraw()

func root_art_config() -> Dictionary:
	if not FileAccess.file_exists("res://data/root_art.json"):
		return {}
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/root_art.json"))
	return raw.get("reino_abissal", {}) if raw is Dictionary else {}

func _prepare_root_art() -> bool:
	if _root_art_material != null:
		return true
	var config := root_art_config()
	if config.is_empty():
		return false
	if not ResourceLoader.exists(String(config.shader)):
		return false
	var shader_resource = load(String(config.shader))
	if not shader_resource is Shader:
		return false
	var mat := ShaderMaterial.new()
	mat.shader = shader_resource
	for id in config.textures:
		var path := String(config.textures[id])
		if not ResourceLoader.exists(path):
			return false
		var texture = load(path)
		if not texture is Texture2D:
			return false
		mat.set_shader_parameter({"surface":"surface_art","junctions":"junction_art","sides":"side_art","depth":"depth_art"}[id],texture)
	var d := TerrainLayout.root_definition()
	var nodes := PackedVector3Array()
	var edges := PackedVector4Array()
	var bounds := Rect2(Iso.to_screen(TerrainLayout.root_point(d.arrival)),Vector2.ZERO)
	for node: Array in d.nodes.values():
		nodes.append(Vector3(float(node[0]),float(node[1]),float(node[2])))
		for i in 96:
			bounds = bounds.expand(Iso.to_screen(TerrainLayout.root_point(node)+Vector2.from_angle(TAU*float(i)/96.0)*float(node[2])))
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		edges.append(Vector4(a.x,a.y,b.x,b.y))
	if nodes.size()!=9 or edges.size()!=12:
		return false
	mat.set_shader_parameter("root_nodes",nodes)
	mat.set_shader_parameter("root_edges",edges)
	mat.set_shader_parameter("half_width",float(d.width)*0.5)
	for key in ["atlas_inset","side_height_px","depth_height_px","side_repeat_px","depth_repeat_px","depth_opacity","top_brightness"]:
		mat.set_shader_parameter(key,float(config[key]))
	mat.set_shader_parameter("side_rows",PackedFloat32Array(config.side_rows))
	bounds.size.y += float(config.depth_height_px)
	_root_art_rect = bounds.grow(2.0)
	_root_art_material = mat
	return true

func _set_size(v: Vector2i) -> void:
	map_size = v
	queue_redraw()

func _set_a(v: Color) -> void:
	color_a = v
	queue_redraw()

func _set_b(v: Color) -> void:
	color_b = v
	queue_redraw()

func _set_modular_atlas(v: bool) -> void:
	use_modular_atlas = v
	queue_redraw()

func _set_atlas_tile_size(v: Vector2i) -> void:
	atlas_tile_size = Vector2i(maxi(1, v.x), maxi(1, v.y))
	queue_redraw()

func _set_atlas_columns(v: int) -> void:
	atlas_columns = maxi(1, v)
	queue_redraw()

func _set_atlas_variants(v: int) -> void:
	atlas_variants = maxi(1, v)
	queue_redraw()

func _set_visual_seed(v: int) -> void:
	visual_seed = v
	queue_redraw()

func _set_stage_visual_id(v: String) -> void:
	stage_visual_id = v
	queue_redraw()

func _set_terrain_layout_id(v: String) -> void:
	terrain_layout_id = v
	queue_redraw()

func _set_use_stage_texture(v: bool) -> void:
	use_stage_texture = v
	queue_redraw()

func _set_terrain_texture_path(v: String) -> void:
	terrain_texture_path = v
	_texture_path = ""
	_texture = null
	queue_redraw()

func _set_baked_texture_path(v: String) -> void:
	baked_texture_path = v
	_baked_path = ""
	_baked = null
	queue_redraw()

func _baked_texture() -> Texture2D:
	if baked_texture_path.is_empty():
		return null
	if baked_texture_path != _baked_path:
		_baked_path = baked_texture_path
		_baked = load(baked_texture_path) if ResourceLoader.exists(baked_texture_path) else null
	return _baked

func _stage_id() -> String:
	if not stage_visual_id.is_empty():
		return stage_visual_id
	var cursor: Node = self
	while cursor != null:
		if cursor.scene_file_path != "":
			return cursor.scene_file_path.get_file().get_basename()
		cursor = cursor.get_parent()
	return ""

func _ground_texture() -> Texture2D:
	if not use_stage_texture:
		return null
	var stage_id := _stage_id()
	var path := terrain_texture_path if not terrain_texture_path.is_empty() else "res://assets/tiles/%s_ground.png" % stage_id
	if path != _texture_path:
		_texture_path = path
		_texture = load(path) if ResourceLoader.exists(path) else null
	return _texture

## Não toca no RNG da batalha: a mesma célula sempre recebe a mesma variação.
static func deterministic_variant(stage_id: String, x: int, y: int, seed: int, variants: int) -> int:
	if variants <= 1:
		return 0
	var hash_value := 2166136261
	for byte in stage_id.to_utf8_buffer():
		hash_value = int((hash_value ^ byte) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ (x * 73856093)) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ (y * 19349663)) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ seed) * 16777619) & 0x7fffffff
	return posmod(hash_value, variants)

func _available_atlas_variants(texture: Texture2D) -> int:
	if not use_modular_atlas:
		return 1
	var available_columns := _effective_atlas_columns(texture)
	var rows := texture.get_height() / atlas_tile_size.y
	var available := available_columns * rows
	return maxi(1, mini(atlas_variants, available))

func _effective_atlas_columns(texture: Texture2D) -> int:
	return maxi(1, mini(atlas_columns, texture.get_width() / atlas_tile_size.x))

func _atlas_uvs(texture: Texture2D, variant: int) -> PackedVector2Array:
	if not use_modular_atlas:
		return PackedVector2Array([
			Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)
		])
	var columns := _effective_atlas_columns(texture)
	var column := variant % columns
	var row := variant / columns
	var texture_size := Vector2(texture.get_width(), texture.get_height())
	var origin := Vector2(column * atlas_tile_size.x, row * atlas_tile_size.y) / texture_size
	var size := Vector2(atlas_tile_size) / texture_size
	return PackedVector2Array([
		origin, origin + Vector2(size.x, 0), origin + size, origin + Vector2(0, size.y)
	])

func _draw() -> void:
	if material == _root_art_material and (terrain_layout_id != "reino_abissal" or not use_root_art):
		material = null
	if terrain_layout_id == "raiz_yggdrasil":
		_draw_yggdrasil_prototype()
		return
	if terrain_layout_id == "domwieck":
		var art := get_parent().get_node_or_null("DomwieckArt") if get_parent() != null else null
		if art != null and art.has_method("is_active") and art.is_active():
			return
		_draw_domwieck_prototype()
		return
	if terrain_layout_id == "reino_abissal":
		if use_root_art and _prepare_root_art():
			if material != _root_art_material:
				material = _root_art_material
			draw_rect(_root_art_rect,Color.WHITE)
			return
		_draw_root_prototype()
		return
	var baked := _baked_texture()
	if baked != null:
		var span := float(map_size.x + map_size.y)
		draw_texture_rect(baked, Rect2(-float(map_size.x) * Iso.TILE_W * 0.5, 0.0, span * Iso.TILE_W * 0.5, span * Iso.TILE_H * 0.5), false)
		return
	TerrainLayout.scale = float(map_size.x) / 40.0
	var hw := Iso.TILE_W * 0.5
	var hh := Iso.TILE_H * 0.5
	var texture := _ground_texture()
	var available_variants := _available_atlas_variants(texture) if texture != null else 0
	var stage_id := _stage_id()
	for x in map_size.x:
		for y in map_size.y:
			var c := Iso.to_screen(Vector2(x + 0.5, y + 0.5))
			var points := PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])
			if not terrain_layout_id.is_empty():
				_draw_layout_cell(c, points, x, y, texture, available_variants)
				continue
			if texture != null:
				var variant := deterministic_variant(stage_id, x, y, visual_seed, available_variants)
				var tint := Color.WHITE if use_modular_atlas else (Color.WHITE if (x + y) % 2 == 0 else Color(0.9, 0.9, 0.94))
				draw_polygon(points, PackedColorArray([tint, tint, tint, tint]), _atlas_uvs(texture, variant), texture)
			else:
				draw_colored_polygon(points, color_a if (x + y) % 2 == 0 else color_b)

func _draw_yggdrasil_prototype() -> void:
	# Geometric QA study only; no approved final appearance is implied.
	var d := TerrainLayout.root_definition("raiz_yggdrasil")
	# Low-contrast vertical silhouette, separated from every supporting surface.
	draw_colored_polygon(PackedVector2Array([Vector2(930,-1400),Vector2(1160,-1400),Vector2(1110,365),Vector2(978,420)]),Color("11151e"))
	for i in 6:
		var x := 985.0+float(i)*22.0
		draw_line(Vector2(x,-1400),Vector2(x-12.0,355),Color("181b24"),3.0)
	var shapes: Array[PackedVector2Array] = []
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		var angle := (b-a).angle()
		var half := TerrainLayout.root_edge_width(d,edge)*0.5
		var points := PackedVector2Array()
		for i in 33:
			points.append(Iso.to_screen(b+Vector2.from_angle(angle-PI*0.5+PI*float(i)/32.0)*half))
		for i in 33:
			points.append(Iso.to_screen(a+Vector2.from_angle(angle+PI*0.5+PI*float(i)/32.0)*half))
		shapes.append(points)
	for node: Array in d.nodes.values():
		var points := PackedVector2Array()
		for i in 96:
			points.append(Iso.to_screen(TerrainLayout.root_point(node)+Vector2.from_angle(TAU*float(i)/96.0)*float(node[2])))
		shapes.append(points)
	for shape in shapes:
		var side := PackedVector2Array()
		for p in shape:
			side.append(p+Vector2(0,28))
		draw_colored_polygon(side,Color("171820"))
	for shape in shapes:
		draw_colored_polygon(shape,Color("3e342f"))
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		var normal := (b-a).normalized().orthogonal()
		var half := TerrainLayout.root_edge_width(d,edge)*0.5
		for strand in range(-6,7):
			var points := PackedVector2Array()
			for i in 33:
				var t := float(i)/32.0
				var offset := float(strand)*half/8.0+sin(t*12.0+float(strand))*0.06
				points.append(Iso.to_screen(a.lerp(b,t)+normal*offset))
			draw_polyline(points,Color("59483b") if strand%3==0 else Color("29282a"),2.0,true)
	# A thin geometric passage mark; HUD owns availability and presence feedback.
	var goal := Iso.to_screen(TerrainLayout.root_point(d.nodes.G))
	draw_arc(goal+Vector2(0,-20),18.0,PI,TAU,28,Color("a380c1"),3.0,true)

func _draw_root_prototype() -> void:
	# HQ17 Q3 v02: dark braided bark, suspended bridges and purple depth.
	# Geometry comes from the same capsules/disks as supporting collisions.
	var d := TerrainLayout.root_definition()
	var shapes: Array[PackedVector2Array] = []
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		var path := PackedVector2Array()
		var angle := (b - a).angle()
		for i in 33:
			path.append(Iso.to_screen(b + Vector2.from_angle(angle - PI * 0.5 + PI * float(i) / 32.0) * float(d.width) * 0.5))
		for i in 33:
			path.append(Iso.to_screen(a + Vector2.from_angle(angle + PI * 0.5 + PI * float(i) / 32.0) * float(d.width) * 0.5))
		shapes.append(path)
	for node: Array in d.nodes.values():
		var path := PackedVector2Array()
		for i in 96:
			path.append(Iso.to_screen(TerrainLayout.root_point(node) + Vector2.from_angle(TAU * float(i) / 96.0) * float(node[2])))
		shapes.append(path)
	for shape in shapes:
		var shadow := PackedVector2Array()
		for point in shape:
			shadow.append(point + Vector2(0,18))
		draw_colored_polygon(shadow, Color("090810"))
	# Draw edge thickness before ALL tops so connected roots have no false seam.
	for shape in shapes:
		var outline := shape.duplicate()
		outline.append(shape[0])
		draw_polyline(outline, Color("665048"), 3.0, true)
	for shape in shapes:
		draw_colored_polygon(shape, Color("251d24"))
	# Fine wood strands remain well inside the supporting six-unit capsules.
	for edge: Array in d.edges:
		var a := TerrainLayout.root_point(d.nodes[edge[0]])
		var b := TerrainLayout.root_point(d.nodes[edge[1]])
		var normal := (b - a).normalized().orthogonal()
		for strand in range(-9,10):
			var path := PackedVector2Array()
			for i in 61:
				var t := float(i) / 60.0
				var offset := float(strand) * 0.27 + sin(t * 17.0 + float(strand)) * 0.10
				path.append(Iso.to_screen(a.lerp(b,t) + normal * offset))
			draw_polyline(path, Color("4c3935") if strand % 3 == 0 else Color("15131c"), 2.5, true)
			if strand % 5 == 0:
				draw_line(path[19],path[21],Color("703c36"),1.5,true)
	for node: Array in d.nodes.values():
		var center := TerrainLayout.root_point(node)
		var radius := float(node[2]) - 0.12
		for axis in 2:
			var direction := Vector2.from_angle(float(axis) * PI * 0.5 + 0.23)
			var normal := direction.orthogonal()
			for strand in range(-int(radius * 3.0),int(radius * 3.0)+1):
				var offset := float(strand) / 3.0
				if absf(offset) >= radius:
					continue
				var half_length := sqrt(radius * radius - offset * offset)
				var path := PackedVector2Array()
				for i in 41:
					var t := float(i) / 20.0 - 1.0
					var braid := sin(t * 12.0 + float(strand) * 1.7) * 0.05 * (1.0-t*t)
					path.append(Iso.to_screen(center + direction * half_length * t + normal * (offset+braid)))
				draw_polyline(path,Color("49353a") if strand % 3 == 0 else Color("15131b"),2.0,true)

func _draw_domwieck_prototype() -> void:
	# Provisional stone streets, architecture and garden; all scenery is visual.
	for x in map_size.x:
		for y in map_size.y:
			var cell := Vector2(x, y)
			var tile := PackedVector2Array([Iso.to_screen(cell), Iso.to_screen(cell + Vector2(1,0)), Iso.to_screen(cell + Vector2(1,1)), Iso.to_screen(cell + Vector2(0,1))])
			var shade := 0.012 * float(posmod(x * 7 + y * 3, 4))
			draw_colored_polygon(tile, Color(0.18 + shade, 0.22 + shade, 0.27 + shade))
			if (x + y) % 2 == 0:
				draw_line(tile[0], tile[1], Color("35404a"), 1.0)
	for anchor in [Vector2(7,20),Vector2(23,22),Vector2(37,38),Vector2(53,40),Vector2(7,39),Vector2(53,21)]:
		_draw_domwieck_building(anchor, anchor.x < 30.0)
	_draw_ailalore_garden()

func _draw_domwieck_building(at: Vector2, burning: bool) -> void:
	var p := Iso.to_screen(at)
	var roof := p + Vector2(0,-62)
	draw_colored_polygon(PackedVector2Array([p + Vector2(-42,-8), p + Vector2(0,14), p + Vector2(42,-8), roof + Vector2(42,-8), roof + Vector2(-42,-8)]), Color("4c5963"))
	draw_colored_polygon(PackedVector2Array([roof + Vector2(-44,-8),roof + Vector2(0,-40),roof + Vector2(44,-8),roof + Vector2(0,13)]), Color("283c4a"))
	for side in [-1,1]:
		var spire := roof + Vector2(float(side) * 33.0,-8)
		draw_line(p + Vector2(float(side) * 33.0,-3), spire + Vector2(0,-27), Color("8498a4"), 4.0)
		draw_colored_polygon(PackedVector2Array([spire + Vector2(-7,-20),spire + Vector2(0,-39),spire + Vector2(7,-20)]), Color("a3b3bd"))
	draw_colored_polygon(PackedVector2Array([p + Vector2(-9,-3),p + Vector2(-9,-26),p + Vector2(0,-39),p + Vector2(9,-26),p + Vector2(9,-3)]), Color("192832"))
	if burning:
		var fire := p + Vector2(-36,1)
		draw_colored_polygon(PackedVector2Array([fire + Vector2(-10,0),fire + Vector2(-7,-18),fire + Vector2(0,-31),fire + Vector2(3,-13),fire + Vector2(12,-21),fire + Vector2(10,0)]), Color("c66b2b"))
		draw_colored_polygon(PackedVector2Array([fire + Vector2(-4,0),fire + Vector2(0,-18),fire + Vector2(6,0)]), Color("efbd61"))

func _draw_ailalore_garden() -> void:
	var center := Vector2(30,7)
	var garden := Iso.to_screen(center)
	draw_colored_polygon(Iso.ground_circle(garden, 4.0 * Iso.TILE_W * 0.5, 48), Color("233c35"))
	for x in range(-7,8):
		for y in range(-7,8):
			var offset := Vector2(float(x) * 0.5,float(y) * 0.5)
			if offset.length() > 3.6 or offset.length() < 1.0:
				continue
			var flower := Iso.to_screen(center + offset)
			draw_circle(flower, 3.0, Color("8f293b") if (x + y) % 2 == 0 else Color("ba3848"))
	for i in 28:
		var angle := float(i) * TAU / 28.0
		var point := Iso.to_screen(center + Vector2.from_angle(angle) * 5.6)
		draw_line(point, point + Vector2(0,-24), Color("50605b"), 4.0)
		draw_colored_polygon(PackedVector2Array([point + Vector2(-13,-14),point + Vector2(-10,-29),point + Vector2(0,-43),point + Vector2(12,-28),point + Vector2(14,-14)]), Color("193330"))
		draw_line(point + Vector2(0,-37),point + Vector2(0,-15),Color("2b4840"),2.0)
	# Ailalore is the intact light-blue fallen star, without health or interaction.
	var star := garden + Vector2(0,-12)
	draw_colored_polygon(PackedVector2Array([star + Vector2(0,-25),star + Vector2(8,-8),star + Vector2(30,-4),star + Vector2(12,5),star + Vector2(16,21),star + Vector2(0,11),star + Vector2(-16,21),star + Vector2(-12,5),star + Vector2(-30,-4),star + Vector2(-8,-8)]),Color("92d8f7"))
	draw_colored_polygon(PackedVector2Array([star + Vector2(0,-22),star + Vector2(7,0),star + Vector2(0,10),star + Vector2(-7,0)]),Color("d1efff"))
	var dome := PackedVector2Array()
	for i in 81:
		var angle := PI + float(i) * PI / 80.0
		dome.append(garden + Vector2(cos(angle) * 1700.0, 15.0 + sin(angle) * 185.0))
	draw_polyline(dome,Color(0.25,0.56,0.91,0.3),13.0)
	draw_polyline(dome,Color(0.46,0.76,1.0,0.65),2.0)
	draw_line(star,garden + Vector2(0,-170),Color(0.35,0.69,1.0,0.18),14.0)
	draw_line(star,garden + Vector2(0,-170),Color("a9e4ff"),3.0)

func _draw_layout_cell(center: Vector2, points: PackedVector2Array, x: int, y: int, texture: Texture2D, available_variants: int) -> void:
	var material := TerrainLayout.material_at(terrain_layout_id, Vector2(x + 0.5, y + 0.5))
	var base := TerrainLayout.color_for(material)
	var variant := deterministic_variant(terrain_layout_id, x, y, visual_seed, 8)
	var accepts_ground_texture := material == TerrainLayout.MATERIAL_FUNGAL_SOIL or material == TerrainLayout.MATERIAL_MYCELIUM or material == TerrainLayout.MATERIAL_OOZE_CRUST or material == TerrainLayout.MATERIAL_MOLOR_ROCK or material == TerrainLayout.MATERIAL_MOLOR_DETRITUS or material == TerrainLayout.MATERIAL_MOLOR_OOZE or material == TerrainLayout.MATERIAL_FENG_TU_STONE or material == TerrainLayout.MATERIAL_FENG_TU_ASH or material == TerrainLayout.MATERIAL_FENG_TU_CRACK or material == TerrainLayout.MATERIAL_SHENDILAVRI_MARBLE or material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN or material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST or material == TerrainLayout.MATERIAL_GORANTHIS_TERRACE or material == TerrainLayout.MATERIAL_GORANTHIS_PEARL or material == TerrainLayout.MATERIAL_GORANTHIS_MOSS or material == TerrainLayout.MATERIAL_PILLARS_OBSIDIAN or material == TerrainLayout.MATERIAL_PILLARS_BASALT or material == TerrainLayout.MATERIAL_PILLARS_DUST
	if accepts_ground_texture and texture != null:
		var atlas_variant := deterministic_variant(terrain_layout_id, x, y, visual_seed, available_variants)
		var tint := Color("a99bab")
		if material == TerrainLayout.MATERIAL_MYCELIUM:
			tint = Color("c4b3c0")
		elif material == TerrainLayout.MATERIAL_OOZE_CRUST:
			tint = Color("9ba276")
		elif material == TerrainLayout.MATERIAL_MOLOR_ROCK:
			tint = Color("8c9982")
		elif material == TerrainLayout.MATERIAL_MOLOR_DETRITUS:
			tint = Color("9a996d")
		elif material == TerrainLayout.MATERIAL_MOLOR_OOZE:
			tint = Color("829a4f")
		elif material == TerrainLayout.MATERIAL_FENG_TU_STONE:
			tint = Color("85909a")
		elif material == TerrainLayout.MATERIAL_FENG_TU_ASH:
			tint = Color("9b9290")
		elif material == TerrainLayout.MATERIAL_FENG_TU_CRACK:
			tint = Color("677080")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_MARBLE:
			tint = Color("a380a8")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN:
			tint = Color("b177a4")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST:
			tint = Color("c59ab9")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_TERRACE:
			tint = Color("c9bd8d")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_PEARL:
			tint = Color("e0d7ae")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_MOSS:
			tint = Color("a9ae72")
		elif material == TerrainLayout.MATERIAL_PILLARS_OBSIDIAN:
			tint = Color("766a98")
		elif material == TerrainLayout.MATERIAL_PILLARS_BASALT:
			tint = Color("9285ae")
		elif material == TerrainLayout.MATERIAL_PILLARS_DUST:
			tint = Color("b0a0c4")
		draw_polygon(points, PackedColorArray([tint, tint, tint, tint]), _atlas_uvs(texture, atlas_variant), texture)
	else:
		draw_colored_polygon(points, base)
	if material == TerrainLayout.MATERIAL_CURRENT or material == TerrainLayout.MATERIAL_SHALLOW:
		# Águas lentas do Estige: bolhas e reflexos deixam a travessia legível.
		var gel := Color("4ba8b8") if material == TerrainLayout.MATERIAL_SHALLOW else Color("2c768d")
		if variant % 3 == 0:
			draw_circle(center + Vector2(variant - 4, -2), 1.8, Color(gel, 0.72))
		if variant == 1:
			draw_circle(center + Vector2(5, 3), 1.1, Color("91d7a2", 0.5))
	elif material == TerrainLayout.MATERIAL_SHEDAKLAH_STYX:
		# Braços calmos: a regra comum do Estige é aplicada pela batalha.
		if variant % 3 == 0:
			draw_line(center + Vector2(-9, 1), center + Vector2(8, -2), Color("475766", 0.52), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHEDAKLAH_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("8e7886", 0.42))
	elif material == TerrainLayout.MATERIAL_MYCELIUM and variant % 3 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(6, -2), Color("9c8294", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_OOZE_CRUST and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 1.7, Color("788452", 0.42))
	elif material == TerrainLayout.MATERIAL_MOLOR_OOZE and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 2.1, Color("94ad54", 0.42))
	elif material == TerrainLayout.MATERIAL_MOLOR_DETRITUS and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.3, Color("6e7650", 0.45))
	elif material == TerrainLayout.MATERIAL_MOLOR_WALL and variant % 2 == 0:
		draw_line(center + Vector2(-9, 2), center + Vector2(8, -3), Color("31462f", 0.75), 1.4, true)
	elif material == TerrainLayout.MATERIAL_FENG_TU_CRACK and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(6, -3), Color("151a24", 0.64), 1.0, true)
	elif material == TerrainLayout.MATERIAL_FENG_TU_ASH and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.3, Color("b59e8f", 0.30))
	elif material == TerrainLayout.MATERIAL_FENG_TU_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("0d1119", 0.75), 1.3, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_STYX:
		# Água escura e parada; o risco mental vem da camada ambiental comum.
		if variant % 3 == 0:
			draw_line(center + Vector2(-9, 1), center + Vector2(8, -2), Color("6d5b82", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("aa728f", 0.34))
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("8f597f", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("d0a6c4", 0.30))
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("1a1222", 0.78), 1.3, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_STYXFALL:
		# A queda continua imóvel; sua base acessível usa o contrato comum do Estige.
		if variant % 2 == 0:
			draw_line(center + Vector2(-8, -5), center + Vector2(8, 5), Color("d6e5d1", 0.58), 1.4, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("d9cc9a", 0.36))
	elif material == TerrainLayout.MATERIAL_GORANTHIS_PEARL and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("eee2b8", 0.35), 1.0, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_MOSS and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("c2c982", 0.36))
	elif material == TerrainLayout.MATERIAL_GORANTHIS_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("4d4839", 0.75), 1.3, true)
	elif material == TerrainLayout.MATERIAL_PILLARS_BASALT and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("514568", 0.52), 1.0, true)
	elif material == TerrainLayout.MATERIAL_PILLARS_DUST and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("c1b3d1", 0.30))
	elif material == TerrainLayout.MATERIAL_PILLARS_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("0d0c18", 0.80), 1.3, true)
	elif material == TerrainLayout.MATERIAL_BANK and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("8f6351"), 1.0, true)
	elif material == TerrainLayout.MATERIAL_ASH and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 1.5, Color("2c2428"))
	elif material == TerrainLayout.MATERIAL_PLATEAU and variant % 4 == 0:
		draw_line(center + Vector2(-7, 3), center + Vector2(5, -3), Color("2b2227"), 1.0, true)
