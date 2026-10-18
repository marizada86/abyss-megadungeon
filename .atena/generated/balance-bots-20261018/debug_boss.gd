extends SceneTree
## Sonda: acompanha o chefe depois do spawn (god + smart). Uso: ... -- --hero brook --stage dagruve --seed 1

func _init() -> void:
	call_deferred("_run")

func _arg(key: String, fallback: String) -> String:
	var args := OS.get_cmdline_user_args()
	var at := args.find(key)
	return args[at + 1] if at >= 0 and at + 1 < args.size() else fallback

func _run() -> void:
	var bot = load("res://.atena/generated/balance-bots-20261018/bot.gd").new()
	var b := Battle.new(int(_arg("--seed", "1")), _arg("--hero", "brook"), _arg("--stage", "dagruve"))
	bot.retreat_close = 0.45
	var rng := RandomNumberGenerator.new()
	rng.seed = int(_arg("--seed", "1")) * 7919 + 13
	var next_log := 0.0
	var steps := 0
	while b.run_time < float(b.stage.duration) + 340.0 and not b.stage_cleared:
		match b.state:
			"levelup", "altar", "item_offer":
				if b.offer.size() > 0:
					b.choose(bot._pick_offer(b, rng))
				else:
					b.state = "running"
			"shop":
				b.state = "running"
			"evolve_cine":
				b.skip_cine()
			"revive_offer":
				b.accept_revive()
		if b.state == "dead" or b.state == "won":
			break
		var dir: Vector2 = bot._smart_dir(b, false)
		bot._maybe_active(b)
		b.hero.hp = b.hero.max_hp
		b.step(dir, 1.0 / 60.0)
		b.events.clear()
		steps += 1
		if b.boss != null and b.run_time >= next_log:
			next_log = b.run_time + 15.0
			var mech = b.boss_mech
			print("t=%.0f boss.hp=%.0f/%.0f dead=%s pos=%s hero=%s dist=%.1f mech=%s shield=%s totems=%d phase=%d enemies=%d immune=%s hero_dmg=%s" % [
				b.run_time, b.boss.hp, b.boss.max_hp, b.boss.dead, b.boss.pos, b.hero.pos, b.hero.pos.distance_to(b.boss.pos),
				mech != null, (mech.shield if mech != null else -1), (mech._alive_totems() if mech != null else -1), b.boss.phase_index, b.enemies.size(),
				(mech.is_immune(b.boss) if mech != null else false), b.hero.m("dmg_pct")])
	print("FIM t=%.0f state=%s boss_dead=%s cleared=%s" % [b.run_time, b.state, b.boss_dead, b.stage_cleared])
	quit()
