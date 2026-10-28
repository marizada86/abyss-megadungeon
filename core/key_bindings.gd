class_name KeyBindings
extends RefCounted
## 0.5.2 (QoL Q3): teclas do teclado remapeáveis. Regras puras; `Game.apply_keybinds` aplica no InputMap.
## O perfil guarda só o que o jogador mudou em `settings.keybinds` ({id: physical_keycode}); sem a chave, valem os padrões
## e um perfil antigo se comporta como antes. Esc (pausa), as setas (movimento), as teclas 1-9 (cartas) e o mouse ficam fixos.

## id = ação do InputMap. Movimento usa ações próprias (`key_move_*`) porque `joy_move_*` são do controle.
const ACTIONS: Array[Dictionary] = [
	{"id": "key_move_up", "label": "Mover para cima", "default": KEY_W},
	{"id": "key_move_left", "label": "Mover para a esquerda", "default": KEY_A},
	{"id": "key_move_down", "label": "Mover para baixo", "default": KEY_S},
	{"id": "key_move_right", "label": "Mover para a direita", "default": KEY_D},
	{"id": "hero_active", "label": "Habilidade do herói", "default": KEY_Q},
	{"id": "run_interact", "label": "Interagir", "default": KEY_E},
	{"id": "run_items", "label": "Ficha do herói", "default": KEY_C},
	{"id": "run_speed", "label": "Velocidade do jogo", "default": KEY_F},
	{"id": "run_reroll", "label": "Rerrolar ofertas", "default": KEY_R},
	{"id": "run_extract", "label": "Extrair", "default": KEY_X},
	{"id": "run_toggle_aim", "label": "Alternar mira", "default": KEY_TAB},
]

## Teclas que não podem ser atribuídas: pausa, setas, números das cartas, modificadores e F11 (tela cheia).
const RESERVED: Array[int] = [KEY_ESCAPE, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META, KEY_F11, KEY_F5, KEY_F6, KEY_F7,
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_ENTER, KEY_KP_ENTER, KEY_SPACE, KEY_NONE]

## Teclas em uso agora, gravadas por `Game.apply_keybinds`. O núcleo (Battle, BossMechanics) lê daqui para não depender do autoload `Game`
## (os bots e as sondas rodam sem autoloads). Vazio = padrões.
static var active_codes: Dictionary = {}

static func active_hint(id: String) -> String:
	return key_text(int(active_codes.get(id, default_of(id))))

static func ids() -> Array:
	return ACTIONS.map(func(a): return String(a.id))

static func label_of(id: String) -> String:
	for a in ACTIONS:
		if String(a.id) == id:
			return String(a.label)
	return id

static func default_of(id: String) -> int:
	for a in ACTIONS:
		if String(a.id) == id:
			return int(a.default)
	return KEY_NONE

static func is_assignable(code: int) -> bool:
	return code != KEY_NONE and not RESERVED.has(code)

## Tecla atual da ação: a gravada (se válida) ou a padrão.
static func code_of(settings: Dictionary, id: String) -> int:
	var saved: Variant = settings.get("keybinds", {})
	if saved is Dictionary and (saved as Dictionary).has(id) and is_assignable(int((saved as Dictionary)[id])):
		return int((saved as Dictionary)[id])
	return default_of(id)

## Outra ação que já usa `code` (para trocar as duas), ou "".
static func owner_of(settings: Dictionary, code: int, except_id: String) -> String:
	for id in ids():
		if id != except_id and code_of(settings, id) == code:
			return id
	return ""

## Atribui `code` a `id`. Se outra ação usava a tecla, ela recebe a tecla antiga de `id` (troca), então nunca há duas ações na mesma tecla.
## Devolve o novo dicionário `keybinds` (só as diferenças dos padrões) ou {} sem mudar nada quando a tecla não vale.
static func rebind(settings: Dictionary, id: String, code: int) -> Dictionary:
	if not ids().has(id) or not is_assignable(code):
		return {}
	var current := {}
	for other in ids():
		current[other] = code_of(settings, other)
	var other_id := owner_of(settings, code, id)
	if other_id != "":
		current[other_id] = int(current[id])
	current[id] = code
	var diff := {}
	for key in current:
		if int(current[key]) != default_of(String(key)):
			diff[key] = int(current[key])
	return diff

static func key_text(code: int) -> String:
	if code == KEY_NONE:
		return "?"
	return OS.get_keycode_string(code)

## Texto da tecla para dicas e avisos ("Q"). Aceita a coleção de ajustes ou o perfil inteiro.
static func hint(settings: Dictionary, id: String) -> String:
	return key_text(code_of(settings, id))
