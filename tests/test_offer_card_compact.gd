extends RefCounted
## Cartão compacto (6+ ofertas): o selo (▲▼ ou "Nv N") fica na coluna do ícone e a base leva só a faixa de preço. Com os dois na base
## eles quebravam em duas linhas, a faixa caía fora da moldura e a tecla ficava por cima dela. A medição na tela (pior caso de texto)
## está em tools/offer_cards_sweep.ps1.
func _card(badge: Variant, price: String) -> OfferCard:
	var card := OfferCard.new()
	var o := {"t": "shop_item", "name": "Equipar Anel Teste [Raro]", "brief": "+3 CA, -1 CAM", "price_text": price, "price": 9, "rarity": "raro", "slot": "anel", "badge": badge}
	card.setup_card(0, o, Color.WHITE, null, OfferCard.COMPACT_SIZE.x, true)
	return card

func run() -> Array[String]:
	var out: Array[String] = []
	var card := _card({"up": 2, "down": 1}, "slot vazio")
	if not card.compact: out.append("o cartão deveria estar no modo compacto")
	var plate: Control = card.find_child("PricePlate", true, false)
	if plate == null:
		out.append("faixa de preço ausente no cartão compacto")
	elif not (plate.get_parent() is HFlowContainer) or plate.get_parent().get_child_count() != 1:
		out.append("na base do compacto só a faixa de preço deveria ficar ao lado da tecla (o selo vai para a coluna do ícone)")
	var arrows := 0
	for box in card.find_children("*", "HBoxContainer", true, false):
		if box.get_child_count() == 2 and box.get_child(0) is HBoxContainer and box.get_child(1) is HBoxContainer:
			arrows += 1
	if arrows != 1: out.append("o selo ▲▼ deveria aparecer uma vez, na coluna do ícone (apareceu %d)" % arrows)
	card.free()
	var level := _card(null, "")
	if level.find_child("PricePlate", true, false) != null: out.append("sem preço não deveria haver faixa")
	level.free()
	if OfferCard.COMPACT_SIZE.y < 224.0: out.append("altura do compacto abaixo do mínimo do conteúdo")
	out.append_array(run_narrow())
	return out

## Cartão completo estreito (5 ofertas): selo e preço quebram em duas linhas, então a altura sobe; a faixa "vende X: N" nunca passa da coluna útil.
func run_narrow() -> Array[String]:
	var out: Array[String] = []
	var o := {"t": "shop_item", "name": "Equipar Anel Teste [Raro]", "brief": "+3 CA", "price_text": "vende Anel de Prata Rúnico da Raposa: 20", "price": 9, "rarity": "raro", "slot": "anel", "badge": {"up": 3, "down": 2}}
	var narrow := OfferCard.new()
	narrow.setup_card(0, o, Color.WHITE, null, 217.6, false)
	var wide := OfferCard.new()
	wide.setup_card(0, o, Color.WHITE, null, OfferCard.CARD_SIZE.x, false)
	if narrow.custom_minimum_size.y <= wide.custom_minimum_size.y: out.append("o cartão estreito deveria ser mais alto que o largo")
	if wide.custom_minimum_size.y != OfferCard.CARD_SIZE.y: out.append("o cartão largo deveria manter CARD_SIZE")
	var plate: Control = narrow.find_child("PricePlate", true, false)
	if plate == null or plate.custom_minimum_size.x > 217.6 - 60.0: out.append("a faixa de preço longa passa da coluna útil do cartão estreito")
	narrow.free()
	wide.free()
	return out
