extends RefCounted
## Lote 3, série E: evoluções por sobreposição. As famílias-base não mudam; sem a folha a evolução usa a arte da base.
func _bolt(weapon: String, dtype: String, owner: String = "hero") -> Dictionary:
	return {"owner": owner, "pos": Vector2(10, 8), "dir": Vector2(1, 0), "life": 1.0, "p": {"id": weapon, "dtype": dtype}}

func run() -> Array[String]:
	var out: Array[String] = []
	for family in ProjectileVfx.EVOLVED_FAMILIES:
		var spec: Dictionary = ProjectileVfx.EVOLVED_FAMILIES[family]
		var texture := load(String(spec.path)) as Texture2D
		if texture == null or texture.get_size() != Vector2(2048, 256):
			out.append("atlas evoluído ausente ou fora de 2048x256: " + String(family))
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for cell in 8:
			var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s célula %d vazia ou sem margem" % [family, cell])
		var weapons: Dictionary = Data.table("weapons")
		for id in spec.weapons:
			if not weapons.has(id) or String(weapons[id].src) != "Evolução": out.append(id + " deveria ser uma evolução")
			var projectile := _bolt(id, String(spec.dtype))
			if ProjectileVfx.evolved_family_for(projectile) != family: out.append("evolução sem arte própria: " + id)
			if ProjectileVfx.visual_family_for(projectile) != family: out.append("visual_family_for deveria dar a evolução: " + id)
			if ProjectileVfx.family_for(projectile) == &"" or ProjectileVfx.family_for(projectile) == family: out.append("a família-base de %s não pode mudar" % id)
			if not ProjectileVfx.handles(projectile) or ProjectileVfx.handles(projectile, true): out.append("handles / impacto reduzido: " + id)
			if ProjectileVfx.evolved_family_for(_bolt(id, "fogo")) != &"" or ProjectileVfx.evolved_family_for(_bolt(id, String(spec.dtype), "enemy")) != &"": out.append("dtype ou dono indevido: " + id)
			var sprite := ProjectileVfx.create_flight(projectile, Color.WHITE)
			if sprite == null: out.append("sem voo evoluído: " + id)
			else:
				if absf(sprite.scale.x - float(spec.scale)) > 0.001 or absf(sprite.offset.x - (128.0 - float(spec.pivot_x))) > 0.001: out.append("escala ou pivô do voo evoluído: " + id)
				sprite.free()
	# nenhuma arma que não seja evolução listada ganha arte evoluída
	for other in ["raio_de_luz", "marca_da_retidao", "raio_enfraquecedor", "lamina_trovejante"]:
		if ProjectileVfx.evolved_family_for(_bolt(other, "radiante")) != &"" or ProjectileVfx.evolved_family_for(_bolt(other, "magico")) != &"": out.append("arma-base ganhou arte evoluída: " + other)
	# o evento do projétil não é alterado
	var event := _bolt("luz_mais_pura", "radiante")
	var before := event.duplicate(true)
	ProjectileVfx.visual_family_for(event)
	ProjectileVfx.handles(event)
	if event != before: out.append("o projétil foi alterado")
	return out
