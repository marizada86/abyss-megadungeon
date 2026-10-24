class_name HitSparkVfx
extends RefCounted
const LIMIT := 8
const KINDS := {"fisico": "hit_fisico", "magico": "hit_magico", "fogo": "hit_fogo", "radiante": "hit_radiante"}

static func kind_for(dtype: String, critical: bool) -> String:
	if not KINDS.has(dtype):
		return ""
	return "hit_critico" if critical else String(KINDS[dtype])

static func can_spawn(current: int, reduced: bool = false) -> bool:
	return not reduced and current < LIMIT

static func create_effect(event: Dictionary, reduced: bool = false, current: int = 0) -> Node2D:
	if not can_spawn(current, reduced):
		return null
	var kind := kind_for(String(event.get("dtype", "")), bool(event.get("crit", false)))
	if kind.is_empty():
		return null
	var sprite := VfxAtlas.sprite("res://assets/vfx/%s.png" % kind, false, 0.18)
	if sprite == null:
		return null
	var multiplier := 1.5 if String(event.get("tier", "")) == "boss" else (1.25 if String(event.get("tier", "")) == "elite" else 1.0)
	sprite.scale = Vector2.ONE * (56.0 / 150.0) * multiplier
	sprite.rotation = float(int(event.get("tid", 0)) % 16) * TAU / 16.0
	if bool(event.get("crit", false)):
		sprite.modulate = {"fisico": Color(1, 0.94, 0.8), "magico": Color(0.72, 0.4, 1), "fogo": Color(1, 0.35, 0.12), "radiante": Color(1, 0.8, 0.3)}.get(String(event.get("dtype", "")), Color.WHITE)
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(event.get("pos", Vector2.ZERO)) + Vector2(0, -24))
	root.add_to_group(&"hit_spark_vfx")
	return root
