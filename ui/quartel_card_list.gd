extends ItemList
## Q02/Q03: apresentação em cartões; ItemList conserva seleção, rolagem e input nativos.

@export_enum("heroi", "fase") var card_kind := "heroi"

const THUMB_DIR := "res://assets/ui/quartel/thumbs/%s_%s.png"
# Geometria da arte (360 px de largura): altura do cartão, janela da miniatura, painel de texto
# e margens do nine-patch (esquerda/direita) que preservam janela e ornamentos sem distorcer.
const CARD_HEIGHT := {"heroi": 72, "fase": 88}
const WINDOW := {"heroi": Rect2(15, 15, 47, 43), "fase": Rect2(13, 23, 64, 44)}
const TEXT_BOX := {"heroi": Rect2(78, 16, 0, 40), "fase": Rect2(128, 22, 0, 44)}
const PATCH := {"heroi": [100, 80], "fase": [128, 80]}
const CARD_ART := {"heroi": "heroi_cartao", "fase": "fase_cartao_medalha"}   # sem o oval: a medalha tem encaixe próprio
const MEDAL_CENTER := Vector2(97, 44)
const MEDAL_SIZE := 48.0   # quadrado da textura; o desenho útil (71x92 de 96) fica com ~46 px de altura
const SOCKET_RADIUS := 19.0
const NAME_SIZES := [16, 14, 12]
const LABEL_SIZE := 11

var _art_layer: Control
var _styles := {}

func _ready() -> void:
	max_columns = 1
	clip_contents = true
	allow_reselect = true
	fixed_icon_size = Vector2i(48, 72) if card_kind == "heroi" else Vector2i(80, 88)
	add_theme_constant_override("v_separation", 8)
	_art_layer = Control.new()
	_art_layer.name = "CardArt"
	_art_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_art_layer)
	_art_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_art_layer.draw.connect(_draw_cards)
	draw.connect(_art_layer.queue_redraw)
	get_v_scroll_bar().value_changed.connect(func(_value): _art_layer.queue_redraw())
	for sig in [focus_entered, focus_exited, resized]:
		sig.connect(_art_layer.queue_redraw)

func refresh_card_art() -> void:
	# O conteúdo nativo continua disponível para seleção/acessibilidade, mas só a
	# camada de arte o desenha: o interior dos PNGs é parcialmente transparente.
	for color_name in ["font_color", "font_selected_color", "font_hovered_color", "font_hovered_selected_color", "font_outline_color"]:
		add_theme_color_override(color_name, Color.TRANSPARENT)
	add_theme_constant_override("outline_size", 0)
	for i in item_count:
		set_item_icon_modulate(i, Color.TRANSPARENT)
	for state in ["selected", "selected_focus", "hovered", "hovered_selected"]:
		add_theme_stylebox_override(state, StyleBoxEmpty.new())
	_art_layer.queue_redraw()

func _card_style() -> StyleBox:
	if not _styles.has("card"):
		var texture := HudArt.tex("res://assets/ui/quartel/%s.png" % CARD_ART[card_kind])
		if texture == null:
			_styles["card"] = null
		else:
			var style := StyleBoxTexture.new()
			style.texture = texture
			style.texture_margin_left = PATCH[card_kind][0]
			style.texture_margin_right = PATCH[card_kind][1]
			_styles["card"] = style
	return _styles["card"]

func _thumb(i: int, icon: Texture2D) -> Texture2D:
	var id := String(get_item_metadata(i))
	var path := THUMB_DIR % [card_kind, id]
	var thumb := HudArt.tex(path) if id != "" else null
	return thumb if thumb != null else icon

func _fit_name(font: Font, text: String, width: float, max_height: float) -> int:
	for font_size in NAME_SIZES:
		if font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, width, font_size).y <= max_height:
			return font_size
	return NAME_SIZES[-1]

