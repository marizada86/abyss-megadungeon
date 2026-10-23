class_name OfferCard
extends Button
## MEC-027: cartão de oferta resumido. Mostra nome, 1 linha de destaque, selo de veredito e preço;
## o detalhe (tabela novo × atual × diferença, rodapé) vem no tooltip customizado ao passar o mouse.

const COLOR_UP := Color(0.55, 0.9, 0.55)
const COLOR_DOWN := Color(1.0, 0.5, 0.45)
const COLOR_NEUTRAL := Color(0.7, 0.7, 0.7)
const COLOR_PRICE := Color(1.0, 0.9, 0.5)

var offer: Dictionary = {}

func setup(index: int, o: Dictionary, name_color: Color, icon_tex: Texture2D) -> void:
	offer = o
	custom_minimum_size = Vector2(680, 64)
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 8 if side in ["left", "right"] else 4)
	add_child(margin)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 10)
	margin.add_child(row)
	if icon_tex != null:
		var icon := TextureRect.new()
		icon.texture = icon_tex
		icon.custom_minimum_size = Vector2(44, 44)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.alignment = BoxContainer.ALIGNMENT_CENTER
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left)
	# O `role` da oferta (synergy, defense, direction) só serve para montar as opções; não aparece no cartão: o nome vem primeiro.
	var title := String(o.name)
	if String(o.get("price_text", "")) != "" and title.find(" — ") >= 0:
		title = title.substr(0, title.rfind(" — "))
	left.add_child(_label("%d.  %s" % [index + 1, title], 19, name_color))
	var brief := _label(String(o.get("brief", "")), 16, Color(0.88, 0.88, 0.88))
	brief.clip_text = true
	left.add_child(brief)
	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_CENTER
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(right)
	var badge_row := _badge(o.get("badge", null))
	if badge_row != null:
		right.add_child(badge_row)
	var price := String(o.get("price_text", ""))
	if price != "":
		var pl := _label(price, 16, COLOR_PRICE)
		pl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right.add_child(pl)
	if _has_detail(o) or String(o.get("tooltip", "")) != "":
		tooltip_text = " "

# ------------------------------------------------------------------ modo cartão vertical (placeholder em código)
## Cartão vertical para nível, altar, lojas e item de baú. O visual é desenhado em código (StyleBoxFlat + ornamentos) e
## troca por arte quando existirem os arquivos de res://assets/ui/oferta/ (ver ASSET-GENERATION-LIST, lote U):
## `oferta_cartao.png` (280×400, nove fatias com margem 28) e `oferta_placa_icone.png` (96×96). Sem eles, valem os placeholders.
## Com 5 ofertas ou mais o HUD usa a versão compacta (264×196, ícone à esquerda) em duas fileiras.

