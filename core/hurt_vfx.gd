class_name HurtVfx
extends RefCounted
## Visual-only impacto de dano no herói (Lote 3, série H): acontece a cada golpe recebido, então é curto e discreto.
## O dano, a invulnerabilidade e o tremor continuam no Battle e em ui/run.gd.
const LIMIT := 6
const SCALE := 0.34
const LIFT := 30.0
const SECONDS := 0.3
## A folha é vermelho e branco: o tipo de dano só a matiza de leve.
const TINTS := {"magico": Color(0.78, 0.5, 1.0), "fogo": Color(1.0, 0.62, 0.2), "radiante": Color(1.0, 0.9, 0.55)}
const TINT_MIX := 0.55

static func tint_for(dtype: String) -> Color:
	return Color.WHITE.lerp(TINTS[dtype], TINT_MIX) if TINTS.has(dtype) else Color.WHITE

static func can_spawn(event: Dictionary, current: int, reduced: bool = false) -> bool:
	return not reduced and not bool(event.get("continuous", false)) and current < LIMIT

## Rotação determinística pelo dano (sem RNG do jogo): golpes seguidos não repetem o mesmo corte.
static func rotation_for(event: Dictionary) -> float:
	return float(int(event.get("amount", 0)) % 8) * TAU / 8.0

static func create_effect(event: Dictionary, reduced: bool = false, current: int = 0) -> Node2D:
	if not can_spawn(event, current, reduced):
		return null
	var sprite := VfxAtlas.sprite("res://assets/vfx/dano_heroi.png", false, SECONDS)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * SCALE
	sprite.rotation = rotation_for(event)
	sprite.modulate = tint_for(String(event.get("dtype", "")))
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(event.get("pos", Vector2.ZERO)) + Vector2(0, -LIFT))
	root.add_to_group(&"hurt_vfx")
	return root
