extends SceneTree
## Bot de balanceamento headless (somente leitura do runtime; não altera dados do jogo).
## Uso: godot --headless --path . --script res://.atena/generated/balance-bots-20261018/bot.gd -- \
##   --out <arquivo.jsonl> --heroes a,b --stages x,y --seeds 1,2,3 --policy kite|idle [--dt 0.0166667]
## Um registro JSON por linha. Nenhum save é lido: Battle.new recebe contexto sintético vazio.

const DT_DEFAULT := 1.0 / 60.0
var retreat_close := 0.45   # mortal: 1.2 (recua de quem está colado); god: 0.45 (luta de perto)
const OBJ_LEAD := 120.0   # segundos antes do fim do cronômetro em que o bot começa a seguir para o objetivo

func _init() -> void:
	call_deferred("_run")

func _arg(key: String, fallback: String) -> String:
	var args := OS.get_cmdline_user_args()
	var at := args.find(key)
	return args[at + 1] if at >= 0 and at + 1 < args.size() else fallback

func _run() -> void:
	var out_path := _arg("--out", "")
	var heroes: PackedStringArray = _arg("--heroes", "durvall").split(",", false)
	var stages: PackedStringArray = _arg("--stages", "dagruve").split(",", false)
	var seeds: PackedStringArray = _arg("--seeds", "1").split(",", false)
	var policy := _arg("--policy", "kite")
	var dt := float(_arg("--dt", str(DT_DEFAULT)))
	var f := FileAccess.open(out_path, FileAccess.WRITE)
	for h in heroes:
		for s in stages:
			for sd in seeds:
				var rec := _play(h, s, int(sd), policy, dt)
				f.store_line(JSON.stringify(rec))
				f.flush()
	f.close()
	quit()

func _kite_dir(b: Battle, objective_mode: bool) -> Vector2:
	var hp: Vector2 = b.hero.pos
	var push := Vector2.ZERO
	for e in b.enemies:
		if e.dead:
			continue
		var d: Vector2 = hp - e.pos
		var dist := d.length()
		if dist < 7.0 and dist > 0.001:
			push += d / (dist * dist) * (3.0 if e.is_boss() else 1.0)
	# parede: empurra para dentro
	var m := 4.0
	var ms: Vector2 = b.map_size
	if hp.x < m: push.x += (m - hp.x) * 0.3
	if hp.x > ms.x - m: push.x -= (hp.x - (ms.x - m)) * 0.3
	if hp.y < m: push.y += (m - hp.y) * 0.3
	if hp.y > ms.y - m: push.y -= (hp.y - (ms.y - m)) * 0.3
	# evita ficar preso nas bordas: puxa levemente ao centro
	push += (ms * 0.5 - hp) * 0.004
	if objective_mode:
		if TerrainLayout.has_roots(b.stage_id):
			# mapas de raízes: segue o campo de navegação do jogo (caminho caminhável até o alvo)
			var rd: Vector2 = b._root_direction(hp, b.objective_target(), Hero.RADIUS)
			if rd.length() < 0.02:
				return Vector2.ZERO
			var rscr := Iso.to_screen(rd.normalized())
			return rscr.normalized() if rscr != Vector2.ZERO else Vector2.ZERO
		var to_t: Vector2 = b.objective_target() - hp
		if to_t.length() > 0.6:
			push = push * 0.35 + to_t.normalized() * 1.2
		else:
			push = Vector2.ZERO
	if push.length() < 0.02:
		return Vector2.ZERO
	var scr := Iso.to_screen(push.normalized())
	return scr.normalized() if scr != Vector2.ZERO else Vector2.ZERO

func _brawl_dir(b: Battle, objective_mode: bool) -> Vector2:
	# aproxima do inimigo mais próximo quando saudável; recua se PV < 45 %; ignora chefe a distância curta
	var hp: Vector2 = b.hero.pos
	var frac: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
	var best: Enemy = null
	var best_d := 1e9
	for e in b.enemies:
		if e.dead:
			continue
		var dd: float = hp.distance_to(e.pos)
		if dd < best_d:
			best_d = dd
			best = e
	if objective_mode:
		return _kite_dir(b, true)
	if best == null:
		return _kite_dir(b, false)
	if frac < 0.45 or best_d < 1.2:
		return _kite_dir(b, false)
	var to_e: Vector2 = best.pos - hp
	var scr := Iso.to_screen(to_e.normalized())
	return scr.normalized() if scr != Vector2.ZERO else Vector2.ZERO

func _nearest_enemy(b: Battle) -> Enemy:
	var best: Enemy = null
	var best_d := 1e9
	for e in b.enemies:
		if e.dead:
			continue
		var dd: float = b.hero.pos.distance_to(e.pos)
		if dd < best_d:
			best_d = dd
			best = e
	return best

