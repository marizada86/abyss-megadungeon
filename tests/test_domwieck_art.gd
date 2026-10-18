extends RefCounted

func run() -> Array:
	var out: Array = []
	var script = load("res://ui/domwieck_art.gd")
	var composer = script.new()
	if not composer.prepare():
		out.append("Domwieck art resources unavailable")
		composer.free()
		return out
	var config: Dictionary = composer.config
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/domwieck-art-20261017/kit-r1/manifest.json"))
	var bytes := 0
	for entry in manifest.entries:
		var id := String(entry.id)
		if FileAccess.get_sha256(String(config.textures[id])) != String(entry.sha256):
			out.append("Admitted source differs from owner-approved PNG: "+id)
		var texture: Texture2D = composer.textures[id]
		bytes += texture.get_width()*texture.get_height()*4
		if texture.get_width()>1024 or texture.get_height()>1024:
			out.append("Import exceeds 1024: "+id)
		var importer := ConfigFile.new()
		if importer.load(String(config.textures[id])+".import") != OK or bool(importer.get_value("params","mipmaps/generate",true)):
			out.append("Import budget/mipmap policy changed")
		for index in config.rects[id].size():
			var rect: Rect2 = composer.atlas_rect(id,index)
			if not Rect2(Vector2.ZERO,Vector2(texture.get_size())).encloses(rect) or rect.size.x<=0 or rect.size.y<=0:
				out.append("Invalid atlas rectangle: "+id)
	if bytes>24*1024*1024 or config.rects.garden.size()!=3 or PackedInt32Array(config.excluded_garden_variants)!=PackedInt32Array([3]):
		out.append("Budget or exclusion of raised rubble not respected")
	if composer.prepare({"stage_id":"domwieck","textures":{}}):
		out.append("Missing art must select fallback")
	if composer.prepare({"stage_id":"reino_abissal"}):
		out.append("Domwieck art must not activate on other maps")
	composer.free()
	var stage: Node2D = load("res://ui/stages/domwieck.tscn").instantiate()
	var art = stage.get_node("DomwieckArt")
	art._ready()
	if not art.is_active() or not stage.get_node("Sorted").y_sort_enabled:
		out.append("Art must use stage Sorted container")
	if art._occluders.size()!=35 or art._sprites.size()!=39:
		out.append("Unexpected architecture, canopy or effects population")
	for sprite in art._sprites:
		if sprite.get_parent()!=stage.get_node("Sorted"):
			out.append("Tall scenery outside y-sorted container")
	var ground = stage.get_node("Ground")
	ground.use_domwieck_art=false
	if art.is_active():
		out.append("Prototype fallback toggle ineffective")
	ground.use_domwieck_art=true
	if not art.is_active():
		out.append("Art failed to reactivate")
	var hero: Node2D = stage.get_node("Sorted/Hero")
	var canopy: Sprite2D = art._occluders[6]
	hero.position = canopy.position - Vector2(0,24)
	art._process(0.0)
	if canopy.modulate.a>0.4:
		out.append("Canopy failed to reveal hero/combat neighborhood")
	hero.position=Vector2(99999,99999)
	art._process(0.0)
	if canopy.modulate.a<0.99:
		out.append("Canopy failed to restore opacity after hero left")
	for row in config.building_anchors:
		var p := Vector2(float(row[0]),float(row[1]))
		if p.distance_to(Vector2(30,45))<6 or p.distance_to(Vector2(30,15))<4 or (p.x>=27 and p.x<=33):
			out.append("Scenery base entered reserved arrival, objective or central route")
	stage.free()
	return out
