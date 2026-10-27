class_name TentacleVfx
extends RefCounted
## Visual-only zona do Colar dos Tentáculos (Lote 3, série T): laço enquanto a zona vive. Raio, dano e tick continuam no Battle.
const WEAPON := "colar_dos_tentaculos"
## Largura do anel do chão na folha preparada (preparation-audit); a escala leva esse anel ao raio da zona.
const RING_PX := 184.0
const BASE_ANCHOR_Y := 196.0
const MAX_ALPHA := 0.95
const FADE_IN := 0.25
const FADE_OUT := 0.35

static func weapon_for(event: Dictionary) -> String:
	var p: Dictionary = event.get("p", {})
	return String(event.get("weapon", p.get("_audio_id", p.get("id", ""))))

static func supports(event: Dictionary, reduced: bool = false) -> bool:
	return not reduced and String(event.get("owner", "hero")) == "hero" and weapon_for(event) == WEAPON and float(event.get("radius", 0.0)) > 0.0

static func scale_for(radius: float) -> float:
	return maxf(0.0, radius) * Iso.TILE_W * sqrt(2.0) / RING_PX

static func create_zone(zone: Dictionary, reduced: bool = false) -> Dictionary:
	if not supports(zone, reduced):
		return {}
	var sprite := VfxAtlas.sprite("res://assets/vfx/tentaculos_laco.png", true, 0.9)
	if sprite == null:
		return {}
	sprite.scale = Vector2.ONE * scale_for(float(zone.radius))
	sprite.offset.y = 128.0 - BASE_ANCHOR_Y
	sprite.position = Iso.to_screen(zone.pos)
	sprite.modulate.a = 0.0
	return {"sprite": sprite, "zone": zone, "born": Time.get_ticks_msec()}

static func update(entry: Dictionary) -> void:
	var life := float(entry.zone.get("life", 0.0))
	var age := float(Time.get_ticks_msec() - int(entry.born)) / 1000.0
	entry.sprite.modulate.a = minf(clampf(age / FADE_IN, 0.0, 1.0), clampf(life / FADE_OUT, 0.0, 1.0)) * MAX_ALPHA
	entry.sprite.position = Iso.to_screen(entry.zone.pos)
