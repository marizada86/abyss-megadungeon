extends RefCounted
## PACING-AUDIT-20261029 (M2): ampulheta garantida nos mapas longos e proporcional à duração, 1 acontecimento opcional por mapa
## e velocidade liberada depois de vencer qualquer mapa.

func run() -> Array:
	var out: Array = []
	_check_hourglass_guarantee(out)
	_check_hourglass_skip(out)
	_check_optional_happening(out)
	_check_speed_unlock(out)
	return out

func _bat(seed_value: int, stage: String) -> Battle:
	var b := Battle.new(seed_value, "durvall", stage)
	b.hero.pos = Vector2(20, 20)
	b.hero.max_hp = 1.0e9
	b.hero.hp = 1.0e9
	b.stage.waves = []
	b.stage.elites = []
	return b

func _hourglass_seen_until(seed_value: int, stage: String, until: float) -> bool:
	var b := _bat(seed_value, stage)
	var seen := false
	while b.time < until:
		var before := b.time
		b.step(Vector2.ZERO, 0.5)
		b.hero.hp = b.hero.max_hp
		b.hero.dead = false
		if b.state == "evolve_cine":
			b.skip_cine()
		if b.state != "running":
			b.offer = []
			b.offer_kind = ""
			b.state = "running"
		for it in b.interactions:
			if String(it.kind) == "ampulheta":
				seen = true
			it.used = true   # coleta tudo para o teto de interativos vivos não interferir
		if is_equal_approx(before, b.time):
			break
	return seen

func _check_hourglass_guarantee(out: Array) -> void:
	for s in 8:
		if not _hourglass_seen_until(500 + s, "molor", 200.0):
			out.append("molor (semente %d): a ampulheta deveria vir garantida no primeiro sorteio aleatório (cerca de 140 s)" % (500 + s))
	# mapa curto não é forçado: o baú fixo e no máximo um sorteio cabem em 180 s
	var short := _bat(7, "docas")
	if short._inter_rolls != 0:
		out.append("o contador de sorteios deveria começar em zero")

func _check_hourglass_skip(out: Array) -> void:
	var long := _bat(3, "molor")
	long.time = 30.0
	long._add_interaction("ampulheta", long.hero.pos + Vector2(0.5, 0.0))
	long.interactions[long.interactions.size() - 1].born_at = -5.0
	long.interact()
	var want := 30.0 + float(long.stage.duration) * 0.2
	if absf(long.time - want) > 1.0:
		out.append("a ampulheta de Molor deveria adiantar 20%% da duração (tempo %.1f, esperado %.1f)" % [long.time, want])

func _check_optional_happening(out: Array) -> void:
	var fixed := 0
	for d in Data.table("stage_events").get("molor", []):
		if String(d.get("pool", "fixed")) != "optional":
			fixed += 1
	for s in 20:
		var picked := Happenings.select("molor", Data.table("stage_events").get("molor", []), 900 + s)
		if picked.size() != fixed + 1:
			out.append("Molor deveria ter os fixos + 1 opcional em toda semente (semente %d veio com %d)" % [900 + s, picked.size()])
			return

func _check_speed_unlock(out: Array) -> void:
	var b := _bat(1, "molor")
	b.cleared_stages = []
	if b.can_speed_2x():
		out.append("sem nenhum mapa vencido a velocidade extra deveria estar bloqueada")
	b.cleared_stages = ["docas"]
	if not b.can_speed_2x():
		out.append("vencer qualquer mapa deveria liberar a velocidade extra nos outros")
