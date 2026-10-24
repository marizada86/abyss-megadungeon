extends RefCounted
## Lote 2, série M: mortes por tipo de inimigo. Só apresentação.
func _enemy(battle: Battle, id: String) -> Enemy:
	return battle._spawn(id, battle.hero.pos + Vector2(3, 0))

func run() -> Array[String]:
	var out: Array[String] = []
	var battle := Battle.new(809, "durvall", "dagruve")
	var rng_state := battle.rng.state
	# tipo a partir dos dados
	var common := _enemy(battle, "zumbi")
	if DeathVfx.kind_for(common) != &"comum": out.append("zumbi deveria ser comum")
	var elite := _enemy(battle, "zumbi")
	elite.affix = "veloz"
	if DeathVfx.kind_for(elite) != &"elite": out.append("elite com afixo")
	var chest := _enemy(battle, "zumbi")
	chest.drops_chest = true
	if DeathVfx.kind_for(chest) != &"elite": out.append("elite com baú")
	var crate := _enemy(battle, "caixote_quebravel")
	if DeathVfx.kind_for(crate) != &"quebravel": out.append("caixote deveria ser quebrável")
	var soul := _enemy(battle, "alma_penada")
	if DeathVfx.kind_for(soul) != &"alma": out.append("alma penada deveria ser alma")
	var boss := _enemy(battle, "sacerdote_mente_derretida")
	if not boss.is_boss() or DeathVfx.kind_for(boss) != &"chefe": out.append("chefe do piloto deveria ser chefe")
	# todo inimigo dos dados cai em um tipo com folha
	for id in Data.table("enemies"):
		var e := _enemy(battle, String(id))
		var kind := DeathVfx.kind_for(e)
		if not DeathVfx.KINDS.has(kind): out.append("inimigo sem tipo de morte: " + String(id))
	# folhas
	for kind in DeathVfx.KINDS:
		var spec: Dictionary = DeathVfx.KINDS[kind]
		var texture := VfxAtlas.texture("res://assets/vfx/%s.png" % String(spec.sheet))
		if texture == null:
			out.append("atlas ausente ou fora de 1536x256: " + String(spec.sheet))
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for cell in 6:
			var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s célula %d vazia ou sem margem" % [spec.sheet, cell])
	# efeito, tinta, âncora
	var at := Vector2(9, 8)
	var puff := DeathVfx.create_effect(common, at)
	if puff == null: out.append("sem efeito de morte comum")
	else:
		if not puff.is_in_group(&"death_vfx"): out.append("efeito fora do grupo de contagem")
		if puff.position != Iso.to_screen(at) + Vector2(0, -18): out.append("âncora da morte comum")
		var sprite := puff.get_child(0) as AnimatedSprite2D
		if sprite.sprite_frames.get_animation_loop(&"default"): out.append("morte comum em laço")
		if (sprite.modulate as Color).v < 0.9: out.append("tinta da morte comum escura demais")
		puff.free()
	var collapse := DeathVfx.create_effect(boss, at)
	if collapse == null or (collapse.get_child(0) as AnimatedSprite2D).offset.y >= 0.0 or collapse.position != Iso.to_screen(at): out.append("colapso de chefe deveria ancorar na base")
	if collapse != null: collapse.free()
	for color in [Color(0.157, 0.078, 0.235), Color(0.5, 0.5, 0.6), Color(1, 0, 0), Color.BLACK]:
		if DeathVfx.tint_for(color).v < 0.95 - 0.001: out.append("tinta não clareia " + str(color))
	# limites e impacto reduzido
	if DeathVfx.create_effect(common, at, true) != null or DeathVfx.create_effect(common, at, false, DeathVfx.LIMIT) != null: out.append("limite ou impacto reduzido ignorado")
	# explosão por afixo
	var blast := DeathVfx.create_explosion(2.2, at)
	if blast == null: out.append("sem explosão")
	else:
		var expected := Iso.TILE_W * 2.2 * sqrt(2.0) * 0.5 * 2.0 / DeathVfx.EXPLOSION_ART_PX
		if absf((blast.get_child(0) as AnimatedSprite2D).scale.x - expected) > 0.001: out.append("escala da explosão não acompanha o raio")
		blast.free()
	if DeathVfx.create_explosion(0.0, at) != null or DeathVfx.create_explosion(2.2, at, true) != null: out.append("explosão sem raio ou com impacto reduzido")
	# metadado dos eventos de explosão
	var explode_enemy := _enemy(battle, "zumbi")
	battle._affix_explode(explode_enemy)
	var tagged := false
	for z in battle.zones:
		if String(z.get("kind", "")) == "telegraph" and String(z.get("affix", "")) == "explosivo": tagged = true
	if not tagged: out.append("telégrafo do afixo explosivo sem metadado")
	var defaults_untouched := true
	for z in battle.zones:
		if String(z.get("kind", "")) == "telegraph" and (float(z.radius) != 2.2 or float(z.delay) != 1.0): defaults_untouched = false
	if not defaults_untouched: out.append("o afixo mudou a geometria do telégrafo")
	if battle.rng.state != rng_state: out.append("RNG alterado")
	return out
