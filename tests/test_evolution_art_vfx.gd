extends RefCounted
## Lote 3: evoluções de golpe físico, pulso radiante e explosão de fogo. As bases continuam com a arte de sempre.
func run() -> Array[String]:
	var out: Array[String] = []
	# golpes físicos evoluídos: arte própria por ID, base intacta, físico apenas
	for id in MeleeVfx.EVOLVED_SHAPES:
		var shape := String(MeleeVfx.EVOLVED_SHAPES[id])
		if MeleeVfx.shape_for(id, "fisico") != shape: out.append("evolução sem forma própria: " + id)
		if MeleeVfx.shape_for(id, "radiante") != "" or MeleeVfx.shape_for(id, "fogo") != "": out.append("o kit físico não cobre outros danos: " + id)
		if not MeleeVfx.WEAPON_SHAPES.has(id): out.append("a forma da base some se a folha faltar: " + id)
		var weapons: Dictionary = Data.table("weapons")
		if String(weapons[id].src) != "Evolução" or String(weapons[id].kind) != "melee": out.append("deveria ser evolução corpo a corpo: " + id)
		var texture := load(String(MeleeVfx.SHAPE_PATHS[shape])) as Texture2D
		if texture == null or texture.get_size() != Vector2(1536, 256):
			out.append("atlas ausente ou fora de 1536x256: " + shape)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for cell in 6:
			var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235: out.append("%s célula %d vazia ou sem margem" % [shape, cell])
		var event := {"type": "swing", "weapon": id, "dtype": "fisico", "pos": Vector2(10, 8), "dir": Vector2(1, 0), "range": 2.6, "cone": 100.0}
		var before := event.duplicate(true)
		var effect := MeleeVfx.create_effect(event, Color.WHITE)
		if effect == null: out.append("sem efeito: " + id)
		else:
			var expected := 2.6 * Iso.TILE_W * 0.5 * sqrt(2.0) / (256.0 * float(MeleeVfx.REACH_FRACTION[shape]))
			if absf((effect.get_child(0) as AnimatedSprite2D).scale.x - expected) > 0.001: out.append("alcance da arte não acompanha o golpe: " + id)
			effect.free()
		if event != before: out.append("o evento do golpe foi alterado")
	for base in ["espada_sombria", "golpe_esmagador", "adaga_rapida", "romper_armadura", "golpe_atordoante"]:
		if MeleeVfx.EVOLVED_SHAPES.has(base): out.append("arma-base ganhou arte evoluída: " + base)
	# pulso radiante evoluído
	var pulse := {"type": "nova", "weapon": "julgamento_da_gloria", "dtype": "radiante", "pos": Vector2(10, 8), "radius": 4.2}
	var base_pulse := pulse.duplicate()
	base_pulse.weapon = "sentenca_de_lliira"
	for id in RadiantPulseVfx.EVOLVED_WEAPONS:
		pulse.weapon = id
		if not RadiantPulseVfx.supports(pulse): out.append("evolução radiante sem roteamento: " + id)
		var node := RadiantPulseVfx.create_effect(pulse, Color.WHITE)
		if node == null: out.append("sem pulso evoluído: " + id)
		else:
			var sprite := node.get_child(0) as AnimatedSprite2D
			if sprite.scale != RadiantPulseVfx.scale_for_radius(4.2, RadiantPulseVfx.EVOLVED_PEAK_RING_RADIUS): out.append("escala do pulso evoluído: " + id)
			node.free()
	var base_node := RadiantPulseVfx.create_effect(base_pulse, Color.WHITE)
	if base_node == null or (base_node.get_child(0) as AnimatedSprite2D).scale != RadiantPulseVfx.scale_for_radius(4.2): out.append("o pulso-base deveria manter a escala de sempre")
	if base_node != null: base_node.free()
	var pulse_texture := load(RadiantPulseVfx.EVOLVED_PATH) as Texture2D
	if pulse_texture == null or pulse_texture.get_size() != Vector2(1536, 256): out.append("atlas do pulso evoluído")
	# explosão de fogo: o sprite soma ao desenho procedural, que continua marcando o raio
	for id in ["bola_de_fogo", "tormenta_de_fogo"]:
		var w: Dictionary = Data.table("weapons")[id]
		var fire := {"type": "nova", "weapon": id, "dtype": "fogo", "pos": Vector2(10, 8), "radius": float(w.radius)}
		var art := FireBurstVfx.create_sprite_effect(fire)
		if art == null: out.append("sem sprite de explosão: " + id)
		else:
			var scale_value := (art.get_child(0) as AnimatedSprite2D).scale.x
			if scale_value < FireBurstVfx.SPRITE_SCALE_MIN - 0.001 or scale_value > FireBurstVfx.SPRITE_SCALE_MAX + 0.001: out.append("escala do sprite de fogo fora dos limites: " + id)
			if art.position != Iso.to_screen(fire.pos): out.append("âncora da explosão: " + id)
			art.free()
		if FireBurstVfx.create_sprite_effect(fire, true) != null: out.append("impacto reduzido ignorado: " + id)
		var procedural := FireBurstVfx.create_effect(fire)
		if procedural == null or not (procedural is FireBurstVfx): out.append("o desenho procedural do raio deve continuar: " + id)
		if procedural != null: procedural.free()
	if FireBurstVfx.create_sprite_effect({"type": "nova", "dtype": "radiante", "radius": 3.0, "pos": Vector2.ZERO}) != null: out.append("sprite de fogo em nova que não é de fogo")
	if FireBurstVfx.sprite_scale_for(3.0) > FireBurstVfx.sprite_scale_for(6.0): out.append("escala deveria crescer com o raio")
	return out
