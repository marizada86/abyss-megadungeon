extends RefCounted
## Lote 3, série H: impacto de dano no herói. Só apresentação.
func run() -> Array[String]:
	var out: Array[String] = []
	var texture := VfxAtlas.texture("res://assets/vfx/dano_heroi.png")
	if texture == null: return ["atlas do dano ausente ou fora de 1536x256"]
	var image := texture.get_image()
	if image.is_compressed(): image.decompress()
	for cell in 6:
		var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
		if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235: out.append("célula %d vazia ou sem margem" % cell)
	var event := {"type": "hurt", "pos": Vector2(9, 7), "amount": 11, "dtype": "magico"}
	var before := event.duplicate(true)
	var effect := HurtVfx.create_effect(event)
	if effect == null: out.append("sem efeito de dano")
	else:
		if not effect.is_in_group(&"hurt_vfx"): out.append("efeito fora do grupo de contagem")
		if effect.position != Iso.to_screen(event.pos) + Vector2(0, -HurtVfx.LIFT): out.append("âncora do dano")
		var sprite := effect.get_child(0) as AnimatedSprite2D
		if sprite.sprite_frames.get_animation_loop(&"default"): out.append("dano em laço")
		if absf(sprite.rotation - HurtVfx.rotation_for(event)) > 0.0001 or absf(sprite.scale.x - HurtVfx.SCALE) > 0.0001: out.append("rotação ou escala")
		if sprite.modulate != HurtVfx.tint_for("magico"): out.append("tinta do tipo de dano")
		effect.free()
	if event != before: out.append("o evento foi alterado")
	# dano contínuo, impacto reduzido e limite
	var fog := {"type": "hurt", "pos": Vector2(9, 7), "amount": 3, "continuous": true}
	if HurtVfx.create_effect(fog) != null: out.append("dano contínuo da névoa não ganha efeito")
	if HurtVfx.create_effect(event, true) != null or HurtVfx.create_effect(event, false, HurtVfx.LIMIT) != null: out.append("impacto reduzido ou limite ignorado")
	# tintas: sem dtype conhecido fica o vermelho da folha; os tipos mudam pouco
	for dtype in ["", "fisico", "outro"]:
		if HurtVfx.tint_for(dtype) != Color.WHITE: out.append("sem tinta para " + dtype)
	for dtype in HurtVfx.TINTS:
		var tint := HurtVfx.tint_for(dtype)
		if tint == Color.WHITE or tint.get_luminance() < 0.6: out.append("tinta escura demais ou ausente: " + dtype)
	# rotação determinística, sem RNG do jogo
	var battle := Battle.new(812, "durvall", "dagruve")
	var rng_state := battle.rng.state
	if HurtVfx.rotation_for({"amount": 5}) != HurtVfx.rotation_for({"amount": 5}) or HurtVfx.rotation_for({"amount": 5}) == HurtVfx.rotation_for({"amount": 6}): out.append("rotação determinística por dano")
	var temp := HurtVfx.create_effect({"type": "hurt", "pos": battle.hero.pos, "amount": 4})
	if temp != null: temp.free()
	if battle.rng.state != rng_state: out.append("RNG alterado")
	return out
