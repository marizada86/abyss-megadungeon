extends RefCounted
func run() -> Array[String]:
	var out: Array[String] = []
	for dtype in HitSparkVfx.KINDS:
		if HitSparkVfx.kind_for(dtype, false) != HitSparkVfx.KINDS[dtype]: out.append("wrong dtype " + dtype)
		if HitSparkVfx.kind_for(dtype, true) != "hit_critico": out.append("critical " + dtype)
	if HitSparkVfx.kind_for("unknown", true) != "": out.append("unknown dtype")
	if HitSparkVfx.can_spawn(8) or HitSparkVfx.can_spawn(0, true): out.append("cap/reduced")
	var battle := Battle.new(807, "durvall", "dagruve")
	var rng_state := battle.rng.state
	var event := {"dtype": "fisico", "crit": true, "tid": 123, "pos": Vector2(4, 5), "tier": "boss"}
	var before := event.duplicate(true)
	var effect := HitSparkVfx.create_effect(event)
	if effect == null: out.append("missing effect")
	else:
		if effect.position != Iso.to_screen(event.pos) + Vector2(0, -24): out.append("hit anchor")
		if (effect.get_child(0) as AnimatedSprite2D).sprite_frames.get_animation_loop(&"default"): out.append("hit loops")
		effect.free()
	if HitSparkVfx.create_effect(event, true) != null or HitSparkVfx.create_effect(event, false, 8) != null: out.append("spawn cap/reduced")
	if event != before or battle.rng.state != rng_state: out.append("gameplay/RNG modified")
	return out
