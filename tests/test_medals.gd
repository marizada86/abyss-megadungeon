extends RefCounted
## Medalhas do Quartel: abates, abates simultâneos, tempo (chefe ou objetivo) e o feito sem dano.

func run() -> Array:
	var out: Array = []
	var p := Profile.new()
	if p.stage_medal("dagruve") != "" or not p.data.has("medals"):
		out.append("perfil novo não deveria ter medalhas")
	var limits: Dictionary = p.medal_thresholds("dagruve")
	var lo: Array = limits.kills
	var gained := p.apply_medals({"dagruve": {"kills": int(lo[0]), "multi": 0, "seconds": 9999.0, "intact": false}})
	if p.medal_tier("dagruve", "kills") != 1 or p.stage_medal("dagruve") != "bronze" or gained.size() != 1:
		out.append("abates no primeiro limiar deveriam dar bronze: %s %s" % [p.stage_medal("dagruve"), str(gained)])
	# o melhor de cada métrica persiste; tempo menor é melhor; resultado pior não rebaixa
	p.apply_medals({"dagruve": {"kills": int(limits.kills[2]), "multi": int(limits.multi[1]), "seconds": float(limits.seconds[2]), "intact": false}})
	p.apply_medals({"dagruve": {"kills": 1, "multi": 1, "seconds": 9999.0, "intact": false}})
	if p.medal_tier("dagruve", "kills") != 3 or p.medal_tier("dagruve", "multi") != 2 or p.medal_tier("dagruve", "seconds") != 3:
		out.append("melhores marcas deveriam persistir (abates 3, simultâneos 2, tempo 3)")
	if p.stage_medal("dagruve") != "ouro":
		out.append("a maior medalha do cartão deveria ser ouro, veio '%s'" % p.stage_medal("dagruve"))
	var again := p.apply_medals({"dagruve": {"kills": int(limits.kills[2]), "multi": int(limits.multi[1]), "seconds": float(limits.seconds[2]), "intact": false}})
	if not again.is_empty():
		out.append("repetir a mesma marca não deveria dar medalha nova")
	# sem dano é a medalha especial e nunca se perde
	var intact := p.apply_medals({"dagruve": {"kills": 0, "multi": 0, "seconds": 9999.0, "intact": true}})
	if p.stage_medal("dagruve") != "especial" or intact.size() != 1 or intact[0].metric != "intact":
		out.append("run sem dano deveria dar a medalha especial: %s" % str(intact))
	p.apply_medals({"dagruve": {"kills": 0, "multi": 0, "seconds": 9999.0, "intact": false}})
	if p.stage_medal("dagruve") != "especial":
		out.append("a medalha especial não pode ser perdida por uma run com dano")
	# fase por objetivo não tem medalha de tempo; só a fase com chefe
	if p.medal_metrics("reino_abissal").has("seconds") or not p.medal_metrics("dagruve").has("seconds"):
		out.append("medalha de tempo só deveria existir em fases com chefe")
	# persistência e apply_run: salvo em JSON sem valores inválidos
	var q := Profile.new(JSON.parse_string(JSON.stringify(p.data)))
	if q.stage_medal("dagruve") != "especial":
		out.append("as medalhas deveriam sobreviver ao salvar/carregar")
	var summary := Profile.new().apply_run({"won": true, "dead": false, "extracted": false, "time": 500.0, "kills": 10, "gold": 0, "level": 3, "stage": "dagruve", "hero": "durvall", "bosses": 0,
		"boss_ids": [], "elites": 0, "crits": 0, "ones": 0, "chests": 0, "stages_cleared": 0, "stage_ids": ["dagruve"], "cleared_ids": [], "final_victory": false, "weapons": [],
		"codex": {"enemies": {}, "items": {}, "weapons": {}}, "stage_medals": {"dagruve": {"kills": 10, "multi": 1, "seconds": 5.0, "intact": true}}})
	if not summary.has("medals") or summary.medals.is_empty():
		out.append("apply_run deveria devolver as medalhas ganhas")
	# Battle: abates (e rajada) contados por fase; dano tira o "sem dano"
	var clean := Battle.new(1, "durvall", "dagruve")
	for n in 3:
		clean._kill(clean.spawn_for_test("zumbi", clean.hero.pos + Vector2(3 + n, 0)))
	clean.boss_dead = true
	clean.time = float(clean.stage.duration) + 42.0
	if not clean.complete_stage("boss"):
		out.append("a fase deveria concluir com o chefe morto")
	var record: Dictionary = clean.result().stage_medals.get("dagruve", {})
	if int(record.get("kills", 0)) != 3 or int(record.get("multi", 0)) != 3 or not bool(record.get("intact", false)) or absf(float(record.get("seconds", 0.0)) - 42.0) > 0.11:
		out.append("registro de medalha da fase incorreto: %s" % str(record))
	var hurt := Battle.new(1, "durvall", "dagruve")
	hurt._hurt_hero(3.0, "teste")
	hurt.boss_dead = true
	hurt.complete_stage("boss")
	if bool(hurt.result().stage_medals.get("dagruve", {}).get("intact", true)):
		out.append("tomar dano deveria tirar o sem dano")
	if Profile.new().medal_lines("dagruve").size() != 4 or Profile.new().medal_lines("reino_abissal").size() != 3:
		out.append("o painel deveria listar 4 linhas com chefe e 3 por objetivo")
	return out
