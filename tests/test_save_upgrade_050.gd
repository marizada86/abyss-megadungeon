extends RefCounted
## Atualização de save 0.4.0 -> 0.5.0 com perfil SINTÉTICO no esquema 0.4.0 (nunca o save real):
## preserva progresso, IDs e ajustes; acrescenta os campos novos; mantém o acesso que o jogador já tinha.

func _save_040() -> Dictionary:
	# Esquema da 0.4.0: sem campaign_progress e sem visual_filter/ui_font/atmosphere/hints em settings.
	return {"name": "Sintetico", "coins": 1234, "upgrades": {"vigor": 2, "forca": 1}, "achievements": {"primeiro_sangue": true},
		"cleared": {"dagruve": true, "shedaklah": true, "molor": true}, "hqs_seen": {"hqn_01": true, "hqn_02": true},
		"ecos": {"dagruve": [0, 2]}, "relics": {"dagruve": true}, "welcome_seen": true,
		"stats": {"kills_total": 5120, "gold_total": 900, "chests_total": 31, "bosses_total": 3, "elites_total": 40, "boss_kills": {"sacerdote_mente_derretida": 2},
			"heroes_played": {"durvall": 7, "korrak": 2}, "reached": {"dagruve": 7, "docas": 4, "shedaklah": 2}, "runs": 9, "deaths": 6, "best_time": {"dagruve": 301.5}},
		"codex": {"enemies": {"zumbi": true}, "items": {"adaga": true}, "weapons": {"espada_sombria": true}},
		"settings": {"aim": "mouse", "volume": 0.5, "music_volume": 0.4, "sfx_volume": 0.6, "ambience_volume": 0.3, "music_muted": true, "sfx_muted": false,
			"ambience_muted": false, "window_mode": "borderless", "resolution": "1920x1080", "fullscreen": false, "difficulty": 2, "abyss_marks": {}}}

func _canon(v: Variant) -> Variant:
	# JSON devolve todo número como float; normaliza inteiros para comparar perfis antes/depois do disco.
	if v is Dictionary:
		var d := {}
		for k in v:
			d[k] = _canon(v[k])
		return d
	if v is Array:
		var a := []
		for x in v:
			a.append(_canon(x))
		return a
	if v is float and is_equal_approx(v, roundf(v)):
		return int(roundf(v))
	return v

func _json(v: Variant) -> String:
	return JSON.stringify(_canon(v), "", true)

func run() -> Array:
	var out: Array = []
	var old := _save_040()
	var snapshot := _json(old)
	var p := Profile.new(old.duplicate(true))
	var d: Dictionary = p.data

	# 1) nada do que o jogador tinha se perde
	for key in ["name", "coins", "upgrades", "achievements", "hqs_seen", "ecos", "relics", "welcome_seen", "stats", "codex"]:
		if _json(d.get(key)) != _json(old[key]):
			out.append("campo %s mudou na atualização: %s" % [key, _json(d.get(key))])
	for key in old.settings:
		if key == "fullscreen":
			continue   # derivado de window_mode
		if _json(d.settings.get(key)) != _json(old.settings[key]):
			out.append("ajuste %s mudou: %s -> %s" % [key, str(old.settings[key]), str(d.settings.get(key))])
	if _json(old) != snapshot:
		out.append("a migração alterou o dicionário de origem")

	# fases vencidas: nada some; a regra antiga (vencer Dagruve abre Docas) pode acrescentar Docas
	for id in old.cleared:
		if not d.cleared.has(id):
			out.append("fase vencida perdida na atualização: %s" % id)
	if not d.cleared.has("docas"):
		out.append("Dagruve vencida deveria deixar Docas como vencida (regra legada)")

	# 2) campos novos entram com os padrões
	for pair in [["visual_filter", "off"], ["ui_font", "fell"], ["atmosphere", "leve"], ["hints", "on"]]:
		if str(d.settings.get(pair[0], "")) != pair[1]:
			out.append("padrão novo ausente: settings.%s" % pair[0])
	if not d.settings.get("hints_seen", null) is Dictionary:
		out.append("settings.hints_seen deveria ser dicionário")

	# 3) campanha: perfil legado recebe progresso e não perde acesso
	var cp: Dictionary = d.get("campaign_progress", {})
	if int(cp.get("version", 0)) != 1:
		out.append("campaign_progress não foi criado")
	if not cp.get("milestones", {}).has("docas_cleared"):
		out.append("legado com Dagruve vencida deveria marcar Docas como vencida")
	if not cp.get("presentation_done", {}).has("hqn_01"):
		out.append("HQ de abertura deveria constar como já apresentada no legado")
	var stages: Dictionary = Data.table("stages")
	var cleared: Dictionary = old.cleared.duplicate()
	cleared["docas"] = true   # regra antiga: vencer Dagruve abre Docas
	for id in ["dagruve", "docas", "shedaklah", "molor", "durao"]:
		var req := String(stages[id].get("unlock", "start"))
		var had_access: bool = req == "start" or cleared.has(req) or id == "dagruve"
		if had_access and not p.stage_unlocked(id):
			out.append("acesso perdido na atualização: %s" % id)
	for id in old.hqs_seen:
		if not Data.table("hqs").has(id):
			out.append("HQ vista não existe mais no catálogo: %s" % id)

	# 4) idempotência e ida-e-volta por JSON (como o Game salva e carrega)
	var again := Profile.new(d.duplicate(true))
	if _json(again.data) != _json(d):
		out.append("migrar duas vezes mudou o perfil")
	var parsed: Variant = JSON.parse_string(JSON.stringify(d))
	if not parsed is Dictionary or _json(Profile.new(parsed).data) != _json(Profile.new(d.duplicate(true)).data):
		out.append("o perfil não sobrevive à ida-e-volta por JSON")

	# 5) perfil novo não é tratado como legado
	var fresh := Profile.new({})
	if not fresh.data.campaign_progress.legacy_stage_access.is_empty():
		out.append("perfil novo não deveria ter acesso legado")
	if String(fresh.data.campaign_progress.next_stage) != "docas":
		out.append("perfil novo deveria começar em Docas")
	if not fresh.stage_unlocked("docas"):
		out.append("perfil novo deveria poder jogar Docas")
	if fresh.stage_unlocked("domwieck"):
		out.append("perfil novo não deveria ter Domwieck aberta")

	# 6) valores inválidos nos ajustes novos voltam ao padrão sem derrubar o perfil
	var bad := _save_040()
	bad.settings["visual_filter"] = "lixo"
	bad.settings["atmosphere"] = 7
	bad.settings["hints"] = "talvez"
	bad.settings["hints_seen"] = "x"
	var q := Profile.new(bad)
	if q.data.settings.visual_filter != "off" or q.data.settings.atmosphere != "leve" or q.data.settings.hints != "on" or not q.data.settings.hints_seen is Dictionary:
		out.append("ajustes inválidos deveriam voltar ao padrão")
	return out
