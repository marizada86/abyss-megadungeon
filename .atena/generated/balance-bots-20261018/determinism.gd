extends SceneTree
## Sonda: a mesma semente produz o mesmo estado? Roda N vezes no processo e imprime impressão digital a cada 10 s.

func _init() -> void:
	call_deferred("_run")

func _fp(b: Battle) -> String:
	var s := "%d|%d|%.3f|%.1f" % [b.enemies.size(), int(b.stats.kills), b.hero.pos.x + b.hero.pos.y, b.hero.hp]
	var acc := 0.0
	for e in b.enemies:
		acc += e.pos.x * 3.1 + e.pos.y * 1.7 + e.hp
	return "%s|%.2f" % [s, acc]

func _once(stage: String, hero: String) -> Array:
	var b := Battle.new(1, hero, stage)
	var out: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = 99
	for i in 3600:
		match b.state:
			"levelup", "altar", "item_offer":
				b.choose(0)
			"shop":
				b.state = "running"
		b.hero.hp = b.hero.max_hp
		var dir := Vector2.from_angle(float(i / 120)).normalized()
		b.step(dir, 1.0 / 60.0)
		b.events.clear()
		if i % 600 == 599:
			out.append(_fp(b))
	return out

func _run() -> void:
	for stage in ["dagruve", "docas"]:
		var a := _once(stage, "durvall")
		var b := _once(stage, "durvall")
		var same := a == b
		print("DET %s same=%s" % [stage, same])
		if not same:
			for i in a.size():
				if a[i] != b[i]:
					print("  diff@%ds: %s  vs  %s" % [(i + 1) * 10, a[i], b[i]])
					break
	quit()
