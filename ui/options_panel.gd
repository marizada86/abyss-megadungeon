class_name OptionsPanel
extends VBoxContainer
## SPEC-165 (MEC-003): configurações do jogo num componente só (áudio, mira, falas, impacto reduzido, tela).
## Lê e grava no mesmo lugar que a aba Opções do Quartel (`profile.data.settings`, `Game.apply_settings`, `Game.save`) e é usado por ela
## e pelo menu de pausa (a pausa esconde o volume mestre, que já tem o `%VolSlider`, e a mira, que tem o botão da aba Jogo).

signal changed

var master_vol: HSlider
var aim: OptionButton
var music_vol: HSlider
var sfx_vol: HSlider
var ambience_vol: HSlider
var music_mute: CheckBox
var sfx_mute: CheckBox
var ambience_mute: CheckBox
var barks: CheckBox
var rmb_interact: CheckBox
var reduced_impact: CheckBox
var display_mode: OptionButton
var resolution: OptionButton
var visual: OptionButton
var atmosphere: OptionButton  # SPEC-177 R5-C/D
var hints: OptionButton  # SPEC-179 R2
var title_font: OptionButton
var ui_scale: OptionButton  # PLAN-ABYSS-QOL-A11Y-P1
var high_contrast: CheckBox
var color_mode: OptionButton
var speech: OptionButton
var _syncing := false

func _init() -> void:
	add_theme_constant_override("separation", 8)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build_accessibility()
	add_child(UiKit.label("ÁUDIO", 16, UiKit.GOLD))
	master_vol = _slider_row("Volume mestre", func(v): _save_master(v))
	music_vol = _slider_row("Música", func(v): _save_volume("music_volume", v))
	music_mute = _check("Música sem som", func(on): _save_mute("music", on))
	sfx_vol = _slider_row("Efeitos", func(v): _save_volume("sfx_volume", v))
	sfx_mute = _check("Efeitos sem som", func(on): _save_mute("sfx", on))
	ambience_vol = _slider_row("Ambiente", func(v): _save_volume("ambience_volume", v))
	ambience_mute = _check("Ambiente sem som", func(on): _save_mute("ambience", on))
	add_child(UiKit.label("JOGO", 16, UiKit.GOLD))
	aim = OptionButton.new()
	aim.add_item("Mira automática (inimigo mais próximo)")
	aim.add_item("Mira no mouse")
	aim.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_aim(Battle.Aim.MOUSE if i == 1 else Battle.Aim.AUTO)
		changed.emit())
	add_child(_row("Mira", aim))
	rmb_interact = _check("Botão direito interage (altar, portal, loja...) quando o cursor está no objeto", func(on): _save("rmb_interact", on))
	barks = _check("Falas dos personagens", func(on): _save("barks", on))
	reduced_impact = _check("Impacto reduzido (menos tremor e flash)", func(on): _save("reduced_impact", on))
	add_child(UiKit.label("TELA", 16, UiKit.GOLD))
	display_mode = OptionButton.new()
	for label in ["Janela", "Sem borda", "Tela cheia (F11)"]:
		display_mode.add_item(label)
	display_mode.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_window_mode(String(Game.WINDOW_MODES[i]))
		changed.emit())
	add_child(_row("Modo de tela", display_mode))
	resolution = OptionButton.new()
	for r in Game.SUPPORTED_RESOLUTIONS:
		resolution.add_item(r)
	resolution.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_resolution(resolution.get_item_text(i))
		changed.emit())
	add_child(_row("Resolução", resolution))
	visual = OptionButton.new()  # SPEC-173 (MEC-065)
	for label in VisualFilter.LABELS:
		visual.add_item(label)
	visual.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_visual_filter(String(VisualFilter.MODES[i]))
		changed.emit())
	add_child(_row("Visual", visual))
	atmosphere = OptionButton.new()  # SPEC-177 R5-C/D
	for label in Atmosphere.LABELS:
		atmosphere.add_item(label)
	atmosphere.tooltip_text = "Partículas e gradação de cor por fase."
	atmosphere.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_atmosphere(String(Atmosphere.MODES[i]))
		changed.emit())
	add_child(_row("Atmosfera", atmosphere))
	hints = OptionButton.new()  # SPEC-179 R2
	hints.add_item("Ligadas")
	hints.add_item("Desligadas")
	hints.tooltip_text = "Dicas curtas na primeira vez que cada sistema aparece."
	hints.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_hints("on" if i == 0 else "off")
		changed.emit())
	var hints_row := _row("Dicas", hints)
	var review := Button.new()
	review.text = "Rever dicas"
	review.tooltip_text = "As dicas já vistas voltam a aparecer."
	review.pressed.connect(func():
		Game.reset_hints()
		changed.emit())
	hints_row.add_child(review)
	add_child(hints_row)
	title_font = OptionButton.new()  # SPEC-173 (MEC-066)
	for o in UiFonts.available():
		title_font.add_item(String(o.label))
	title_font.tooltip_text = "Fonte dos títulos. Vale ao reabrir a tela."
	title_font.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_ui_font(String(UiFonts.available()[i].id))
		changed.emit())
	add_child(_row("Fonte dos títulos", title_font))

