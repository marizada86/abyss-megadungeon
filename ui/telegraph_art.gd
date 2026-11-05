class_name TelegraphArt
extends Node2D
## Arte dos avisos de golpe dos inimigos COMUNS: faixa de investida (T20), mira do atirador (T21) e círculo de golpe em área (T22).
## As folhas são neutras (branco com o brilho no alfa) e saem tingidas pela cor do aviso do Overlay (`_warn(dtype).main`, que já segue o
## modo de daltonismo), em mistura aditiva. O Overlay enfileira os comandos de cada quadro (`reset`, `lane`/`aim`/`ring`, `flush`) e este nó
## os desenha ATRÁS do Overlay, então o preenchimento de progresso e os realces por código ficam por cima.
## Sem a folha (`has_sheet` falso) o Overlay mantém o desenho por código de sempre, como as peles de chefe (`BossVfx.skinned`).
## Só apresentação: geometria, dano e tempo do golpe ficam em Battle. Fontes e medições: .atena/generated/asset-queue-20261105-r1/prep.

## Folhas de 256 px por célula. `freeze` é o quadro mostrado em "Impacto reduzido" (o de energia mais próxima da média).
const KINDS := {
	"faixa": {"path": "res://assets/vfx/aviso_comum_faixa.png", "cells": 6, "frame_ms": 100, "freeze": 2},
	"mira": {"path": "res://assets/vfx/aviso_comum_mira.png", "cells": 6, "frame_ms": 80, "freeze": 1},
	"area": {"path": "res://assets/vfx/aviso_comum_area.png", "cells": 4, "frame_ms": 130, "freeze": 1},
}
const CELL := 256.0
## Fatias da barra [x, largura] na célula: pontas fixas e miolo esticado ao comprimento (as mesmas de `BossVfx.BEAM`).
const CAP_L := Vector2(24.0, 56.0)
const CAP_M := Vector2(80.0, 96.0)
const CAP_R := Vector2(176.0, 56.0)
## Altura visível do corpo da faixa na célula (folha preparada: 58 a 68 px): ela casa com a largura do golpe (2 x meia largura).
const LANE_BAND_PX := 62.0
## Escala da mira em tela: altura visível de cerca de 15 px e mira de cerca de 20 px (a de código tinha 22 px).
const AIM_K := 0.5
## Centro da mira dentro da célula: o fim do raio (`b`) cai sobre ele, não sobre a borda da ponta direita.
const RETICLE_X := 203.5
## A mira fecha conforme o tiro se aproxima: escala da ponta direita no começo e no fim do aviso.
const AIM_CLOSE_FROM := 1.35
const AIM_CLOSE_TO := 0.85
## Raio do anel externo na célula (folha preparada: 80 a 88 px, média 83).
const RING_R := 83.0

static var _textures := {}

var _cmds: Array = []

func _init() -> void:
	var additive := CanvasItemMaterial.new()
	additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = additive
	VfxAtlas.smooth(self)
	show_behind_parent = true

# ------------------------------------------------------------------ funções puras (testáveis)

static func path_for(kind: String) -> String:
	return String(KINDS[kind].path) if KINDS.has(kind) else ""

## Folha com a geometria certa, ou nulo (arquivo ausente ou tamanho errado).
static func load_sheet(path: String, cells: int) -> Texture2D:
	return VfxAtlas.texture(path, cells)

static func texture_for(kind: String) -> Texture2D:
	if not KINDS.has(kind):
		return null
	if not _textures.has(kind):
		_textures[kind] = load_sheet(path_for(kind), int(KINDS[kind].cells))
	return _textures[kind]

static func has_sheet(kind: String) -> bool:
	return texture_for(kind) != null

## Quadro do ciclo no instante `now_ms`; em "Impacto reduzido" fica parado no quadro de repouso da folha.
static func frame_for(kind: String, now_ms: int, reduced: bool) -> int:
	if not KINDS.has(kind):
		return 0
	var spec: Dictionary = KINDS[kind]
	if reduced:
		return int(spec.freeze)
	@warning_ignore("integer_division")
	return (now_ms / int(spec.frame_ms)) % int(spec.cells)