const CARD_SIZE := Vector2(264, 396)
const COMPACT_SIZE := Vector2(264, 222)
const ART_DIR := "res://assets/ui/oferta/"
const GOLD := Color(0.93, 0.78, 0.4)
const RARITY_GEM := {"comum": Color(0.62, 0.62, 0.66), "magico": Color(0.35, 0.6, 1.0), "incomum": Color(0.4, 0.85, 0.5), "raro": Color(1.0, 0.7, 0.25), "unico": Color(0.78, 0.45, 1.0)}
const SLOT_LABELS := {"arma": "Arma", "armadura": "Armadura", "amuleto": "Amuleto", "anel": "Anel"}
## Por tipo de oferta: fita (vazia = sem fita), cor da fita, cor de destaque, categoria e glifo de reserva (sem ícone).
const KIND_STYLE := {
	"weapon_new": {"ribbon": "NOVA", "ribbon_col": Color(0.26, 0.58, 0.32), "accent": Color(0.55, 0.9, 0.55), "cat": "Arma"},
	"weapon_up": {"ribbon": "", "ribbon_col": Color(0.3, 0.45, 0.7), "accent": Color(0.6, 0.78, 1.0), "cat": "Arma"},
	"evolve": {"ribbon": "EVOLUI", "ribbon_col": Color(0.78, 0.56, 0.14), "accent": Color(1.0, 0.85, 0.3), "cat": "Evolução"},
	"synergy_activate": {"ribbon": "SINERGIA", "ribbon_col": Color(0.22, 0.42, 0.8), "accent": Color(0.5, 0.75, 1.0), "cat": "Sinergia"},
	"passive": {"ribbon": "", "ribbon_col": Color(0.26, 0.58, 0.32), "accent": Color(0.88, 0.76, 0.5), "cat": "Passiva"},
	"boon": {"ribbon": "BÊNÇÃO", "ribbon_col": Color(0.5, 0.28, 0.7), "accent": Color(0.85, 0.6, 1.0), "cat": "Bênção"},
	"boon_skip": {"ribbon": "", "ribbon_col": Color(0.3, 0.3, 0.3), "accent": Color(0.6, 0.6, 0.6), "cat": "Recusar", "glyph": "✕"},
	"heal": {"ribbon": "", "ribbon_col": Color(0.6, 0.25, 0.25), "accent": Color(1.0, 0.55, 0.5), "cat": "Recurso"},
	"gold": {"ribbon": "", "ribbon_col": Color(0.6, 0.5, 0.2), "accent": Color(1.0, 0.9, 0.5), "cat": "Recurso"},
	"shop_item": {"ribbon": "", "ribbon_col": Color(0.6, 0.5, 0.2), "accent": Color(0.88, 0.76, 0.5), "cat": "Equipamento"},
	"shop_item_up": {"ribbon": "FORJA", "ribbon_col": Color(0.74, 0.4, 0.14), "accent": Color(1.0, 0.65, 0.3), "cat": "Forja"},
	"shop_weapon_up": {"ribbon": "FORJA", "ribbon_col": Color(0.74, 0.4, 0.14), "accent": Color(0.6, 0.78, 1.0), "cat": "Arma"},
	"shop_heal": {"ribbon": "CURA", "ribbon_col": Color(0.6, 0.25, 0.25), "accent": Color(1.0, 0.55, 0.5), "cat": "Curandeiro"},
	"shop_leave": {"ribbon": "", "ribbon_col": Color(0.3, 0.3, 0.3), "accent": Color(0.6, 0.6, 0.64), "cat": "Sair", "glyph": "↩"},
	"shop_info": {"ribbon": "", "ribbon_col": Color(0.3, 0.3, 0.3), "accent": Color(0.6, 0.6, 0.64), "cat": "Aviso", "glyph": "…"},
	"item_swap": {"ribbon": "", "ribbon_col": Color(0.26, 0.58, 0.32), "accent": Color(0.88, 0.76, 0.5), "cat": "Equipamento"},
	"donate": {"ribbon": "DOAR", "ribbon_col": Color(0.55, 0.25, 0.4), "accent": Color(0.9, 0.55, 0.7), "cat": "Doação"},
	"gamble": {"ribbon": "APOSTA", "ribbon_col": Color(0.6, 0.5, 0.2), "accent": Color(1.0, 0.9, 0.5), "cat": "Aposta"},
	"pact": {"ribbon": "PACTO", "ribbon_col": Color(0.5, 0.25, 0.4), "accent": Color(0.9, 0.6, 0.75), "cat": "Pacto"},
	"ev_choice": {"ribbon": "", "ribbon_col": Color(0.4, 0.3, 0.6), "accent": Color(0.8, 0.75, 1.0), "cat": "Evento"},
}
## Fita de arte por texto da fita; glifo de categoria por tipo de oferta (lote U, assets/ui/oferta).
const RIBBON_ART := {"NOVA": "fita_nova", "EQUIPAR": "fita_nova", "EVOLUI": "fita_evolui", "FORJA": "fita_evolui", "SINERGIA": "fita_sinergia", "MANTER": "fita_sinergia",
	"DOAR": "fita_maldicao", "APOSTA": "fita_maldicao", "CURA": "fita_maldicao", "PACTO": "fita_maldicao", "BÊNÇÃO": "fita_bencao"}
const GLYPH_ART := {"weapon_new": "glifo_arma", "weapon_up": "glifo_arma", "shop_weapon_up": "glifo_arma", "passive": "glifo_passiva", "evolve": "glifo_evolucao",
	"synergy_activate": "glifo_sinergia", "boon": "glifo_bencao", "shop_item": "glifo_equipamento", "shop_item_up": "glifo_equipamento", "item_swap": "glifo_equipamento",
	"donate": "glifo_maldicao", "gamble": "glifo_dado", "gold": "glifo_moeda", "shop_heal": "glifo_bencao", "heal": "glifo_bencao", "pact": "glifo_maldicao"}
const GEM_ART := {"comum": "gema_comum", "magico": "gema_magico", "incomum": "gema_incomum", "raro": "gema_raro", "unico": "gema_unico"}

## Cache obrigatório: o draw do cartão só enfileira o RID, e uma textura sem dono seria liberada antes de desenhar (quadrado branco).
static var _art_cache := {}

static func art(name: String) -> Texture2D:
	if _art_cache.has(name):
		return _art_cache[name]
	var path := ART_DIR + name + ".png"
	var tex: Texture2D = load(path) as Texture2D if ResourceLoader.exists(path) else null
	_art_cache[name] = tex
	return tex

