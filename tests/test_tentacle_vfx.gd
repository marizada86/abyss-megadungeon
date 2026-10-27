extends RefCounted
## Lote 3, série T: zona do Colar dos Tentáculos. Só apresentação.
func run() -> Array[String]:
	var out: Array[String] = []
	var texture := VfxAtlas.texture("res://assets/vfx/tentaculos_laco.png")
	if texture == null: return ["atlas do laço ausente ou fora de 1536x256"]
	var image := texture.get_image()
	if image.is_compressed(): image.decompress()
	for cell in 6:
		var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
		if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235: out.append("célula %d vazia ou sem margem" % cell)
	var zone := {"owner": "hero", "kind": "zone", "radius": 2.4, "pos": Vector2(7, 6), "life": 4.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico"}}
	var before := zone.duplicate(true)
	if not TentacleVfx.supports(zone) or TentacleVfx.supports(zone, true): out.append("suporte ou impacto reduzido")
	if TentacleVfx.supports({"weapon": "cera_fervente", "radius": 2.0}) or TentacleVfx.supports({"owner": "enemy", "weapon": "colar_dos_tentaculos", "radius": 2.0}) or TentacleVfx.supports({"weapon": "colar_dos_tentaculos", "radius": 0.0}): out.append("consumer indevido")
	var entry := TentacleVfx.create_zone(zone)
	if entry.is_empty(): out.append("sem laço de tentáculos")
	else:
		var sprite := entry.sprite as AnimatedSprite2D
		if not sprite.sprite_frames.get_animation_loop(&"default"): out.append("laço deveria repetir")
		if sprite.offset.y >= 0.0: out.append("o laço ancora na base")
		if absf(sprite.scale.x - TentacleVfx.scale_for(2.4)) > 0.001: out.append("escala não acompanha o raio")
		entry.born = int(entry.born) - 2000
		TentacleVfx.update(entry)
		if absf(sprite.modulate.a - TentacleVfx.MAX_ALPHA) > 0.001: out.append("opacidade cheia no meio da vida")
		zone.life = 0.0
		TentacleVfx.update(entry)
		if sprite.modulate.a != 0.0: out.append("a zona deveria sumir ao acabar a vida")
		sprite.free()
	zone.life = 4.0
	if zone != before: out.append("o dicionário da zona foi alterado")
	if TentacleVfx.scale_for(3.0) <= TentacleVfx.scale_for(1.0): out.append("escala deveria crescer com o raio")
	return out
