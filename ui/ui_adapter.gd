class_name UiAdapter
extends RefCounted
## PLAN-ABYSS-QOL-A11Y-P1: aplica a escala da interface e o contraste alto aos controles, num lugar só.
## A escala move o tamanho padrão do tema (todo controle sem tamanho próprio) e cada `font_size` explícito (`add_theme_font_size_override`).
## O tamanho original fica guardado no próprio nó (meta), então voltar a 100% devolve o que o código tinha pedido.
## Texto do mundo (números de dano) leva `META_SKIP` e não passa por aqui: ele tem a escala própria de `DamageFeedback`.

const META_SKIP := &"ui_adapt_skip"
const META_BASE := &"ui_adapt_base"        # item -> valor antes de adaptar
const META_APPLIED := &"ui_adapt_applied"  # item -> valor que a adaptação gravou (se mudou, alguém reescreveu: vira a nova base)
const DEFAULT_THEME_SIZE := 20             # default_font_size de ui/theme.tres
const SIZE_ITEMS := ["font_size"]
const RICH_SIZE_ITEMS := ["normal_font_size", "bold_font_size", "italics_font_size", "bold_italics_font_size", "mono_font_size"]
const OUTLINE_MARK := &"ui_adapt_outline"

var factor := 1.0
var high_contrast := false
var _tree: SceneTree
var _theme_base := DEFAULT_THEME_SIZE

func install(tree: SceneTree) -> void:
	if _tree != null:
		return
	_tree = tree
	var theme := ThemeDB.get_project_theme()
	if theme != null and theme.default_font_size > 0:
		_theme_base = theme.default_font_size
	tree.node_added.connect(_on_node_added)

## Muda escala e contraste e reaplica em tudo que já está na árvore.
func configure(new_factor: float, new_contrast: bool) -> void:
	factor = clampf(new_factor, 1.0, 2.0)
	high_contrast = new_contrast
	var theme := ThemeDB.get_project_theme()
	if theme != null:
		theme.default_font_size = scaled(_theme_base)
	if _tree != null:
		_walk(_tree.root)

func scaled(base: int) -> int:
	return maxi(1, roundi(float(base) * factor))

func _on_node_added(node: Node) -> void:
	if not (node is Control):
		return
	if factor == 1.0 and not high_contrast and not node.has_meta(META_BASE):
		return
	apply.call_deferred(node)   # o código que criou o nó ainda põe tamanhos e cores depois do add_child

func _walk(node: Node) -> void:
	apply(node)
	for child in node.get_children():
		_walk(child)

func apply(node: Node) -> void:
	if not is_instance_valid(node) or not (node is Control) or node.has_meta(META_SKIP):
		return
	var items: Array = RICH_SIZE_ITEMS if node is RichTextLabel else SIZE_ITEMS
	if node is Label or node is BaseButton or node is RichTextLabel or node is LineEdit or node is ItemList or node is TabBar or node is TabContainer:
		for item in items:
			_adapt_size(node, item)
	if node is TabContainer and node.get_tab_bar() != null:
		for item in items:
			_adapt_size(node.get_tab_bar(), item)   # o TabBar interno não passa por node_added depois dos overrides
	_adapt_color(node)

func _adapt_size(node: Control, item: String) -> void:
	var key := "size:" + item
	var bases: Dictionary = node.get_meta(META_BASE, {})
	var applied: Dictionary = node.get_meta(META_APPLIED, {})
	if node.has_theme_font_size_override(item):
		var current := node.get_theme_font_size(item)
		var base: int = int(bases.get(key, current))
		if applied.has(key) and current != int(applied[key]):
			base = current
		var target := scaled(base)
		if target != current:
			node.add_theme_font_size_override(item, target)
		bases[key] = base
		applied[key] = target
	elif bases.has(key):
		bases.erase(key)
		applied.erase(key)
	_store(node, bases, applied)

func _store(node: Control, bases: Dictionary, applied: Dictionary) -> void:
	if not bases.is_empty():
		node.set_meta(META_BASE, bases)
		node.set_meta(META_APPLIED, applied)
	elif node.has_meta(META_BASE):
		node.remove_meta(META_BASE)
		node.remove_meta(META_APPLIED)

func _adapt_color(node: Control) -> void:
	var item := "default_color" if node is RichTextLabel else "font_color"
	if not (node is Label or node is BaseButton or node is RichTextLabel):
		return
	var key := "color:" + item
	var bases: Dictionary = node.get_meta(META_BASE, {})
	var applied: Dictionary = node.get_meta(META_APPLIED, {})
	if node.has_theme_color_override(item):
		var current := node.get_theme_color(item)
		var base: Color = bases.get(key, current)
		if applied.has(key) and not current.is_equal_approx(applied[key]):
			base = current
		var target := Accessibility.lift_text(base) if high_contrast else base
		if not target.is_equal_approx(current):
			node.add_theme_color_override(item, target)
		bases[key] = base
		applied[key] = target
	elif bases.has(key):
		bases.erase(key)
		applied.erase(key)
	_store(node, bases, applied)
	if node is Label:
		_adapt_outline(node)

## Contorno escuro nos rótulos que não têm um (texto sobre o mundo e sobre fundos claros).
func _adapt_outline(label: Label) -> void:
	var ours := label.has_meta(OUTLINE_MARK)
	if high_contrast:
		if not ours and not label.has_theme_constant_override("outline_size"):
			label.add_theme_constant_override("outline_size", Accessibility.HC_OUTLINE_SIZE)
			label.add_theme_color_override("font_outline_color", Accessibility.HC_OUTLINE_COLOR)
			label.set_meta(OUTLINE_MARK, true)
	elif ours:
		if label.get_theme_constant("outline_size") == Accessibility.HC_OUTLINE_SIZE:
			label.remove_theme_constant_override("outline_size")
			label.remove_theme_color_override("font_outline_color")
		label.remove_meta(OUTLINE_MARK)

func uninstall() -> void:
	if _tree != null and _tree.node_added.is_connected(_on_node_added):
		_tree.node_added.disconnect(_on_node_added)
	_tree = null