const NAME_PREFIXES := ["NOVA: ", "★ EVOLUÇÃO: ", "SINERGIA: "]
## Fita: altura em tela e largura (px da arte) das pontas com os ornamentos, que não esticam.
const RIBBON_HEIGHT := 34.0
const RIBBON_HEIGHT_COMPACT := 24.0
const RIBBON_CAP := 56.0
## Janela do ícone no cartão vertical: a arte (`oferta_cartao`) tem a janela até ~y=190; o nome começa abaixo dela.
const WINDOW_SPACER := 18.0
## Tecla numérica do cartão vertical: altura e distância da borda de baixo (assenta sobre a moldura inferior da arte).
const KEY_HEIGHT := 24.0
const KEY_BOTTOM := 10.0

var index := 0
var compact := false
var _accent := GOLD
var _rarity := ""
var _glow: Control
var _selection_art: TextureRect
var _brief: Label
var _detail_view: Control

## Shift: troca o destaque pela tabela de comparação (só nos cartões que têm detalhe).
func show_detail(on: bool) -> void:
	if _detail_view == null or _brief == null:
		return
	_detail_view.visible = on
	_brief.visible = not on

func _ready() -> void:
	# raro e único respiram um brilho (placeholder do efeito que a arte final traz)
	var pulse: Control = _selection_art if _selection_art != null else _glow
	if pulse != null and (_rarity == "raro" or _rarity == "unico") and not Game.reduced_impact():
		var tw := pulse.create_tween().set_loops()
		tw.tween_property(pulse, "modulate:a", 0.55, 1.1).set_trans(Tween.TRANS_SINE)
		tw.tween_property(pulse, "modulate:a", 1.0, 1.1).set_trans(Tween.TRANS_SINE)

## Raridade da oferta (item novo, mantido ou comprado); "" quando não há item.
static func rarity_of(o: Dictionary) -> String:
	for source in [o, o.get("item", {}), o.get("keep", {})]:
		if source is Dictionary and String(source.get("rarity", "")) != "":
			return String(source.rarity)
	return ""

static func slot_of(o: Dictionary) -> String:
	for source in [o, o.get("item", {}), o.get("keep", {})]:
		if source is Dictionary and String(source.get("slot", "")) != "":
			return String(source.slot)
	return ""

## "Equipar Colar dos Tentáculos [Único]" vira "Colar dos Tentáculos"; devolve também a fita (EQUIPAR/MANTER).
static func _clean_item_title(title: String) -> Array:
	var ribbon := ""
	if title.begins_with("Equipar "):
		title = title.substr(8)
		ribbon = "EQUIPAR"
	elif title.begins_with("Manter "):
		title = title.substr(7)
		ribbon = "MANTER"
	elif title.begins_with("Doar "):
		title = title.substr(5)
	var br := title.rfind(" [")
	if br > 0 and title.ends_with("]"):
		title = title.substr(0, br)
	return [title, ribbon]

