class_name HourglassVfx
extends RefCounted
## Visual-only presentation of the ampulheta weapon's existing magical nova.
## A evolução (Ampulheta do Tempo Parado, plano de 2026-11-04) usa folha própria; sem a folha, ela mostra a arte da base.

const TEXTURE_PATH := "res://assets/vfx/ampulheta_silencio.png"
const DURATION := RadiantPulseVfx.DURATION
const PEAK_RING_RADIUS := 88.0
const EVOLVED_WEAPON := "ampulheta_do_tempo_parado"
const EVOLVED_PATH := "res://assets/vfx/pulso_ampulheta_tempo.png"
## Anel dominante no pico da folha da evolução (mesma medida do resto: máximo do perfil radial no quadro de maior brilho).
const EVOLVED_PEAK_RING_RADIUS := 82.0
static var _frames: SpriteFrames
static var _evolved_frames: SpriteFrames

static func supports(event: Dictionary, reduced_impact: bool = false) -> bool:
	var weapon := String(event.get("weapon", ""))
	return not reduced_impact and event.get("type", "") == "nova" and event.get("dtype", "") == "magico" and (weapon == "ampulheta" or weapon == EVOLVED_WEAPON) and float(event.get("radius", 0.0)) > 0.0

static func scale_for_radius(radius: float, peak_ring_radius: float = PEAK_RING_RADIUS) -> Vector2:
	return Vector2(Iso.TILE_W, Iso.TILE_H) * (radius * sqrt(2.0) * 0.5 / peak_ring_radius)

static func create_effect(event: Dictionary, color: Color, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	var evolved_frames: SpriteFrames = null
	if String(event.get("weapon", "")) == EVOLVED_WEAPON:
		if _evolved_frames == null and ResourceLoader.exists(EVOLVED_PATH):
			_evolved_frames = RadiantPulseVfx.frames_from_texture(load(EVOLVED_PATH) as Texture2D)
		evolved_frames = _evolved_frames
	if evolved_frames == null and _frames == null:
		if not ResourceLoader.exists(TEXTURE_PATH):
			return null
		_frames = RadiantPulseVfx.frames_from_texture(load(TEXTURE_PATH) as Texture2D)
		if _frames == null:
			return null
	var root := Node2D.new()
	root.position = Iso.to_screen(event.pos)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = evolved_frames if evolved_frames != null else _frames
	VfxAtlas.smooth(sprite)
	sprite.scale = scale_for_radius(float(event.radius), EVOLVED_PEAK_RING_RADIUS if evolved_frames != null else PEAK_RING_RADIUS)
	sprite.modulate = color
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.material = material
	root.add_child(sprite)
	sprite.animation_finished.connect(root.queue_free)
	sprite.play(&"default")
	return root
