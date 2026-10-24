class_name BossVfx
extends RefCounted
## Visual-only mecânicas de chefe (Lote 2, série G). Geometria, dano e tempo continuam em BossMechanics: aqui só se lê o
## estado e se descreve o que desenhar. O contorno de perigo de BossMechanics.draw_fx permanece SEMPRE desenhado por baixo.
const SLOWMO_SCALE := 0.35
const SLOWMO_SECONDS := 0.5
const FLASH_ALPHA := 0.5
const FLASH_SECONDS := 0.25
const SECTOR_COUNT := 4
const SECTOR_STEPS := 10
const BURST_SECONDS := 0.5
## Raio, em px da célula de 256, das pontas do selo (G03) e das setas da mira (G04): é o que vale um raio de telégrafo.
const SIGIL_HALF_PX := 74.0
const MARK_HALF_PX := 75.0
const DOME_PX := 130.0
const DOME_ART_PX := 203.0
const BASE_ANCHOR_Y := 196.0
const SCALE_MIN := 0.8
const SCALE_MAX := 1.6
## Fatias [x, largura] da barra na célula: pontas fixas e miolo esticado ao comprimento da varredura.
const BEAM := {
	"boss_varredura_aviso": {"l": [24.0, 56.0], "m": [80.0, 96.0], "r": [176.0, 56.0], "k": 0.46},
	"boss_varredura_feixe": {"l": [24.0, 56.0], "m": [80.0, 96.0], "r": [176.0, 56.0], "k": 0.50},
}
const SHEETS := ["boss_varredura_aviso", "boss_varredura_feixe", "boss_quadrante_runas", "boss_marca_alvo", "boss_conjuracao_carga",
	"boss_conjuracao_estouro", "boss_conjuracao_interrompida", "boss_escudo", "boss_fase_estouro"]
const EIGHT_CELL := ["boss_quadrante_runas", "boss_marca_alvo", "boss_escudo"]

## Chefes grandes não podem produzir efeitos do tamanho da tela: a escala da arte acompanha o chefe só entre 0,8 e 1,6.
static func fit(boss_scale: float) -> float:
	return clampf(boss_scale, SCALE_MIN, SCALE_MAX)

static func path_for(sheet: String) -> String:
	return "res://assets/vfx/%s.png" % sheet

static func cinematic_allowed(reduced: bool) -> bool:
	return not reduced

static func make_flash() -> ColorRect:
	var rect := ColorRect.new()
	rect.color = Color(1.0, 0.97, 0.9, FLASH_ALPHA)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.add_to_group(&"boss_flash")
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	return rect

static func _additive() -> CanvasItemMaterial:
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	return material

# ------------------------------------------------------------------ nós

class BeamNode extends Node2D:
	var texture: Texture2D
	var sheet := ""
	var length := 100.0
	var frame := 0

	func _draw() -> void:
		if texture == null or not BossVfx.BEAM.has(sheet):
			return
		var spec: Dictionary = BossVfx.BEAM[sheet]
		var left: Array = spec.l
		var middle: Array = spec.m
		var right: Array = spec.r
		var k: float = spec.k
		var caps := (float(left[1]) + float(right[1])) * k
		if length < caps and caps > 0.0:
			k *= length / caps
		var height := 256.0 * k
		var x0 := float(frame) * 256.0
		var cap_left := float(left[1]) * k
		var cap_right := float(right[1]) * k
		var mid_width := maxf(0.0, length - cap_left - cap_right)
		draw_texture_rect_region(texture, Rect2(0.0, -height * 0.5, cap_left, height), Rect2(x0 + float(left[0]), 0.0, float(left[1]), 256.0))
		draw_texture_rect_region(texture, Rect2(cap_left, -height * 0.5, mid_width, height), Rect2(x0 + float(middle[0]), 0.0, float(middle[1]), 256.0))
		draw_texture_rect_region(texture, Rect2(cap_left + mid_width, -height * 0.5, cap_right, height), Rect2(x0 + float(right[0]), 0.0, float(right[1]), 256.0))

class SectorNode extends Node2D:
	var texture: Texture2D
	var center := Vector2.ZERO   # chão, em tiles
	var radius := 1.0
	var sectors: Array = []
	var frame := 0
	var alpha := 1.0
	var burst := false
	var age := 0.0

	func _process(delta: float) -> void:
		if not burst:
			return
		age += delta
		if age >= BossVfx.BURST_SECONDS:
			queue_free()
			return
		frame = 4 + mini(3, int(age / (BossVfx.BURST_SECONDS / 4.0)))
		alpha = clampf((BossVfx.BURST_SECONDS - age) / 0.15, 0.0, 1.0)
		queue_redraw()

	func _draw() -> void:
		if texture == null or radius <= 0.0:
			return
		var origin := Iso.to_screen(center)
		for s in sectors:
			var points := PackedVector2Array([Vector2.ZERO])
			for step in BossVfx.SECTOR_STEPS + 1:
				points.append(Vector2.from_angle((float(s) + float(step) / float(BossVfx.SECTOR_STEPS)) * TAU / float(BossVfx.SECTOR_COUNT)) * radius)
			var screen := PackedVector2Array()
			var uvs := PackedVector2Array()
			var colors := PackedColorArray()
			for g in points:
				screen.append(Iso.to_screen(center + g) - origin)
				var t := (g / radius).rotated(-PI / 4.0) * BossVfx.SIGIL_HALF_PX   # pontas cardinais da arte no meio de cada fatia
				uvs.append(Vector2((float(frame) * 256.0 + 128.0 + t.x) / float(texture.get_width()), (128.0 + t.y) / 256.0))
				colors.append(Color(1, 1, 1, alpha))
			draw_polygon(screen, colors, uvs, texture)

