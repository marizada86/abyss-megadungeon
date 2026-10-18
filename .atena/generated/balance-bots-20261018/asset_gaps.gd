extends SceneTree
## Auditoria de lacunas de assets por convenção de caminho. Somente leitura.
##   godot --headless --path . --script res://.atena/generated/balance-bots-20261018/asset_gaps.gd -- --out <arquivo.json>
## Cada lacuna: {cat, id, detalhe, caminho_esperado, gravidade: bloqueia|degrada|cosmetico}

var gaps: Array = []

func _init() -> void:
	call_deferred("_run")

func _exists(p: String) -> bool:
	return FileAccess.file_exists(p) or ResourceLoader.exists(p)

func _gap(cat: String, id: String, detail: String, path: String, sev: String) -> void:
	gaps.append({"cat": cat, "id": id, "detalhe": detail, "caminho_esperado": path, "gravidade": sev})

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var out_path: String = args[args.find("--out") + 1]
	var enemies: Dictionary = Data.table("enemies")
	var heroes: Dictionary = Data.table("heroes")
	var stages: Dictionary = Data.table("stages")
	var stage_ids: Array = []
	for s in stages:
		stage_ids.append(String(s))
	stage_ids.append("raiz_yggdrasil")

	# --- inimigos: quais aparecem em alguma fase (ondas, elites, chefes, eventos)
	var used := {}
	var all_stage_defs: Dictionary = stages.duplicate(true)
	all_stage_defs["raiz_yggdrasil"] = Data.table("prototype_stages").get("raiz_yggdrasil", {})
	for sid in all_stage_defs:
		var s: Dictionary = all_stage_defs[sid]
		for w in s.get("waves", []):
			used[String(w.id)] = sid
		for e in s.get("elites", []):
			used[String(e.id)] = sid
		if String(s.get("boss", "")) != "":
			used[String(s.boss)] = sid
	for id in used:
		if not enemies.has(id):
			_gap("inimigo", id, "usado em %s mas ausente em enemies.json" % used[id], "data/enemies.json", "bloqueia")
			continue
		var dir := "res://assets/animations/enemies/%s" % id
		var static_png := "res://assets/enemies/%s.png" % id
		var missing: Array = []
		for seq in ["idle", "move", "attack", "death"]:
			if not _exists("%s/%s.png" % [dir, seq]):
				missing.append(seq)
		var is_boss := false
		for sid in all_stage_defs:
			if String(all_stage_defs[sid].get("boss", "")) == id:
				is_boss = true
		if missing.size() == 4:
			if _exists(static_png):
				_gap("inimigo", id, "só sprite estático (sem animações); fase %s%s" % [used[id], " (CHEFE)" if is_boss else ""], dir + "/{idle,move,attack,death}.png", "degrada")
			else:
				_gap("inimigo", id, "sem arte alguma; fase %s%s" % [used[id], " (CHEFE)" if is_boss else ""], dir + "/", "bloqueia")
		elif not missing.is_empty():
			_gap("inimigo", id, "faltam sequências: %s; fase %s" % [", ".join(missing), used[id]], dir, "degrada")

	# --- heróis
	for h in heroes:
		var d := "res://assets/animations/heroes/%s" % h
		var miss: Array = []
		for seq in ["idle", "attack", "active", "death", "move_n", "move_ne", "move_e", "move_se", "move_s"]:
			if not _exists("%s/%s.png" % [d, seq]):
				miss.append(seq)
		if not miss.is_empty():
			_gap("heroi_anim", h, "faltam: %s" % ", ".join(miss), d, "degrada")
		for p in ["res://assets/heroes/%s.png" % h, "res://assets/portraits/%s.png" % h]:
			if not _exists(p):
				_gap("heroi_arte", h, "arquivo ausente", p, "degrada")

	# --- ícones
	var abilities: Dictionary = Data.table("abilities")
	for h in abilities:
		var aid := String(abilities[h].get("id", ""))
		if not _exists("res://assets/icons/abilities/%s.png" % aid):
			_gap("icone_habilidade", aid, "habilidade ativa de %s" % h, "res://assets/icons/abilities/%s.png" % aid, "degrada")
	for b in Data.table("boons").get("boons", []):
		if not _exists("res://assets/icons/boons/%s.png" % String(b.id)):
			_gap("icone_bencao", String(b.id), "bênção de %s sem ícone próprio" % String(b.get("god", "?")), "res://assets/icons/boons/%s.png" % String(b.id), "cosmetico")
	var passives: Dictionary = Data.table("passives")
	for p in passives:
		if not _exists("res://assets/icons/passives/%s.png" % p):
			_gap("icone_passiva", String(p), "passiva sem ícone", "res://assets/icons/passives/%s.png" % p, "cosmetico")
	var weapons: Dictionary = Data.table("weapons")
	for w in weapons:
		if String(w).begins_with("_"):
			continue
		if not _exists("res://assets/icons/weapons/%s.png" % w):
			_gap("icone_arma", String(w), "arma sem ícone próprio", "res://assets/icons/weapons/%s.png" % w, "cosmetico")
	var items: Dictionary = Data.table("items")
	for slot in items.get("bases", {}):
		for b in items.bases[slot]:
			if not _exists("res://assets/icons/items/%s.png" % String(b.id)):
				_gap("icone_item_base", String(b.id), "base de %s sem ícone" % slot, "res://assets/icons/items/%s.png" % String(b.id), "cosmetico")
	for u in items.get("uniques", []):
		if not _exists("res://assets/icons/items/%s.png" % String(u.id)):
			_gap("icone_item_unico", String(u.id), "item único sem ícone próprio (slot %s)" % String(u.get("slot", "?")), "res://assets/icons/items/%s.png" % String(u.id), "cosmetico")

	# --- fases (inclui protótipo)
	var manifest: Dictionary = Data.table("audio_manifest")
	var music: Dictionary = manifest.get("music", {})
	var ambience: Dictionary = manifest.get("ambience", {})
	var decals: Dictionary = Data.table("ground_decals")
	var chron: Dictionary = Data.table("chronicles")
	var story: Dictionary = Data.table("stage_story")
	var rules: Dictionary = Data.table("stage_rules")
	var sevents: Dictionary = Data.table("stage_events")
	var atmo: Dictionary = Data.table("atmosphere")
	var scenery: Dictionary = Data.table("scenery")
	var bosspres: Dictionary = Data.table("boss_presentations")
	for sid in stage_ids:
		if not music.has(sid):
			_gap("fase_audio", sid, "sem música no audio_manifest", "assets/audio/music/%s.wav + manifest.music.%s" % [sid, sid], "degrada")
		elif not _exists(String(music[sid].get("file", music[sid])) if music[sid] is Dictionary else String(music[sid])):
			_gap("fase_audio", sid, "música listada mas arquivo ausente", String(music[sid]), "bloqueia")
		if not ambience.has(sid):
			_gap("fase_audio", sid, "sem ambiência no audio_manifest", "assets/audio/ambience/%s.wav + manifest.ambience.%s" % [sid, sid], "degrada")
		if not decals.has(sid):
			_gap("fase_decais", sid, "sem remendo/trilha de chão (ground_decals.json)", "assets/decals/%s_remendo_01.png, %s_trilha_01.png" % [sid, sid], "cosmetico")
		if not chron.has(sid):
			_gap("fase_texto", sid, "sem crônica de campanha (chronicles.json) — texto, depende de lore aprovada", "data/chronicles.json", "cosmetico")
		if not story.has(sid):
			_gap("fase_texto", sid, "sem stage_story", "data/stage_story.json", "cosmetico")
		if not rules.has(sid):
			_gap("fase_regra", sid, "sem regra de fase (stage_rules.json)", "data/stage_rules.json", "degrada")
		if not sevents.has(sid):
			_gap("fase_eventos", sid, "sem stage_events", "data/stage_events.json", "degrada")
		if not atmo.has(sid):
			_gap("fase_atmosfera", sid, "sem atmosfera", "data/atmosphere.json", "cosmetico")
		if not _exists("res://assets/stages/%s_thumb.png" % sid):
			_gap("fase_thumb", sid, "sem miniatura de seleção", "res://assets/stages/%s_thumb.png" % sid, "degrada")
		if sid in ["docas", "reino_abissal", "domwieck", "raiz_yggdrasil"] and not _exists("res://assets/icons/stages/%s_rule.png" % sid):
			_gap("fase_icone", sid, "sem ícone da regra de fase no HUD (hud.gd mapeia só 7 fases; durao é vazio de propósito)", "res://assets/icons/stages/%s_rule.png" % sid, "cosmetico")
		var has_ground := false
		for suffix in ["_ground.png", "_ground_atlas_v1.png", "_ground_atlas_v2.png", "_ground_atlas_v3.png", "_ground_baked_v1.png"]:
			if _exists("res://assets/tiles/%s%s" % [sid, suffix]):
				has_ground = true
		if not has_ground and not (DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://assets/tiles/%s_r1" % sid)) or DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://assets/tiles/%s_roots_r1" % sid)) or DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://assets/tiles/%s_r1" % sid.trim_prefix("raiz_")))):
			_gap("fase_chao", sid, "sem textura/atlas de chão (provável piso geométrico)", "res://assets/tiles/%s_ground_atlas_v1.png" % sid, "degrada")
		var pres_boss := String(all_stage_defs[sid].get("boss", ""))
		if pres_boss != "" and not bosspres.has(pres_boss):
			_gap("fase_chefe", sid, "chefe %s sem apresentação (boss_presentations.json: cartaz de introdução)" % pres_boss, "assets/ui/boss-intros/%s.png" % pres_boss, "degrada")

	# --- quebráveis temáticos por fase
	for sid in Battle.BREAKABLE_TYPES_BY_STAGE:
		for t in Battle.BREAKABLE_TYPES_BY_STAGE[sid]:
			if not _exists("res://assets/animations/enemies/%s/idle.png" % t) and not _exists("res://assets/enemies/%s.png" % t):
				_gap("quebravel", String(t), "tipo usado em %s sem arte" % sid, "res://assets/animations/enemies/%s/" % t, "degrada")
	for sid in ["reino_abissal", "domwieck", "raiz_yggdrasil"]:
		if not Battle.BREAKABLE_TYPES_BY_STAGE.has(sid):
			_gap("quebravel", sid, "sem quebráveis temáticos dedicados (usa fallback arbusto_quebravel)", "Battle.BREAKABLE_TYPES_BY_STAGE", "cosmetico")

	# --- chefes sem 'special' (mecânica própria L5)
	var mech: Dictionary = Data.table("boss_mechanics")
	for id in mech:
		if String(id).begins_with("_") or not enemies.has(id):
			continue
		if not _exists("res://assets/animations/enemies/%s/special.png" % id) and _exists("res://assets/animations/enemies/%s/idle.png" % id):
			_gap("chefe_special", String(id), "tem mecânica L5 mas sem sequência special.png", "res://assets/animations/enemies/%s/special.png" % id, "cosmetico")

	var f := FileAccess.open(out_path, FileAccess.WRITE)
	f.store_string(JSON.stringify({"total": gaps.size(), "gaps": gaps}, "\t"))
	f.close()
	var by_cat := {}
	for g in gaps:
		by_cat[g.cat] = int(by_cat.get(g.cat, 0)) + 1
	print("ASSET_GAPS total=%d %s" % [gaps.size(), JSON.stringify(by_cat)])
	quit()
