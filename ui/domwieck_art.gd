extends Node2D
## Local visual composition only. Gameplay geometry and state stay authoritative elsewhere.

const CONFIG := "res://data/domwieck_art.json"

class FloorLayer extends Node2D:
	var composer: Node2D
	func _draw() -> void:
		composer.draw_floor(self)

var config: Dictionary = {}
var textures: Dictionary = {}
var _ground: Node2D
var _floor: Node2D
var _sorted: Node2D
var _sprites: Array[Sprite2D] = []
var _occluders: Array[Sprite2D] = []
var _ready_art := false
var _last_active := false

static func read_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG):
		return {}
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG))
	return raw if raw is Dictionary else {}

func prepare(candidate: Dictionary = {}) -> bool:
	config = read_config() if candidate.is_empty() else candidate
	textures.clear()
	if config.get("stage_id", "") != "domwieck":
		return false
	for id in ["ground", "architecture", "vegetation", "garden", "ailalore", "ambient"]:
		var resource_path := String(config.get("textures", {}).get(id, ""))
		if resource_path.is_empty() or not ResourceLoader.exists(resource_path):
			return false
		var resource = load(resource_path)
		if not resource is Texture2D:
			return false
		textures[id] = resource
	return true

func _ready() -> void:
	var stage := get_parent()
	_ground = stage.get_node_or_null("Ground")
	_sorted = stage.get_node_or_null("Sorted")
	if _ground == null or _sorted == null or _ground.get("terrain_layout_id") != "domwieck" or not prepare():
		return
	_floor = FloorLayer.new()
	_floor.composer = self
	_floor.z_index = -99
	_floor.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(_floor)
	_build_scenery()
	_ready_art = true
	_refresh()

func is_active() -> bool:
	return _ready_art and is_instance_valid(_ground) and bool(_ground.get("use_domwieck_art"))

func _process(_dt: float) -> void:
	_refresh()
	if not is_active():
		return
	var hero := _sorted.get_node_or_null("Hero") as Node2D
	if hero == null:
		return
	for sprite in _occluders:
		var size: Vector2 = sprite.get_meta("display_size")
		var p := hero.position - sprite.position
		# Fade a generous combat neighborhood, not just the hero's exact pixel.
		var overlaps := absf(p.x) < size.x * 0.5 + 72.0 and p.y > -size.y - 48.0 and p.y < 40.0
		sprite.modulate.a = float(config.canopy_fade) if overlaps else 1.0

func _refresh() -> void:
	var active := is_active()
	if is_instance_valid(_floor):
		_floor.visible = active
	for sprite in _sprites:
		sprite.visible = active
	if active != _last_active:
		_ground.queue_redraw()
		_last_active = active

func _exit_tree() -> void:
	# These nodes live in the stage's y-sorted sibling container.
	for sprite in _sprites:
		if is_instance_valid(sprite):
			sprite.queue_free()

func atlas_rect(id: String, variant: int) -> Rect2:
	var raw: Array = config.rects[id][variant]
	var texture: Texture2D = textures[id]
	return Rect2(float(raw[0])*texture.get_width(), float(raw[1])*texture.get_height(), float(raw[2])*texture.get_width(), float(raw[3])*texture.get_height()).grow(-1.0)

func _sprite(id: String, variant: int, at: Vector2, height: float, tint: Color = Color.WHITE, occluder: bool = false) -> Sprite2D:
	var sprite := Sprite2D.new()
	var rect := atlas_rect(id, variant)
	sprite.texture = textures[id]
	sprite.region_enabled = true
	sprite.region_rect = rect
	sprite.region_filter_clip_enabled = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.position = Iso.to_screen(at)
	sprite.centered = false
	sprite.offset = Vector2(-rect.size.x*0.5, -rect.size.y)
	sprite.scale = Vector2.ONE * height / rect.size.y
	sprite.modulate = tint
	sprite.set_meta("display_size", rect.size * sprite.scale)
	sprite.set_meta("art_kind", id)
	_sorted.add_child(sprite)
	_sprites.append(sprite)
	if occluder:
		_occluders.append(sprite)
	return sprite

func _build_scenery() -> void:
	for i in config.building_anchors.size():
		var anchor: Array = config.building_anchors[i]
		var at := Vector2(float(anchor[0]), float(anchor[1]))
		_sprite("architecture", i%4, at, float(config.building_heights[i]), Color("b9c0cb"), true)
		if PackedInt32Array(config.burning_indices).has(i):
			var fire := _sprite("ambient", i%2, at + Vector2(-0.35,0.35), float(config.fire_height), Color(1.0,0.85,0.65,0.8))
			fire.z_index = 1
	var center := Vector2(float(config.garden_center[0]), float(config.garden_center[1]))
	for i in int(config.tree_count):
		_sprite("vegetation", i%4, center + tree_offset(i), float(config.tree_height), Color("a3afb0"), true)
	_sprite("ailalore",0,center,float(config.star_height),Color(0.87,0.94,1.0),true)
	var aura := _sprite("ambient",2,center,float(config.aura_height),Color(0.7,0.85,1.0,0.14))
	aura.z_index = -1
	aura.offset.y = -aura.region_rect.size.y*0.55
	aura.scale.y *= 0.5