## PLAN-ABYSS-QOL-A11Y-P1: fica no topo do painel, para quem precisa dela achar antes de rolar.
func _build_accessibility() -> void:
	add_child(UiKit.label("ACESSIBILIDADE", 16, UiKit.GOLD))
	ui_scale = OptionButton.new()
	for label in Accessibility.UI_SCALE_LABELS:
		ui_scale.add_item(label)
	ui_scale.tooltip_text = "Aumenta o texto da interface (HUD, janelas, avisos). Os números de dano não mudam."
	ui_scale.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_ui_scale(int(Accessibility.UI_SCALES[i]))
		changed.emit())
	add_child(_row("Tamanho do texto", ui_scale))
	high_contrast = _check("Contraste alto (janelas opacas, texto mais claro)", func(on): _apply_accessibility(func(): Game.set_high_contrast(on)))
	color_mode = OptionButton.new()
	for label in Accessibility.COLOR_LABELS:
		color_mode.add_item(label)
	color_mode.tooltip_text = "Troca as cores de tipo de dano e raridade e marca o tipo no número de dano (▲ fogo, ● radiante, ◆ mágico)."
	color_mode.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_color_mode(String(Accessibility.COLOR_MODES[i]))
		changed.emit())
	add_child(_row("Daltonismo", color_mode))
	speech = OptionButton.new()
	for label in Accessibility.SPEECH_LABELS:
		speech.add_item(label)
	speech.tooltip_text = "Quanto tempo as falas dos personagens e os avisos do topo ficam na tela."
	speech.item_selected.connect(func(i):
		if _syncing:
			return
		Game.set_speech_time(String(Accessibility.SPEECH_MODES[i]))
		changed.emit())
	add_child(_row("Duração das falas", speech))

func _row(text: String, control: Control) -> Control:
	var row := HBoxContainer.new()
	var l := UiKit.label(text, 15)
	l.custom_minimum_size = Vector2(150, 0)
	row.add_child(l)
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(control)
	return row

func _slider_row(text: String, on_change: Callable) -> HSlider:
	var s := HSlider.new()
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.05
	s.custom_minimum_size = Vector2(220, 24)
	s.value_changed.connect(func(v):
		if not _syncing:
			on_change.call(v))
	add_child(_row(text, s))
	return s

func _check(text: String, on_toggle: Callable) -> CheckBox:
	var c := CheckBox.new()
	c.text = text
	c.toggled.connect(func(on):
		if not _syncing:
			on_toggle.call(on))
	add_child(c)
	return c

