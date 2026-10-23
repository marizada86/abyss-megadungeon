class_name HudArt
extends RefCounted
## Arte do HUD da run (lote U12–U21, DRAFT visualmente aceito): painel do herói, barras, chips, cronômetro, botões, lista de armas,
## anel da habilidade e molduras de modal/tooltip. Cada peça é opcional: sem o arquivo, o consumer mantém o desenho de antes.

const DIR := "res://assets/ui/hud/"
const MODAL_DIR := "res://assets/ui/modal/"
static var _cache := {}

static func tex(path: String) -> Texture2D:
	if not _cache.has(path):
		_cache[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
	return _cache[path]

static func hud(name: String) -> Texture2D:
	return tex(DIR + name + ".png")

## Nove fatias com margens (esq, dir, topo, base) e margens de conteúdo; null sem a arte.
static func frame(texture: Texture2D, margins: Array, content: Array = [], modulate: Color = Color.WHITE) -> StyleBoxTexture:
	if texture == null:
		return null
	var sb := StyleBoxTexture.new()
	sb.texture = texture
	sb.texture_margin_left = float(margins[0])
	sb.texture_margin_right = float(margins[1])
	sb.texture_margin_top = float(margins[2])
	sb.texture_margin_bottom = float(margins[3])
	if content.size() == 4:
		sb.content_margin_left = float(content[0])
		sb.content_margin_right = float(content[1])
		sb.content_margin_top = float(content[2])
		sb.content_margin_bottom = float(content[3])
	sb.modulate_color = modulate
	return sb

## Cronômetro e botões de topo.
static func style_timer(label: Label) -> void:
	var sb := frame(hud("hud_cronometro"), [44, 44, 22, 22], [50, 50, 14, 14])
	if sb != null:
		label.add_theme_stylebox_override("normal", sb)
		label.custom_minimum_size = Vector2(190, 62)
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

static func style_square_button(btn: Button, art_name: String) -> void:
	var t := hud(art_name)
	if t == null:
		return
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var sb := frame(t, [18, 18, 18, 18], [8, 8, 6, 6])
		if state == "hover" or state == "focus":
			sb.modulate_color = Color(1.25, 1.2, 1.05)
		elif state == "pressed":
			sb.modulate_color = Color(0.8, 0.8, 0.8)
		btn.add_theme_stylebox_override(state, sb)
	btn.add_theme_color_override("font_color", Color(0.95, 0.82, 0.45))

static func style_weapon_list(label: Label) -> void:
	var sb := frame(hud("hud_lista_armas"), [26, 26, 12, 12], [34, 30, 12, 12], Color(1, 1, 1, 0.82))
	if sb != null:
		label.add_theme_stylebox_override("normal", sb)

## Barra com caixilho: o ProgressBar ganha o preenchimento de arte e um quadro por cima (NinePatchRect filho).
static func style_bar(bar: ProgressBar, frame_name: String, fill_name: String, frame_margins: Array, overshoot := 0.0) -> void:
	var frame_tex := hud(frame_name)
	var fill_tex := hud(fill_name)
	if frame_tex == null or fill_tex == null:
		return
	var fill := frame(fill_tex, [6, 6, 0, 0])
	bar.add_theme_stylebox_override("fill", fill)
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0.07, 0.03, 0.04, 0.8)
	bar.add_theme_stylebox_override("background", back)
	if bar.has_node("ArtFrame"):
		return
	var rect := NinePatchRect.new()
	rect.name = "ArtFrame"
	rect.texture = frame_tex
	rect.patch_margin_left = int(frame_margins[0])
	rect.patch_margin_right = int(frame_margins[1])
	rect.patch_margin_top = int(frame_margins[2])
	rect.patch_margin_bottom = int(frame_margins[3])
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(rect)
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.offset_left = -overshoot
	rect.offset_right = overshoot

## Chip de valor com o ícone embutido na arte (moedas, abates, CA, CAM).
static func chip_style(kind: String) -> StyleBoxTexture:
	var name := {"coin": "hud_chip_moedas", "kill": "hud_chip_abates", "ca": "hud_chip_ca", "cam": "hud_chip_cam"}.get(kind, "") as String
	if name == "":
		return null
	return frame(hud(name), [46, 22, 12, 12], [44, 14, 3, 5])

## Moldura de modal (reviver, resultado, confirmação) e de dica de detalhe.
static func modal_style(tooltip := false) -> StyleBoxTexture:
	var t := tex(MODAL_DIR + ("tooltip_moldura.png" if tooltip else "modal_moldura.png"))
	if t == null:
		return null
	var m := 30 if tooltip else 46
	return frame(t, [m, m, m, m], [m + 8, m + 8, m, m], Color(1, 1, 1, 0.97))
