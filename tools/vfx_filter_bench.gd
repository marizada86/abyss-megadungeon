extends SceneTree
## Bancada de comparação de filtro de textura dos VFX grandes (somente apresentação; não altera o jogo).
## Cada efeito é criado pelo código real do jogo, congelado no quadro de pico e desenhado três vezes:
## NEAREST (hoje), LINEAR e LINEAR com mipmaps + anisotrópico.
## Uso: powershell -File tools/vfx_filter_bench.ps1 [-Size 1920x1080]
const OUTPUT := "res://.atena/generated/vfx-filter-bench-20261104-r1/captures/"
const USER_ROOT := "res://.atena/generated/vfx-filter-bench-20261104-r1/synthetic/"
const PEAK_FRAME := 3
const COLUMNS := [["NEAREST (atual)", 0], ["LINEAR", 1], ["LINEAR + MIPMAPS + ANISO", 2]]
const BACKGROUNDS := {"escuro": Color(0.06, 0.055, 0.075), "chao": Color(0.30, 0.27, 0.22)}
var tag := "1280x720"
var _mip_cache: Dictionary = {}

func _init() -> void:
	call_deferred("_run")

func _effects() -> Array:
	var o := Vector2.ZERO
	var warm := Color(1.0, 0.72, 0.4)
	var holy := Color(1.0, 0.92, 0.6)
	var arcane := Color(0.7, 0.55, 1.0)
	var white := Color.WHITE
	return [
		["suspensao_temporal-r7", func(): return HeroAbilityVfx.create_effect("suspensao_temporal", {"pos": o, "radius": 7.0}, arcane)],
		["modify_memory-r4", func(): return HeroAbilityVfx.create_effect("modify_memory", {"pos": o, "radius": 4.0}, arcane)],
		["concordia-r3.5", func(): return HeroAbilityVfx.create_effect("concordia", {"pos": o, "radius": 3.5}, holy)],
		["impacto_de_xargath-r3", func(): return HeroAbilityVfx.create_effect("impacto_de_xargath", {"pos": o, "radius": 3.0}, warm)],
		["constelacao-r3", func(): return HeroAbilityVfx.create_effect("constelacao", {"pos": o, "radius": 3.0}, holy)],
		["ruptura_sombria-arco", func(): return HeroAbilityVfx.create_effect("ruptura_sombria", {"pos": o, "radius": 3.2}, white, Vector2(1, 0.4))],
		["navios_em_chamas-arco", func(): return HeroAbilityVfx.create_effect("navios_em_chamas", {"pos": o, "radius": 2.6}, warm, Vector2(1, 0.4))],
		["passo_pelas_sombras-rastro", func(): return HeroAbilityVfx.create_effect("passo_pelas_sombras", {"pos": o, "distance": 3.5}, arcane, Vector2(1, 0.4))],
		["pulso_radiante-r4", func(): return RadiantPulseVfx.create_effect({"type": "nova", "dtype": "radiante", "weapon": "sentenca_de_lliira", "radius": 4.0, "pos": o}, holy)],
		["pulso_evo-r4", func(): return RadiantPulseVfx.create_effect({"type": "nova", "dtype": "radiante", "weapon": "julgamento_da_gloria", "radius": 4.0, "pos": o}, holy)],
		["ampulheta-r4", func(): return HourglassVfx.create_effect({"type": "nova", "dtype": "magico", "weapon": "ampulheta", "radius": 4.0, "pos": o}, arcane)],
		["detonacao_magica-r3", func(): return DetonationVfx.create_effect(3.0, o, "magico")],
		["detonacao_fisica-r3", func(): return DetonationVfx.create_effect(3.0, o, "fisico")],
		["tentaculos_emergem-r3", func(): return TentacleVfx.create_cast({"owner": "hero", "weapon": "colar_dos_tentaculos", "radius": 3.0, "pos": o})],
		["explosao_fogo-r4", func(): return FireBurstVfx.create_sprite_effect({"type": "nova", "dtype": "fogo", "radius": 4.0, "pos": o})],
		["cera_lancamento-r5", func(): return WaxVfx.create_cast({"owner": "hero", "weapon": "inferno_de_cera", "radius": 5.0, "pos": o})],
	]

