extends RefCounted
func _ring(id: String, out: Array[String]) -> void:
	var pr := {"owner": "enemy", "ring": true, "src": id}
	if ProjectileVfx.enemy_family_for(pr) != &"bala_de_chefe": out.append("ring route " + id)
	var color := ProjectileVfx.enemy_tint(pr)
	if maxf(color.r, maxf(color.g, color.b)) < 0.649: out.append("dark ring " + id)
	var rgb: Array = Data.table("enemies")[id].color
	var expected := Color(float(rgb[0])/255, float(rgb[1])/255, float(rgb[2])/255)
	var peak := maxf(expected.r, maxf(expected.g, expected.b))
	if peak < 0.65: expected = expected.lerp(Color.WHITE, (0.65 - peak)/(1-peak))
	if not color.is_equal_approx(expected): out.append("data tint " + id)

func run() -> Array[String]:
	var out: Array[String] = []
	var enemies := Data.table("enemies")
	for id in enemies:
		for ability in enemies[id].get("abilities", []):
			if ability.t == "shoot":
				if ProjectileVfx.enemy_family_for({"owner": "enemy", "src": id}) == &"": out.append("unmapped shooter " + id)
			if ability.t == "ring": _ring(id, out)
	for id in Data.table("boss_phases"):
		for phase in Data.table("boss_phases")[id]:
			for action in phase.get("actions", []):
				if action.t == "ring": _ring(id, out)
	if ProjectileVfx.enemy_family_for({"owner": "hero", "ring": true, "src": "cultista_arqueiro"}) != &"": out.append("enemy helper captured hero")
	if ProjectileVfx.family_for({"owner": "enemy", "src": "cultista_arqueiro"}) != &"": out.append("hero helper captured enemy")
	if ProjectileVfx.can_spawn(80) or ProjectileVfx.can_spawn(0, true): out.append("projectile cap/reduced")
	for family in ProjectileVfx.ENEMY_FAMILIES:
		if ProjectileVfx.frames_for(family).is_empty(): out.append("missing frames " + String(family))
	var pr := {"owner": "enemy", "src": "cultista_arqueiro", "pos": Vector2(4,5), "dir": Vector2.DOWN}
	var before := pr.duplicate(true)
	var flight := ProjectileVfx.create_flight(pr, Color.WHITE)
	if flight == null: out.append("enemy flight")
	else:
		if not is_equal_approx(flight.rotation, Iso.to_screen(pr.dir).angle()): out.append("enemy heading")
		flight.free()
	if ProjectileVfx.handles(pr, true): out.append("enemy reduced")
	if before != pr: out.append("projectile mutated")
	return out
