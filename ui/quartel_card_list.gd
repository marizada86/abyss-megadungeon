extends ItemList
## Q02/Q03: apresentação em cartões; ItemList conserva seleção, rolagem e input nativos.

@export_enum("heroi", "fase") var card_kind := "heroi"
var _art_layer: Control

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

func _draw_cards() -> void:
	var font := get_theme_font("font")
	var scroll := get_v_scroll_bar()
	var frame := get_theme_stylebox("panel")
	for i in item_count:
		var r := get_item_rect(i)
		r.position += frame.get_offset() - Vector2(0, scroll.value)
		r.position.x = frame.get_margin(SIDE_LEFT)
		r.size.x = size.x - r.position.x - frame.get_margin(SIDE_RIGHT) - (scroll.size.x if scroll.visible else 0.0)
		if r.end.y < 0 or r.position.y > size.y:
			continue
		var locked := get_item_text(i).begins_with("🔒 ")
		var texture := HudArt.tex("res://assets/ui/quartel/%s_cartao%s.png" % [card_kind, "_bloqueado" if locked else ""])
		if texture != null:
			_art_layer.draw_texture_rect(texture, r, false)
		else:
			_art_layer.draw_rect(r, Color(0.06, 0.05, 0.08, 0.98))
		if is_selected(i):
			_art_layer.draw_rect(r.grow(-3), Color(1, 0.82, 0.36, 0.14))
			_art_layer.draw_rect(r.grow(-3), Color(1, 0.84, 0.4) if has_focus() else Color(0.7, 0.6, 0.4), false, 2.0 if has_focus() else 1.0)
		var icon := get_item_icon(i)
		var icon_size := Vector2(46, 46) if card_kind == "heroi" else Vector2(70, 48)
		var icon_rect := Rect2(r.position + Vector2(10, (r.size.y - icon_size.y) * 0.5), icon_size)
		if card_kind == "heroi":
			var plate := HudArt.tex("res://assets/ui/quartel/heroi_placa.png")
			if plate != null:
				_art_layer.draw_texture_rect(plate, icon_rect.grow(5), false)
		if icon != null:
			var fit := icon.get_size() * minf(icon_size.x / icon.get_width(), icon_size.y / icon.get_height())
			_art_layer.draw_texture_rect(icon, Rect2(icon_rect.get_center() - fit * 0.5, fit), false, Color(0.65, 0.65, 0.65) if locked else Color.WHITE)
		var left := r.position.x + (70.0 if card_kind == "heroi" else 110.0)
		var name_text := get_item_text(i).trim_prefix("🔒 ")
		var name_color := Color(0.74, 0.72, 0.7) if locked else Color(0.97, 0.91, 0.76)
		var text_width := maxf(20.0, r.end.x - left - 14.0)
		_art_layer.draw_multiline_string(font, Vector2(left, r.position.y + 30), name_text, HORIZONTAL_ALIGNMENT_LEFT, text_width, 16, 2, name_color)
		if locked:
			_art_layer.draw_string(font, Vector2(left, r.end.y - 14), "BLOQUEADO", HORIZONTAL_ALIGNMENT_LEFT, text_width, 11, Color(0.75, 0.6, 0.4))