## Fatias da faixa ao longo do trajeto, em tiles: [{d0, d1, x, w}] com as pontas de largura fixa e o miolo esticado. Se o trajeto é curto
## demais para as duas pontas, elas encolhem juntas (como a BeamNode).
static func lane_slices(length: float, half_width: float) -> Array:
	var tiles_per_px := (2.0 * half_width) / LANE_BAND_PX
	var cap_l := CAP_L.y * tiles_per_px
	var cap_r := CAP_R.y * tiles_per_px
	if length < cap_l + cap_r and cap_l + cap_r > 0.0:
		var shrink := length / (cap_l + cap_r)
		cap_l *= shrink
		cap_r *= shrink
	var mid := maxf(0.0, length - cap_l - cap_r)
	return [
		{"d0": 0.0, "d1": cap_l, "x": CAP_L.x, "w": CAP_L.y},
		{"d0": cap_l, "d1": cap_l + mid, "x": CAP_M.x, "w": CAP_M.y},
		{"d0": cap_l + mid, "d1": cap_l + mid + cap_r, "x": CAP_R.x, "w": CAP_R.y},
	]

# ------------------------------------------------------------------ fila de comandos do quadro

func reset() -> void:
	_cmds.clear()

func flush() -> void:
	queue_redraw()

## Faixa no chão: `origin` e `dir` (unitário) em tiles, `length` e `half_width` em tiles.
## `fill` (0 a 1) é o progresso do aviso: o feixe inteiro fica fraco e a parte já carregada, do início até `fill`, fica forte, com a ponta em arte.
func lane(origin: Vector2, dir: Vector2, length: float, half_width: float, color: Color, frame: int, fill: float = 0.0) -> void:
	_cmds.append({"k": "lane", "origin": origin, "dir": dir, "length": length, "half_width": half_width, "color": color, "frame": frame, "fill": fill})

## Mira em tela: de `a` (atirador) a `b` (ponto final, já com a elevação do tiro).
func aim(a: Vector2, b: Vector2, progress: float, color: Color, frame: int) -> void:
	_cmds.append({"k": "aim", "a": a, "b": b, "progress": progress, "color": color, "frame": frame})

## Círculo no chão: centro em tiles e raio em tiles.
func ring(pos: Vector2, radius: float, color: Color, frame: int) -> void:
	_cmds.append({"k": "ring", "pos": pos, "radius": radius, "color": color, "frame": frame})

func command_count() -> int:
	return _cmds.size()

# ------------------------------------------------------------------ desenho

func _draw() -> void:
	for c in _cmds:
		match String(c.k):
			"lane":
				_draw_lane(c)
			"aim":
				_draw_aim(c)
			"ring":
				_draw_ring(c)

func _draw_lane(c: Dictionary) -> void:
	var texture := texture_for("faixa")
	if texture == null:
		return
	var tex_w := float(texture.get_width())
	var dir: Vector2 = c.dir
	var side := Vector2(-dir.y, dir.x)
	var origin: Vector2 = c.origin
	var half: float = c.half_width
	var lateral := CELL * 0.5 * (2.0 * half / LANE_BAND_PX)
	var color: Color = c.color
	var fill := clampf(float(c.fill), 0.0, 1.0)
	var length: float = c.length
	# Feixe inteiro mais fraco (o trajeto todo) e, por cima, a parte já carregada com a cor cheia: o feixe se enche até o golpe.
	_draw_lane_pass(texture, tex_w, origin, dir, side, lateral, length, half, int(c.frame), Color(color, color.a * (0.65 if fill > 0.0 else 1.0)))
	if fill > 0.0:
		_draw_lane_pass(texture, tex_w, origin, dir, side, lateral, length * fill, half, int(c.frame), color)
	# Eixo luminoso do feixe: um fio fino no centro, mais forte na parte carregada.
	var tip := origin + dir * length
	var charged := origin + dir * length * fill
	draw_line(Iso.to_screen(origin), Iso.to_screen(tip), Color(color, color.a * 0.3), 1.6)
	if fill > 0.0:
		draw_line(Iso.to_screen(origin), Iso.to_screen(charged), Color(color.lerp(Color.WHITE, 0.2), color.a * 0.55), 2.0)