## Anel aberto para o sul (de onde o grupo chega), com raio e ângulo levemente irregulares e determinísticos.
func tree_offset(i: int) -> Vector2:
	var count := int(config.tree_count)
	var gap := deg_to_rad(float(config.tree_entrance_gap))
	var arc := TAU - gap
	var step := arc / float(count)
	var angle := deg_to_rad(float(config.tree_entrance_angle)) + gap * 0.5 + (float(i) + 0.5) * step
	angle += _jitter(i, 1.7) * step * float(config.tree_angle_jitter)
	var radius := float(config.tree_radius) + _jitter(i, 4.3) * float(config.tree_radial_jitter)
	return Vector2.from_angle(angle) * radius

func _jitter(i: int, salt: float) -> float:
	return fposmod(sin(float(i) * 12.9898 + salt * 78.233) * 43758.5453, 1.0) * 2.0 - 1.0

func _quad(canvas: Node2D, at: Vector2, size: Vector2, id: String, variant: int, tint: Color) -> void:
	var points := PackedVector2Array([Iso.to_screen(at),Iso.to_screen(at+Vector2(size.x,0)),Iso.to_screen(at+size),Iso.to_screen(at+Vector2(0,size.y))])
	var texture: Texture2D = textures[id]
	var rect := atlas_rect(id,variant)
	var uv := rect.position/Vector2(texture.get_size())
	var span := rect.size/Vector2(texture.get_size())
	canvas.draw_polygon(points,PackedColorArray([tint,tint,tint,tint]),PackedVector2Array([uv,uv+Vector2(span.x,0),uv+span,uv+Vector2(0,span.y)]),texture)

func _flower_disk(canvas: Node2D, at: Vector2, radius: float, variant: int) -> void:
	var texture: Texture2D = textures.garden
	var rect := atlas_rect("garden",variant)
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	for i in 48:
		var unit := Vector2.from_angle(TAU*float(i)/48.0)
		points.append(Iso.to_screen(at+unit*radius))
		uvs.append((rect.position+(unit*0.5+Vector2.ONE*0.5)*rect.size)/Vector2(texture.get_size()))
	canvas.draw_polygon(points,PackedColorArray([Color("b1b7b4")]),uvs,texture)

func draw_floor(canvas: Node2D) -> void:
	# Overhead materials receive the existing projection exactly once.
	for x in range(0,60,2):
		for y in range(0,60,2):
			var variant := 3 if x in range(26,34) else 0
			_quad(canvas,Vector2(x,y),Vector2(2,2),"ground",variant,Color(config.ground_tint))
	var center := Vector2(float(config.garden_center[0]),float(config.garden_center[1]))
	canvas.draw_colored_polygon(Iso.ground_circle(Iso.to_screen(center),float(config.flower_radius)*Iso.TILE_W*0.5*sqrt(2.0),64),Color("172b28"))
	var flower_step := 0.7
	var flower_limit := float(config.flower_radius) - flower_step
	var flower_span := ceili(flower_limit / flower_step)
	for x in range(-flower_span,flower_span + 1):
		for y in range(-flower_span,flower_span + 1):
			var offset := Vector2(x,y)*flower_step
			if offset.length()>flower_limit:
				continue
			_flower_disk(canvas,center+offset,0.8,0 if posmod(x+y,3) else 1)
	var origin := Iso.to_screen(center)+Vector2(0,-float(config.star_height)*0.55)
	var end := Iso.to_screen(center)+Vector2(0,-float(config.beam_top))
	canvas.draw_line(origin,end,Color(0.35,0.69,1.0,0.12),11.0)
	canvas.draw_line(origin,end,Color(0.65,0.87,1.0,0.72),2.0)
	var dome := PackedVector2Array()
	for i in 81:
		var angle := PI+float(i)*PI/80.0
		dome.append(Iso.to_screen(center)+Vector2(cos(angle)*1700.0,8.0+sin(angle)*185.0))
	canvas.draw_polyline(dome,Color(0.25,0.56,0.91,0.15),8.0)
	canvas.draw_polyline(dome,Color(0.46,0.76,1.0,0.48),1.5)
