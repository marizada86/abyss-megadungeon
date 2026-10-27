extends SceneTree
## Cartões de oferta da loja no pior caso de texto (nome e resumo longos, selo ▲▼, preço longo, etiqueta de escola) com 3, 5 e 6
## ofertas: salva a captura e imprime quanto o conteúdo de cada cartão passa da altura dele (0 = cabe).
## Uso: powershell -File tools/offer_cards_sweep.ps1 [-Tag antes|depois] [-Size 1280x720]
const OUTPUT := "res://.atena/generated/offer-card-compact-20261027-r1/"
const USER_ROOT := "res://.atena/generated/offer-card-compact-20261027-r1/synthetic/"
var tag := "depois"
var size_tag := "1280x720"

func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var expected := ProjectSettings.globalize_path(USER_ROOT).replace(String.chr(92), "/")
	if not OS.get_user_data_dir().replace(String.chr(92), "/").begins_with(expected) or DisplayServer.get_name() == "headless":
		print("offers: precisa de janela e do diretório sintético isolado")
		quit(1)
		return
	var args := OS.get_cmdline_user_args()
	if args.size() > 0: tag = args[0]
	if args.size() > 1: size_tag = args[1]
	await process_frame
	await process_frame
	var game := root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game._save_path = "user://offer-cards-synthetic.json"
	game.profile = Profile.new({"name": "Offer cards synthetic", "welcome_seen": true})
	var hud = load("res://ui/hud.tscn").instantiate()
	root.add_child(hud)
	var battle := Battle.new(420, "durvall", "dagruve")
	hud.update_stats(battle)
	battle.offer_kind = "shop_loja"
	battle.state = "shop"
	var necklace: Dictionary = Data.table("items").uniques.filter(func(item): return item.id == "colar_dos_tentaculos")[0]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	for amount in [3, 5, 6]:
		battle.offer = []
		for i in amount:
			var o := {"t": "shop_item", "item": Items.unique(necklace), "name": "Equipar Colar dos Tentáculos [Único]", "desc": "Proteção e resistência",
				"brief": "Proteção e resistência, +3 CA, -1 CAM, +20% área de efeito", "price_text": "999 moedas", "price": 999, "locked": i == 1,
				"rarity": "unico", "slot": "amuleto", "badge": {"up": 3, "down": 2}}
			if i == 2:
				o.price_text = "vende Anel de Prata Rúnico da Raposa: 20"
			battle.offer.append(o)
		hud.show_offer(battle)
		for i in 10: await process_frame
		var cards: Array = hud.find_children("*", "Button", true, false).filter(func(b): return b.get_script() != null and b.get_script().get_global_name() == &"OfferCard")
		# Geometria real: a faixa de preço tem de ficar dentro da moldura (margem de 12 px embaixo) e sem tocar a tecla.
		var outside := 0
		for card in cards:
			var plate: Control = card.find_child("PricePlate", true, false)
			var key: Control = null
			for c in card.find_children("*", "PanelContainer", true, false):
				if c.get_child_count() == 1 and c.get_child(0) is Label and (c.get_child(0) as Label).text == str(cards.find(card) + 1):
					key = c
			var frame := Rect2(card.global_position, card.size)
			if plate == null:
				continue
			var plate_rect := Rect2(plate.global_position, plate.size)
			var bad := plate_rect.end.y > frame.end.y - 12.0 or plate_rect.end.x > frame.end.x - 12.0
			if key != null and plate_rect.intersects(Rect2(key.global_position, key.size)):
				bad = true
			if bad:
				outside += 1
		print("offers %d ofertas: cartão %s, faixa de preço fora da moldura ou sobre a tecla em %d de %d cartões" % [amount, cards[0].size, outside, cards.size()])
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(ProjectSettings.globalize_path(OUTPUT + "%s-%d-%s.png" % [tag, amount, size_tag]))
	quit(0)
