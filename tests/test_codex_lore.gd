extends RefCounted
## PLAN-ABYSS-CODEX-LORE: textos dos personagens no Códex do Quartel (data/codex_lore.json + Catalog).
## Conta pura com Profile em memória: não carrega nem grava o save real.

const FORBIDDEN := ["Receptáculo", "receptáculo", "Gellad", "Zapomoni", "Síntese", " Adam", "Astherion"]
## Inimigos: "Receptáculo de Juiblex" e "A Síntese Abissal" são nomes de inimigos; o que segue proibido é o segredo do Durvall e o ritual de Ghaunadaur.
const ENEMY_FORBIDDEN := ["Gellad", "Zapomoni", " Adam", "Astherion", "receptáculo de Ghaunadaur"]
const MAX_TEXT := 260

func run() -> Array:
	var out: Array = []
	var heroes: Dictionary = Data.table("heroes")
	var lore: Dictionary = Dictionary(Data.table("codex_lore").get("heroes", {}))
	var hqs: Dictionary = Data.table("hqs")

	# cobertura e forma dos dados
	for id in heroes:
		if not lore.has(id):
			out.append("%s: sem entrada em codex_lore" % id)
			continue
		var entry: Dictionary = lore[id]
		var curiosities: Array = Array(entry.get("curiosities", []))
		if curiosities.size() < 3:
			out.append("%s: menos de 3 curiosidades (%d)" % [id, curiosities.size()])
		if not (entry.get("hqs", null) is Array):
			out.append("%s: falta a lista `hqs` (pode ser vazia)" % id)
		for hq_id in Array(entry.get("hqs", [])):
			if not hqs.has(hq_id):
				out.append("%s: HQ inexistente %s" % [id, hq_id])
		for c in curiosities:
			var text := String(c.get("text", ""))
			var req := String(c.get("req", ""))
			if text == "" or text.length() > MAX_TEXT:
				out.append("%s: texto vazio ou maior que %d (%d): %s" % [id, MAX_TEXT, text.length(), text.left(40)])
			if String(c.get("fonte", "")) == "":
				out.append("%s: curiosidade sem fonte: %s" % [id, text.left(40)])
			if not (req in ["base", "bio"] or (req.begins_with("hq:") and hqs.has(req.substr(3)))):
				out.append("%s: req inválido '%s'" % [id, req])
			if text.find("[") >= 0 or text.find("]") >= 0:
				out.append("%s: colchetes quebram o BBCode: %s" % [id, text.left(40)])
			for bad in FORBIDDEN:
				if text.find(bad) >= 0:
					out.append("%s: termo proibido '%s' em: %s" % [id, bad, text.left(40)])
	for id in lore:
		if not heroes.has(id) and not String(id).begins_with("_"):
			out.append("codex_lore tem herói que não existe: %s" % id)

	# lista do Quartel: 4 categorias, a pausa continua com 3
	if Catalog.QUARTEL_CATEGORIES.size() != 4 or Catalog.CATEGORIES.size() != 3 or "heroes" in Catalog.CATEGORIES:
		out.append("a pausa não deve listar personagens")
	var fresh := Profile.new()
	var entries := Catalog.hero_entries(fresh)
	if entries.size() != heroes.size():
		out.append("hero_entries deveria listar os %d heróis (%d)" % [heroes.size(), entries.size()])
	for e in entries:
		var starts: bool = String(heroes[e.id].unlock) == "start"
		if bool(e.known) != starts:
			out.append("%s: perfil novo deveria %s" % [e.id, "liberar" if starts else "bloquear"])
		if not bool(e.known) and (String(e.name) != Catalog.UNKNOWN_NAME or String(e.icon) != ""):
			out.append("%s: bloqueado deveria ser '???' sem ícone" % e.id)
		if bool(e.known) and (String(e.name) != String(heroes[e.id].name) or String(e.icon) == ""):
			out.append("%s: liberado deveria ter nome e ícone" % e.id)
	var counts := Catalog.hero_counts(fresh)
	if int(counts.total) != heroes.size() or int(counts.known) != 5:
		out.append("contagem de perfil novo deveria ser 5/%d (veio %s)" % [heroes.size(), str(counts)])

	# herói bloqueado não revela nada
	var locked_text := Catalog.hero_detail(fresh, "bromnor")
	if locked_text.find("Bromnor") >= 0 or locked_text.find("virou luz") >= 0 or locked_text.find(Catalog.UNKNOWN_DETAIL) != 0:
		out.append("detalhe de herói bloqueado vaza informação: %s" % locked_text)
	if locked_text.find("Caçador de Chefes") < 0:
		out.append("detalhe de herói bloqueado deveria dar a pista da conquista")
	if Catalog.hero_detail(fresh, "inexistente") != Catalog.UNKNOWN_DETAIL:
		out.append("id inexistente cai em 'não descoberto'")

	# liberação em três níveis: base, biografia, HQ
	var base_only := Catalog.hero_curiosities(fresh, "durvall")
	var d_all := Array(lore.durvall.curiosities)
	var n_base := d_all.filter(func(c): return c.req == "base").size()
	if Array(base_only.shown).size() != n_base or int(base_only.locked) != d_all.size() - n_base:
		out.append("Durvall novo: deveria mostrar só as %d de base (%s)" % [n_base, str(base_only)])
	var with_bio := Profile.new({"achievements": {"bio_brook": true}})
	var brook := Catalog.hero_curiosities(with_bio, "brook")
	var b_all := Array(lore.brook.curiosities)
	var n_bio := b_all.filter(func(c): return c.req == "base" or c.req == "bio").size()
	if Array(brook.shown).size() != n_bio:
		out.append("Brook com biografia: deveria mostrar %d (mostrou %d)" % [n_bio, Array(brook.shown).size()])
	var brook_text := Catalog.hero_detail(with_bio, "brook")
	if brook_text.find("[b]Biografia[/b]") < 0 or brook_text.find("Conselheiro de Fateridge") >= 0 or brook_text.find("por descobrir") < 0:
		out.append("Brook sem HQ: biografia sim, fim do arco não, e avisar o que falta")
	var seen_hq := Profile.new({"achievements": {"bio_brook": true}, "hqs_seen": {"hqn_19": true, "hqn_21": true}})
	var brook_full := Catalog.hero_detail(seen_hq, "brook")
	if brook_full.find("Conselheiro de Fateridge") < 0 or brook_full.find("por descobrir") >= 0 or brook_full.find("Nas HQs") < 0:
		out.append("Brook com as HQs vistas deveria liberar tudo e listar as HQs")
	if brook_full.find(String(hqs.hqn_19.title)) < 0:
		out.append("a lista 'Nas HQs' deveria trazer o título da HQ vista")

	# Bromnor: a morte só aparece depois da HQ que a mostra
	var bromnor_profile := Profile.new({"achievements": {"cacador_de_chefes": true}})
	if Catalog.hero_detail(bromnor_profile, "bromnor").find("virou luz") >= 0:
		out.append("Bromnor: 'virou luz' não pode aparecer antes de ver a HQ da Concórdia Eterna")
	bromnor_profile.data.hqs_seen["hqn_11"] = true
	if Catalog.hero_detail(bromnor_profile, "bromnor").find("virou luz") < 0:
		out.append("Bromnor: depois de ver a hqn_11 a curiosidade deveria aparecer")

	# o texto de todo herói liberado compõe sem erro e traz o nome
	var everything := Profile.new({"achievements": {}, "hqs_seen": hqs.duplicate()})
	for id in heroes:
		everything.data.achievements["bio_" + id] = true
		if String(heroes[id].unlock).begins_with("ach:"):
			everything.data.achievements[String(heroes[id].unlock).substr(4)] = true
	for id in heroes:
		var t := Catalog.hero_detail(everything, id)
		if t.find(String(heroes[id].name)) < 0 or t == Catalog.UNKNOWN_DETAIL or t.find("por descobrir") >= 0:
			out.append("%s: ficha completa deveria trazer o nome e nada por descobrir" % id)

	# ---- inimigos (lotes 1 a 6: todos os 64 ids de enemies.json)
	var enemies: Dictionary = Data.table("enemies")
	var elore: Dictionary = Dictionary(Data.table("codex_lore").get("enemies", {}))
	var stages: Dictionary = Data.table("stages")
	var boss_ids: Array = []
	for sid in stages:
		boss_ids.append(String(stages[sid].get("boss", "")))
	for id in ["zumbi", "notivago", "cultista_adaga", "cultista_arqueiro", "cultista_cajado", "slime_corrosivo", "criatura_corrompida", "sacerdote_mente_derretida", "gargula",
			"guardiao_copia", "guardiao_verdadeiro", "arch_hag", "tentaculo_kraken", "totem_de_chefe", "mimico", "pilha_carga_quebravel", "carroca_quebravel", "caixote_quebravel",
			"candelabro_quebravel", "arbusto_quebravel",
			"cogumelo_fungico", "servo_de_zuggtmoy", "esporo_voador", "pudim_negro", "slime_de_juiblex", "zuggtmoy", "bolha_de_slime", "cultista_thullgrime", "receptaculo_de_juiblex",
			"manifestacao_de_juiblex", "blogbog", "saco_de_esporos_quebravel", "casulo_viscoso_quebravel",
			"alma_penada", "demonio_de_gehenna", "carcereiro_de_pedra", "molydeus_menor", "molydeus_chefe", "aberracao_shu", "ezro", "urna_funeraria_quebravel",
			"larva_de_lu_yueh", "cultista_de_feng_tu", "estatua_do_templo", "discipulo_pestilento", "lu_yueh", "lanterna_de_papel_quebravel",
			"escravo_de_rivenheart", "sucubo", "ilusao_de_sucubo", "guarda_do_castelo", "malcanthet", "ilusao_de_socothbenoth", "guardiao_de_goranthis", "cultista_de_socothbenoth", "socothbenoth",
			"espelho_ilusorio_quebravel", "estatua_rachada_quebravel",
			"cultista_ghaunadaur", "master_of_cruelties", "sintese_abissal", "death_tyrant", "nidhogg", "relicario_instavel_quebravel"]:
		if not elore.has(id):
			out.append("inimigo do lote 1 sem entrada: %s" % id)
	# cobertura total: todo id de enemies.json tem entrada (o Códex não pode voltar a mostrar só "Nottcard.")
	for id in enemies:
		if not String(id).begins_with("_") and not elore.has(id):
			out.append("inimigo sem entrada em codex_lore: %s" % id)
	for id in elore:
		if not enemies.has(id):
			out.append("codex_lore tem inimigo que não existe: %s" % id)
			continue
		var e: Dictionary = elore[id]
		var quem := String(e.get("quem", ""))
		if quem == "" or quem.length() > 400 or quem.find("[") >= 0:
			out.append("%s: 'quem' vazio, maior que 400 ou com colchete" % id)
		if String(e.get("fonte", "")) == "" and Array(e.get("curiosities", [])).is_empty():
			out.append("%s: sem fonte (entrada ou curiosidades)" % id)
		for bad in ENEMY_FORBIDDEN:
			if quem.find(bad) >= 0:
				out.append("%s: termo proibido '%s' em 'quem'" % [id, bad])
		for c in Array(e.get("curiosities", [])):
			var text := String(c.get("text", ""))
			var req := String(c.get("req", ""))
			if text == "" or text.length() > MAX_TEXT or String(c.get("fonte", "")) == "":
				out.append("%s: curiosidade vazia, longa ou sem fonte: %s" % [id, text.left(40)])
			if not (req == "base" or (req == "boss" and boss_ids.has(id)) or (req.begins_with("hq:") and hqs.has(req.substr(3)))):
				out.append("%s: req inválido '%s'" % [id, req])
			if text.find("[") >= 0 or text.find("]") >= 0:
				out.append("%s: colchetes quebram o BBCode: %s" % [id, text.left(40)])
			for bad in ENEMY_FORBIDDEN:
				if text.find(bad) >= 0:
					out.append("%s: termo proibido '%s' em: %s" % [id, bad, text.left(40)])
		# `onde` bate com o que as fases realmente sorteiam
		var real: Array = []
		for sid in stages:
			if JSON.stringify(stages[sid]).contains('"%s"' % id):
				real.append(String(sid))
		var declared: Array = Array(e.get("onde", []))
		real.sort()
		declared.sort()
		if real != declared:
			out.append("%s: 'onde' %s não bate com as fases %s" % [id, str(declared), str(real)])

	# detalhe do inimigo no Quartel: biografia, curiosidades por req, "Onde aparece"; a pausa (sem perfil) não muda
	var seen := Profile.new()
	var priest := Catalog.detail("enemies", "sacerdote_mente_derretida", true, seen)
	if priest.find(String(elore.sacerdote_mente_derretida.quem)) < 0 or priest.find("Encarar o olho") < 0 or priest.find("queimado por luz") >= 0 \
			or priest.find("derrote este chefe") < 0 or priest.find("Dagruve") < 0:
		out.append("sacerdote: biografia e curiosidade base sim, a do chefe derrotado não, com pista e 'Onde aparece'")
	seen.data.stats.boss_kills["sacerdote_mente_derretida"] = 1
	if Catalog.detail("enemies", "sacerdote_mente_derretida", true, seen).find("queimado por luz") < 0:
		out.append("sacerdote derrotado deveria liberar a curiosidade do chefe")
	if Catalog.detail("enemies", "sacerdote_mente_derretida", true).find("Curiosidades") >= 0:
		out.append("a pausa (sem perfil) não mostra curiosidades")
	if Catalog.detail("enemies", "sacerdote_mente_derretida", false, seen) != Catalog.UNKNOWN_DETAIL:
		out.append("inimigo não descoberto continua sem informação")
	var kraken := Catalog.detail("enemies", "tentaculo_kraken", true, Profile.new())
	if kraken.find("Aboleth") < 0 or kraken.find("segundo Kraken") >= 0:
		out.append("Kraken: Aboleth (base) sim, o da Sessão 21 só depois da HQ final")


	# quebráveis: detalhe enxuto, com e sem perfil (a pausa não passa perfil)
	for with_profile in [true, false]:
		var urn := Catalog.detail("enemies", "urna_funeraria_quebravel", true, Profile.new() if with_profile else null)
		if urn.find("quebra e não ataca") < 0 or urn.find("velocidade") >= 0 or urn.find("dano") >= 0 or urn.find("Resistências") >= 0:
			out.append("quebrável: só PV e 'quebra e não ataca', sem dano, velocidade nem resistências (%s)" % urn.left(120))
	if Catalog.detail("enemies", "urna_funeraria_quebravel", true, Profile.new()).find(String(elore.urna_funeraria_quebravel.quem)) < 0:
		out.append("quebrável com perfil: deveria trazer o 'quem'")
	# Erik: os pais entram só com a biografia liberada
	var erik_plain := Catalog.hero_detail(Profile.new({"achievements": {"ach_dummy": true}}), "erik")
	if erik_plain.find("Frank Blackthorn") >= 0:
		out.append("Erik: os pais só aparecem com a biografia liberada")
	var erik_bio := Catalog.hero_detail(Profile.new({"achievements": {"bio_erik": true, "ecos_docas": true}}), "erik")
	if erik_bio.find("Frank Blackthorn") < 0:
		out.append("Erik: com a biografia, o pai Frank Blackthorn deveria aparecer")
	# Síntese: a divergência da mesa fica escrita
	if Catalog.detail("enemies", "sintese_abissal", true, Profile.new()).find("No jogo, o psíquico não a atinge") < 0:
		out.append("Síntese: deveria dizer que no jogo o psíquico não a atinge")

	# "Resistências" não pode mostrar o dicionário cru dos dados
	var sint := Catalog.detail("enemies", "sintese_abissal", true, Profile.new())
	if sint.find("{") >= 0 or sint.find("dano recebido: ") < 0 or sint.find("radiante 100%") < 0:
		out.append("Resistências deveria sair legível (dano recebido: ... radiante 100%%), veio: %s" % sint.left(240))
	if Catalog.resist_text({}) != "nenhuma":
		out.append("sem resistência: nenhuma")

	# ---- armas e itens únicos (S-C09, lote A em diante)
	var items_lore: Dictionary = Dictionary(Data.table("codex_lore").get("items", {}))
	var weapons_lore: Dictionary = Dictionary(Data.table("codex_lore").get("weapons", {}))
	var uniques: Dictionary = Catalog.source("items")
	var weapon_table: Dictionary = Data.table("weapons")
	for id in ["machado_de_xargath", "martelo_da_gloria", "colar_visao_verdadeira", "broche_celestial", "amuleto_da_luz", "lamina_da_digestao", "chicote_avarento", "cajado_dos_desejos",
			"colar_dos_tentaculos", "sopro_de_estrela", "ampulheta", "anel_resistencia_abissal", "anel_passagem_sombria", "aneis_de_grazzt", "manto_do_pantano"]:
		if not items_lore.has(id):
			out.append("item único do lote A sem entrada: %s" % id)
	for id in ["machado_de_xargath", "martelo_da_gloria", "martelo_da_luz", "lamina_da_digestao", "chicote_avarento", "cajado_dos_desejos", "colar_dos_tentaculos", "sopro_de_estrela", "ampulheta"]:
		if not weapons_lore.has(id):
			out.append("arma do lote A sem entrada: %s" % id)
	for id in items_lore:
		if not uniques.has(id):
			out.append("codex_lore.items tem id que não é único: %s" % id)
			continue
		var it: Dictionary = items_lore[id]
		var iquem := String(it.get("quem", ""))
		if iquem == "" or iquem.length() > 400 or iquem.find("[") >= 0:
			out.append("item %s: 'quem' vazio, longo ou com colchete" % id)
		for c in Array(it.get("curiosities", [])):
			var itext := String(c.get("text", ""))
			var ireq := String(c.get("req", ""))
			if itext == "" or itext.length() > MAX_TEXT or String(c.get("fonte", "")) == "" or itext.find("[") >= 0:
				out.append("item %s: curiosidade vazia, longa, sem fonte ou com colchete: %s" % [id, itext.left(40)])
			if not (ireq == "base" or (ireq.begins_with("hq:") and hqs.has(ireq.substr(3)))):
				out.append("item %s: req inválido '%s'" % [id, ireq])
			for bad in ENEMY_FORBIDDEN:
				if itext.find(bad) >= 0 or iquem.find(bad) >= 0:
					out.append("item %s: termo proibido '%s'" % [id, bad])
	for id in weapons_lore:
		if not weapon_table.has(id):
			out.append("codex_lore.weapons tem arma que não existe: %s" % id)
		var wl: Dictionary = weapons_lore[id]
		if wl.has("igual_a") and not items_lore.has(String(wl.igual_a)):
			out.append("arma %s: igual_a aponta para item sem entrada (%s)" % [id, wl.igual_a])
		if not wl.has("igual_a") and String(wl.get("quem", "")) == "":
			out.append("arma %s: sem igual_a e sem quem" % id)

	# detalhe no Quartel: item e arma por igual_a mostram o mesmo texto; a pausa (sem perfil) não muda
	var fresh_p := Profile.new()
	var hammer_item := Catalog.detail("items", "martelo_da_gloria", true, fresh_p)
	var hammer_weapon := Catalog.detail("weapons", "martelo_da_luz", true, fresh_p)
	if hammer_item.find(String(items_lore.martelo_da_gloria.quem)) < 0 or hammer_weapon.find(String(items_lore.martelo_da_gloria.quem)) < 0:
		out.append("martelo: item e arma (igual_a) deveriam trazer o mesmo 'quem'")
	if hammer_item.find("Redenção Divina") < 0 or hammer_item.find("entregou o martelo") >= 0 or hammer_item.find("por descobrir") < 0:
		out.append("martelo: curiosidade base sim, a da hqn_19 só depois da HQ")
	fresh_p.data.hqs_seen["hqn_19"] = true
	if Catalog.detail("items", "martelo_da_gloria", true, fresh_p).find("entregou o martelo") < 0:
		out.append("martelo: depois da hqn_19 a entrega deveria aparecer")
	if Catalog.detail("items", "martelo_da_gloria", true).find("Redenção Divina") >= 0 or Catalog.detail("weapons", "martelo_da_luz", true).find("[b]História[/b]") >= 0:
		out.append("a pausa (sem perfil) não mostra história de arma nem de item")
	if Catalog.detail("weapons", "espada_sombria", true, Profile.new()).find("[b]História[/b]") >= 0:
		out.append("W-2: a Espada Sombria não ganha história")
	if Catalog.detail("items", "colar_visao_verdadeira", true, Profile.new()).find("Astherion") >= 0:
		out.append("W-3: o Colar de visão verdadeira não cita Astherion")

	# armas com texto próprio (lote D): mesma disciplina dos itens; W-2: as espadas do Durvall ficam sem entrada
	for id in ["sentenca_de_lliira", "julgamento_da_gloria", "raio_de_luz", "luz_mais_pura", "memoria_alterada", "dominar_pessoa", "tocha_do_incendiario", "constelacao_de_silva"]:
		if not weapons_lore.has(id):
			out.append("arma do lote D sem entrada: %s" % id)
	for id in ["espada_sombria", "espada_do_receptaculo"]:
		if weapons_lore.has(id):
			out.append("W-2: %s não ganha lore" % id)
	for id in weapons_lore:
		var wentry: Dictionary = weapons_lore[id]
		if wentry.has("igual_a"):
			continue
		var wq := String(wentry.get("quem", ""))
		if wq.length() > 400 or wq.find("[") >= 0:
			out.append("arma %s: 'quem' longo ou com colchete" % id)
		if Array(wentry.get("curiosities", [])).is_empty() and String(wentry.get("fonte", "")) == "":
			out.append("arma %s: sem curiosidades e sem fonte" % id)
		for bad in ENEMY_FORBIDDEN:
			if wq.find(bad) >= 0:
				out.append("arma %s: termo proibido '%s' em 'quem'" % [id, bad])
		for c in Array(wentry.get("curiosities", [])):
			var wtext := String(c.get("text", ""))
			var wreq := String(c.get("req", ""))
			if wtext == "" or wtext.length() > MAX_TEXT or String(c.get("fonte", "")) == "" or wtext.find("[") >= 0:
				out.append("arma %s: curiosidade vazia, longa, sem fonte ou com colchete: %s" % [id, wtext.left(40)])
			if not (wreq == "base" or (wreq.begins_with("hq:") and hqs.has(wreq.substr(3)))):
				out.append("arma %s: req inválido '%s'" % [id, wreq])
			for bad in ENEMY_FORBIDDEN:
				if wtext.find(bad) >= 0:
					out.append("arma %s: termo proibido '%s'" % [id, bad])
	# Memória Alterada: o fim de Bromnor só depois da hqn_11
	var mem := Profile.new()
	if Catalog.detail("weapons", "memoria_alterada", true, mem).find("partículas douradas") >= 0:
		out.append("Memória Alterada: o fim de Bromnor só depois da hqn_11")
	mem.data.hqs_seen["hqn_11"] = true
	if Catalog.detail("weapons", "memoria_alterada", true, mem).find("partículas douradas") < 0:
		out.append("Memória Alterada: depois da hqn_11 o fim de Bromnor deveria aparecer")
	# cobertura total dos itens únicos: todo único tem entrada em `items` (lotes A a C)
	for uid in uniques:
		if not items_lore.has(uid):
			out.append("item único sem entrada em codex_lore.items: %s" % uid)
	if not weapons_lore.has("dominio_da_vontade"):
		out.append("arma dominio_da_vontade deveria apontar para o Coração da Dominância")
	# W-3: só o Colar de visão verdadeira evita Astherion e o olho de Ghaunadaur; os demais itens podem citar o Olho (Colar dos Tentáculos)
	var vision: Dictionary = items_lore.colar_visao_verdadeira
	var vision_all := String(vision.quem)
	for c in Array(vision.curiosities):
		vision_all += " " + String(c.text)
	for bad in ["astherion", "olho de ghaunadaur"]:
		if vision_all.to_lower().find(bad) >= 0:
			out.append("W-3: o Colar de visão verdadeira não cita '%s'" % bad)
	for id in items_lore:
		var all_text := String(items_lore[id].quem)
		for c in Array(items_lore[id].curiosities):
			all_text += " " + String(c.text)
		if all_text.find("Astherion") >= 0:
			out.append("item %s: Astherion não entra em nenhum item" % id)

	return out