func setup_card(i: int, o: Dictionary, name_color: Color, icon_tex: Texture2D, width: float = CARD_SIZE.x, compact_mode := false) -> void:
	offer = o
	index = i
	compact = compact_mode
	var kind := String(o.get("t", ""))
	var style: Dictionary = KIND_STYLE.get(kind, {"ribbon": "", "ribbon_col": Color(0.4, 0.4, 0.4), "accent": name_color, "cat": ""})
	_accent = Color(style.accent)
	_rarity = rarity_of(o)
	if kind == "ev_choice" and RandomEvents.is_kind(String(o.get("ev", ""))):
		_accent = RandomEvents.color(String(o.ev))
	elif _rarity != "" and kind in ["shop_item", "shop_item_up", "item_swap", "donate"]:
		_accent = Items.rarity_color(_rarity)
	custom_minimum_size = Vector2(width, COMPACT_SIZE.y if compact else CARD_SIZE.y)
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	focus_mode = Control.FOCUS_ALL
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		add_theme_stylebox_override(state, _frame_style(state))
	# U09 tem fundo preto: adição remove o preto e fica abaixo do texto.
	var glow_texture := art("oferta_brilho")
	if glow_texture != null:
		_selection_art = TextureRect.new()
		_selection_art.name = "SelectionArt"
		_selection_art.texture = glow_texture
		_selection_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_selection_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var additive := CanvasItemMaterial.new()
		additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		_selection_art.material = additive
		add_child(_selection_art)
		_selection_art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		for sig in [focus_entered, focus_exited, mouse_entered, mouse_exited]:
			sig.connect(_update_selection_art)
		_update_selection_art()
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 36 if compact else 30)
	margin.add_theme_constant_override("margin_top", 28 if compact else 20)
	margin.add_theme_constant_override("margin_bottom", 30 if compact else 30)
	add_child(margin)
	var col := VBoxContainer.new()
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_theme_constant_override("separation", 4)
	margin.add_child(col)
	# nome sem os prefixos que viram fita; bênção "Deus: Nome" vira categoria + nome
	var title := String(o.name)
	if String(o.get("price_text", "")) != "" and title.find(" — ") >= 0:
		title = title.substr(0, title.rfind(" — "))
	var ribbon := String(style.ribbon)
	for prefix in NAME_PREFIXES:
		if title.begins_with(prefix):
			title = title.substr(prefix.length())
			if ribbon == "":
				ribbon = "NOVA"
	var category := String(style.cat)
	if kind == "boon" and title.find(": ") > 0:
		category = title.substr(0, title.find(": "))
		title = title.substr(title.find(": ") + 2)
	if kind in ["shop_item", "shop_item_up", "item_swap", "donate"]:
		var cleaned := _clean_item_title(title)
		title = String(cleaned[0])
		if String(cleaned[1]) != "":
			ribbon = String(cleaned[1])
		var slot_label := String(SLOT_LABELS.get(slot_of(o), ""))
		var rarity_name := Items.rarity_label(_rarity) if _rarity != "" else ""
		category = " · ".join([slot_label, rarity_name].filter(func(t): return t != "")) if (slot_label != "" or rarity_name != "") else category
	if category == title:
		category = ""   # "Sair" não precisa repetir o nome na categoria
	var arrow := title.find(" → Nv ")
	var level_chip := ""
	if arrow > 0:
		level_chip = "Nv %s" % title.substr(arrow + 6)
		title = title.substr(0, arrow)
	var glyph_text := String(style.get("glyph", "✦"))
	var badge := _badge(o.get("badge", null))
	if badge != null:
		(badge as HBoxContainer).alignment = BoxContainer.ALIGNMENT_CENTER
	var price := String(o.get("price_text", ""))
	var price_col := COLOR_DOWN if (bool(o.get("locked", false)) and int(o.get("price", 0)) > 0) else COLOR_PRICE
	if compact:
		_build_compact(col, title, category, ribbon, style, name_color, icon_tex, glyph_text, badge, level_chip, price, price_col, i, String(o.get("brief", "")))
	else:
		_build_full(col, title, category, ribbon, style, name_color, icon_tex, glyph_text, badge, level_chip, price, price_col, i, String(o.get("brief", "")))
	if _has_detail(o):
		_detail_view = build_detail(true, true)
		_detail_view.visible = false
		_detail_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
		_detail_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_brief.get_parent().add_child(_detail_view)
		_brief.get_parent().move_child(_detail_view, _brief.get_index() + 1)
	if _has_detail(o) or String(o.get("tooltip", "")) != "":
		tooltip_text = " "
	# ornamentos, gema e brilho de seleção por cima de tudo
	_glow = Control.new()
	_glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_glow.draw.connect(func(): _draw_ornaments(_glow))
	add_child(_glow)
	for sig in [focus_entered, focus_exited, mouse_entered, mouse_exited]:
		sig.connect(_glow.queue_redraw)

func _pill(text: String, col: Color) -> PanelContainer:
	var pill := PanelContainer.new()
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ribbon_tex := art(String(RIBBON_ART.get(text, "")))
	if ribbon_tex != null:
		# A fita (256×55) tem uma ponta de andorinha + dois ornamentos em cada extremidade. Em nove fatias com altura achatada
		# os ornamentos eram espremidos e o texto caía sobre eles: aqui as pontas mantêm a proporção e só o miolo liso estica.
		var ribbon_h := RIBBON_HEIGHT_COMPACT if compact else RIBBON_HEIGHT
		var cap := RIBBON_CAP * ribbon_h / ribbon_tex.get_height()
		pill.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		pill.custom_minimum_size = Vector2(0, ribbon_h)
		var strip := HBoxContainer.new()
		strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		strip.add_theme_constant_override("separation", 0)
		var width := float(ribbon_tex.get_width())
		for part in [Rect2(0, 0, RIBBON_CAP, ribbon_tex.get_height()), Rect2(RIBBON_CAP, 0, width - 2.0 * RIBBON_CAP, ribbon_tex.get_height()), Rect2(width - RIBBON_CAP, 0, RIBBON_CAP, ribbon_tex.get_height())]:
			var slice := AtlasTexture.new()
			slice.atlas = ribbon_tex
			slice.region = part
			var piece := TextureRect.new()
			piece.texture = slice
			piece.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			piece.stretch_mode = TextureRect.STRETCH_SCALE
			piece.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if part.size.x == RIBBON_CAP:
				piece.custom_minimum_size = Vector2(cap, ribbon_h)
			else:
				piece.custom_minimum_size = Vector2(0, ribbon_h)
				piece.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			strip.add_child(piece)
		pill.add_child(strip)
		var text_box := MarginContainer.new()
		text_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text_box.add_theme_constant_override("margin_left", int(cap) + 4)
		text_box.add_theme_constant_override("margin_right", int(cap) + 4)
		var ribbon_label := _label(text, 12 if compact else 14, Color(1, 1, 1))
		ribbon_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
		ribbon_label.add_theme_constant_override("outline_size", 3)
		ribbon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ribbon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		text_box.add_child(ribbon_label)
		pill.add_child(text_box)
		return pill
	var pill_style := StyleBoxFlat.new()
	pill_style.bg_color = col
	pill_style.border_color = col.lightened(0.35)
	pill_style.set_border_width_all(1)
	pill_style.corner_radius_top_left = 3
	pill_style.corner_radius_bottom_right = 3
	pill_style.content_margin_left = 12
	pill_style.content_margin_right = 12
	pill_style.content_margin_top = 1
	pill_style.content_margin_bottom = 1
	pill.add_theme_stylebox_override("panel", pill_style)
	pill.add_child(_label(text, 13, Color(1, 1, 1)))
	return pill