func _mip_frames(source: SpriteFrames) -> SpriteFrames:
	var copy := SpriteFrames.new()
	copy.set_animation_loop(&"default", false)
	copy.set_animation_speed(&"default", source.get_animation_speed(&"default"))
	for i in source.get_frame_count(&"default"):
		var frame := source.get_frame_texture(&"default", i)
		if frame is AtlasTexture:
			var atlas := frame as AtlasTexture
			var key := atlas.atlas.resource_path
			if not _mip_cache.has(key):
				var image := atlas.atlas.get_image()
				image.generate_mipmaps()
				_mip_cache[key] = ImageTexture.create_from_image(image)
			var region := AtlasTexture.new()
			region.atlas = _mip_cache[key]
			region.region = atlas.region
			copy.add_frame(&"default", region)
		else:
			copy.add_frame(&"default", frame)
	return copy

func _sprites(node: Node, found: Array) -> void:
	if node is AnimatedSprite2D:
		found.append(node)
	for child in node.get_children():
		_sprites(child, found)

func _freeze(node: Node2D, variant: int) -> void:
	var sprites: Array = []
	_sprites(node, sprites)
	for sprite: AnimatedSprite2D in sprites:
		if variant == 2:
			sprite.sprite_frames = _mip_frames(sprite.sprite_frames)
		# O jogo agora define o filtro no próprio sprite (VfxAtlas.smooth); a coluna sobrepõe esse valor.
		sprite.texture_filter = [CanvasItem.TEXTURE_FILTER_NEAREST, CanvasItem.TEXTURE_FILTER_LINEAR, CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC][variant]
		sprite.stop()
		sprite.frame = mini(PEAK_FRAME, sprite.sprite_frames.get_frame_count(&"default") - 1)

func _label(text: String, at: Vector2, size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = at
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_constant_override("outline_size", 4)
	return label

func _shot(file: String) -> void:
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + file))

func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		printerr("vfx_filter_bench: exige pasta de dados sintética e janela (não headless)")
		quit(1)
		return
	for a in OS.get_cmdline_user_args():
		if a.contains("x"):
			tag = a
	await process_frame
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	var failures: Array = []
	for bg_name in BACKGROUNDS:
		for entry in _effects():
			var stage := Node2D.new()
			root.add_child(stage)
			var backdrop := ColorRect.new()
			backdrop.color = BACKGROUNDS[bg_name]
			backdrop.size = Vector2(1280, 720)
			stage.add_child(backdrop)
			stage.add_child(_label("%s  [fundo %s, %s]" % [entry[0], bg_name, tag], Vector2(12, 8), 18))
			var made := 0
			for i in COLUMNS.size():
				var node: Node2D = (entry[1] as Callable).call()
				if node == null:
					failures.append(entry[0])
					break
				made += 1
				var holder := Node2D.new()
				holder.position = Vector2(213.0 + 427.0 * i, 400)
				holder.texture_filter = [CanvasItem.TEXTURE_FILTER_NEAREST, CanvasItem.TEXTURE_FILTER_LINEAR, CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC][COLUMNS[i][1]]
				stage.add_child(holder)
				holder.add_child(node)
				_freeze(node, int(COLUMNS[i][1]))
				stage.add_child(_label(String(COLUMNS[i][0]), Vector2(20.0 + 427.0 * i, 60), 15))
			if made == COLUMNS.size():
				await _shot("%s-%s-%s.png" % [entry[0], bg_name, tag])
			stage.queue_free()
			await process_frame
	print("vfx_filter_bench: concluido, falhas=%s" % str(failures))
	quit(1 if not failures.is_empty() else 0)
