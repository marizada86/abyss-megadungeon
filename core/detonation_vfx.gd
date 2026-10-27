class_name DetonationVfx
extends RefCounted
## Visual-only detonação de AoE inimigo (Lote 3, série D). O raio e o dano vêm do telégrafo no Battle; a arte é só do
## tamanho do aviso e nunca passa dele. O afixo explosivo continua com a arte de morte explosiva (DeathVfx).
const LIMIT := 10
const SECONDS := 0.5
## sheet, largura do anel elíptico no pico da folha preparada (preparation-audit) e se a âncora fica na base.
const KINDS := {
	"fisico": {"sheet": "detonacao_fisica", "ring_px": 190.0, "base": false},
	"magico": {"sheet": "detonacao_magica", "ring_px": 122.0, "base": true},
}

static func sheet_for(dtype: String) -> String:
	return String(KINDS.get(dtype, {}).get("sheet", ""))

static func path_for(sheet: String) -> String:
	return "res://assets/vfx/%s.png" % sheet

static func can_spawn(current: int, reduced: bool = false) -> bool:
	return not reduced and current < LIMIT

## A escala leva o anel da arte ao raio do telégrafo (a mesma elipse 2:1 do chão isométrico).
static func scale_for(radius: float, dtype: String = "fisico") -> float:
	var ring_px := float(KINDS.get(dtype, KINDS.fisico).ring_px)
	return Iso.TILE_W * radius * sqrt(2.0) * 0.5 * 2.0 / ring_px

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
	sprite.scale = Vector2.ONE * scale_for(radius, dtype)
	if bool(KINDS[dtype].base):
		sprite.offset.y = 128.0 - 196.0
	var root := VfxAtlas.one_shot(sprite, Iso.to_screen(ground))
	root.add_to_group(&"detonation_vfx")
	return root
