class_name FireSwingVfx
extends Node2D
## Visual-only arc of flames for fire melee weapons (Tocha do Incendiário). Range, cone and direction come from the swing event.

const DURATION := 0.3
const STEPS := 14
const EMBERS := 12
var _dir := Vector2.RIGHT
var _range := 1.0
var _cone := 0.0   # meio-ângulo em radianos, igual ao do cone de dano
var _t := 0.0:
	set(value):
		_t = value
		queue_redraw()

static func supports(event: Dictionary, reduced_impact: bool = false) -> bool:
	return not reduced_impact and event.get("type", "") == "swing" and event.get("dtype", "") == "fogo" and float(event.get("range", 0.0)) > 0.0

static func create_effect(event: Dictionary, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	var node := FireSwingVfx.new()
	node._dir = (event.dir as Vector2).normalized() if (event.dir as Vector2) != Vector2.ZERO else Vector2.RIGHT
	node._range = float(event.range)
	node._cone = deg_to_rad(float(event.get("cone", 60.0)))
	node.position = Iso.to_screen(event.pos) + Vector2(0, -18)
	node.z_index = 1
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	node.material = material
	var tween := node.create_tween()
	tween.tween_property(node, "_t", 1.0, DURATION)
	tween.tween_callback(node.queue_free)
	return node

## Ponto do chão (em tiles, relativo ao herói) projetado na tela.
func _ground(angle: float, fraction: float) -> Vector2:
	return Iso.to_screen(_dir.rotated(angle) * _range * fraction)

func _draw() -> void:
	var sweep := clampf(_t / 0.55, 0.0, 1.0)   # a labareda varre o cone na primeira metade
	var fade := 1.0 - _t
	var front := lerpf(-_cone, _cone, sweep)
	# Cunha em brasa do início do golpe até a frente da chama.
	for layer in 3:
		var k := float(layer) / 2.0
		var pts := PackedVector2Array([Vector2.ZERO])
		for i in STEPS + 1:
			pts.append(_ground(lerpf(-_cone, front, float(i) / STEPS), 1.0 - 0.3 * k))
		if pts.size() >= 3:
			draw_colored_polygon(pts, Color(1.0, 0.25 + 0.55 * k, 0.05 + 0.3 * k, (0.2 + 0.1 * k) * fade))
	# Frente da chama: arco externo brilhante.
	var arc := PackedVector2Array()
	for i in STEPS + 1:
		arc.append(_ground(lerpf(-_cone, front, float(i) / STEPS), 1.0))
	if arc.size() >= 2:
		draw_polyline(arc, Color(1.0, 0.6, 0.15, 0.95 * fade), 4.0 + 5.0 * fade, true)
		draw_polyline(arc, Color(1.0, 0.92, 0.55, 0.8 * fade), 2.0, true)
	draw_line(Vector2.ZERO, _ground(front, 1.0), Color(1.0, 0.85, 0.4, 0.7 * fade), 3.0)
	# Faíscas soltas da ponta da chama.
	for i in EMBERS:
		var a := lerpf(-_cone, front, fposmod(float(i) * 0.6180339, 1.0))
		var from := _ground(a, 0.55 + 0.45 * fposmod(float(i) * 0.37, 1.0))
		var rise := (14.0 + 26.0 * fposmod(float(i) * 0.53, 1.0)) * _t
		var size := (2.0 + 2.5 * fposmod(float(i) * 0.29, 1.0)) * (1.0 - _t * 0.6)
		draw_circle(from + Vector2(0, -rise), size, Color(1.0, 0.55 + 0.35 * fposmod(float(i) * 0.41, 1.0), 0.15, 0.9 * fade))
