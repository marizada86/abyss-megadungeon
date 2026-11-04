extends RefCounted
## Plano de evolução de armas (2026-11-04): VFX próprios da Vigília Perpétua, da Ampulheta do Tempo Parado e do Abraço dos Tentáculos.
## Os quatro projéteis evoluídos (Selo, Cajado, Lâmina do Eclipse, Memória) são cobertos por test_evolution_vfx.gd (EVOLVED_FAMILIES).

func _margins(path: String, cells: int, out: Array) -> void:
	var texture := VfxAtlas.texture(path, cells)
	if texture == null:
		out.append("atlas ausente ou fora de %dx256: %s" % [cells * 256, path])
		return
	var image := texture.get_image()
	if image.is_compressed():
		image.decompress()
	for cell in cells:
		var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
		if not box.has_area() or box.position.x < 20 or box.position.y < 20 or box.end.x > 236 or box.end.y > 236:
			out.append("%s célula %d vazia ou sem margem" % [path.get_file(), cell])

func run() -> Array[String]:
	var out: Array[String] = []
	var weapons: Dictionary = Data.table("weapons")
	for id in ["vigilia_perpetua", "ampulheta_do_tempo_parado", "abraco_dos_tentaculos"]:
		if not weapons.has(id) or String(weapons[id].src) != "Evolução":
			out.append(id + " deveria ser uma evolução")
	_margins(RadiantPulseVfx.OWN_PULSES.vigilia_perpetua.path, 6, out)
	_margins(HourglassVfx.EVOLVED_PATH, 6, out)
	_margins(TentacleVfx.EVOLVED_LOOP_PATH, 6, out)

	# Vigília Perpétua: pulso radiante com folha própria e raio medido; a Vela continua com o pulso comum
	var vigil := {"type": "nova", "weapon": "vigilia_perpetua", "dtype": "radiante", "pos": Vector2(10, 8), "radius": 3.6}
	var vela := vigil.duplicate()
	vela.weapon = "vela_sagrada"
	if not RadiantPulseVfx.supports(vigil) or RadiantPulseVfx.supports(vigil, true): out.append("Vigília: suporte ou impacto reduzido")
	var vigil_fx := RadiantPulseVfx.create_effect(vigil, Color.WHITE)
	var vela_fx := RadiantPulseVfx.create_effect(vela, Color.WHITE)
	if vigil_fx == null or vela_fx == null:
		out.append("Vigília ou Vela sem efeito")
	else:
		var vs := vigil_fx.get_child(0) as AnimatedSprite2D
		var base := vela_fx.get_child(0) as AnimatedSprite2D
		if (vs.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != String(RadiantPulseVfx.OWN_PULSES.vigilia_perpetua.path): out.append("Vigília deveria usar a folha própria")
		if (base.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != RadiantPulseVfx.TEXTURE_PATH: out.append("a Vela não pode mudar de arte")
		if vs.scale != RadiantPulseVfx.scale_for_radius(3.6, float(RadiantPulseVfx.OWN_PULSES.vigilia_perpetua.peak)): out.append("escala da Vigília não segue o raio medido")
		if base.scale != RadiantPulseVfx.scale_for_radius(3.6): out.append("escala da Vela mudou")
		vigil_fx.free()
		vela_fx.free()
	var vigil_other := vigil.duplicate()
	vigil_other.dtype = "magico"
	if RadiantPulseVfx.supports(vigil_other): out.append("Vigília aceita dtype indevido")

	# Ampulheta do Tempo Parado: folha própria na evolução; a Ampulheta base não muda
	var evo_hg := {"type": "nova", "weapon": HourglassVfx.EVOLVED_WEAPON, "dtype": "magico", "pos": Vector2(10, 8), "radius": 6.5}
	var base_hg := evo_hg.duplicate()
	base_hg.weapon = "ampulheta"
	if not HourglassVfx.supports(evo_hg) or HourglassVfx.supports(evo_hg, true): out.append("Ampulheta evoluída: suporte ou impacto reduzido")
	var hg_evo := HourglassVfx.create_effect(evo_hg, Color.WHITE)
	var hg_base := HourglassVfx.create_effect(base_hg, Color.WHITE)
	if hg_evo == null or hg_base == null:
		out.append("Ampulheta (base ou evolução) sem efeito")
	else:
		var es := hg_evo.get_child(0) as AnimatedSprite2D
		var bs := hg_base.get_child(0) as AnimatedSprite2D
		if (es.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != HourglassVfx.EVOLVED_PATH: out.append("a evolução deveria usar a folha própria")
		if (bs.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != HourglassVfx.TEXTURE_PATH: out.append("a Ampulheta base não pode mudar de arte")
		if es.scale != HourglassVfx.scale_for_radius(6.5, HourglassVfx.EVOLVED_PEAK_RING_RADIUS): out.append("escala da evolução não segue o raio medido")
		hg_evo.free()
		hg_base.free()

	# Abraço dos Tentáculos: laço próprio ancorado no chão; emersão herdada do Colar; o Colar não muda
	var zone := {"owner": "hero", "kind": "zone", "radius": 4.2, "pos": Vector2(7, 6), "life": 6.0, "p": {"id": TentacleVfx.EVOLVED_WEAPON, "dtype": "magico"}}
	if not TentacleVfx.supports(zone) or TentacleVfx.supports(zone, true): out.append("Abraço: suporte ou impacto reduzido")
	var entry := TentacleVfx.create_zone(zone)
	if entry.is_empty():
		out.append("Abraço sem laço")
	else:
		var sprite := entry.sprite as AnimatedSprite2D
		if (sprite.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != TentacleVfx.EVOLVED_LOOP_PATH: out.append("o Abraço deveria usar o laço próprio")
		if not is_equal_approx(sprite.offset.y, VfxAtlas.ground_offset_y("abraco_laco")) or sprite.offset.y >= 0.0: out.append("âncora de chão do laço do Abraço")
		if absf(sprite.scale.x - TentacleVfx.scale_for(4.2, TentacleVfx.EVOLVED_RING_PX)) > 0.001: out.append("escala do laço do Abraço não acompanha o raio")
		sprite.free()
	var colar := zone.duplicate(true)
	colar.p.id = TentacleVfx.WEAPON
	var colar_entry := TentacleVfx.create_zone(colar)
	if colar_entry.is_empty() or (colar_entry.sprite.sprite_frames.get_frame_texture(&"default", 0) as AtlasTexture).atlas.resource_path != "res://assets/vfx/tentaculos_laco.png": out.append("o laço do Colar não pode mudar")
	if not colar_entry.is_empty():
		if absf(colar_entry.sprite.scale.x - TentacleVfx.scale_for(4.2)) > 0.001: out.append("escala do Colar mudou")
		colar_entry.sprite.free()
	var cast := TentacleVfx.create_cast({"owner": "hero", "weapon": TentacleVfx.EVOLVED_WEAPON, "radius": 4.2, "pos": Vector2(7, 6)})
	if cast == null: out.append("Abraço sem emersão")
	else: cast.free()
	if TentacleVfx.supports({"owner": "hero", "weapon": "cera_fervente", "radius": 2.0}) or TentacleVfx.supports({"owner": "enemy", "weapon": TentacleVfx.EVOLVED_WEAPON, "radius": 2.0}): out.append("Abraço aceita consumer indevido")
	return out
