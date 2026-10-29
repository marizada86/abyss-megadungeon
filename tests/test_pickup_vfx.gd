extends RefCounted
## Lote 2, série P: coleta, XP, subida de nível e aura da Maré. Só apresentação.
const KINDS := ["xp", "gold", "potion", "magnet"]

func run() -> Array[String]:
	var out: Array[String] = []
	for kind in KINDS:
		if not PickupVfx.supports(kind): out.append("sem efeito de coleta para " + kind)
	if PickupVfx.supports("item") or PickupVfx.supports(""): out.append("tipo desconhecido não deveria ter efeito")
	# todo `kind` que Battle._collect trata tem de estar coberto
	var source := FileAccess.get_file_as_string("res://core/battle.gd")
	for kind in ["xp", "gold", "potion", "magnet"]:
		if not source.contains("\"%s\":" % kind): out.append("Battle._collect mudou: revisar " + kind)
	for sheet in ["xp_brilho", "xp_coleta", "moeda_coleta", "pocao_coleta", "ima_pulso", "subida_de_nivel_v2", "mare_aura"]:
		var texture := VfxAtlas.texture(PickupVfx.path_for(sheet))
		if texture == null:
			out.append("atlas ausente ou fora de 1536x256: " + sheet)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for cell in 6:
			var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s célula %d vazia ou sem margem" % [sheet, cell])
	# limites e ritmo
	if PickupVfx.can_spawn("xp", PickupVfx.LIMIT, 100000) or PickupVfx.can_spawn("xp", 0, 100000, true): out.append("limite ou impacto reduzido ignorado")
	var ground := Vector2(6, 7)
	var first := PickupVfx.create_collect("xp", ground, false, 0, 500000)
	if first == null: out.append("sem efeito de XP")
	else:
		if not first.is_in_group(&"pickup_vfx"): out.append("efeito fora do grupo de contagem")
		if first.position != Iso.to_screen(ground) + Vector2(0, -float(PickupVfx.COLLECT.xp.lift)): out.append("âncora do efeito de XP")
		first.free()
	if PickupVfx.create_collect("xp", ground, false, 0, 500020) != null: out.append("ritmo: dois efeitos de XP no mesmo instante")
	var later := PickupVfx.create_collect("xp", ground, false, 0, 500200)
	if later == null: out.append("ritmo: efeito deveria voltar após o intervalo")
	else: later.free()
	var potion := PickupVfx.create_collect("potion", ground, false, 0, 600000)
	if potion == null or (potion.get_child(0) as AnimatedSprite2D).offset.y >= 0.0: out.append("poção deveria ancorar na base")
	if potion != null: potion.free()
	if PickupVfx.create_collect("magnet", ground, true, 0, 700000) != null: out.append("ímã ignora impacto reduzido")
	# subida de nível e Maré
	var level := PickupVfx.create_levelup(ground)
	if level == null: out.append("sem efeito de subida de nível")
	else: level.free()
	if PickupVfx.create_levelup(ground, true) != null: out.append("subida de nível ignora impacto reduzido")
	var aura := PickupVfx.create_tide_aura()
	if aura == null or not aura.sprite_frames.get_animation_loop(&"default") or aura.modulate.a != 0.0: out.append("aura da Maré deveria nascer em laço e invisível")
	if aura != null: aura.free()
	var a := 0.0
	for i in 40: a = PickupVfx.tide_alpha(a, true, 0.1)
	if not is_equal_approx(a, PickupVfx.TIDE_ALPHA): out.append("aura não sobe até a opacidade sutil")
	for i in 40: a = PickupVfx.tide_alpha(a, false, 0.1)
	if a != 0.0: out.append("aura não some ao zerar a sequência")
	# brilho
	for ms in [0, 149, 150, 99999]:
		var frame := PickupVfx.glimmer_frame(Vector2(3.2, 8.1), ms)
		if frame < 0 or frame > 5: out.append("quadro do brilho fora de 0..5")
	if PickupVfx.glimmer_frame(Vector2(3, 4), 1000) != PickupVfx.glimmer_frame(Vector2(3, 4), 1000): out.append("brilho não determinístico")
	var probe := Node2D.new()
	var pickup := {"kind": "gold", "pos": Vector2(3, 4), "value": 1.0, "magnet": false, "src": ""}
	var before := pickup.duplicate(true)
	if PickupVfx.draw_glimmer(probe, pickup, Vector2.ZERO, 0, 0): out.append("só cristal de XP brilha")
	pickup.kind = "xp"
	if PickupVfx.draw_glimmer(probe, pickup, Vector2.ZERO, PickupVfx.GLIMMER_LIMIT, 0) or PickupVfx.draw_glimmer(probe, pickup, Vector2.ZERO, 0, 0, true): out.append("limite de brilhos ou impacto reduzido ignorado")
	pickup.kind = "gold"
	if pickup != before: out.append("o pickup foi alterado")
	# pulso: só XP, respeita impacto reduzido e não altera o pickup
	pickup.kind = "xp"
	if PickupVfx.draw_pulse(probe, pickup, Vector2.ZERO, 0, true): out.append("pulso ignora impacto reduzido")
	var phases := {}
	for ms in range(0, 3000, 50):
		var s := PickupVfx.pulse_phase(Vector2(3.2, 8.1), ms)
		if s < 0.0 or s > 1.0: out.append("fase do pulso fora de 0..1")
		phases[snappedf(s, 0.1)] = true
	if phases.size() < 5: out.append("o pulso deveria variar no tempo")
	if is_equal_approx(PickupVfx.pulse_phase(Vector2(1, 1), 0), PickupVfx.pulse_phase(Vector2(4, 9), 0)): out.append("cristais diferentes pulsam em fase")
	pickup.kind = "gold"
	if PickupVfx.draw_pulse(probe, pickup, Vector2.ZERO, 0): out.append("só cristal de XP pulsa")
	if pickup != before: out.append("o pulso alterou o pickup")
	probe.free()
	# seleção do brilho: visíveis e mais próximos, nunca os antigos fora da tela
	var crowd: Array = []
	for i in 60:   # os 60 mais antigos, longe e fora da tela
		crowd.append({"kind": "xp", "pos": Vector2(100 + i, 100), "value": 1.0, "magnet": false, "src": ""})
	for i in 60:   # os 60 mais novos, visíveis, a distâncias crescentes
		crowd.append({"kind": "xp", "pos": Vector2(1 + i * 0.1, 0), "value": 1.0, "magnet": false, "src": ""})
	crowd.append({"kind": "gold", "pos": Vector2(0.5, 0), "value": 1.0, "magnet": false, "src": ""})
	var on_screen := func(c: Vector2) -> bool: return c.x < 50.0
	var picked := PickupVfx.glimmer_indices(crowd, Vector2.ZERO, on_screen)
	if picked.size() != PickupVfx.GLIMMER_LIMIT: out.append("o brilho deveria usar o orçamento inteiro (%d), usou %d" % [PickupVfx.GLIMMER_LIMIT, picked.size()])
	for i in picked:
		if i < 60: out.append("brilho em cristal fora da tela (%d)" % i)
		if String(crowd[i].kind) != "xp": out.append("brilho em pickup que não é XP")
	if not picked.has(60) or picked.has(119): out.append("deveria priorizar os cristais mais próximos do herói")
	var few := PickupVfx.glimmer_indices(crowd.slice(60, 70), Vector2.ZERO, on_screen)
	if few.size() != 10: out.append("poucos cristais visíveis: todos brilham")
	# nenhum RNG nem estado do jogo
	var battle := Battle.new(808, "durvall", "dagruve")
	var rng_state := battle.rng.state
	var pickups_before := battle.pickups.duplicate(true)
	var temp := PickupVfx.create_collect("gold", battle.hero.pos, false, 0, 800000)
	if temp != null: temp.free()
	if battle.rng.state != rng_state or battle.pickups != pickups_before: out.append("RNG ou pickups alterados")
	return out