# ------------------------------------------------------------------ descrição (pura, sem nós, sem mutação)

static func _alive_totems(mech: BossMechanics) -> int:
	var n := 0
	for t in mech.totems:
		if is_instance_valid(t) and not t.dead:
			n += 1
	return n

static func shield_active(mech: BossMechanics) -> bool:
	if mech.finished or mech.boss == null or mech.boss.dead:
		return false
	return (_alive_totems(mech) > 0 and mech.shield > 0.0) or mech.armor_t > 0.0 or mech.is_immune(mech.boss)

static func describe(mech: BossMechanics) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if mech == null or mech.finished or mech.boss == null or mech.boss.dead:
		return out
	var boss_scale := float(mech.boss.scale)
	if not mech.sweep.is_empty():
		var warn: bool = float(mech.sweep.t) < float(mech.sweep.warn)
		var index := 0
		for off in mech.sweep.get("offsets", [0.0]):
			var tip: Vector2 = (mech.sweep.origin as Vector2) + Vector2.from_angle(float(mech.sweep.a) + float(off)) * float(mech.sweep.len)
			out.append({"key": "sweep:%d" % index, "kind": "beam", "layer": "fx", "sheet": "boss_varredura_aviso" if warn else "boss_varredura_feixe", "from": mech.sweep.origin, "to": tip})
			index += 1
	if not mech.quad.is_empty():
		out.append({"key": "quad", "kind": "sectors", "layer": "under", "center": mech.quad.center, "radius": float(mech.quad.radius), "sectors": (mech.quad.sectors as Array).duplicate(),
			"ratio": clampf(1.0 - float(mech.quad.t) / maxf(0.01, float(mech.quad.total)), 0.0, 1.0)})
	if not mech.mark.is_empty():
		out.append({"key": "mark", "kind": "ring", "layer": "under", "pos": mech.mark.pos, "radius": float(mech.mark.radius), "locked": float(mech.mark.t) >= float(mech.mark.follow)})
	if not mech.cast.is_empty():
		out.append({"key": "cast", "kind": "charge", "layer": "fx", "pos": mech.boss.pos, "scale": boss_scale, "ratio": clampf(1.0 - float(mech.cast.t) / maxf(0.01, float(mech.cast.total)), 0.0, 1.0)})
	if shield_active(mech):
		out.append({"key": "shield", "kind": "dome", "layer": "fx", "pos": mech.boss.pos, "scale": boss_scale})
	return out

# ------------------------------------------------------------------ construção e atualização

static func _ring_scale(radius: float) -> Vector2:
	var half_width := Iso.TILE_W * radius * sqrt(2.0) * 0.5
	var s := half_width / MARK_HALF_PX
	return Vector2(s, s * Iso.TILE_H / Iso.TILE_W)

static func build(desc: Dictionary) -> Node2D:
	var node: Node2D = null
	match String(desc.kind):
		"beam":
			var texture := VfxAtlas.texture(path_for(String(desc.sheet)))
			if texture == null:
				return null
			var beam := BeamNode.new()
			beam.texture = texture
			beam.sheet = String(desc.sheet)
			beam.material = _additive()
			node = beam
		"sectors":
			var texture8 := VfxAtlas.texture(path_for("boss_quadrante_runas"), 8)
			if texture8 == null:
				return null
			var sectors := SectorNode.new()
			sectors.texture = texture8
			sectors.material = _additive()
			node = sectors
		"ring":
			node = VfxAtlas.sprite8(path_for("boss_marca_alvo"), "loop", 0.6)
		"charge":
			var charge := VfxAtlas.sprite(path_for("boss_conjuracao_carga"), true, 0.8)
			if charge != null:
				charge.offset.y = 128.0 - BASE_ANCHOR_Y
			node = charge
		"dome":
			var dome := VfxAtlas.sprite8(path_for("boss_escudo"), "loop", 0.8)
			if dome != null:
				dome.offset.y = 128.0 - BASE_ANCHOR_Y
			node = dome
	if node != null:
		node.set_meta(&"kind", String(desc.kind))
		node.add_to_group(&"boss_vfx")
	return node

