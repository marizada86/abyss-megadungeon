extends RefCounted
## Bola de Fogo de ponta a ponta na lógica: arma real na Battle -> evento nova -> efeito visual criado (relato: "usei a bola de fogo e o asset não aparece").

func _bat() -> Battle:
	var b := Battle.new(3, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _novas_until_fired(b: Battle, frames: int) -> Array:
	var novas: Array = []
	for i in frames:
		b.step(Vector2.ZERO, 1.0 / 60.0)
		for ev in b.events:
			if ev.type == "nova":
				novas.append(ev)
		if not novas.is_empty():
			break
		b.events.clear()
	return novas

func run() -> Array[String]:
	var failures: Array[String] = []
	var b := _bat()
	b.hero.weapons.append(Weapon.make("bola_de_fogo"))
	b.enemies.append(Enemy.make("zumbi", b.hero.pos + Vector2(1.5, 0.0), 0.0, 1.0, 0))
	b.events.clear()
	var novas := _novas_until_fired(b, 600)
	if novas.is_empty():
		failures.append("Bola de Fogo equipada não emitiu evento nova com inimigo no raio")
		return failures
	var ev: Dictionary = novas[0]
	if ev.get("weapon", "") != "bola_de_fogo" or ev.get("dtype", "") != "fogo":
		failures.append("evento nova da Bola de Fogo chegou com arma/dtype errados: %s" % ev)
	var effect := FireBurstVfx.create_effect(ev, false)
	if effect == null:
		failures.append("evento real da Bola de Fogo não gera FireBurstVfx")
	else:
		if effect.position != Iso.to_screen(ev.pos): failures.append("explosão fora do herói")
		effect.free()
	if FireBurstVfx.create_effect(ev, true) != null:
		failures.append("impacto reduzido deveria cair no anel simples")
	# Sem inimigo no raio a nova não dispara (comportamento atual): quem testa sem alvos não vê nada.
	var empty := _bat()
	empty.hero.weapons.append(Weapon.make("bola_de_fogo"))
	empty.events.clear()
	if not _novas_until_fired(empty, 600).is_empty():
		failures.append("Bola de Fogo disparou sem nenhum inimigo no raio")
	return failures