## "smart": como o brawl, mas coleta XP/moedas quando não há inimigo perto e usa a habilidade ativa.
func _smart_dir(b: Battle, objective_mode: bool) -> Vector2:
	if objective_mode:
		return _kite_dir(b, true)
	var hp: Vector2 = b.hero.pos
	var frac: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
	var near := _nearest_enemy(b)
	var near_d: float = hp.distance_to(near.pos) if near != null else 1e9
	if frac < 0.45 or near_d < retreat_close:
		return _kite_dir(b, false)
	if near_d > 3.5 and not b.pickups.is_empty():
		var pk: Dictionary = {}
		var pk_d := 14.0
		for p in b.pickups:
			var d: float = p.pos.distance_to(hp)
			if d < pk_d:
				pk_d = d
				pk = p
		if not pk.is_empty():
			var scr_p := Iso.to_screen((pk.pos - hp).normalized())
			return scr_p.normalized() if scr_p != Vector2.ZERO else Vector2.ZERO
	if near == null:
		return _kite_dir(b, false)
	var scr := Iso.to_screen((near.pos - hp).normalized())
	return scr.normalized() if scr != Vector2.ZERO else Vector2.ZERO

## Escolha de oferta para jogador razoável: evolução > sinergia > subir arma > arma nova > passiva > resto (bênção sem dano negativo).
func _pick_offer(b: Battle, rng: RandomNumberGenerator) -> int:
	var best := 0
	var best_score := -1e9
	for i in b.offer.size():
		var c: Dictionary = b.offer[i]
		var s := rng.randf()   # desempate aleatório
		match String(c.get("t", "")):
			"evolve": s += 100.0
			"synergy_activate": s += 90.0
			"weapon_up": s += 80.0
			"weapon_new": s += 60.0
			"passive": s += 50.0
			"boon":
				var mods: Dictionary = c.get("boon", {}).get("mods", {})
				s += 40.0 + 20.0 * float(mods.get("dmg_pct", 0.0)) + 10.0 * float(mods.get("hp", 0.0)) / 20.0
			"boon_skip": s += 5.0
			"heal": s += 30.0 * (1.0 - b.hero.hp / maxf(1.0, b.hero.max_hp))
			"gold": s += 2.0
			_: s += 20.0
		if s > best_score:
			best_score = s
			best = i
	return best

func _maybe_active(b: Battle) -> void:
	if b.active_cd > 0.0 or b.state != "running":
		return
	var near := _nearest_enemy(b)
	var frac: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
	var count := 0
	for e in b.enemies:
		if not e.dead and b.hero.pos.distance_to(e.pos) < 4.0:
			count += 1
	if count >= 3 or (near != null and b.hero.pos.distance_to(near.pos) < 2.5 and frac < 0.7):
		var to := (near.pos - b.hero.pos).normalized() if near != null else Vector2.ZERO
		b.use_active(to)

