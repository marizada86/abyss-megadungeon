extends RefCounted
## Relato do playtest: o herói morreu com o PNG de apresentação do chefe na tela. A simulação precisa ficar parada enquanto a arte está visível.

func _bat(boss_stage: String) -> Battle:
	var b := Battle.new(105, "durvall", boss_stage)
	b.hero.pos = Vector2(20, 20)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 0.0
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array[String]:
	var failures: Array[String] = []
	var presentations: Dictionary = Data.table("boss_presentations")
	for id in presentations:
		var p: Dictionary = presentations[id]
		var shown := Battle.intro_overlay_seconds(p)
		if shown < 1.5 or shown > 2.0: failures.append(id + ": tempo da arte fora de 1,5 a 2,0 s")
	var b := _bat("dagruve")
	b._director(0.01)
	var intro_ev: Array = b.events.filter(func(ev): return ev.type == "boss_intro")
	if intro_ev.size() != 1:
		failures.append("o chefe da fase deveria abrir a apresentação")
		return failures
	var shown_for := Battle.intro_overlay_seconds(intro_ev[0].presentation)
	if b.boss_intro_remaining < shown_for:
		failures.append("a pausa (%.2f s) termina antes da arte sair da tela (%.2f s)" % [b.boss_intro_remaining, shown_for])
	# Inimigos colados no herói e o chefe em cima dele: nada pode ferir o herói enquanto a arte está visível.
	for i in 6:
		var foe := Enemy.make("zumbi", b.hero.pos + Vector2(0.3 * i, 0.2), 0.0, 1.0, 0)
		b.enemies.append(foe)
	var hp_before := b.hero.hp
	var time_before := b.time
	var elapsed := 0.0
	while elapsed < shown_for - 0.05:
		b.step(Vector2.ZERO, 1.0 / 60.0)
		elapsed += 1.0 / 60.0
		if b.hero.hp < hp_before or b.hero.dead:
			failures.append("o herói levou dano com a arte do chefe na tela (t=%.2f s)" % elapsed)
			break
		if b.time != time_before:
			failures.append("o relógio da fase andou com a arte do chefe na tela (t=%.2f s)" % elapsed)
			break
	return failures
