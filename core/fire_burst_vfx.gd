class_name FireBurstVfx
extends Node2D
## Visual-only explosion for the fire novas (Bola de Fogo, Tormenta de Fogo). Radius comes from the nova event; no gameplay state.

const DURATION := 0.6
const EMBERS := 22
const LAYERS := 5
var _rx := 1.0
var _ry := 1.0
var _t := 0.0:
	set(value):
		_t = value
		queue_redraw()

static func supports(event: Dictionary, reduced_impact: bool = false) -> bool:
	return not reduced_impact and event.get("type", "") == "nova" and event.get("dtype", "") == "fogo" and float(event.get("radius", 0.0)) > 0.0

## Semi-axes of the ground circle of `radius` tiles on screen (same projection as RadiantPulseVfx).
static func axes_for_radius(radius: float) -> Vector2:
	return Vector2(Iso.TILE_W, Iso.TILE_H) * (radius * sqrt(2.0) * 0.5)

static func create_effect(event: Dictionary, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	var node := FireBurstVfx.new()
	var axes := axes_for_radius(float(event.radius))
	node._rx = axes.x
	node._ry = axes.y
	node.position = Iso.to_screen(event.pos)
	node.z_index = 1
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	node.material = material
	var tween := node.create_tween()
	tween.tween_property(node, "_t", 1.0, DURATION)
	tween.tween_callback(node.queue_free)
	return node

func _ellipse(scale_: float, offset: Vector2 = Vector2.ZERO) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 41:
		var a := TAU * i / 40.0
		pts.append(offset + Vector2(cos(a) * _rx * scale_, sin(a) * _ry * scale_))
	return pts

func _draw() -> void:
	var grow := 1.0 - pow(1.0 - clampf(_t * 1.6, 0.0, 1.0), 3.0)   # a bola abre rápido e assenta
	var fade := 1.0 - _t
	# Piso em brasa: camadas concêntricas do vermelho na borda ao amarelo no centro.
	for layer in LAYERS:
		var k := float(layer) / float(LAYERS - 1)
		var col := Color(1.0, 0.18 + 0.72 * k, 0.04 + 0.5 * k * k, (0.16 + 0.1 * k) * fade)
		draw_colored_polygon(_ellipse(grow * (1.0 - 0.82 * k)), col)
	# Anel de choque na borda.
	var ring := _ellipse(grow)
	draw_polyline(ring, Color(1.0, 0.62, 0.15, 0.95 * fade), 3.0 + 7.0 * fade, true)
	draw_polyline(_ellipse(grow * 0.92), Color(1.0, 0.9, 0.5, 0.6 * fade), 2.0, true)
	# Clarão no instante da detonação.
	var flash := clampf(1.0 - _t / 0.25, 0.0, 1.0)
	if flash > 0.0:
		draw_colored_polygon(_ellipse(0.45 + 0.3 * grow), Color(1.0, 0.95, 0.7, 0.7 * flash))
	# Brasas e línguas de fogo subindo.
	for i in EMBERS:
		var seed_a := float(i) * 2.399963   # ângulo áureo: espalhamento estável sem RNG
		var dist := 0.25 + 0.7 * fposmod(float(i) * 0.6180339, 1.0)
		var base := Vector2(cos(seed_a) * _rx * dist * grow, sin(seed_a) * _ry * dist * grow)
		var rise := (30.0 + 40.0 * fposmod(float(i) * 0.37, 1.0)) * _t
		var size := (2.5 + 4.0 * fposmod(float(i) * 0.53, 1.0)) * (1.0 - _t * 0.7)
		var heat := fposmod(float(i) * 0.29, 1.0)
		draw_circle(base + Vector2(0, -rise), size, Color(1.0, 0.45 + 0.45 * heat, 0.1 + 0.3 * heat, 0.9 * fade))
		draw_line(base, base + Vector2(0, -rise), Color(1.0, 0.4, 0.1, 0.35 * fade), size * 0.8)

## Lote 3 (E07): bola de fogo desenhada, somada ao desenho procedural (que continua marcando o raio do dano).
const SPRITE_PATH := "res://assets/vfx/explosao_fogo.png"
const SPRITE_ART_PX := 144.0   # largura da bola de fogo no pico, com a âncora na base (preparation-audit)
const SPRITE_SECONDS := 0.6
const SPRITE_SCALE_MIN := 0.9
const SPRITE_SCALE_MAX := 1.5

static func sprite_scale_for(radius: float) -> float:
	return clampf(axes_for_radius(radius).x / SPRITE_ART_PX, SPRITE_SCALE_MIN, SPRITE_SCALE_MAX)

static func create_sprite_effect(event: Dictionary, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	var sprite := VfxAtlas.sprite(SPRITE_PATH, false, SPRITE_SECONDS)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * sprite_scale_for(float(event.radius))
	sprite.offset.y = 128.0 - 196.0
	return VfxAtlas.one_shot(sprite, Iso.to_screen(event.pos))
