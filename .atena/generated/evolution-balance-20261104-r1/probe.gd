extends SceneTree
## Sonda de balanço das evoluções (plano de 2026-11-04). Somente leitura: arena controlada, sem save, sem rede.
## Mede, para cada arma base no Nv 5 e para a evolução (passiva exigida no Nv 1, atributo mínimo cumprido), o dano por segundo em
## alvo único (um zumbi imóvel a 1,6 casa) e em área (anel de 10 zumbis imóveis a 2,0 casas, soma de todos).
## Uso: godot --headless --path . -s .atena/generated/evolution-balance-20261104-r1/probe.gd -- --controller-profile <perfil sintético> [ATTR]
## ATTR = valor dos 4 atributos do herói (padrão 16, ~meio de partida).

func _init() -> void:
	call_deferred("_run")

func _quiet(b: Battle) -> void:
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0

func _measure(weapon: Weapon, passive: String, attr_value: int, ring: bool) -> float:
	var b := Battle.new(5, "durvall", "dagruve")
	_quiet(b)
	b.hero.pos = Vector2(20, 20)
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	for a in ["forca", "inteligencia", "constituicao", "carisma"]:
		b.hero.base_attrs[a] = attr_value
	b.hero.weapons = [weapon]
	if passive != "":
		b.hero.passives[passive] = 1
	b.hero.recalc()
	var units: Array = []
	if ring:
		for i in 10:
			var e: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2.from_angle(TAU * i / 10.0) * 2.0)
			e.max_hp = 1e7
			e.hp = 1e7
			units.append([e, e.pos])
	else:
		var d: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.6, 0))
		d.max_hp = 1e7
		d.hp = 1e7
		units.append([d, d.pos])
	for _i in 1200:   # 20 s a 60 passos por segundo
		for u in units:
			u[0].pos = u[1]
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 1.0 / 60.0)
		b.events.clear()
		if b.state != "running":
			b.state = "running"
			b.offer.clear()
	var total := 0.0
	for u in units:
		total += 1e7 - u[0].hp
	return total / 20.0

func _run() -> void:
	var attr_value := 16
	var only: Array = []   # ids de armas base; vazio = todas
	for a in OS.get_cmdline_user_args():
		if a.is_valid_int():
			attr_value = int(a)
		elif not a.begins_with("--") and not a.ends_with(".json"):
			only.append(a)
	var weapons: Dictionary = Data.table("weapons")
	print("PAR;base;evolucao;passiva;base_single;evo_single;x_single;base_ring;evo_ring;x_ring")
	for wid in weapons:
		var d: Dictionary = weapons[wid]
		if not d.has("evolve") or (not only.is_empty() and not only.has(String(wid))):
			continue
		var into := String(d.evolve.into)
		var bs := _measure(Weapon.make(String(wid), Weapon.MAX_LEVEL), "", attr_value, false)
		var es := _measure(Weapon.make(into), String(d.evolve.passive), attr_value, false)
		var br := _measure(Weapon.make(String(wid), Weapon.MAX_LEVEL), "", attr_value, true)
		var er := _measure(Weapon.make(into), String(d.evolve.passive), attr_value, true)
		print("PAR;%s;%s;%s;%.1f;%.1f;%.2f;%.1f;%.1f;%.2f" % [wid, into, d.evolve.passive, bs, es, es / maxf(bs, 0.01), br, er, er / maxf(br, 0.01)])
	quit()
