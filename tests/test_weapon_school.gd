extends RefCounted
## Escola da arma: Física = dano físico + Força; Mágica = dano mágico + Inteligência. Fogo e Radiante mostram o atributo real.
## Física/Mágica com outro atributo só vale como exceção declarada em Weapon.SCHOOL_EXCEPTIONS; o jogador vê a etiqueta no cartão,
## no catálogo e na ficha.

func _texts(node: Node, out: Array) -> void:
	if node is Label:
		out.append((node as Label).text)
	for c in node.get_children():
		_texts(c, out)

func _chip_text(card: Node) -> String:
	var chip := card.find_child("SchoolChip", true, false)
	if chip == null:
		return ""
	var t: Array = []
	_texts(chip, t)
	return String(t[0]) if not t.is_empty() else ""

func run() -> Array:
	var out: Array = []
	var table: Dictionary = Data.table("weapons")
	_data_rule(out, table)
	_labels(out, table)
	_cards(out)
	_catalog(out)
	return out

## Toda arma tem tipo e atributo conhecidos; o que foge de Física→Força / Mágica→Inteligência está na lista de exceções (e só ele).
func _data_rule(out: Array, table: Dictionary) -> void:
	for id in table:
		var d: Dictionary = table[id]
		if not Weapon.DTYPE_LABELS.has(String(d.get("dtype", ""))):
			out.append("%s: dtype desconhecido (%s)" % [id, d.get("dtype", "")])
		if not Weapon.ATTR_FULL.has(String(d.get("attr", ""))):
			out.append("%s: attr desconhecido (%s)" % [id, d.get("attr", "")])
		var s := Weapon.school(d)
		var listed: bool = Weapon.SCHOOL_EXCEPTIONS.has(id)
		if bool(s.exception) and not listed:
			out.append("%s é %s mas não está em SCHOOL_EXCEPTIONS: corrija o atributo ou declare a exceção" % [id, s.tag])
		if listed and not bool(s.exception):
			out.append("%s está em SCHOOL_EXCEPTIONS mas segue a regra (%s)" % [id, s.tag])
	for id in Weapon.SCHOOL_EXCEPTIONS:
		if not table.has(id):
			out.append("SCHOOL_EXCEPTIONS cita arma inexistente: %s" % id)

func _labels(out: Array, table: Dictionary) -> void:
	var expect := {
		"espada_sombria": "Física · Força", "maca_demolidora": "Física · Força",
		"raio_enfraquecedor": "Mágica · Inteligência", "tempestade": "Mágica · Inteligência", "ampulheta": "Mágica · Inteligência",
		"bola_de_fogo": "Fogo · Inteligência", "tocha_do_incendiario": "Fogo · Força",
		"sentenca_de_lliira": "Radiante · Carisma", "raio_de_luz": "Radiante · Constituição",
		"dominar_pessoa": "Mágica · Carisma", "chicote_avarento": "Física · Carisma",
	}
	for id in expect:
		var tag := String(Weapon.school(table[id]).tag)
		if tag != expect[id]:
			out.append("%s deveria ser %s (é %s)" % [id, expect[id], tag])
	if Weapon.school(table.espada_sombria).color == Weapon.school(table.tempestade).color:
		out.append("Força e Inteligência deveriam ter cores diferentes")
	if Weapon.school(table.dominar_pessoa).exception == false:
		out.append("Mágica · Carisma deveria ser marcada como exceção")
	var hint := Weapon.school_hint(table.tempestade)
	if hint.find("mágico") < 0 or hint.find("CAM") < 0 or hint.find("Inteligência") < 0:
		out.append("a explicação da magia deveria citar dano mágico, CAM e Inteligência (%s)" % hint)
	var fisico := Weapon.school_hint(table.espada_sombria)
	if fisico.find("físico") < 0 or fisico.find("CA)") < 0 or fisico.find("Força") < 0:
		out.append("a explicação da arma física deveria citar dano físico, CA e Força (%s)" % fisico)
	var b := Battle.new(61, "durvall", "dagruve")
	var text := b.weapon_damage_text(Weapon.make("tempestade").params())
	if text.find("Mágica") < 0 or text.find("Inteligência") < 0:
		out.append("o texto de dano deveria citar a escola e o atributo (%s)" % text)

