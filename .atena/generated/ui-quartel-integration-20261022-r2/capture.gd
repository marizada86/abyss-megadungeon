extends SceneTree

var output: String
var count := 0
var baseline_offers := false

func _init() -> void:
	call_deferred("_capture")

func _shot(label: String) -> void:
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := output.path_join("%s-%dx%d.png" % [label, root.size.x, root.size.y])
	assert(root.get_texture().get_image().save_png(path) == OK)
	count += 1

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	output = args[args.find("--capture-dir") + 1]
	baseline_offers = "--baseline-offers" in args
	var game := root.get_node("Game")
	game.profile = Profile.new({"name": "Synthetic UI review", "welcome_seen": true})
	game.profile.data.settings.reduced_impact = true
	game.qa_sandbox = false
	for resolution in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = resolution
		if not baseline_offers:
			var menu = load("res://ui/menu.tscn").instantiate()
			root.add_child(menu)
			await _shot("quartel")
			menu.hero_list.select(menu.heroes.size() - 1)
			menu.hero_list.ensure_current_is_visible()
			menu._refresh_hero()
			menu.stage_list.select(menu.stages.size() - 1)
			menu.stage_list.ensure_current_is_visible()
			menu._refresh_stage()
			await _shot("quartel-last-locked")
			menu.free()
		var hud = load("res://ui/hud.tscn").instantiate()
		root.add_child(hud)
		var battle := Battle.new(420, "durvall", "dagruve")
		battle.time = 95.0
		hud.update_stats(battle)
		hud.stage_label.text = "Reino Abissal · Mira AUTO · Modificador de teste 120 s"
		hud.boss_panel.show()
		hud.boss_name.text = "Death Tyrant — teste de leitura"
		hud.boss_bar.value = 65
		if not baseline_offers:
			await _shot("hud-boss")
		battle.offer_kind = "shop_loja"
		battle.state = "shop"
		var necklace: Dictionary = Data.table("items").uniques.filter(func(item): return item.id == "colar_dos_tentaculos")[0]
		for amount in [3, 6]:
			battle.offer = []
			for i in amount:
				battle.offer.append({"t":"shop_item", "item":Items.unique(necklace), "name":"Equipar Colar dos Tentáculos [Único]", "desc":"Proteção e resistência", "brief":"Proteção e resistência", "price_text":"999 moedas", "price":999, "locked":i == 1, "rarity":"unico", "slot":"amuleto"})
			hud.show_offer(battle)
			if baseline_offers:
				for child in hud.offer_box.get_children():
					child.free()
				var original_card = load(output.get_base_dir().path_join("before-offer.gd"))
				for i in amount:
					var card = original_card.new()
					var icon_path: String = hud.offer_icon_path(battle.offer[i])
					var icon: Texture2D = load(icon_path) if ResourceLoader.exists(icon_path) else null
					card.setup_card(i, battle.offer[i], Items.rarity_color("unico"), icon, hud._offer_card_width(amount), hud._offer_compact(amount))
					card.disabled = bool(battle.offer[i].locked)
					hud.offer_box.add_child(card)
				hud.offer_box.get_child(0).grab_focus()
			await _shot("offers-%d" % amount)
		var result := battle.result()
		result.time = 125.0
		result.level = 12
		result.kills = 234
		result.bosses = 2
		result.descent_depth = 3
		for won in [true, false]:
			if baseline_offers:
				continue
			result.won = won
			result.dead = not won
			hud.show_result(result, {"earned":123, "coins":4567, "reward_rate":1.0 if won else 0.3, "achievements":[]})
			await _shot("result-win" if won else "result-partial")
		hud.free()
	print("CAPTURES_PASS=", count)
	quit()