func _plate(icon_tex: Texture2D, plate_size: float, icon_size: float, glyph_text: String) -> PanelContainer:
	var plate := PanelContainer.new()
	plate.custom_minimum_size = Vector2(plate_size, plate_size)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_theme_stylebox_override("panel", _plate_style())
	if icon_tex != null:
		var icon := TextureRect.new()
		icon.texture = icon_tex
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(icon_size, icon_size)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		plate.add_child(icon)
	else:
		var glyph := _label(glyph_text, int(icon_size * 0.5), _accent)
		glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		plate.add_child(glyph)
	return plate

func _key_chip(i: int) -> CenterContainer:
	var key_row := CenterContainer.new()
	key_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var key := PanelContainer.new()
	key.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var key_style := UiKit.box(Color(0.05, 0.04, 0.07), Color(_accent.r, _accent.g, _accent.b, 0.7), 1, 4)
	key_style.content_margin_left = 12
	key_style.content_margin_right = 12
	key_style.content_margin_top = 1
	key_style.content_margin_bottom = 1
	key.add_theme_stylebox_override("panel", key_style)
	key.add_child(_label(str(i + 1), 15, GOLD))
	key_row.add_child(key)
	return key_row

## Selo + faixa de preço. Quebra em duas linhas quando não cabe: o texto longo ("vende Anel ...: 20") alargava a coluna e empurrava
## fita, ícone e preço para fora do centro da carta.
func _chips_row(badge: Control, level_chip: String, price: String, price_col: Color) -> FlowContainer:
	var chips := HFlowContainer.new()
	chips.alignment = FlowContainer.ALIGNMENT_CENTER
	chips.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chips.add_theme_constant_override("h_separation", 10)
	chips.add_theme_constant_override("v_separation", 2)
	chips.custom_minimum_size = Vector2(0, 26)
	if badge != null:
		chips.add_child(badge)
	elif level_chip != "":
		chips.add_child(_label(level_chip, 18, COLOR_UP))
	if price != "":
		var price_label := _label(price, 16, price_col)
		# A arte (160×48) tem 8 linhas transparentes em cima e embaixo e a tampa direita acaba em x=156: recorta o desenho
		# (região 157×32), senão a faixa escura fica espremida e o texto cai sobre as bordas douradas.
		var price_style := HudArt.frame(art("oferta_preco"), [24, 6, 6, 7], [28, 10, 5, 6])
		if price_style != null:
			price_style.region_rect = Rect2(0, 8, 157, 32)
			price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			price_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			var plate := PanelContainer.new()
			plate.name = "PricePlate"
			plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
			plate.custom_minimum_size = Vector2(120, 36)
			plate.add_theme_stylebox_override("panel", price_style)
			var split := price.rfind(": ")
			if split > 0:
				# "vende Nome Longo: 20": só o nome cede (reticências); o valor fica sempre visível e a faixa tem largura fixa
				plate.custom_minimum_size.x = 176.0
				price_label.text = price.substr(split)
				var name_label := _label(price.substr(0, split), 16, price_col)
				name_label.clip_text = true
				name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
				name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				var parts := HBoxContainer.new()
				parts.mouse_filter = Control.MOUSE_FILTER_IGNORE
				parts.add_theme_constant_override("separation", 0)
				parts.add_child(name_label)
				price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				parts.add_child(price_label)
				plate.add_child(parts)
			else:
				plate.add_child(price_label)
			chips.add_child(plate)
		else:
			chips.add_child(price_label)
	return chips

func _update_selection_art() -> void:
	if _selection_art == null:
		return
	var lit := has_focus() or is_hovered()
	_selection_art.visible = not disabled and (lit or _rarity in ["raro", "unico"])
	_selection_art.self_modulate = Color(1, 1, 1, 0.5 if lit else 0.18)

