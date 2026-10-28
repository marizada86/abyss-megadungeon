extends RefCounted
## PLAN-ABYSS-CODEX-LORE (S-C05): aba Personagens do Códex do Quartel: lista, arte, texto, galeria de HQs e liberação.
## Perfil em memória e caminho de save em res://tmp: nunca o save real.

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var saved_path: String = Game._save_path
	var saved_profile = Game.profile
	Game._save_path = "res://tmp/test-codex-quartel/profile.json"
	Game.profile = Profile.new({"name": "Teste Códex", "welcome_seen": true, "achievements": {"bio_durvall": true}, "hqs_seen": {"hqn_01": true}})
	Game.profile.data.codex.enemies["zumbi"] = true
	var menu: Control = load("res://ui/menu.tscn").instantiate()
	tree.root.add_child(menu)

	# a quarta categoria do seletor é Personagens
	if menu.codex_cat.item_count != 4 or menu.codex_cat.get_item_text(3) != "Personagens":
		out.append("o seletor do códex deveria ter 4 categorias, a última 'Personagens'")
	menu.codex_cat.select(3)
	menu._fill_codex()
	var heroes: Dictionary = Data.table("heroes")
	if menu._codex_cat_cache != "heroes" or menu.codex_list.item_count != heroes.size():
		out.append("Personagens deveria listar os %d heróis (listou %d)" % [heroes.size(), menu.codex_list.item_count])
	if menu.codex_art.visible or menu.codex_gallery.visible:
		out.append("sem seleção, arte e galeria ficam escondidas")

	# herói liberado: arte, texto do Catalog e galeria só com a HQ vista
	var durvall_at: int = menu.codex_ids.find("durvall")
	menu._show_codex(durvall_at)
	if menu.codex_text.text != Catalog.hero_detail(Game.profile, "durvall"):
		out.append("o texto do herói deveria ser o do Catalog")
	if not menu.codex_art.visible or menu.codex_art.texture == null:
		out.append("herói liberado deveria mostrar a arte")
	var gallery_names: Array = []
	for c in menu.codex_gallery.get_children():
		gallery_names.append(String(c.name))
	if gallery_names != ["Gallery_hqn_01"] or not menu.codex_gallery.visible:
		out.append("galeria do Durvall deveria ter só a HQ vista hqn_01 (veio %s)" % str(gallery_names))
	elif (menu.codex_gallery.get_child(0) as Button).focus_mode != Control.FOCUS_ALL:
		out.append("miniatura da galeria precisa aceitar foco (controle)")

	# herói bloqueado: nada vaza, sem arte nem galeria
	var bromnor_at: int = menu.codex_ids.find("bromnor")
	if menu.codex_list.get_item_text(bromnor_at) != Catalog.UNKNOWN_NAME:
		out.append("herói bloqueado deveria aparecer como '???'")
	menu._show_codex(bromnor_at)
	if menu.codex_text.text.find("Bromnor") >= 0 or menu.codex_art.visible or menu.codex_gallery.visible:
		out.append("herói bloqueado não pode mostrar nome, arte nem galeria")

	# outra categoria: inimigo conhecido tem arte, sem galeria; arma não tem arte grande
	menu.codex_cat.select(0)
	menu._fill_codex()
	menu._show_codex(menu.codex_ids.find("zumbi"))
	if not menu.codex_art.visible or menu.codex_gallery.visible:
		out.append("inimigo conhecido: arte sim, galeria não")
	menu.codex_cat.select(1)
	menu._fill_codex()
	menu._show_codex(0)
	if menu.codex_art.visible or menu.codex_gallery.visible:
		out.append("arma não usa arte grande nem galeria")

	# trocar de categoria limpa a galeria
	menu.codex_cat.select(3)
	menu._fill_codex()
	if menu.codex_gallery.get_child_count() != 0:
		out.append("refazer a lista deveria limpar a galeria")

	menu.queue_free()
	Game.profile = saved_profile
	Game._save_path = saved_path
	return out