static func update(node: Node2D, desc: Dictionary, now_ms: int) -> void:
	match String(desc.kind):
		"beam":
			var beam := node as BeamNode
			var start: Vector2 = Iso.to_screen(desc["from"]) + Vector2(0, -8)
			var finish: Vector2 = Iso.to_screen(desc["to"]) + Vector2(0, -8)
			beam.position = start
			beam.rotation = (finish - start).angle()
			beam.length = start.distance_to(finish)
			beam.sheet = String(desc.sheet)
			beam.texture = VfxAtlas.texture(path_for(beam.sheet))
			beam.frame = int(now_ms / 80) % 6
			beam.queue_redraw()
		"sectors":
			var sectors := node as SectorNode
			sectors.center = desc.center
			sectors.radius = float(desc.radius)
			sectors.sectors = desc.sectors
			sectors.position = Iso.to_screen(sectors.center)
			sectors.frame = int(now_ms / 170) % 4
			sectors.alpha = 0.55 + 0.45 * float(desc.ratio)
			sectors.queue_redraw()
		"ring":
			node.position = Iso.to_screen(desc.pos)
			node.scale = _ring_scale(float(desc.radius))
			node.modulate = Color(1.0, 0.55, 0.45, 1.0) if bool(desc.locked) else Color(1, 1, 1, 0.85)
		"charge":
			node.position = Iso.to_screen(desc.pos)
			node.scale = Vector2.ONE * 0.8 * fit(float(desc.scale))
			node.modulate.a = 0.4 + 0.6 * float(desc.ratio)
		"dome":
			node.position = Iso.to_screen(desc.pos)
			node.scale = Vector2.ONE * DOME_PX * fit(float(desc.scale)) / DOME_ART_PX
			node.modulate.a = 0.85

# ------------------------------------------------------------------ explosões pontuais (eventos)

static func _one_shot_sprite(sprite: AnimatedSprite2D, at_screen: Vector2) -> Node2D:
	if sprite == null:
		return null
	var root := VfxAtlas.one_shot(sprite, at_screen)
	root.add_to_group(&"boss_vfx")
	return root

## Detonação do quadrante, da marca e da conjuração, a partir do evento `telegraph_burst` (com `verb`).
static func create_burst(event: Dictionary, boss_scale: float = 1.0, reduced: bool = false) -> Node2D:
	if reduced:
		return null
	var pos: Vector2 = event.get("pos", Vector2.ZERO)
	match String(event.get("verb", "")):
		"quad":
			var texture := VfxAtlas.texture(path_for("boss_quadrante_runas"), 8)
			if texture == null or (event.get("sectors", []) as Array).is_empty():
				return null
			var node := SectorNode.new()
			node.texture = texture
			node.material = _additive()
			node.center = pos
			node.radius = float(event.get("radius", 1.0))
			node.sectors = (event.get("sectors", []) as Array).duplicate()
			node.position = Iso.to_screen(pos)
			node.burst = true
			node.frame = 4
			node.add_to_group(&"boss_vfx")
			return node
		"mark":
			var sprite := VfxAtlas.sprite8(path_for("boss_marca_alvo"), "burst", 0.6, BURST_SECONDS)
			if sprite == null:
				return null
			sprite.scale = _ring_scale(float(event.get("radius", 1.0)))
			return _one_shot_sprite(sprite, Iso.to_screen(pos))
		"cast":
			var burst := VfxAtlas.sprite(path_for("boss_conjuracao_estouro"), false, BURST_SECONDS)
			if burst == null:
				return null
			burst.scale = Vector2.ONE * fit(boss_scale)
			return _one_shot_sprite(burst, Iso.to_screen(pos) + Vector2(0, -30.0 * fit(boss_scale)))
	return null

static func create_interrupt(pos: Vector2, boss_scale: float = 1.0, reduced: bool = false) -> Node2D:
	if reduced:
		return null
	var sprite := VfxAtlas.sprite(path_for("boss_conjuracao_interrompida"), false, 0.6)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * 0.9 * fit(boss_scale)
	return _one_shot_sprite(sprite, Iso.to_screen(pos) + Vector2(0, -40.0 * fit(boss_scale)))

static func create_phase_burst(pos: Vector2, boss_scale: float = 1.0, reduced: bool = false) -> Node2D:
	if reduced:
		return null
	var sprite := VfxAtlas.sprite(path_for("boss_fase_estouro"), false, 0.8)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * 0.8 * fit(boss_scale)
	sprite.offset.y = 128.0 - BASE_ANCHOR_Y
	return _one_shot_sprite(sprite, Iso.to_screen(pos))

static func create_shield_break(pos: Vector2, boss_scale: float = 1.0, reduced: bool = false) -> Node2D:
	if reduced:
		return null
	var sprite := VfxAtlas.sprite8(path_for("boss_escudo"), "burst", 0.8, BURST_SECONDS)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * DOME_PX * fit(boss_scale) / DOME_ART_PX
	sprite.offset.y = 128.0 - BASE_ANCHOR_Y
	return _one_shot_sprite(sprite, Iso.to_screen(pos))
