extends RefCounted
## Conjuração do Discípulo Pestilento: a folha "special" (0,5 s) fica no último quadro enquanto a preparação do chefe durar,
## é solta quando ela acaba ou é interrompida, e outros inimigos não são afetados.

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de inimigo"]
	var view = packed.instantiate()
	tree.root.add_child(view)
	view.setup(Enemy.make("discipulo_pestilento", Vector2.ZERO))
	if view.sprite.sprite_frames.get_frame_count(&"special") != 6:
		out.append("o Discípulo deveria ter a conjuração de 6 quadros")
	view.set_cast_hold(true)
	if view.sprite.animation != &"special" or not view._action_locked:
		out.append("ao começar a conjuração a pose special deveria tocar e travar o estado")
	view._on_animation_finished()
	if not view._action_locked or view.sprite.animation != &"special":
		out.append("a pose deveria ficar no último quadro enquanto a conjuração durar")
	view.play_action(&"attack")
	if view.sprite.animation != &"special":
		out.append("um ataque comum não pode interromper a pose de conjuração")
	view.sync_visual(view.position)
	if view.sprite.animation != &"special":
		out.append("andar/parar não pode tirar o Discípulo da pose de conjuração")
	view.set_cast_hold(false)
	view.sync_visual(view.position)
	if view._action_locked or view.sprite.animation != &"idle":
		out.append("ao acabar ou ser interrompida a conjuração, o Discípulo deveria voltar ao idle")
	view.set_cast_hold(true)
	view.play_death()
	if view.sprite.animation != &"death":
		out.append("morrer durante a conjuração deveria tocar a morte")
	view.free()
	var other = packed.instantiate()
	tree.root.add_child(other)
	other.setup(Enemy.make("blogbog", Vector2.ZERO))
	other.set_cast_hold(true)
	if other._cast_hold or other._action_locked:
		out.append("só o Discípulo usa a pose sustentada de conjuração")
	other.free()
	return out
