extends RefCounted
## Lote 3, só código: indicador da Maré, brilho da barra de XP e o dtype nos eventos de dano ao herói.
func run() -> Array[String]:
	var out: Array[String] = []
	if HeroPanel.tide_text(0.0) != "" or HeroPanel.tide_text(-0.1) != "": out.append("sem bônus não há indicador")
	if HeroPanel.tide_text(0.06) != "Maré +6%" or HeroPanel.tide_text(0.10) != "Maré +10%": out.append("texto do indicador")
	for t in [0.0, 0.4, 1.7, 99.0]:
		var a := HeroPanel.tide_alpha(t, false)
		if a < 0.55 or a > 1.0: out.append("opacidade do indicador fora de 0,56..1")
	if HeroPanel.tide_alpha(3.3, true) != 1.0: out.append("impacto reduzido deveria deixar o indicador parado")
	var battle := Battle.new(811, "durvall", "dagruve")
	if battle.tide_xp_bonus() != 0.0: out.append("a run começa sem Maré")
	battle._tide_buffs.append(battle.time + 5.0)
	if HeroPanel.tide_text(battle.tide_xp_bonus()) != "Maré +2%": out.append("um marco = +2%")
	# o dtype chega ao evento hurt; sem dado fica vazio
	var got := ""
	for i in 60:
		battle.events.clear()
		battle.invuln = 0.0
		battle.hero.hp = battle.hero.max_hp
		battle._enemy_hit_hero(8, "1d4", "magico", false)
		for e in battle.events:
			if String(e.get("type", "")) == "hurt": got = String(e.get("dtype", "x"))
		if got != "": break
	if got != "magico": out.append("o evento hurt deveria trazer o dtype (%s)" % got)
	battle.events.clear()
	battle.invuln = 0.0
	battle._hurt_hero(3.0, "trap")
	var plain := "x"
	for e in battle.events:
		if String(e.get("type", "")) == "hurt": plain = String(e.get("dtype", "x"))
	if plain != "": out.append("sem dtype conhecido o evento deveria trazer vazio (%s)" % plain)
	return out
