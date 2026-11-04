class_name TentacleVfx
extends RefCounted
## Visual-only zona do Colar dos Tentáculos (Lote 3, série T): T01 quando a zona nasce e o laço T02 enquanto ela vive.
## Raio, dano e tick continuam no Battle.
const WEAPON := "colar_dos_tentaculos"
## Abraço dos Tentáculos (evolução, plano de 2026-11-04): laço próprio; a emersão (T01) é a do Colar. Folha ausente = laço do Colar.
const EVOLVED_WEAPON := "abraco_dos_tentaculos"
const EVOLVED_LOOP_PATH := "res://assets/vfx/abraco_laco.png"
## Largura do anel de chão da folha do laço da evolução, na mesma medida que RING_PX (0,94 do vão medido de ponta a ponta, 198 px).
const EVOLVED_RING_PX := 186.0
## Largura do anel do chão nas folhas preparadas (preparation-audit); a escala leva esse anel ao raio da zona.
const RING_PX := 166.0
const MAX_ALPHA := 0.95
const FADE_IN := 0.25
const FADE_OUT := 0.35
## T01 dura CAST_SECONDS; o laço entra aos LOOP_DELAY s e os dois se sobrepõem até o fim da emersão.
const CAST_SECONDS := 0.6
const LOOP_DELAY := 0.35
const LIMIT := 6
const CAST_PATH := "res://assets/vfx/tentaculos_emergem.png"

static func weapon_for(event: Dictionary) -> String:
	var p: Dictionary = event.get("p", {})
	return String(event.get("weapon", p.get("_audio_id", p.get("id", ""))))

static func supports(event: Dictionary, reduced: bool = false) -> bool:
	var weapon := weapon_for(event)
	return not reduced and String(event.get("owner", "hero")) == "hero" and (weapon == WEAPON or weapon == EVOLVED_WEAPON) and float(event.get("radius", 0.0)) > 0.0

static func scale_for(radius: float, ring_px: float = RING_PX) -> float:
	return maxf(0.0, radius) * Iso.TILE_W * sqrt(2.0) / ring_px

## Emersão dos tentáculos no evento `zone`; nula sem a folha (o laço entra direto, sem atraso).
static func create_cast(event: Dictionary, reduced: bool = false, current: int = 0) -> Node2D:
	if not supports(event, reduced) or current >= LIMIT:
		return null
	var sprite := VfxAtlas.sprite(CAST_PATH, false, CAST_SECONDS)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * scale_for(float(event.radius))
	sprite.offset.y = VfxAtlas.ground_offset_y("tentaculos_emergem")
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(event.pos))
	root.add_to_group(&"tentacle_vfx")
	return root

static func create_zone(zone: Dictionary, reduced: bool = false) -> Dictionary:
	if not supports(zone, reduced):
		return {}
	var loop_path := "res://assets/vfx/tentaculos_laco.png"
	var sheet := "tentaculos_laco"
	var ring_px := RING_PX
	if weapon_for(zone) == EVOLVED_WEAPON and VfxAtlas.texture(EVOLVED_LOOP_PATH) != null:
		loop_path = EVOLVED_LOOP_PATH
		sheet = "abraco_laco"
		ring_px = EVOLVED_RING_PX
	var sprite := VfxAtlas.sprite(loop_path, true, 0.9)
	if sprite == null:
		return {}
	sprite.scale = Vector2.ONE * scale_for(float(zone.radius), ring_px)
	sprite.offset.y = VfxAtlas.ground_offset_y(sheet)
	sprite.position = Iso.to_screen(zone.pos)
	sprite.modulate.a = 0.0
	var delay := LOOP_DELAY if VfxAtlas.texture(CAST_PATH) != null else 0.0
	return {"sprite": sprite, "zone": zone, "born": Time.get_ticks_msec(), "delay": delay}

static func update(entry: Dictionary) -> void:
	var life := float(entry.zone.get("life", 0.0))
	var age := float(Time.get_ticks_msec() - int(entry.born)) / 1000.0 - float(entry.get("delay", 0.0))
	entry.sprite.modulate.a = minf(clampf(age / FADE_IN, 0.0, 1.0), clampf(life / FADE_OUT, 0.0, 1.0)) * MAX_ALPHA
	entry.sprite.position = Iso.to_screen(entry.zone.pos)
