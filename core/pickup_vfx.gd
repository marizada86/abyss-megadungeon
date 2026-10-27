class_name PickupVfx
extends RefCounted
## Visual-only coleta, XP e progressão (Lote 2, série P). Nada aqui lê RNG do jogo nem altera valores, pickups ou XP.
const LIMIT := 10
const GLIMMER_LIMIT := 48
const GLIMMER_SIZE := 44.0
const TIDE_ALPHA := 0.35
const TIDE_FADE_PER_SECOND := 2.0
## Âncora "base": o anel do chão fica em (128,196) da célula; "center": o centro da célula.
const BASE_ANCHOR_Y := 196.0
## Folha da aura da Maré: o centro do anel (linha mais larga) está na linha 176 da célula, 20 px acima da base (196).
const TIDE_ANCHOR_Y := 176.0
const COLLECT := {
	"xp": {"sheet": "xp_coleta", "scale": 0.50, "lift": 30.0, "base": false, "gap_ms": 90},
	"gold": {"sheet": "moeda_coleta", "scale": 0.45, "lift": 30.0, "base": false, "gap_ms": 110},
	"potion": {"sheet": "pocao_coleta", "scale": 0.55, "lift": 0.0, "base": true, "gap_ms": 0},
	"magnet": {"sheet": "ima_pulso", "scale": 0.90, "lift": 28.0, "base": false, "gap_ms": 0},
}
static var _last_ms: Dictionary = {}
static var _glimmer_frames: Array[AtlasTexture] = []

static func path_for(sheet: String) -> String:
	return "res://assets/vfx/%s.png" % sheet

static func supports(kind: String) -> bool:
	return COLLECT.has(kind)

static func can_spawn(kind: String, current: int, now_ms: int, reduced: bool = false) -> bool:
	if reduced or not supports(kind) or current >= LIMIT:
		return false
	return now_ms - int(_last_ms.get(kind, -100000)) >= int(COLLECT[kind].gap_ms)

static func _place(sprite: AnimatedSprite2D, base: bool, scale_value: float, anchor_y: float = BASE_ANCHOR_Y) -> void:
	sprite.scale = Vector2.ONE * scale_value
	if base:
		sprite.offset.y = 128.0 - anchor_y

## Efeito de coleta sobre o herói: `ground` é a posição do evento `pickup` (a do herói).
static func create_collect(kind: String, ground: Vector2, reduced: bool = false, current: int = 0, now_ms: int = -1) -> Node2D:
	if now_ms < 0:
		now_ms = Time.get_ticks_msec()
	if not can_spawn(kind, current, now_ms, reduced):
		return null
	var spec: Dictionary = COLLECT[kind]
	var sprite := VfxAtlas.sprite(path_for(String(spec.sheet)), false, 0.45)
	if sprite == null:
		return null
	_place(sprite, bool(spec.base), float(spec.scale))
	_last_ms[kind] = now_ms
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(ground) + Vector2(0, -float(spec.lift)))
	root.add_to_group(&"pickup_vfx")
	return root

## Subida de nível: pilar de luz e anéis no chão, no lugar da folha 2x2 antiga (que continua de fallback no chamador).
static func create_levelup(ground: Vector2, reduced: bool = false) -> Node2D:
	if reduced:
		return null
	var sprite := VfxAtlas.sprite(path_for("subida_de_nivel_v2"), false, 0.9)
	if sprite == null:
		return null
	_place(sprite, true, 1.4)
	return VfxAtlas.one_shot(sprite, Iso.to_screen(ground))

## Aura da Maré: laço sutil no herói enquanto o bônus de XP vigora; a opacidade sobe e desce em `tide_alpha`.
static func create_tide_aura(reduced: bool = false) -> AnimatedSprite2D:
	if reduced:
		return null
	var sprite := VfxAtlas.sprite(path_for("mare_aura"), true, 0.9)
	if sprite == null:
		return null
	_place(sprite, true, 0.6, TIDE_ANCHOR_Y)
	sprite.modulate.a = 0.0
	return sprite

static func tide_alpha(current: float, active: bool, dt: float) -> float:
	return move_toward(current, TIDE_ALPHA if active else 0.0, TIDE_FADE_PER_SECOND * dt)

static func glimmer_frame(ground: Vector2, now_ms: int) -> int:
	var phase := int(absf(ground.x) * 7.0 + absf(ground.y) * 13.0)
	return int(now_ms / 150 + phase) % 6

## Brilho em laço sobre um cristal de XP no chão. Desenho direto com a folha (sem nós); só os `GLIMMER_LIMIT` primeiros.
static func draw_glimmer(ci: CanvasItem, pickup: Dictionary, screen: Vector2, index: int, now_ms: int, reduced: bool = false) -> bool:
	if reduced or index >= GLIMMER_LIMIT or String(pickup.get("kind", "")) != "xp":
		return false
	var sheet := VfxAtlas.texture(path_for("xp_brilho"))
	if sheet == null:
		return false
	if _glimmer_frames.is_empty():
		for cell in 6:
			var region := AtlasTexture.new()
			region.atlas = sheet
			region.region = Rect2(cell * 256, 0, 256, 256)
			_glimmer_frames.append(region)
	var size := GLIMMER_SIZE
	ci.draw_texture_rect(_glimmer_frames[glimmer_frame(pickup.pos, now_ms)], Rect2(screen.x - size * 0.5, screen.y - size * 0.78, size, size), false, Color(1, 1, 1, 0.9))
	return true
