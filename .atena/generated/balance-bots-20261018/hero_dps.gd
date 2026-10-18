extends SceneTree
## Sonda: DPS do herói em arena controlada (somente leitura). Alvo imóvel a 2 casas + anel de 10 zumbis.
## Uso: ... --script res://.atena/generated/balance-bots-20261018/hero_dps.gd

func _init() -> void:
	call_deferred("_run")

func _quiet(b: Battle) -> void:
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0

func _measure(hero_id: String, use_active: bool, ring: bool) -> Dictionary:
	var b := Battle.new(5, hero_id, "dagruve")
	_quiet(b)
	b.hero.pos = Vector2(20, 20)
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	var dummy: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.6, 0))
	dummy.max_hp = 1e7
	dummy.hp = 1e7
	var ring_units: Array = []
	if ring:
		for i in 10:
			var e: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2.from_angle(TAU * i / 10.0) * 3.0)
			e.max_hp = 1e7
			e.hp = 1e7
			ring_units.append([e, e.pos])
	var dpos: Vector2 = dummy.pos
	var total_ring := 0.0
	var steps := 1200
	for i in steps:
		dummy.pos = dpos
		for r in ring_units:
			r[0].pos = r[1]
		var before_ring := 0.0
		for r in ring_units:
			before_ring += 1e7 - r[0].hp
		if use_active:
			b.use_active((dpos - b.hero.pos).normalized())
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 1.0 / 60.0)
		b.events.clear()
		if b.state != "running":
			b.state = "running"
			b.offer.clear()
	for r in ring_units:
		total_ring += 1e7 - r[0].hp
	return {"single": (1e7 - dummy.hp) / 20.0, "ring": total_ring / 20.0}

func _run() -> void:
	var heroes: Dictionary = Data.table("heroes")
	for id in heroes:
		var w := String(heroes[id].weapon)
		var base := _measure(id, false, false)
		var act := _measure(id, true, false)
		var ring := _measure(id, true, true)
		print("DPS %-9s weapon=%-22s kind=%-6s single=%6.1f single+Q=%6.1f ring+Q(total)=%7.1f" % [id, w, String(Data.table("weapons")[w].get("kind", "?")), base.single, act.single, ring.ring])
	quit()
