extends SceneTree
## Depuração: golpes, erros e DPS de uma arma em arena controlada, 240 s para reduzir o ruído das armas lentas (somente leitura).
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	for spec in [["martelo_da_gloria", 5, ""], ["martelo_da_luz", 1, "vigor_sagrado"]]:
		var b := Battle.new(5, "durvall", "dagruve")
		b.stage.waves = []
		b.stage.elites = []
		b.stage.duration = 99999
		b._inter_t = 99999.0
		b._breakable_t = 99999.0
		b.hero.pos = Vector2(20, 20)
		b.hero.max_hp = 99999.0
		for a in ["forca", "inteligencia", "constituicao", "carisma"]:
			b.hero.base_attrs[a] = 16
		b.hero.weapons = [Weapon.make(spec[0], spec[1])]
		if spec[2] != "":
			b.hero.passives[spec[2]] = 1
		b.hero.recalc()
		var d: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.6, 0))
		d.max_hp = 1e7
		d.hp = 1e7
		var pos := d.pos
		var hits := 0
		var misses := 0
		var swings := 0
		for i in 14400:
			d.pos = pos
			b.hero.hp = b.hero.max_hp
			b.step(Vector2.ZERO, 1.0 / 60.0)
			for e in b.events:
				if e.type == "hit": hits += 1
				elif e.type == "miss": misses += 1
				elif e.type == "swing": swings += 1
			b.events.clear()
		print("DBG %s swings=%d hits=%d miss=%d dps=%.1f" % [spec[0], swings, hits, misses, (1e7 - d.hp) / 240.0])
	quit()

