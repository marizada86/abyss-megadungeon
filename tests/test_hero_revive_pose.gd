extends RefCounted
## Playtest 0.5.2: ao reviver, o herói ficava na pose de morte até usar Q/RMB, porque a trava da animação de
## morte nunca soltava. Reviver precisa voltar ao idle na hora.

func run() -> Array[String]:
	var failures: Array[String] = []
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	var view: Node2D = packed.instantiate()
	var holder := Node.new()
	(Engine.get_main_loop() as SceneTree).root.add_child(holder)
	holder.add_child(view)
	view.apply_hero("durvall")
	var sprite: AnimatedSprite2D = view.sprite
	if not sprite.sprite_frames.has_animation(&"death"):
		failures.append("durvall precisa da animação death para este teste")
	else:
		view.sync_visual(Vector2.ZERO, true, false)
		if sprite.animation != &"death":
			failures.append("morto, o herói deveria tocar death, tocou %s" % sprite.animation)
		sprite.animation_finished.emit()   # a morte termina e fica no último quadro
		view.sync_visual(Vector2.ZERO, false, false)
		if sprite.animation == &"death":
			failures.append("reviveu e continuou deitado: o sync_visual deveria sair de death")
		if view._action_locked:
			failures.append("reviveu e a trava de ação continuou ligada")
		if sprite.modulate != Color.WHITE:
			failures.append("reviveu com o tom de morto (%s)" % str(sprite.modulate))
	(Engine.get_main_loop() as SceneTree).root.remove_child(holder)
	holder.free()
	return failures
