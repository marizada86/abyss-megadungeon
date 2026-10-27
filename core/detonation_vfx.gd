class_name DetonationVfx
extends RefCounted
## Visual-only detonação de AoE inimigo (Lote 3, série D). O raio e o dano vêm do telégrafo no Battle; a arte é só do
## tamanho do aviso e nunca passa dele. O afixo explosivo continua com a arte de morte explosiva (DeathVfx).
const LIMIT := 10
const SECONDS := 0.5
## Largura do anel elíptico no pico da folha preparada (preparation-audit): a escala leva esse anel ao raio do telégrafo.
const RING_PX := 190.0
const KINDS := {"fisico": "detonacao_fisica", "magico": "detonacao_magica"}

static func sheet_for(dtype: String) -> String:
	return String(KINDS.get(dtype, ""))

static func path_for(sheet: String) -> String:
	return "res://assets/vfx/%s.png" % sheet

static func can_spawn(current: int, reduced: bool = false) -> bool:
	return not reduced and current < LIMIT

static func scale_for(radius: float) -> float:
	return Iso.TILE_W * radius * sqrt(2.0) * 0.5 * 2.0 / RING_PX

## `affix` não vazio (explosivo) fica de fora: a arte de morte explosiva já cobre o instante do dano.
static func create_effect(radius: float, ground: Vector2, dtype: String, reduced: bool = false, current: int = 0, affix: String = "") -> Node2D:
	if not can_spawn(current, reduced) or radius <= 0.0 or affix != "":
		return null
	var sheet := sheet_for(dtype)
	if sheet.is_empty():
		return null
	var sprite := VfxAtlas.sprite(path_for(sheet), false, SECONDS)
	if sprite == null:
		return null
	sprite.scale = Vector2.ONE * scale_for(radius)
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(ground))
	root.add_to_group(&"detonation_vfx")
	return root
