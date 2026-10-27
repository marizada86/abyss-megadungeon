class_name VfxAtlas
extends RefCounted
## Shared, presentation-only six-frame atlas reader. Missing/invalid sheets keep procedural fallbacks.
static var _cache: Dictionary = {}
## Linha da célula (256 px) onde fica o CENTRO do anel de chão de cada folha ancorada no chão. Não é a borda de baixo da arte
## (196): o anel é uma elipse achatada, e ancorar o fundo dela no ponto do chão a levantava 14-38 px acima do alvo. Medida na
## folha (linha mais larga do anel no quadro de pico) e confirmada no jogo; tests/test_vfx_ground_anchor.gd confere a medida.
## Folha fora da tabela usa a base da arte (`BASE_ROW`).
const BASE_ROW := 196.0
const GROUND_ROW := {
	"mare_aura": 176.0, "pocao_coleta": 171.0, "subida_de_nivel_v2": 175.0, "detonacao_magica": 189.0, "detonacao_fisica": 143.0,
	"tentaculos_laco": 164.0, "tentaculos_emergem": 164.0, "boss_fase_estouro": 175.0, "morte_chefe_colapso": 175.0, "morte_alma": 179.0,
}

## `offset.y` que põe o centro do anel da folha sobre o ponto do chão (a escala do nó multiplica o offset, então não entra aqui).
static func ground_offset_y(sheet: String) -> float:
	return 128.0 - float(GROUND_ROW.get(sheet, BASE_ROW))


static func frames(path: String, looped: bool = false, duration: float = 0.24) -> SpriteFrames:
	var key := "%s:%s:%s" % [path, looped, duration]
	if _cache.has(key):
		return _cache[key]
	if not ResourceLoader.exists(path):
		return null
	var texture := load(path) as Texture2D
	if texture == null or texture.get_size() != Vector2(1536, 256):
		return null
	var built := SpriteFrames.new()
	built.set_animation_loop(&"default", looped)
	built.set_animation_speed(&"default", 6.0 / duration)
	for index in 6:
		var region := AtlasTexture.new()
		region.atlas = texture
		region.region = Rect2(index * 256, 0, 256, 256)
		built.add_frame(&"default", region)
	_cache[key] = built
	return built

static func sprite(path: String, looped: bool = false, duration: float = 0.24, additive: bool = true) -> AnimatedSprite2D:
	var built := frames(path, looped, duration)
	if built == null:
		return null
	var node := AnimatedSprite2D.new()
	node.sprite_frames = built
	if additive:
		var material := CanvasItemMaterial.new()
		material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		node.material = material
	node.play()
	return node

static func one_shot(sprite_node: AnimatedSprite2D, at: Vector2) -> Node2D:
	if sprite_node == null:
		return null
	var root := Node2D.new()
	root.position = at
	root.add_child(sprite_node)
	sprite_node.animation_finished.connect(root.queue_free)
	return root

## Cached full-sheet texture when it has the expected 256 px cell grid; null otherwise (callers keep their fallback).
static func texture(path: String, cells: int = 6) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	var loaded := load(path) as Texture2D
	if loaded == null or loaded.get_size() != Vector2(256 * cells, 256):
		return null
	return loaded

## Eight-cell sheets (2048x256): cells 0-3 loop, cells 4-7 play once. {"loop": SpriteFrames, "burst": SpriteFrames} or {}.
static func frames8(path: String, loop_duration: float = 0.6, burst_duration: float = 0.5) -> Dictionary:
	var key := "8:%s:%s:%s" % [path, loop_duration, burst_duration]
	if _cache.has(key):
		return _cache[key]
	var sheet := texture(path, 8)
	if sheet == null:
		return {}
	var loop := SpriteFrames.new()
	loop.set_animation_loop(&"default", true)
	loop.set_animation_speed(&"default", 4.0 / loop_duration)
	var burst := SpriteFrames.new()
	burst.set_animation_loop(&"default", false)
	burst.set_animation_speed(&"default", 4.0 / burst_duration)
	for index in 8:
		var region := AtlasTexture.new()
		region.atlas = sheet
		region.region = Rect2(index * 256, 0, 256, 256)
		(loop if index < 4 else burst).add_frame(&"default", region)
	var built := {"loop": loop, "burst": burst}
	_cache[key] = built
	return built

static func sprite8(path: String, part: String, loop_duration: float = 0.6, burst_duration: float = 0.5, additive: bool = true) -> AnimatedSprite2D:
	var built := frames8(path, loop_duration, burst_duration)
	if built.is_empty():
		return null
	var node := AnimatedSprite2D.new()
	node.sprite_frames = built[part]
	if additive:
		var material := CanvasItemMaterial.new()
		material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		node.material = material
	node.play()
	return node
