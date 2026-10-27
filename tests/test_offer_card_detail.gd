extends RefCounted
## Cartão de oferta: o que o item faz (resumo) tem altura reservada mesmo com a etiqueta da escola, e Shift (detalhes) troca a janela do
## ícone pela tabela. A geometria (nada se mexe, tudo dentro do cartão) é conferida pela captura `tools/offer_detail_capture.gd`:
## este teste roda sem laço de quadros e não tem layout real, então confere só a estrutura e os textos.

func _hud(tree: SceneTree) -> Node:
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	return hud

func _labels(node: Node, found: Array) -> void:
	if node is Label:
		found.append((node as Label).text)
	for c in node.get_children():
		_labels(c, found)

func run() -> Array:
	var out: Array = []
	if OfferCard.short_header("Diferença", 2) != "Dif." or OfferCard.short_header("Colar dos Tentáculos [Único]", 0) != "Este" \
			or OfferCard.short_header("Talismã [Comum]", 1) != "Outro" or OfferCard.short_header("Nv 2 (atual)", 1) != "Nv 2" or OfferCard.short_header("Nv 3", 0) != "Nv 3":
		out.append("cabeçalhos curtos da tabela do cartão")

	var tree := Engine.get_main_loop() as SceneTree
	var hud := _hud(tree)
	var b := Battle.new(7, "sylas", "dagruve")
	b.state = "running"
	b.hero.items["amuleto"] = {"id": "talisma", "name": "Talismã", "slot": "amuleto", "rarity": "comum", "mods": {"regen": 0.2}, "weapon": "", "level": 1}
	var colar := {}
	for u in Data.table("items").uniques:
		if String(u.id) == "colar_dos_tentaculos":
			colar = Items.unique(u)
	b.give_item(colar, true)
	hud.show_offer(b)
	var cards: Array = hud.offer_box.get_children().filter(func(c): return c is OfferCard)
	if cards.size() != 2:
		hud.free()
		return out + ["a troca de item deveria ter 2 cartões (%d)" % cards.size()]
	var keep: OfferCard = cards[0]
	var equip: OfferCard = cards[1]
	if equip._school.is_empty():
		out.append("o colar tem escola (Mágica · Inteligência); o teste precisa do caso com etiqueta")
	for card in [keep, equip]:
		if card._brief.text == "" or card._brief.custom_minimum_size.y < 40.0:
			out.append("o resumo do que o item faz precisa de altura reservada (\"%s\")" % card._brief.text)
	if equip._brief.text.find("PV") < 0 or equip._brief.text.find("INT") < 0:
		out.append("o resumo do colar deveria citar PV e INT (%s)" % equip._brief.text)

	# Shift: a tabela entra na janela do ícone; o resumo continua visível
	var host: Control = equip._detail_host
	if host == null or equip._window_rows.is_empty():
		hud.free()
		return out + ["o cartão vertical deveria ter a janela de detalhe"]
	if host.visible or equip._window_rows.any(func(r): return not r.visible):
		out.append("sem Shift o ícone aparece e a tabela fica escondida")
	equip.show_detail(true)
	if not host.visible or equip._window_rows.any(func(r): return r.visible):
		out.append("com Shift a tabela aparece e o ícone some")
	if not equip._brief.visible:
		out.append("com Shift o resumo dos efeitos continua visível")
	var texts: Array = []
	_labels(host, texts)
	for expected in ["Este", "Outro", "Dif.", "PV", "INT"]:
		if not texts.has(expected):
			out.append("a tabela deveria ter \"%s\" (%s)" % [expected, str(texts)])
	if texts.any(func(t): return String(t).begins_with("Colar dos") or String(t).begins_with("vende ") or String(t).begins_with("Mágica:")):
		out.append("a tabela do cartão não repete nome, preço nem a explicação da escola (ficam no hover): %s" % str(texts))
	equip.show_detail(false)
	if host.visible or equip._window_rows.any(func(r): return not r.visible):
		out.append("soltar o Shift devolve o ícone")

	# cartão baixo (5 ofertas ou mais): a tabela continua trocando o resumo
	var compact_card := OfferCard.new()
	compact_card.setup_card(0, equip.offer, Color.WHITE, null, 264.0, true)
	if compact_card._detail_host != null:
		out.append("o cartão baixo não tem a janela do ícone")
	compact_card.show_detail(true)
	if compact_card._brief.visible or not compact_card._detail_view.visible:
		out.append("no cartão baixo a tabela troca o resumo")
	compact_card.free()
	hud.free()
	return out
