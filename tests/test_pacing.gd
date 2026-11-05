extends RefCounted
## PACING-AUDIT-20261029 (M2): ampulheta garantida nos mapas longos e proporcional à duração, 1 acontecimento opcional por mapa
## e velocidade liberada depois de vencer qualquer mapa.

func run() -> Array:
	var out: Array = []
	_check_hourglass_guarantee(out)
	_check_hourglass_skip(out)
	_check_optional_happening(out)
	_check_speed_unlock(out)
	_check_bag(out)
	_check_stream(out)
	_check_retry_and_cadence(out)
	_check_service_guarantee(out)
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
	for d in Data.table("stage_events").get("shedaklah", []):
		if String(d.get("pool", "fixed")) != "optional":
			fixed += 1
	for s in 20:
		var picked := Happenings.select("shedaklah", Data.table("stage_events").get("shedaklah", []), 900 + s)
		if picked.size() != fixed + 1:
			out.append("Shedaklah deveria ter os fixos + 1 opcional em toda semente (semente %d veio com %d)" % [900 + s, picked.size()])
			return

func _check_speed_unlock(out: Array) -> void:
	var b := _bat(1, "molor")
	b.cleared_stages = []
	if b.can_speed_2x():
		out.append("sem nenhum mapa vencido a velocidade extra deveria estar bloqueada")
	b.cleared_stages = ["docas"]
	if not b.can_speed_2x():
		out.append("vencer qualquer mapa deveria liberar a velocidade extra nos outros")

func _check_bag(out: Array) -> void:
	var b := _bat(11, "molor")
	var weights: Dictionary = b.stage.interactions
	b._fill_inter_bag(weights)
	var tickets := 0
	for k in weights:
		tickets += maxi(1, int(round(float(weights[k]))))
	if b._inter_bag.size() != tickets:
		out.append("o saco deveria ter %d fichas, tem %d" % [tickets, b._inter_bag.size()])
	for k in weights:
		var n := b._inter_bag.count(String(k))
		if n != maxi(1, int(round(float(weights[k])))):
			out.append("%s: %d fichas no saco, esperado %d" % [k, n, maxi(1, int(round(float(weights[k]))))])

## A sequência de interativos vem de um fluxo próprio: mesma semente, mesmo mapa e mesma ordem, mesmo que o combate consuma a RNG.
func _check_stream(out: Array) -> void:
	var seqs: Array = []
	for variant in 2:
		var b := _bat(21, "molor")
		var seq: Array = []
		for i in 12:
			if variant == 1:
				for j in 7:
					b.rng.randf()   # o combate consumindo a RNG da Battle
			if b._inter_bag.is_empty():
				b._fill_inter_bag(b.stage.interactions)
			seq.append(String(b._inter_bag.pop_front()))
		seqs.append(seq)
	if seqs[0] != seqs[1]:
		out.append("a ordem dos interativos não deveria depender da RNG do combate")

func _check_retry_and_cadence(out: Array) -> void:
	# Mapa longo (>= 300 s): o teto sobe de 3 para 4 vivos; com 3 ainda há vaga, com 4 o sorteio tenta de novo em 8 s.
	var b := _bat(31, "molor")
	for i in 3:
		b._add_interaction("chest", b.hero.pos + Vector2(2 + i, 0))
	b._inter_t = 0.0
	b._spawn_random_interaction()
	if absf(b._inter_t - 8.0) < 0.01:
		out.append("mapa longo com 3 interativos vivos ainda deveria ter vaga (teto 4)")
	b = _bat(31, "molor")
	for i in 4:
		b._add_interaction("chest", b.hero.pos + Vector2(2 + i, 0))
	b._inter_t = 0.0
	b._spawn_random_interaction()
	if absf(b._inter_t - 8.0) > 0.01:
		out.append("sem vaga o sorteio deveria tentar de novo em 8 s, ficou %.1f" % b._inter_t)
	var short := _bat(35, "docas")
	for i in 3:
		short._add_interaction("chest", short.hero.pos + Vector2(2 + i, 0))
	short._inter_t = 0.0
	short._spawn_random_interaction()
	if absf(short._inter_t - 8.0) > 0.01:
		out.append("mapa curto (180 s) deveria manter o teto de 3 interativos vivos, ficou %.1f" % short._inter_t)
	var docas := _bat(32, "docas")
	for i in 20:
		if docas._interaction_interval() < 80.0:
			out.append("mapas de 180 s não devem encurtar o intervalo de interativos")
			break
	var mid := _bat(33, "molor")
	mid.stage.duration = 330.0
	for i in 20:
		var v: float = mid._interaction_interval()
		if v < 44.0 or v > 63.3:
			out.append("mapa de 330 s deveria sortear entre 44 e 63 s, veio %.1f" % v)
			break
	var long := _bat(34, "molor")
	long.stage.duration = 570.0   # o cálculo é por duração; Molor ficou em 360 s na M4
	for i in 20:
		var v: float = long._interaction_interval()
		if v < 76.0 or v > 114.0:
			out.append("mapa de 570 s deveria ficar perto de 76 a 114 s, veio %.1f" % v)
			break

func _services_seen_until(seed_value: int, stage: String, until: float) -> bool:
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
			if Battle.TRUCE_KINDS.has(String(it.kind)):
				seen = true
			it.used = true
		if is_equal_approx(before, b.time):
			break
	return seen

func _check_service_guarantee(out: Array) -> void:
	for s in 8:
		if not _services_seen_until(700 + s, "molor", 330.0):
			out.append("molor (semente %d): deveria sair pelo menos um serviço até o segundo sorteio aleatório" % (700 + s))