func _build_full(col: VBoxContainer, title: String, category: String, ribbon: String, style: Dictionary, name_color: Color, icon_tex: Texture2D, glyph_text: String, badge: Control, level_chip: String, price: String, price_col: Color, i: int, brief_text: String) -> void:
	# fita (a linha é sempre reservada, para os cartões alinharem)
	var ribbon_row := CenterContainer.new()
	ribbon_row.custom_minimum_size = Vector2(0, RIBBON_HEIGHT)
	ribbon_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(ribbon_row)
	if ribbon != "":
		ribbon_row.add_child(_pill(ribbon, Color(style.ribbon_col)))
	var plate_row := CenterContainer.new()
	plate_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(plate_row)
	plate_row.add_child(_plate(icon_tex, 104.0, 86.0, glyph_text))
	if art("oferta_cartao") != null:
		var below_window := Control.new()   # a janela da arte acaba abaixo da placa: o nome não pode invadir a moldura
		below_window.custom_minimum_size = Vector2(0, WINDOW_SPACER)
		below_window.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(below_window)
	var name_label := _label(title, 20, name_color if _rarity == "" else _accent)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.custom_minimum_size = Vector2(0, 46)
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	col.add_child(name_label)
	var cat_label := _label(category, 14, Color(_accent.r, _accent.g, _accent.b, 0.85))
	cat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var glyph_tex := art(String(GLYPH_ART.get(String(offer.get("t", "")), "")))
	if glyph_tex != null and category != "":
		var cat_row := HBoxContainer.new()
		cat_row.alignment = BoxContainer.ALIGNMENT_CENTER
		cat_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat_row.add_theme_constant_override("separation", 6)
		var glyph_icon := TextureRect.new()
		glyph_icon.texture = glyph_tex
		glyph_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		glyph_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		glyph_icon.custom_minimum_size = Vector2(22, 22)
		glyph_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat_row.add_child(glyph_icon)
		cat_row.add_child(cat_label)
		col.add_child(cat_row)
	else:
		col.add_child(cat_label)
	var rule := ColorRect.new()
	rule.color = Color(_accent.r, _accent.g, _accent.b, 0.35)
	rule.custom_minimum_size = Vector2(0, 1)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(rule)
	var brief := _label(brief_text, 16, Color(0.9, 0.9, 0.9))
	brief.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	brief.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	brief.size_flags_vertical = Control.SIZE_EXPAND_FILL
	brief.max_lines_visible = 3
	brief.clip_text = true   # sem isto o texto longo empurra preço e tecla para fora do cartão
	brief.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	col.add_child(brief)
	_brief = brief
	col.add_child(_chips_row(badge, level_chip, price, price_col))
	# A tecla fica presa à base do cartão, sobre a moldura de baixo: posição fixa em todos, sem depender do conteúdo.
	var key := _key_chip(i)
	add_child(key)
	key.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	key.offset_top = -(KEY_BOTTOM + KEY_HEIGHT)
	key.offset_bottom = -KEY_BOTTOM

## Versão baixa (5+ ofertas): ícone à esquerda, texto à direita, números e tecla na base.
func _build_compact(col: VBoxContainer, title: String, category: String, ribbon: String, style: Dictionary, name_color: Color, icon_tex: Texture2D, glyph_text: String, badge: Control, level_chip: String, price: String, price_col: Color, i: int, brief_text: String) -> void:
	var top := HBoxContainer.new()
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_theme_constant_override("separation", 10)
	top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(top)
	var plate_col := VBoxContainer.new()
	plate_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate_col.add_child(_plate(icon_tex, 76.0, 60.0, glyph_text))
	if ribbon != "":
		var rb := CenterContainer.new()
		rb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rb.add_child(_pill(ribbon, Color(style.ribbon_col)))
		plate_col.add_child(rb)
	top.add_child(plate_col)
	var text_col := VBoxContainer.new()
	text_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_col.add_theme_constant_override("separation", 2)
	top.add_child(text_col)
	var name_label := _label(title, 17, name_color if _rarity == "" else _accent)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.max_lines_visible = 2
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	text_col.add_child(name_label)
	var category_label := _label(category, 13, Color(_accent.r, _accent.g, _accent.b, 0.85))
	category_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	category_label.max_lines_visible = 2
	category_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	text_col.add_child(category_label)
	var brief := _label(brief_text, 13, Color(0.9, 0.9, 0.9))
	brief.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	brief.max_lines_visible = 3
	brief.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	brief.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_col.add_child(brief)
	_brief = brief
	var base := HBoxContainer.new()
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	base.add_theme_constant_override("separation", 8)
	var chips := _chips_row(badge, level_chip, price, price_col)
	chips.alignment = FlowContainer.ALIGNMENT_BEGIN
	chips.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	base.add_child(chips)
	base.add_child(_key_chip(i))
	col.add_child(base)