func _draw_cards() -> void:
	var font := get_theme_font("font")
	var scroll := get_v_scroll_bar()
	var frame := get_theme_stylebox("panel")
	var card_h := float(CARD_HEIGHT[card_kind])
	for i in item_count:
		var r := get_item_rect(i)
		r.position += frame.get_offset() - Vector2(0, scroll.value)
		r.position.x = frame.get_margin(SIDE_LEFT)
		r.size.x = size.x - r.position.x - frame.get_margin(SIDE_RIGHT) - (scroll.size.x if scroll.visible else 0.0)
		if r.end.y < 0 or r.position.y > size.y:
			continue
		# Cartão na altura nativa (sem esticar ornamentos), centralizado na linha do item.
		r = Rect2(r.position + Vector2(0, (r.size.y - card_h) * 0.5), Vector2(r.size.x, card_h))
		var locked := get_item_text(i).begins_with("🔒 ")
		var window: Rect2 = WINDOW[card_kind]
		window.position += r.position
		var thumb := _thumb(i, get_item_icon(i))
		if thumb != null:
			# Por baixo do cartão: a moldura cobre a emenda da janela transparente.
			_art_layer.draw_texture_rect(thumb, window.grow(2), false, Color(0.5, 0.5, 0.55) if locked else Color.WHITE)
		var style := _card_style()
		if style != null:
			_art_layer.draw_style_box(style, r)
		else:
			_art_layer.draw_rect(r, Color(0.06, 0.05, 0.08, 0.98))
		if card_kind == "fase":
			_draw_medal(r, i, locked)
		if locked:
			_art_layer.draw_rect(r.grow(-4), Color(0, 0, 0, 0.3))
		if is_selected(i):
			_art_layer.draw_rect(r.grow(-3), Color(1, 0.82, 0.36, 0.14))
			_art_layer.draw_rect(r.grow(-3), Color(1, 0.84, 0.4) if has_focus() else Color(0.7, 0.6, 0.4), false, 2.0 if has_focus() else 1.0)
		_draw_label(font, r, get_item_text(i).trim_prefix("🔒 "), locked)

## Medalha de progresso da fase no encaixe do cartão: a maior conquistada, "especial" para a run sem dano.
## Sem medalha ainda, um aro apagado marca o lugar.
func _draw_medal(r: Rect2, i: int, locked: bool) -> void:
	var medal := "bloqueada" if locked else Game.profile.stage_medal(String(get_item_metadata(i)))
	var center := r.position + MEDAL_CENTER
	var texture := HudArt.tex("res://assets/ui/quartel/medalhas/%s.png" % medal) if medal != "" else null
	if texture == null:
		_art_layer.draw_arc(center, SOCKET_RADIUS, 0.0, TAU, 40, Color(0.55, 0.43, 0.22, 0.55), 1.5, true)
		return
	_art_layer.draw_texture_rect(texture, Rect2(center - Vector2.ONE * MEDAL_SIZE * 0.5, Vector2.ONE * MEDAL_SIZE), false)

func _draw_label(font: Font, r: Rect2, name_text: String, locked: bool) -> void:
	var box: Rect2 = TEXT_BOX[card_kind]
	var left := r.position.x + box.position.x
	var text_width := maxf(20.0, r.end.x - left - 22.0)
	var label_height := (font.get_height(LABEL_SIZE) + 2.0) if locked else 0.0
	var font_size := _fit_name(font, name_text, text_width, box.size.y - label_height)
	var name_height := font.get_multiline_string_size(name_text, HORIZONTAL_ALIGNMENT_LEFT, text_width, font_size).y
	# Bloco (nome + selo) centralizado no painel, sem tocar as molduras do cartão.
	var top := r.position.y + box.position.y + (box.size.y - name_height - label_height) * 0.5
	var name_color := Color(0.74, 0.72, 0.7) if locked else Color(0.97, 0.91, 0.76)
	_art_layer.draw_multiline_string(font, Vector2(left, top + font.get_ascent(font_size)), name_text, HORIZONTAL_ALIGNMENT_LEFT, text_width, font_size, -1, name_color)
	if locked:
		_art_layer.draw_string(font, Vector2(left, top + name_height + 2.0 + font.get_ascent(LABEL_SIZE)), "BLOQUEADO", HORIZONTAL_ALIGNMENT_LEFT, text_width, LABEL_SIZE, Color(0.75, 0.6, 0.4))
