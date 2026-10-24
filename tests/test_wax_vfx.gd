extends RefCounted
func run() -> Array[String]:
	var out: Array[String] = []
	for id in ["cera_fervente", "inferno_de_cera"]:
		var event := {"weapon": id, "radius": 2.0, "pos": Vector2(5,5)}
		var before := event.duplicate(true)
		if not WaxVfx.supports(event) or WaxVfx.supports(event, true): out.append("wax support " + id)
		var cast := WaxVfx.create_cast(event)
		if cast == null: out.append("wax cast " + id)
		else: cast.free()
		var zone := {"owner": "hero", "radius": 2.0, "pos": Vector2(5,5), "life": 3.0, "p": {"id": id}}
		var puddle := WaxVfx.create_puddle(zone)
		if puddle.is_empty(): out.append("wax layers " + id)
		else:
			if not puddle.body.modulate.is_equal_approx(WaxVfx.tint_for(event)): out.append("wax tint")
			if puddle.body.scale.y != puddle.body.scale.x * 0.5: out.append("wax projection")
			if not puddle.flames.sprite_frames.get_animation_loop(&"default"): out.append("wax loop")
			puddle.born = int(puddle.born) - 2000
			WaxVfx.update(puddle)
			if not is_equal_approx(puddle.body.modulate.a, WaxVfx.BODY_ALPHA): out.append("wax body must stay translucent")
			if puddle.flames.modulate.a < 1.0 - WaxVfx.FLICKER_ALPHA - 0.001 or puddle.flames.modulate.a > 1.0: out.append("wax flicker alpha range")
			if absf(puddle.flames.scale.x / WaxVfx.scale_for(2.0) - 1.0) > WaxVfx.FLICKER_SCALE + 0.001: out.append("wax flicker scale range")
			zone.life = 0.0
			WaxVfx.update(puddle)
			if puddle.body.modulate.a != 0.0 or puddle.flames.modulate.a != 0.0: out.append("wax fade")
			puddle.body.free()
			puddle.flames.free()
		if event != before: out.append("wax event modified")
	if WaxVfx.supports({"weapon":"colar_dos_tentaculos","radius":3}) or WaxVfx.supports({"owner":"enemy","weapon":"cera_fervente","radius":2}): out.append("wax wrong consumer")
	if WaxVfx.scale_for(3.0) <= WaxVfx.scale_for(1.0): out.append("wax scale")
	if VfxAtlas.frames("res://assets/vfx/nonexistent.png") != null: out.append("missing atlas fallback")
	var bad := ImageTexture.create_from_image(Image.create(12, 12, false, Image.FORMAT_RGBA8))
	if not ProjectileVfx.frames_from_texture(bad).is_empty(): out.append("invalid projectile atlas")
	return out
