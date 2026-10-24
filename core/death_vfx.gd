class_name DeathVfx
extends RefCounted
## Visual-only mortes (Lote 2, série M). Tipo, tamanho e tinta vêm do inimigo; nada aqui lê RNG nem altera o jogo.
const LIMIT := 14
const MIN_VALUE := 0.96
const SOUL_IDS := ["alma_penada"]
## sheet, escala por arte, âncora na base do chão, duração da animação.
const KINDS := {
	&"comum": {"sheet": "morte_poeira", "scale": 0.34, "base": false, "seconds": 0.30},
	&"elite": {"sheet": "morte_elite_estouro", "scale": 0.50, "base": false, "seconds": 0.55},
	&"chefe": {"sheet": "morte_chefe_colapso", "scale": 0.95, "base": true, "seconds": 1.10},
	&"quebravel": {"sheet": "morte_detritos", "scale": 0.40, "base": false, "seconds": 0.40},
	&"alma": {"sheet": "morte_alma", "scale": 0.70, "base": true, "seconds": 1.20},
	&"explosivo": {"sheet": "morte_explosivo", "scale": 0.62, "base": false, "seconds": 0.60},
}
const EXPLOSION_ART_PX := 182.0   # largura do pico da folha preparada (preparation-audit)

static func kind_for(enemy: Enemy) -> StringName:
	if enemy.is_boss():
		return &"chefe"
	if enemy.has_flag("quebravel"):
		return &"quebravel"
	if SOUL_IDS.has(enemy.id) or enemy.has_flag("alma"):
		return &"alma"
	if enemy.affix != "" or enemy.drops_chest:
		return &"elite"
	return &"comum"

## Poeira branco-quente que o jogo tinge: cor do inimigo, clareada até um brilho mínimo para não sumir em mistura aditiva.
static func tint_for(color: Color) -> Color:
	return Color.from_hsv(color.h, minf(color.s, 0.55), maxf(color.v, MIN_VALUE))

static func can_spawn(current: int, reduced: bool = false) -> bool:
	return not reduced and current < LIMIT

static func _build(kind: StringName, at_ground: Vector2, scale_value: float, tint: Color) -> Node2D:
	var spec: Dictionary = KINDS[kind]
	var sprite := VfxAtlas.sprite("res://assets/vfx/%s.png" % String(spec.sheet), false, float(spec.seconds))
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * scale_value
	if bool(spec.base):
		sprite.offset.y = 128.0 - PickupVfx.BASE_ANCHOR_Y
	sprite.modulate = tint
	var lift := 0.0 if bool(spec.base) else 18.0
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(at_ground) + Vector2(0, -lift))
	root.add_to_group(&"death_vfx")
	return root

static func create_effect(enemy: Enemy, at_ground: Vector2, reduced: bool = false, current: int = 0) -> Node2D:
	if not can_spawn(current, reduced):
		return null
	var kind := kind_for(enemy)
	var spec: Dictionary = KINDS[kind]
	var size := clampf(enemy.scale, 0.8, 1.5) if kind == &"comum" else 1.0
	var tint := tint_for(enemy.color) if kind == &"comum" else Color.WHITE
	return _build(kind, at_ground, float(spec.scale) * size, tint)

## Detonação de afixo explosivo, no instante do dano (evento `boom`), com o tamanho do raio do telégrafo.
static func create_explosion(radius: float, at_ground: Vector2, reduced: bool = false, current: int = 0) -> Node2D:
	if not can_spawn(current, reduced) or radius <= 0.0:
		return null
	var half_width := Iso.TILE_W * radius * sqrt(2.0) * 0.5
	return _build(&"explosivo", at_ground, half_width * 2.0 / EXPLOSION_ART_PX, Color.WHITE)