func _draw_lane_pass(texture: Texture2D, tex_w: float, origin: Vector2, dir: Vector2, side: Vector2, lateral: float, length: float, half: float, frame: int, color: Color) -> void:
	var colors := PackedColorArray([color, color, color, color])
	for s in lane_slices(length, half):
		if float(s.d1) - float(s.d0) < 0.001:
			continue
		var u0 := (float(frame) * CELL + float(s.x)) / tex_w
		var u1 := (float(frame) * CELL + float(s.x) + float(s.w)) / tex_w
		var points := PackedVector2Array([
			Iso.to_screen(origin + dir * float(s.d0) - side * lateral), Iso.to_screen(origin + dir * float(s.d1) - side * lateral),
			Iso.to_screen(origin + dir * float(s.d1) + side * lateral), Iso.to_screen(origin + dir * float(s.d0) + side * lateral)])
		draw_polygon(points, colors, PackedVector2Array([Vector2(u0, 0.0), Vector2(u1, 0.0), Vector2(u1, 1.0), Vector2(u0, 1.0)]), texture)

func _draw_aim(c: Dictionary) -> void:
	var texture := texture_for("mira")
	if texture == null:
		return
	var a: Vector2 = c.a
	var b: Vector2 = c.b
	var length := a.distance_to(b)
	if length < 1.0:
		return
	var k := AIM_K
	var tail_px := CAP_R.x + CAP_R.y - RETICLE_X
	var caps := (CAP_L.y + CAP_R.y) * k
	if length + tail_px * k < caps:
		k *= (length + tail_px * k) / caps
	var span := length + tail_px * k
	var height := CELL * k
	var cap_left := CAP_L.y * k
	var cap_right := CAP_R.y * k
	var mid_width := maxf(0.0, span - cap_left - cap_right)
	var x0 := float(c.frame) * CELL
	var color: Color = c.color
	var close := lerpf(AIM_CLOSE_FROM, AIM_CLOSE_TO, clampf(float(c.progress), 0.0, 1.0))
	draw_set_transform(a, (b - a).angle(), Vector2.ONE)
	draw_texture_rect_region(texture, Rect2(0.0, -height * 0.5, cap_left, height), Rect2(x0 + CAP_L.x, 0.0, CAP_L.y, CELL), color)
	draw_texture_rect_region(texture, Rect2(cap_left, -height * 0.5, mid_width, height), Rect2(x0 + CAP_M.x, 0.0, CAP_M.y, CELL), color)
	var rw := cap_right * close
	var rh := height * close
	var center_x := cap_left + mid_width + cap_right * 0.5
	var reticle := Rect2(center_x - rw * 0.5, -rh * 0.5, rw, rh)
	var reticle_src := Rect2(x0 + CAP_R.x, 0.0, CAP_R.y, CELL)
	draw_texture_rect_region(texture, reticle, reticle_src, color)
	draw_texture_rect_region(texture, reticle, reticle_src, color)   # os traços finos da mira ficam fracos em escala 0,5: somar duas vezes dá a nitidez do desenho por código
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_ring(c: Dictionary) -> void:
	var texture := texture_for("area")
	if texture == null:
		return
	var pos: Vector2 = c.pos
	var radius: float = c.radius
	var origin := Iso.to_screen(pos)
	var ex := Iso.to_screen(pos + Vector2(radius, 0.0)) - origin
	var ey := Iso.to_screen(pos + Vector2(0.0, radius)) - origin
	draw_set_transform_matrix(Transform2D(ex / RING_R, ey / RING_R, origin))
	draw_texture_rect_region(texture, Rect2(-CELL * 0.5, -CELL * 0.5, CELL, CELL), Rect2(float(c.frame) * CELL, 0.0, CELL, CELL), c.color)
	draw_set_transform_matrix(Transform2D.IDENTITY)
