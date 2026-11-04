extends RefCounted
## Plano de evolução de armas (2026-11-04): toda arma que sobe de nível tem evolução alcançável, salvo as exceções declaradas.
## Exceções: armas sem níveis (forma evoluída ou recompensa de uma estrela só, como Domínio da Vontade).

## Armas com níveis que, por decisão do dono, não evoluem. Hoje vazia: nova arma com níveis e sem evolução precisa entrar aqui.
const NO_EVOLUTION: Array = []

func _bat(hero_id: String = "durvall") -> Battle:
	var b := Battle.new(7, hero_id, "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array:
	var out: Array = []
	_coverage(out)
	_new_passives(out)
	_reachable(out)
	run_radiant(out)
	return out

func _coverage(out: Array) -> void:
	var weapons: Dictionary = Data.table("weapons")
	var passives: Dictionary = Data.table("passives")
	var targets := {}
	for wid in weapons:
		var d: Dictionary = weapons[wid]
		if d.has("evolve"):
			targets[String(d.evolve.into)] = String(wid)
	for wid in weapons:
		var d: Dictionary = weapons[wid]
		var has_levels: bool = not d.get("levels", []).is_empty()
		if has_levels and not d.has("evolve") and not NO_EVOLUTION.has(String(wid)):
			out.append("arma %s tem níveis mas não evolui (nem consta em NO_EVOLUTION)" % wid)
		if d.has("evolve"):
			var into := String(d.evolve.into)
			if not has_levels:
				out.append("arma %s evolui mas não tem níveis para chegar ao Nv 5" % wid)
			if not passives.has(String(d.evolve.passive)):
				out.append("arma %s evolui com passiva inexistente %s" % [wid, d.evolve.passive])
			if not weapons.has(into):
				out.append("arma %s evolui para inexistente %s" % [wid, into])
				continue
			var e: Dictionary = weapons[into]
			if not String(e.src).begins_with("Evolu"):
				out.append("evolução %s deveria ter src 'Evolução' (fora das ofertas NOVA)" % into)
			if not e.get("levels", []).is_empty() or e.has("evolve"):
				out.append("evolução %s não deve ter níveis nem nova evolução" % into)
			if not ResourceLoader.exists(Items.weapon_icon(into)):
				out.append("evolução %s sem ícone (própria ou icon_like)" % into)
	# toda forma evoluída é destino de exatamente uma arma base
	for wid in weapons:
		if String(weapons[wid].src).begins_with("Evolu") and not targets.has(String(wid)):
			out.append("forma evoluída %s não é destino de nenhuma arma" % wid)


func _new_passives(out: Array) -> void:
	var passives: Dictionary = Data.table("passives")
	# regra do dono: a exigência de evolução não se repete, sem exceções (a herança de cota_de_malha ×3 e sabedoria ×2 foi desfeita em 2026-11-04).
	var by_passive := {}
	for wid in Data.table("weapons"):
		var ev: Dictionary = Data.table("weapons")[wid].get("evolve", {})
		if not ev.is_empty():
			var pid := String(ev.passive)
			if not by_passive.has(pid):
				by_passive[pid] = []
			by_passive[pid].append(String(wid))
	for pid in by_passive:
		var ws: Array = by_passive[pid]
		if ws.size() > 1:
			out.append("a passiva %s é exigida por mais de uma evolução (%s)" % [pid, ", ".join(ws)])
	# cada passiva do jogo deve servir a alguma evolução
	for pid in passives:
		if not by_passive.has(String(pid)):
			out.append("passiva %s não libera nenhuma evolução" % pid)
	# as passivas novas fazem o que dizem (só chaves que o herói já lê)
	var expected := {"precisao": {"hit": 1.0}, "sede_de_sangue": {"lifesteal": 0.01}, "brasa": {"fire_pct": 0.08}, "ponta_certeira": {"crit_overflow_bonus": 0.02},
		"olhar_abissal": {"area_dmg_pct": 0.06}, "acido": {"dmg_flat": 1.0}, "ventura": {"sorte": 1.0}, "tempo_suspenso": {"cd_pct": 0.04},
		"veu_de_sombras": {"dodge": 0.02}, "memoria_viva": {"xp_pct": 0.04, "eco_xp_pct": 0.03},
		"furia_sombria": {"low_hp_dmg": 0.05}, "fe_radiante": {"radiant_pct": 0.08}, "presenca_dominante": {"cd_pct": 0.03, "hit": 1.0}}
	for pid in expected:
		if not passives.has(pid):
			out.append("passiva nova %s ausente" % pid)
			continue
		for k in expected[pid]:
			if absf(float(passives[pid].mods.get(k, 0.0)) - float(expected[pid][k])) > 0.0001:
				out.append("passiva %s: mod %s deveria ser %s" % [pid, k, expected[pid][k]])
		for k in passives[pid].mods:
			if not Items.MOD_LABELS.has(String(k)):
				out.append("passiva %s usa mod sem rótulo (%s)" % [pid, k])

## Para cada arma base: com Nv 5 e a passiva em mãos (e os atributos mínimos), a oferta de nível traz a evolução e aplicá-la troca a arma.
func _reachable(out: Array) -> void:
	var weapons: Dictionary = Data.table("weapons")
	for wid in weapons:
		var d: Dictionary = weapons[wid]
		if not d.has("evolve"):
			continue
		var b := _bat()
		var w := Weapon.make(String(wid), Weapon.MAX_LEVEL)
		b.hero.weapons = [w]
		b.hero.passives[String(d.evolve.passive)] = 1
		for a in w.evolve_min_attr():
			b.hero.base_attrs[String(a)] = int(w.evolve_min_attr()[a])
		if not w.missing_attrs(b.hero).is_empty():
			out.append("%s: atributo mínimo não aplicável no teste (%s)" % [wid, str(w.missing_attrs(b.hero))])
			continue
		var offered := false
		for _i in 40:
			for o in b._build_offer():
				if String(o.t) == "evolve" and String(o.id) == String(wid) and String(o.into) == String(d.evolve.into):
					offered = true
					break
			if offered:
				break
		if not offered:
			out.append("%s: a evolução %s não apareceu na oferta com Nv 5 + passiva" % [wid, d.evolve.into])
			continue
		b.hero.weapons = [Weapon.make(String(wid), Weapon.MAX_LEVEL)]
		b.state = "levelup"
		b.offer = [{"t": "evolve", "id": String(wid), "into": String(d.evolve.into), "name": "x", "desc": ""}]
		b.choose(0)
		if b.hero.weapons.size() != 1 or b.hero.weapons[0].id != String(d.evolve.into):
			out.append("%s: aplicar a evolução deveria trocar a arma por %s" % [wid, d.evolve.into])

## Fé Radiante só reforça dano radiante (mesma semente: o dado e o acerto são idênticos; muda apenas o multiplicador).
func _dmg_of(weapon_id: String, passive: String) -> float:
	var b := _bat()
	b.hero.pos = Vector2(20, 20)
	b.hero.weapons = [Weapon.make(weapon_id)]
	if passive != "":
		b.hero.passives[passive] = 5
	b.hero.recalc()
	var foe: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.0, 0))
	foe.max_hp = 1.0e9
	foe.hp = 1.0e9
	b._hero_hit(foe, b.hero.weapons[0].params(), true)
	return 1.0e9 - foe.hp

func run_radiant(out: Array) -> void:
	var plain := _dmg_of("martelo_da_gloria", "")
	var boosted := _dmg_of("martelo_da_gloria", "fe_radiante")
	if plain <= 0.0:
		out.append("o golpe de teste errou o alvo: troque a semente do teste")
	elif boosted <= plain:
		out.append("Fé Radiante deveria aumentar o dano de uma arma radiante (%s -> %s)" % [plain, boosted])
	var fire_plain := _dmg_of("tocha_do_incendiario", "")
	var fire_boosted := _dmg_of("tocha_do_incendiario", "fe_radiante")
	if absf(fire_plain - fire_boosted) > 0.001:
		out.append("Fé Radiante não deveria mexer no dano de fogo (%s -> %s)" % [fire_plain, fire_boosted])
