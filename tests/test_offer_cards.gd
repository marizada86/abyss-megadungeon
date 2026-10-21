extends RefCounted
## Cartões verticais de oferta (nível e altar) com visual em código: layout horizontal, fita/nome/categoria derivados do tipo
## da oferta e a lista antiga mantida nas lojas e trocas de item.

func _texts(node: Node, out: Array) -> void:
	if node is Label:
		out.append((node as Label).text)
	for c in node.get_children():
		_texts(c, out)

func _hud(tree: SceneTree) -> Node:
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	return hud

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	# nível: fileira horizontal de cartões, um por oferta, com índice
	var hud := _hud(tree)
	var b := Battle.new(42, "durvall", "dagruve")
	b.offer = [
		{"t": "weapon_new", "id": "espada_longa", "name": "NOVA: Espada Longa", "desc": "Golpe em arco.", "brief": "Golpe em arco."},
		{"t": "weapon_up", "id": "espada_sombria", "name": "Espada Sombria → Nv 2", "desc": "Mais dano.", "brief": "Dano 5–9", "badge": {"text": "Nv 1 → 2"}},
		{"t": "evolve", "id": "espada_sombria", "into": "espada_do_receptaculo", "name": "★ EVOLUÇÃO: Espada da Armadura Negra", "desc": "Arco enorme.", "brief": "Arco enorme."},
	]
	b.offer_kind = "levelup"
	b.state = "levelup"
	hud.show_offer(b)
	if hud.offer_box.vertical:
		out.append("o nível deveria usar a fileira horizontal de cartões")
	var cards: Array = hud.offer_box.get_children().filter(func(c): return c is OfferCard)
	if cards.size() != 3 or hud.offer_box.get_child_count() != 3:
		out.append("o nível deveria ter exatamente 3 cartões diretos em offer_box (%d)" % hud.offer_box.get_child_count())
	else:
		for i in 3:
			if (cards[i] as OfferCard).index != i:
				out.append("o cartão %d deveria guardar o próprio índice" % i)
		var t0: Array = []
		_texts(cards[0], t0)
		var t1: Array = []
		_texts(cards[1], t1)
		var t2: Array = []
		_texts(cards[2], t2)
		if not t0.has("NOVA") or not t0.has("Espada Longa") or not t0.has("Arma"):
			out.append("o cartão de arma nova deveria ter fita NOVA, nome sem prefixo e categoria Arma (%s)" % str(t0))
		if not t1.has("Espada Sombria") or not t1.has("Nv 1 → 2") or t1.has("NOVA"):
			out.append("o cartão de arma em nível deveria mostrar o nome sem o sufixo e o chip Nv 1 → 2 (%s)" % str(t1))
		if not t2.has("EVOLUI") or not t2.has("Evolução"):
			out.append("o cartão de evolução deveria ter a fita EVOLUI (%s)" % str(t2))
	if cards.size() > 0 and (cards[0] as Button).custom_minimum_size.y != OfferCard.CARD_SIZE.y:
		out.append("o cartão deveria ter a altura de CARD_SIZE")
	# clique e foco continuam por botão
	var chosen: Array = []
	hud.offer_chosen.connect(func(i): chosen.append(i))
	if cards.size() == 3:
		(cards[1] as Button).pressed.emit()
	if chosen != [1]:
		out.append("confirmar o segundo cartão deveria escolher a opção 1 (%s)" % str(chosen))
	hud.free()
	# altar: a opção sem brief (recusar) também vira cartão
	var hud2 := _hud(tree)
	var b2 := Battle.new(43, "durvall", "dagruve")
	b2._open_altar()
	hud2.show_offer(b2)
	if hud2.offer_box.vertical:
		out.append("o altar deveria usar a fileira horizontal")
	var skip: Array = hud2.offer_box.get_children().filter(func(c): return c is OfferCard)
	if skip.size() != b2.offer.size():
		out.append("todas as opções do altar (inclusive recusar) deveriam ser cartões (%d de %d)" % [skip.size(), b2.offer.size()])
	hud2.free()
	# loja: cartões, com o preço no chip e o "Sair" também como cartão
	var hud3 := _hud(tree)
	var b3 := Battle.new(44, "durvall", "dagruve")
	b3.hero.gold = 500
	b3._open_shop_event("loja")
	hud3.show_offer(b3)
	if hud3.offer_box.vertical:
		out.append("a loja deveria usar cartões em fileira")
	var shop_cards: Array = hud3.offer_box.get_children().filter(func(c): return c is OfferCard)
	if shop_cards.size() != b3.offer.size():
		out.append("todas as opções da loja deveriam ser cartões (%d de %d)" % [shop_cards.size(), b3.offer.size()])
	var shop_texts: Array = []
	if shop_cards.size() > 0:
		_texts(shop_cards[0], shop_texts)
	if shop_texts.filter(func(t): return String(t).find("moedas") >= 0).is_empty():
		out.append("o cartão de item da loja deveria mostrar o preço (%s)" % str(shop_texts))
	hud3.hide_offer()
	hud3.free()
	# ferreiro com muitas linhas: versão compacta em duas fileiras (6+ ofertas)
	var hud4 := _hud(tree)
	var b4 := Battle.new(45, "durvall", "dagruve")
	b4.offer = []
	for k in 6:
		b4.offer.append({"t": "shop_item_up", "name": "Peça %d → Nv 2 — 40 moedas" % k, "desc": "x", "brief": "Ganho: +1 FOR", "badge": {"text": "Nv 1 → 2"}, "price_text": "40 moedas", "slot": "arma", "rarity": "raro", "base": "espada_longa", "price": 40, "locked": k == 5})
	b4.offer_kind = "shop_ferreiro"
	b4.state = "shop"
	hud4.show_offer(b4)
	var many: Array = hud4.offer_box.get_children().filter(func(c): return c is OfferCard)
	if many.size() != 6 or not (many[0] as OfferCard).compact:
		out.append("6 ofertas deveriam virar cartões compactos")
	elif (many[5] as Button).disabled == false:
		out.append("a oferta travada deveria ficar desabilitada")
	hud4.free()
	# item de baú: a raridade vira a cor do cartão e a fita diz EQUIPAR
	var hud5 := _hud(tree)
	var b5 := Battle.new(46, "durvall", "dagruve")
	b5.hero.items.erase("amuleto")
	var unique_amulet: Dictionary = Data.table("items").uniques.filter(func(u): return String(u.slot) == "amuleto")[0]
	b5.give_item(Items.unique(unique_amulet), true)
	hud5.show_offer(b5)
	var chest_cards: Array = hud5.offer_box.get_children().filter(func(c): return c is OfferCard)
	if chest_cards.size() != 1:
		out.append("o item do baú deveria ser um cartão (%d)" % chest_cards.size())
	else:
		var chest_texts: Array = []
		_texts(chest_cards[0], chest_texts)
		if not chest_texts.has("EQUIPAR") or chest_texts.filter(func(t): return String(t).begins_with("Amuleto")).is_empty():
			out.append("o cartão do baú deveria ter a fita EQUIPAR e a categoria Amuleto · raridade (%s)" % str(chest_texts))
	hud5.free()
	# pacto: cartão
	var hud6 := _hud(tree)
	var b6 := Battle.new(47, "durvall", "dagruve")
	b6.offer = [{"t": "pact", "name": "Pacto", "desc": "x", "brief": "x"}]
	b6.offer_kind = "pact"
	b6.state = "shop"
	hud6.show_offer(b6)
	if hud6.offer_box.get_children().filter(func(c): return c is OfferCard).size() != 1:
		out.append("o pacto deveria ser um cartão")
	hud6.free()
	return out