func _play(hero_id: String, stage_id: String, seed_value: int, policy: String, dt: float) -> Dictionary:
	var chain := policy.ends_with("-chain")
	policy = policy.trim_suffix("-chain")
	var god := policy.ends_with("-god")
	policy = policy.trim_suffix("-god")
	var boss_kill_time := -1.0
	retreat_close = 0.45 if god else 1.2
	var b := Battle.new(seed_value, hero_id, stage_id)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 7919 + 13
	var dur := float(b.stage.get("duration", 360))
	var reach := b.has_reach_objective()
	var min_hp := 1.0
	var peak_enemies := 0
	var max_dmg_window := 0.0
	var outcome := "timeout"
	var levelups := 0
	var offers := 0
	var wall_start := Time.get_ticks_msec()
	var clear_time := -1.0
	var boss_time := -1.0
	var steps := 0
	var revives := 0
	var hp_hist: Array = []   # amostra a cada 30 s: [t, hp_frac, enemies, level]
	var next_sample := 0.0
	var dmg_prev := 0.0
	var segments: Array = []
	var seg_t0 := 0.0
	var seg_dmg0 := 0.0
	var seg_k0 := 0
	var seg_stage := stage_id
	var seg_min_hp := 1.0
	while true:
		match b.state:
			"levelup", "altar", "item_offer":
				offers += 1
				if b.state == "levelup":
					levelups += 1
				var n := b.offer.size()
				if n == 0:
					b.state = "running"
				elif policy == "idle":
					b.choose(0)
				else:
					b.choose(_pick_offer(b, rng) if policy == "smart" else rng.randi_range(0, n - 1))
			"shop":
				b.state = "running"
				b.offer.clear()
			"evolve_cine":
				b.skip_cine()
			"revive_offer":
				if b.accept_revive():
					revives += 1
				else:
					b.decline_revive()
			"dead":
				outcome = "dead"
				break
			"won":
				outcome = "won"
				clear_time = b.run_time
				break
		if b.state == "dead" or b.state == "won":
			continue
		if b.stage_cleared:
			segments.append({"stage": seg_stage, "result": "cleared", "t": snappedf(b.run_time - seg_t0, 0.1), "damage": snappedf(float(b.stats.damage_taken) - seg_dmg0, 0.1), "kills": int(b.stats.kills) - seg_k0, "level": b.hero.level, "min_hp": snappedf(seg_min_hp, 0.01), "boss_kill": snappedf(boss_kill_time, 0.1), "max_hp": snappedf(b.hero.max_hp, 0.1)})
			if chain and String(b.stage.get("next", "")) != "" and segments.size() < 8:
				b.enter_next_stage()
				b.events.clear()
				seg_t0 = b.run_time
				seg_dmg0 = float(b.stats.damage_taken)
				seg_k0 = int(b.stats.kills)
				seg_stage = b.stage_id
				seg_min_hp = 1.0
				dur = float(b.stage.get("duration", 360))
				reach = b.has_reach_objective()
				boss_kill_time = -1.0
				boss_time = -1.0
				peak_enemies = 0
				continue
			outcome = "cleared"
			clear_time = b.run_time - seg_t0
			break
		if b.run_time - seg_t0 > dur + 360.0:
			break
		var dir := Vector2.ZERO
		if policy == "kite":
			dir = _kite_dir(b, reach and b.time >= dur - OBJ_LEAD)
		elif policy == "brawl":
			dir = _brawl_dir(b, reach and b.time >= dur - OBJ_LEAD)
		elif policy == "smart":
			dir = _smart_dir(b, reach and b.time >= dur - OBJ_LEAD)
			_maybe_active(b)
		if god and not b.hero.dead:
			b.hero.hp = b.hero.max_hp
		b.step(dir, dt)
		if b.boss_dead and boss_kill_time < 0.0:
			boss_kill_time = b.run_time
		b.events.clear()
		steps += 1
		if b.boss != null and boss_time < 0.0:
			boss_time = b.run_time
		min_hp = minf(min_hp, b.hero.hp / maxf(1.0, b.hero.max_hp))
		seg_min_hp = minf(seg_min_hp, b.hero.hp / maxf(1.0, b.hero.max_hp))
		peak_enemies = maxi(peak_enemies, b.enemies.size())
		if b.run_time >= next_sample:
			next_sample += 30.0
			hp_hist.append([snappedf(b.run_time, 0.1), snappedf(b.hero.hp / maxf(1.0, b.hero.max_hp), 0.01), b.enemies.size(), b.hero.level, snappedf(float(b.stats.damage_taken), 0.1), int(b.stats.kills)])
	if segments.is_empty() or String(segments[-1].stage) != seg_stage or outcome != "cleared":
		segments.append({"stage": seg_stage, "result": outcome, "t": snappedf(b.run_time - seg_t0, 0.1), "damage": snappedf(float(b.stats.damage_taken) - seg_dmg0, 0.1), "kills": int(b.stats.kills) - seg_k0, "level": b.hero.level, "min_hp": snappedf(seg_min_hp, 0.01), "boss_kill": snappedf(boss_kill_time, 0.1), "max_hp": snappedf(b.hero.max_hp, 0.1)})
	return {
		"chain": chain, "segments": segments,
		"hero": hero_id, "stage": stage_id, "seed": seed_value, "policy": policy,
		"outcome": outcome, "run_time": snappedf(b.run_time, 0.1), "stage_duration": dur,
		"end_pos": [snappedf(b.hero.pos.x, 0.1), snappedf(b.hero.pos.y, 0.1)], "target": ([b.objective_target().x, b.objective_target().y] if reach else []), "presence": b.objective_presence, "map": [b.map_size.x, b.map_size.y], "god": god, "boss_kill_time": snappedf(boss_kill_time, 0.1), "clear_time": snappedf(clear_time, 0.1), "boss_time": snappedf(boss_time, 0.1),
		"level": b.hero.level, "levelups": levelups, "offers": offers, "revives": revives,
		"kills": int(b.stats.kills), "elites": int(b.stats.elites), "gold": snappedf(float(b.stats.gold), 0.1),
		"damage_taken": snappedf(float(b.stats.damage_taken), 0.1), "min_hp_frac": snappedf(min_hp, 0.01),
		"max_hp": snappedf(b.hero.max_hp, 0.1), "peak_enemies": peak_enemies,
		"death_reason": b.death_reason, "reach": reach, "steps": steps,
		"wall_ms": Time.get_ticks_msec() - wall_start, "hist": hp_hist,
	}
