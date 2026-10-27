extends RefCounted
## Lote 3, série D: detonação de AoE inimigo por tipo de dano. Só apresentação: o raio vem do telégrafo.
func run() -> Array[String]:
	var out: Array[String] = []
	var ground := Vector2(12, 9)
	for dtype in DetonationVfx.KINDS:
		var sheet := DetonationVfx.sheet_for(dtype)
		var texture := VfxAtlas.texture(DetonationVfx.path_for(sheet))
		var effect := DetonationVfx.create_effect(2.2, ground, dtype)
		if texture != null:
			if effect == null: out.append("sem efeito para " + dtype)
			else:
				if not effect.is_in_group(&"detonation_vfx"): out.append("efeito fora do grupo")
				if effect.position != Iso.to_screen(ground): out.append("âncora da detonação " + dtype)
				if absf((effect.get_child(0) as AnimatedSprite2D).scale.x - DetonationVfx.scale_for(2.2)) > 0.001: out.append("escala não acompanha o raio")
				if (effect.get_child(0) as AnimatedSprite2D).sprite_frames.get_animation_loop(&"default"): out.append("detonação em laço")
				effect.free()
			var image := texture.get_image()
			if image.is_compressed(): image.decompress()
			for cell in 6:
				var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
				if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235: out.append("%s célula %d vazia ou sem margem" % [sheet, cell])
		elif effect != null:
			out.append("sem folha de %s, o efeito deveria ser nulo (fallback do anel)" % dtype)
			effect.free()
	if DetonationVfx.sheet_for("fogo") != "" or DetonationVfx.sheet_for("") != "": out.append("dtype sem folha deveria cair no fallback")
	if DetonationVfx.create_effect(0.0, ground, "fisico") != null or DetonationVfx.create_effect(2.2, ground, "fisico", true) != null or DetonationVfx.create_effect(2.2, ground, "fisico", false, DetonationVfx.LIMIT) != null: out.append("raio zero, impacto reduzido ou limite ignorado")
	if DetonationVfx.create_effect(2.2, ground, "fisico", false, 0, "explosivo") != null: out.append("afixo explosivo fica com a arte de morte explosiva")
	if DetonationVfx.scale_for(3.0) <= DetonationVfx.scale_for(1.0): out.append("escala deveria crescer com o raio")
	# o evento boom carrega o dtype do telégrafo, sem mudar a geometria
	var battle := Battle.new(810, "durvall", "dagruve")
	var rng_state := battle.rng.state
	battle.zones.append({"owner": "enemy", "kind": "telegraph", "pos": battle.hero.pos + Vector2(20, 0), "radius": 1.8, "delay": 0.01, "total": 1.0, "life": 99.0, "dice": "1d4", "bonus": 0, "dtype": "magico", "friendly": false})
	battle.events.clear()
	battle._update_zones(0.05)
	var boom: Dictionary = {}
	for e in battle.events:
		if String(e.get("type", "")) == "boom": boom = e
	if boom.is_empty(): out.append("o telégrafo deveria detonar")
	else:
		if String(boom.get("dtype", "")) != "magico": out.append("boom sem dtype")
		if float(boom.radius) != 1.8: out.append("o raio da detonação mudou")
	if battle.rng.state != rng_state: out.append("RNG alterado")
	return out
