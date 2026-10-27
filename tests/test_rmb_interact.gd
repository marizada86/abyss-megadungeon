extends RefCounted
## PLAN-ABYSS-QOL-RMB-INTERACT-20261027: botão direito sobre um objeto interativo ao alcance interage; fora dele não faz nada aqui (a habilidade segue no Run).

func run() -> Array:
	var out: Array = []
	var b := Battle.new(3, "sylas", "dagruve")
	b.state = "running"
	b.time = 10.0
	b.interactions.clear()
	b.hero.pos = Vector2(20, 20)
	var hero_screen := Iso.to_screen(b.hero.pos)
	var near := {"kind": "ferreiro", "pos": Vector2(21, 20), "used": false, "born_at": -5.0}
	var far := {"kind": "loja", "pos": Vector2(30, 20), "used": false, "born_at": -5.0}
	var young := {"kind": "altar", "pos": Vector2(20, 21), "used": false, "born_at": 9.9}
	var chest := {"kind": "chest", "pos": Vector2(19, 20), "used": false, "born_at": -5.0}
	b.interactions.append_array([near, far, young, chest])

	var near_screen := hero_screen + Iso.to_screen(near.pos - b.hero.pos)
	# cursor sobre a arte (acima do ponto no chão) acerta; longe do objeto não
	if b.interactable_at_screen(near_screen + Vector2(0, -50), hero_screen) != near:
		out.append("cursor sobre a arte do objeto deveria achá-lo")
	if not b.interactable_at_screen(near_screen + Vector2(300, 0), hero_screen).is_empty():
		out.append("cursor longe do objeto não pode achar nada")
	if not b.interactable_at_screen(near_screen + Vector2(0, 200), hero_screen).is_empty():
		out.append("cursor muito abaixo do objeto não pode achar nada")
	# objeto fora do alcance do herói, recém-nascido ou sem interação manual não entra
	var far_screen := hero_screen + Iso.to_screen(far.pos - b.hero.pos)
	if not b.interactable_at_screen(far_screen, hero_screen).is_empty():
		out.append("objeto fora do alcance não pode ser alvo")
	var young_screen := hero_screen + Iso.to_screen(young.pos - b.hero.pos)
	if not b.interactable_at_screen(young_screen, hero_screen).is_empty():
		out.append("objeto que acabou de surgir (menos de 0,65 s) não pode ser alvo")
	var chest_screen := hero_screen + Iso.to_screen(chest.pos - b.hero.pos)
	if not b.interactable_at_screen(chest_screen, hero_screen).is_empty():
		out.append("baú abre ao encostar e não é alvo do clique")
	# dois objetos no mesmo ponto: vence o mais perto do cursor
	var twin := {"kind": "curandeiro", "pos": Vector2(21.4, 20), "used": false, "born_at": -5.0}
	b.interactions.append(twin)
	var twin_screen := hero_screen + Iso.to_screen(twin.pos - b.hero.pos)
	if b.interactable_at_screen(twin_screen + Vector2(0, 8), hero_screen) != twin:
		out.append("com dois objetos juntos vence o mais perto do cursor")
	b.interactions.erase(twin)
	# fora de "running" nada acontece
	b.state = "levelup"
	if not b.interactable_at_screen(near_screen, hero_screen).is_empty() or b.interact(near):
		out.append("só interage com a corrida em andamento")
	b.state = "running"

	# interact(target): só o alvo, ao alcance
	if b.interact(far):
		out.append("interact(alvo) fora do alcance não deveria abrir nada")
	if far.used:
		out.append("alvo fora do alcance não pode ser marcado como usado")
	if b.interact({"kind": "ferreiro", "pos": near.pos, "used": false, "born_at": -5.0}):
		out.append("alvo que não está na lista de interações não vale")
	if not b.interact(near) or not near.used:
		out.append("interact(alvo) ao alcance deveria interagir e marcar usado")
	if b.interact(near):
		out.append("o mesmo objeto não interage duas vezes")
	# sem alvo, E continua achando o mais próximo ao alcance
	b.state = "running"
	var e_target := {"kind": "curandeiro", "pos": Vector2(20, 20.5), "used": false, "born_at": -5.0}
	b.interactions.append(e_target)
	if not b.interact() or not e_target.used:
		out.append("E (sem alvo) continua interagindo com o mais próximo")

	# opção do perfil: padrão ligada; perfil antigo não ganha a chave
	if not Accessibility.rmb_interact_of({}) or Accessibility.rmb_interact_of({"rmb_interact": false}):
		out.append("rmb_interact: padrão ligado, desligável")
	var old := Profile.new({"settings": {"volume": 0.5}})
	if old.data.settings.has("rmb_interact"):
		out.append("perfil antigo não ganha a chave rmb_interact")
	var s: Dictionary = Game.profile.data.settings
	var saved: Variant = s.get("rmb_interact")
	Game.set_right_click_interact(false)
	if Game.right_click_interact():
		out.append("a opção desligada deveria desligar o clique direito")
	var panel := OptionsPanel.new()
	panel.refresh()
	if panel.rmb_interact.button_pressed:
		out.append("o painel deveria refletir a opção desligada")
	panel.free()
	if saved == null:
		s.erase("rmb_interact")
	else:
		s["rmb_interact"] = saved
	Game.save()
	if not Game.right_click_interact() and saved == null:
		out.append("sem a chave, o clique direito interage")
	return out