## Lê o perfil e põe os controles no estado atual, sem disparar gravação.
func refresh() -> void:
	var s: Dictionary = Game.profile.data.settings
	_syncing = true
	aim.select(1 if Game.aim_mode() == Battle.Aim.MOUSE else 0)
	master_vol.value = float(s.get("volume", 1.0))
	music_vol.value = float(s.get("music_volume", 1.0))
	sfx_vol.value = float(s.get("sfx_volume", 1.0))
	ambience_vol.value = float(s.get("ambience_volume", 1.0))
	music_mute.button_pressed = bool(s.get("music_muted", false))
	sfx_mute.button_pressed = bool(s.get("sfx_muted", false))
	ambience_mute.button_pressed = bool(s.get("ambience_muted", false))
	rmb_interact.button_pressed = bool(s.get("rmb_interact", true))
	barks.button_pressed = bool(s.get("barks", true))
	reduced_impact.button_pressed = bool(s.get("reduced_impact", false))
	display_mode.select(maxi(0, Game.WINDOW_MODES.find(String(s.get("window_mode", "windowed")))))
	resolution.select(maxi(0, Game.SUPPORTED_RESOLUTIONS.find(String(s.get("resolution", "1280x720")))))
	visual.select(maxi(0, VisualFilter.MODES.find(VisualFilter.mode_of(s))))
	atmosphere.select(maxi(0, Atmosphere.MODES.find(Atmosphere.mode_of(s))))
	hints.select(0 if String(s.get("hints", "on")) != "off" else 1)
	var font_ids: Array = UiFonts.available().map(func(o): return String(o.id))
	title_font.select(maxi(0, font_ids.find(UiFonts.normalize(s.get("ui_font", UiFonts.DEFAULT_ID)))))
	ui_scale.select(maxi(0, Accessibility.UI_SCALES.find(Accessibility.ui_scale_of(s))))
	high_contrast.button_pressed = Accessibility.high_contrast_of(s)
	color_mode.select(maxi(0, Accessibility.COLOR_MODES.find(Accessibility.color_mode_of(s))))
	speech.select(maxi(0, Accessibility.SPEECH_MODES.find(Accessibility.speech_mode_of(s))))
	_syncing = false

func _apply_accessibility(action: Callable) -> void:
	action.call()
	changed.emit()

func _save(key: String, value: Variant) -> void:
	Game.profile.data.settings[key] = value
	Game.save()
	if key == "reduced_impact":
		Game.visual_settings_changed.emit()  # SPEC-173: a gravura tira o grão com impacto reduzido
	changed.emit()

func _save_master(value: float) -> void:
	Game.profile.data.settings.volume = value
	Game.apply_audio()
	_save_soon()
	changed.emit()

func _save_volume(key: String, value: float) -> void:
	Game.profile.data.settings[key] = value
	if value > 0.0001:
		var channel := key.trim_suffix("_volume")
		Game.profile.data.settings["%s_muted" % channel] = false
		_syncing = true
		match channel:
			"music": music_mute.button_pressed = false
			"sfx": sfx_mute.button_pressed = false
			"ambience": ambience_mute.button_pressed = false
		_syncing = false
	Game.apply_audio()
	_save_soon()
	changed.emit()

func _save_mute(channel: String, muted: bool) -> void:
	Game.profile.data.settings["%s_muted" % channel] = muted
	Game.apply_audio()
	_save_soon()
	changed.emit()

## BUG-044: arrastar o slider dispara dezenas de mudanças; o save (com backup) é gravado uma vez, 0,4 s depois da última,
## ou na hora se o painel sair da tela. Fora da árvore (testes) grava direto.
const SAVE_DELAY := 0.4
var _save_timer: Timer
var save_pending := false

func _save_soon() -> void:
	save_pending = true
	if not is_inside_tree():
		flush_save()
		return
	if _save_timer == null:
		_save_timer = Timer.new()
		_save_timer.one_shot = true
		_save_timer.timeout.connect(flush_save)
		add_child(_save_timer)
	_save_timer.start(SAVE_DELAY)

func flush_save() -> void:
	if not save_pending:
		return
	save_pending = false
	if _save_timer != null and not _save_timer.is_stopped():
		_save_timer.stop()
	Game.save()

func _exit_tree() -> void:
	flush_save()

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and not is_visible_in_tree():
		flush_save()
