extends RefCounted
## Bola de Fogo / Tormenta de Fogo: a nova de fogo precisa ter explosão visível própria (relato do playtest da Zynara).

func run() -> Array[String]:
	var failures: Array[String] = []
	var weapons: Dictionary = Data.table("weapons")
	for id in ["bola_de_fogo", "tormenta_de_fogo"]:
		var w: Dictionary = weapons[id]
		if w.kind != "nova" or w.dtype != "fogo": failures.append(id + ": deixou de ser nova de fogo")
		var event := {"type": "nova", "weapon": id, "dtype": "fogo", "pos": Vector2(10, 8), "radius": float(w.radius)}
		if not FireBurstVfx.supports(event): failures.append(id + ": nova de fogo sem efeito próprio")
		if FireBurstVfx.supports(event, true): failures.append(id + ": ignora impacto reduzido")
		for field in ["type", "dtype"]:
			var other := event.duplicate()
			other[field] = "outro"
			if FireBurstVfx.supports(other): failures.append(id + ": aceita " + field + " indevido")
		var before := event.duplicate(true)
		var effect := FireBurstVfx.create_effect(event)
		if effect == null:
			failures.append(id + ": sem efeito")
			continue
		if effect.position != Iso.to_screen(event.pos): failures.append(id + ": efeito fora do herói")
		if (effect.material as CanvasItemMaterial).blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append(id + ": material aditivo")
		if event != before: failures.append(id + ": helper alterou o evento")
		effect.free()
	if FireBurstVfx.create_effect({"type": "nova", "dtype": "fogo", "pos": Vector2.ZERO, "radius": 3.0}, true) != null: failures.append("impacto reduzido deveria cair no anel simples")
	var axes := FireBurstVfx.axes_for_radius(3.0)
	var expected_x := Iso.to_screen(Vector2(3.0 / sqrt(2.0), -3.0 / sqrt(2.0))).x
	if not is_equal_approx(axes.x, expected_x) or not is_equal_approx(axes.y / axes.x, 0.5): failures.append("explosão: raio/projeção diferentes do alcance lógico")
	for kind in ["radiante", "magico"]:
		if FireBurstVfx.supports({"type": "nova", "dtype": kind, "radius": 3.0}): failures.append("explosão de fogo interfere na nova " + kind)
	return failures
