class_name WaxVfx
extends RefCounted
const IDS := ["cera_fervente", "inferno_de_cera"]
## O corpo da poça é translúcido: o chão de pedra aparece por baixo e a chama carrega o brilho.
const BODY_ALPHA := 0.62
## A chama oscila só em apresentação (relógio de tela, sem RNG do jogo); as folhas têm quadros quase idênticos.
const FLICKER_SCALE := 0.045
const FLICKER_ALPHA := 0.12

static func weapon_for(event: Dictionary) -> String:
	var p: Dictionary = event.get("p", {})
	return String(event.get("weapon", p.get("_audio_id", p.get("id", ""))))

static func supports(event: Dictionary, reduced: bool = false) -> bool:
	return not reduced and String(event.get("owner", "hero")) == "hero" and IDS.has(weapon_for(event)) and float(event.get("radius", 0.0)) > 0.0

static func scale_for(radius: float) -> float:
	return maxf(0.0, radius) * Iso.TILE_W / 180.0

## Tinta multiplicada sobre o corpo bege: âmbar escuro na Cera Fervente, carmim escuro no Inferno de Cera.
static func tint_for(event: Dictionary) -> Color:
	return Color(0.62, 0.08, 0.12) if weapon_for(event) == "inferno_de_cera" else Color(0.86, 0.46, 0.14)

static func _path(event: Dictionary, cast: bool) -> String:
	var prefix := "inferno_de_cera" if weapon_for(event) == "inferno_de_cera" else "cera_fervente"
	if not cast:
		return "res://assets/vfx/inferno_de_cera_chama.png" if prefix == "inferno_de_cera" else "res://assets/vfx/cera_poca_chama.png"
	return "res://assets/vfx/%s_lancamento.png" % prefix

static func create_cast(event: Dictionary, reduced: bool = false) -> Node2D:
	if not supports(event, reduced):
		return null
	var sprite := VfxAtlas.sprite(_path(event, true), false, 0.36)
	if sprite == null:
		return null
	sprite.offset.y = -62
	sprite.scale = Vector2.ONE * scale_for(float(event.radius))
	return VfxAtlas.one_shot(sprite, Iso.to_screen(event.pos))

static func create_puddle(zone: Dictionary, reduced: bool = false) -> Dictionary:
	if not supports(zone, reduced):
		return {}
	var body := VfxAtlas.sprite("res://assets/vfx/cera_poca_corpo.png", true, 0.65, false)
	var flames := VfxAtlas.sprite(_path(zone, false), true, 0.65)
	if body == null or flames == null:
		if body != null: body.free()
		if flames != null: flames.free()
		return {}
	var scale_value := scale_for(float(zone.radius))
	body.scale = Vector2(scale_value, scale_value * 0.5)
	body.modulate = tint_for(zone)
	body.position = Iso.to_screen(zone.pos)
	flames.scale = Vector2.ONE * scale_value
	flames.offset.y = -62
	flames.position = body.position
	var phase := float(zone.pos.x) * 1.7 + float(zone.pos.y) * 2.3   # cada poça pisca fora de fase das vizinhas
	return {"body": body, "flames": flames, "zone": zone, "total": float(zone.get("life", 1.0)), "born": Time.get_ticks_msec(), "base_scale": scale_value, "phase": phase}

static func update(entry: Dictionary) -> void:
	var life := float(entry.zone.get("life", 0.0))
	var age := float(Time.get_ticks_msec() - int(entry.born)) / 1000.0
	var fade := minf(clampf(age / 0.18, 0, 1), clampf(life / 0.35, 0, 1))
	var wave := sin(age * 9.0 + float(entry.get("phase", 0.0)))
	entry.body.modulate.a = fade * BODY_ALPHA
	entry.flames.modulate.a = fade * (1.0 - FLICKER_ALPHA * 0.5 * (1.0 - wave))
	entry.flames.scale = Vector2.ONE * float(entry.get("base_scale", 1.0)) * (1.0 + FLICKER_SCALE * wave)
	entry.body.position = Iso.to_screen(entry.zone.pos)
	entry.flames.position = entry.body.position