func _frame_style(state: String) -> StyleBox:
	var frame_tex := art("oferta_cartao_compacto" if compact else "oferta_cartao")
	if frame_tex != null:
		var tex_style := StyleBoxTexture.new()
		tex_style.texture = frame_tex
		for edge in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			tex_style.set_texture_margin(edge, 36 if compact else 40)
		tex_style.modulate_color = {"normal": Color(1, 1, 1), "hover": Color(1.15, 1.12, 1.05), "pressed": Color(0.8, 0.8, 0.8), "focus": Color(1.2, 1.15, 1.0), "disabled": Color(0.55, 0.55, 0.55)}[state]
		return tex_style
	var bg: Color = {"normal": Color(0.085, 0.07, 0.105), "hover": Color(0.12, 0.1, 0.145), "pressed": Color(0.06, 0.05, 0.08), "focus": Color(0.115, 0.095, 0.14), "disabled": Color(0.07, 0.065, 0.08)}[state]
	var border := _accent.darkened(0.45 if _rarity == "" else 0.2)
	var width := 3
	if state == "hover" or state == "focus":
		border = GOLD
		width = 4
	if state == "disabled":
		border = Color(0.3, 0.3, 0.33)
	var box := UiKit.box(bg, border, width, 8)
	box.shadow_color = Color(0, 0, 0, 0.55)
	box.shadow_size = 8
	if _rarity in ["raro", "unico"] and state != "disabled":
		box.shadow_color = Color(_accent.r, _accent.g, _accent.b, 0.45)   # aura de raridade
		box.shadow_size = 12
	return box

func _plate_style() -> StyleBox:
	var plate_tex := art("oferta_placa_icone")
	if plate_tex != null and art("oferta_cartao") != null and not compact:
		var window_style := StyleBoxEmpty.new()   # o cartão já tem a janela do ícone no desenho
		for edge in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			window_style.set_content_margin(edge, 6)
		return window_style
	if plate_tex != null:
		var tex_style := StyleBoxTexture.new()
		tex_style.texture = plate_tex
		for edge in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			tex_style.set_texture_margin(edge, 22)
			tex_style.set_content_margin(edge, 9 if compact else 12)
		if _rarity != "":
			tex_style.modulate_color = Color.WHITE.lerp(_accent, 0.55)   # a moldura dourada pega a cor da raridade
		return tex_style
	var plate_bg := Color(0.035, 0.03, 0.055)
	if _rarity != "":
		plate_bg = plate_bg.lerp(_accent, 0.12)   # fundo da placa tingido pela raridade
	var box := UiKit.box(plate_bg, _accent.darkened(0.2) if _rarity == "" else _accent, 2 if _rarity == "" else 3, 6)
	var pad := 6 if compact else 8
	box.content_margin_left = pad
	box.content_margin_right = pad
	box.content_margin_top = pad
	box.content_margin_bottom = pad
	return box

func _draw_ornaments(g: Control) -> void:
	var r := Rect2(Vector2.ZERO, g.size)
	var lit := has_focus() or is_hovered()
	var tone := GOLD if lit else _accent.darkened(0.15)
	# filete interno
	var inner := r.grow(-7.0)
	g.draw_polyline(PackedVector2Array([inner.position, Vector2(inner.end.x, inner.position.y), inner.end, Vector2(inner.position.x, inner.end.y), inner.position]), Color(tone.r, tone.g, tone.b, 0.45), 1.0)
	# estrelas de quatro pontas nos cantos
	for c in [r.position + Vector2(8, 8), Vector2(r.end.x - 8, r.position.y + 8), Vector2(r.position.x + 8, r.end.y - 8), r.end - Vector2(8, 8)]:
		var pts := PackedVector2Array([c + Vector2(0, -7), c + Vector2(2, -2), c + Vector2(7, 0), c + Vector2(2, 2), c + Vector2(0, 7), c + Vector2(-2, 2), c + Vector2(-7, 0), c + Vector2(-2, -2)])
		g.draw_colored_polygon(pts, tone)
	# gema de raridade no topo (ou losango do destaque)
	var gem_col: Color = RARITY_GEM.get(_rarity, _accent)
	var gem_tex := art(String(GEM_ART.get(_rarity, ""))) if _rarity != "" else null
	if gem_tex != null:
		var gh := 46.0 if _rarity == "unico" else 40.0
		var gw := gh * 0.75
		g.draw_texture_rect(gem_tex, Rect2(r.size.x * 0.5 - gw * 0.5, -gh * 0.32, gw, gh), false)
	var top := Vector2(r.size.x * 0.5, 4.0)
	var gem_h := 1.5 if _rarity in ["raro", "unico"] else 1.0
	var gem := PackedVector2Array([top + Vector2(0, -5 * gem_h), top + Vector2(6 * gem_h, 2), top + Vector2(0, 9 * gem_h), top + Vector2(-6 * gem_h, 2)])
	if gem_tex == null:
		g.draw_colored_polygon(gem, gem_col)
		g.draw_polyline(PackedVector2Array([gem[0], gem[1], gem[2], gem[3], gem[0]]), Color(0, 0, 0, 0.6), 1.0)
	# raro e único: moldura externa luminosa
	if _rarity in ["raro", "unico"]:
		var aura := r.grow(2.0)
		g.draw_polyline(PackedVector2Array([aura.position, Vector2(aura.end.x, aura.position.y), aura.end, Vector2(aura.position.x, aura.end.y), aura.position]), Color(gem_col.r, gem_col.g, gem_col.b, 0.5), 2.0)
	# brilho de seleção
	if lit:
		var halo := r.grow(3.0)
		g.draw_polyline(PackedVector2Array([halo.position, Vector2(halo.end.x, halo.position.y), halo.end, Vector2(halo.position.x, halo.end.y), halo.position]), Color(GOLD.r, GOLD.g, GOLD.b, 0.35), 3.0)

