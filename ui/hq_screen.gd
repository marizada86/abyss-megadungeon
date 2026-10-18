extends Control
## Leitor reutilizável de HQ; a cena permanece ativa enquanto a run está pausada.

signal closed
signal panel_changed(index: int)

@onready var panel_image: TextureRect = %PanelImage
@onready var title_label: Label = %HqTitle
@onready var panel_counter: Label = %PanelCounter
@onready var caption_label: Label = %Caption
@onready var caption_right_label: Label = %CaptionRight

var panels: Array = []
var panel_index := 0
var is_closed := false
var completed := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Game.controls.changed.connect(_update_hint)
	_update_hint()
func start_hq(hq: Dictionary, resume_index: int = 0) -> void:
	Game.controls.transition()
	title_label.text = String(hq.get("title", ""))
	panels = hq.get("panels", [])
	panel_index = clampi(resume_index, 0, maxi(0, panels.size() - 1))
	is_closed = false
	completed = false
	visible = true
	if panels.is_empty():
		finish()
		return
	_show_panel()

func advance() -> void:
	if is_closed:
		return
	if panel_index + 1 >= panels.size():
		completed = true
		finish()
		return
	panel_index += 1
	_show_panel()

func finish() -> void:
	if is_closed:
		return
	is_closed = true
	Game.controls.transition()
	visible = false
	closed.emit()

func _update_hint() -> void:
	$ControlsHint.text = "Use Próximo para avançar ou Fechar para sair." if false else "%s Avançar · %s Fechar" % [Game.controls.prompt("ui_accept", "Enter / Espaço / clique"), Game.controls.prompt("ui_cancel", "Esc")]

func _input(event: InputEvent) -> void:
	if is_closed or not Game.controls.accepts(event):
		return
	# O bloco de notas (F5) fica por cima da HQ e precisa receber espaço e clique.
	if Playtest.is_note_open():
		return
	if event is InputEventJoypadButton and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			finish()
			Game.controls.transition()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_accept"):
			advance()
			Game.controls.transition()
			get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			finish()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_SPACE:
			advance()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance()
		get_viewport().set_input_as_handled()

func _show_panel() -> void:
	panel_changed.emit(panel_index)
	var panel: Dictionary = panels[panel_index]
	var image_path := String(panel.get("image", ""))
	panel_image.texture = load(image_path) as Texture2D if ResourceLoader.exists(image_path) else null
	caption_label.text = String(panel.get("text", ""))
	caption_right_label.text = String(panel.get("text_right", ""))
	var split_caption := not caption_right_label.text.strip_edges().is_empty()
	caption_right_label.visible = split_caption
	caption_label.anchor_right = 0.48 if split_caption else 0.945
	panel_counter.text = "Quadro %d de %d" % [panel_index + 1, panels.size()]
