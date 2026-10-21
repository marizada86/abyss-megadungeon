extends RefCounted
## Tocha do Incendiário: o golpe de fogo precisa de arco de chamas visível (o cone genérico quase não aparecia).

func run() -> Array[String]:
	var failures: Array[String] = []
	var weapon: Dictionary = Data.table("weapons")["tocha_do_incendiario"]
	if weapon.kind != "melee" or weapon.dtype != "fogo": failures.append("tocha deixou de ser melee de fogo")
	var event := {"type": "swing", "weapon": "tocha_do_incendiario", "dtype": "fogo", "pos": Vector2(10, 8), "dir": Vector2(1, 0), "range": float(weapon.range), "cone": float(weapon.cone)}
	if not FireSwingVfx.supports(event): failures.append("golpe de fogo sem efeito próprio")
	if FireSwingVfx.supports(event, true): failures.append("ignora impacto reduzido")
	for field in ["type", "dtype"]:
		var other := event.duplicate()
		other[field] = "outro"
		if FireSwingVfx.supports(other): failures.append("aceita " + field + " indevido")
	if MeleeVfx.create_effect(event, Color.WHITE) != null: failures.append("kit físico não deve capturar o golpe de fogo")
	var before := event.duplicate(true)
	var effect := FireSwingVfx.create_effect(event)
	if effect == null:
		failures.append("sem efeito")
		return failures
	if effect.position != Iso.to_screen(event.pos) + Vector2(0, -18): failures.append("efeito fora do herói")
	if (effect.material as CanvasItemMaterial).blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append("material aditivo")
	if event != before: failures.append("helper alterou o evento")
	effect.free()
	return failures