static func _has_detail(o: Dictionary) -> bool:
	var d: Dictionary = o.get("detail", {})
	return not d.is_empty() and (not d.get("rows", []).is_empty() or not d.get("footer", []).is_empty())

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _badge(b: Variant) -> Control:
	if not (b is Dictionary):
		return null
	var box := HBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_END
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 8)
	if b.has("text"):
		box.add_child(_label(String(b.text), 18, COLOR_PRICE))
		return box
	var up := int(b.get("up", 0))
	var down := int(b.get("down", 0))
	if up == 0 and down == 0:
		box.add_child(_label("=", 20, COLOR_NEUTRAL))
		return box
	if up > 0:
		box.add_child(_arrow("seta_cima", "▲", up, COLOR_UP))
	if down > 0:
		box.add_child(_arrow("seta_baixo", "▼", down, COLOR_DOWN))
	return box

## Seta de arte (quando existe) + número; sem a arte, o triângulo de texto de antes.
func _arrow(art_name: String, fallback: String, count: int, col: Color) -> Control:
	var tex := art(art_name)
	if tex == null:
		return _label("%s %d" % [fallback, count], 20, col)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 3)
	var icon := TextureRect.new()
	icon.texture = tex
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(20, 20)
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(icon)
	row.add_child(_label(str(count), 20, col))
	return row

## Tooltip com a tabela de comparação (ou o texto antigo, quando a oferta não tem detalhe).
func _make_custom_tooltip(_for_text: String) -> Object:
	if not _has_detail(offer) and String(offer.get("tooltip", "")) == "":
		return null
	var detail := build_detail()
	var frame := HudArt.modal_style(true)
	if frame == null:
		return detail
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", frame)
	panel.add_child(detail)
	return panel

## Tabela de detalhe da oferta; inline_only=true devolve null quando não há detalhe (modo Shift do HUD).
func build_detail(inline_only := false, compact := false) -> Control:
	if inline_only and not _has_detail(offer):
		return null
	var margin := MarginContainer.new()
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)
	var d: Dictionary = offer.get("detail", {})
	var rows: Array = d.get("rows", [])
	if not rows.is_empty():
		var cols: Array = d.get("columns", [])
		var grid := GridContainer.new()
		grid.columns = 4
		grid.add_theme_constant_override("h_separation", 8 if compact else 18)
		grid.add_theme_constant_override("v_separation", 2)
		box.add_child(grid)
		var fs := 13 if compact else 16
		grid.add_child(_label("", fs, COLOR_NEUTRAL))
		for c in cols:
			grid.add_child(_label(String(c), fs, Color(0.95, 0.85, 0.55)))
		for r in rows:
			var sign := int(r.sign)
			grid.add_child(_label(String(r.label), fs + 1, Color(0.9, 0.9, 0.9)))
			for v in r.cols:
				grid.add_child(_label(String(v), fs + 1, Color(0.95, 0.95, 0.95)))
			grid.add_child(_label(String(r.delta), fs + 1, COLOR_UP if sign > 0 else (COLOR_DOWN if sign < 0 else COLOR_NEUTRAL)))
	var footer: Array = d.get("footer", [])
	if rows.is_empty() and footer.is_empty():
		footer = [String(offer.get("tooltip", ""))]
	for line in footer:
		var fl := _label(String(line), 13 if compact else 16, Color(0.8, 0.8, 0.7))
		fl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		fl.custom_minimum_size = Vector2(0 if compact else 420, 0)
		box.add_child(fl)
	return margin