func _cards(out: Array) -> void:
	var tree := Engine.get_main_loop() as SceneTree
	for compact in [false, true]:
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		var b := Battle.new(42, "durvall", "dagruve")
		b.offer = [
			{"t": "weapon_new", "id": "bola_de_fogo", "name": "NOVA: Bola de Fogo", "desc": "Explosão.", "brief": "Explosão."},
			{"t": "weapon_up", "id": "espada_sombria", "name": "Espada Sombria → Nv 2", "desc": "Mais dano.", "brief": "Dano 5–9", "badge": {"text": "Nv 1 → 2"}},
			{"t": "evolve", "id": "golpe_atordoante", "into": "golpe_do_juizo", "name": "★ EVOLUÇÃO: Golpe do Juízo", "desc": "Julga.", "brief": "Julga."},
			{"t": "shop_weapon_up", "weapon_id": "tempestade", "name": "Tempestade → Nv 2 — 30 moedas", "desc": "Mais raios.", "brief": "Mais raios.", "price_text": "30 moedas", "price": 30},
			{"t": "passive", "id": "cota_de_malha", "name": "Cota de Malha", "desc": "CA.", "brief": "CA."},
			{"t": "weapon_new", "id": "arma_inexistente", "name": "NOVA: ???", "desc": "x", "brief": "x"},
		]
		b.offer = b.offer.slice(0, 6 if compact else 4)   # 5+ ofertas usam o cartão compacto
		b.offer_kind = "levelup"
		b.state = "levelup"
		hud.show_offer(b)
		var cards: Array = hud.offer_box.find_children("*", "OfferCard", true, false)
		if cards.size() != b.offer.size():
			out.append("deveria haver %d cartões (%d, compacto=%s)" % [b.offer.size(), cards.size(), str(compact)])
			hud.free()
			continue
		var want := ["Fogo · Inteligência", "Física · Força", "Radiante · Constituição", "Mágica · Inteligência", "", ""]
		for i in b.offer.size():
			var got := _chip_text(cards[i])
			var expected: String = _short(want[i]) if compact else want[i]
			if got != expected:
				out.append("cartão %d (%s): etiqueta deveria ser '%s' (é '%s')" % [i, cards[i].offer.t, expected, got])
		hud.free()
	# equipamento que concede arma: a etiqueta vem da arma concedida
	var item: Dictionary = Data.table("items").uniques.filter(func(u): return String(u.id) == "colar_dos_tentaculos")[0]
	var card := OfferCard.new()
	card.setup_card(0, {"t": "shop_item", "item": Items.unique(item), "name": "Equipar Colar dos Tentáculos [Único]", "desc": "x", "brief": "x", "price_text": "9 moedas", "price": 9, "slot": "amuleto"},
		Color.WHITE, null)
	if _chip_text(card) != "Mágica · Inteligência":
		out.append("o amuleto que concede magia deveria mostrar Mágica · Inteligência ('%s')" % _chip_text(card))
	card.free()

func _catalog(out: Array) -> void:
	var detail := Catalog.detail("weapons", "espada_sombria", true)
	if detail.find("Física · Força") < 0 or detail.find("dano físico") < 0:
		out.append("o catálogo deveria mostrar a escola da arma (%s)" % detail)
	var spell := Catalog.detail("weapons", "raio_enfraquecedor", true)
	if spell.find("Mágica · Inteligência") < 0:
		out.append("o catálogo deveria mostrar Mágica · Inteligência para o Raio Enfraquecedor (%s)" % spell)
	if Catalog.detail("weapons", "espada_sombria", false).find("Força") >= 0:
		out.append("arma desconhecida não deve revelar a escola")

## O cartão compacto (5+ ofertas) abrevia o atributo: "Mágica · Inteligência" vira "Mágica · INT".
func _short(tag: String) -> String:
	for attr in Weapon.ATTR_FULL:
		tag = tag.replace(String(Weapon.ATTR_FULL[attr]), String(Weapon.ATTR_ABBR.get(attr, attr)))
	return tag
