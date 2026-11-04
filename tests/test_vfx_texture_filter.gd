extends RefCounted
## Filtro dos VFX: as folhas pintadas de 256 px são ampliadas, achatadas em Y e giradas; em nearest viram degraus.
## O filtro linear vale só para os efeitos (VfxAtlas.FILTER); o restante do jogo continua nearest (pixel art).

func _sprites(node: Node, found: Array) -> void:
	if node is AnimatedSprite2D:
		found.append(node)
	for child in node.get_children():
		_sprites(child, found)

func _check(label: String, node: Node, failures: Array[String]) -> void:
	if node == null:
		failures.append("%s: efeito não criado" % label)
		return
	var sprites: Array = []
	_sprites(node, sprites)
	if sprites.is_empty():
		# Feixe e setores do chefe desenham a textura no próprio nó (_draw), sem AnimatedSprite2D.
		if not (node is CanvasItem) or (node as CanvasItem).texture_filter != VfxAtlas.FILTER:
			failures.append("%s: nó sem filtro suave" % label)
	for sprite: AnimatedSprite2D in sprites:
		if sprite.texture_filter != VfxAtlas.FILTER:
			failures.append("%s: sprite sem filtro suave" % label)
	node.free()

func run() -> Array[String]:
	var failures: Array[String] = []
	var o := Vector2.ZERO
	if VfxAtlas.FILTER != CanvasItem.TEXTURE_FILTER_LINEAR:
		failures.append("VfxAtlas.FILTER deixou de ser linear")
	if int(ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter", -1)) != 0:
		failures.append("o filtro padrão do projeto mudou: só os VFX devem ser suavizados (pixel art continua nearest)")
	_check("VfxAtlas.sprite", VfxAtlas.sprite("res://assets/vfx/explosao_fogo.png"), failures)
	_check("VfxAtlas.sprite8", VfxAtlas.sprite8("res://assets/vfx/boss_escudo.png", "loop"), failures)
	_check("habilidade de herói", HeroAbilityVfx.create_effect("impacto_de_xargath", {"pos": o, "radius": 3.0}, Color.WHITE), failures)
	_check("habilidade em arco", HeroAbilityVfx.create_effect("ruptura_sombria", {"pos": o, "radius": 3.2}, Color.WHITE, Vector2(1, 0.4)), failures)
	_check("pulso radiante", RadiantPulseVfx.create_effect({"type": "nova", "dtype": "radiante", "weapon": "sentenca_de_lliira", "radius": 4.0, "pos": o}, Color.WHITE), failures)
	_check("ampulheta", HourglassVfx.create_effect({"type": "nova", "dtype": "magico", "weapon": "ampulheta", "radius": 4.0, "pos": o}, Color.WHITE), failures)
	_check("corpo a corpo", MeleeVfx.create_effect({"weapon": "espada_sombria", "dtype": "fisico", "dir": Vector2(1, 0), "pos": o, "range": 2.0}, Color.WHITE), failures)
	_check("detonação", DetonationVfx.create_effect(3.0, o, "magico"), failures)
	_check("tentáculos", TentacleVfx.create_cast({"owner": "hero", "weapon": "colar_dos_tentaculos", "radius": 3.0, "pos": o}), failures)
	_check("cera", WaxVfx.create_cast({"owner": "hero", "weapon": "inferno_de_cera", "radius": 5.0, "pos": o}), failures)
	_check("explosão de fogo", FireBurstVfx.create_sprite_effect({"type": "nova", "dtype": "fogo", "radius": 4.0, "pos": o}), failures)
	var projectile := {"owner": "hero", "pos": o, "dir": Vector2(1, 0), "p": {"_audio_id": "raio_de_luz", "dtype": "radiante"}}
	if ProjectileVfx.handles(projectile):
		_check("projétil em voo", ProjectileVfx.create_flight(projectile, Color.WHITE), failures)
		_check("impacto de projétil", ProjectileVfx.create_impact(ProjectileVfx.visual_family_for(projectile), o, Color.WHITE), failures)
	else:
		failures.append("projétil de teste não é tratado pelo ProjectileVfx")
	for desc in [{"kind": "beam", "sheet": "boss_varredura_feixe"}, {"kind": "sectors", "boss": "", "sectors": []}]:
		_check("chefe " + String(desc.kind), BossVfx.build(desc), failures)
	return failures
