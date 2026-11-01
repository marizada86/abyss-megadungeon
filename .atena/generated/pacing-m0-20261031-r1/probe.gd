extends SceneTree
## M0 (PACING-AUDIT-20261029-r1): mede interativos e acontecimentos no código real, sem combate (ondas e elites vazias),
## com o herói parado e invulnerável. "coletor" usa tudo na hora; "ignorador" deixa acumular (efeito do teto de 3 vivos).
## Uso: godot --headless --path . -s .atena/generated/pacing-m0-20261031-r1/probe.gd -- <seeds> <stage,stage,...>

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("probe start")
	var args := OS.get_cmdline_user_args()
	var seeds := int(args[0]) if args.size() > 0 else 30
	var stages: PackedStringArray = (args[1] if args.size() > 1 else "dagruve,shedaklah,molor,durao,feng_tu,shendilavri,goranthis").split(",")
	for stage_id in stages:
		for mode in ["coletor", "ignorador"]:
			var kinds := {}
			var hg_maps := 0
			var smith_maps := 0
			var svc_maps := 0
			var happen := 0
			var happen_min := 99
			var inter_total := 0
			var t0 := Time.get_ticks_msec()
			for s in seeds:
				var b := Battle.new(1000 + s, "durvall", stage_id)
				b.hero.pos = Vector2(20, 20)
				b.hero.max_hp = 1.0e9
				b.hero.hp = 1.0e9
				b.stage.waves = []
				b.stage.elites = []
				var dur := float(b.stage.duration) - 6.0
				var seen := {}
				var objs := {}
				var hg := false
				var smith := false
				var svc := false
				var n_inter := 0
				var stall := 0
				var last_t := -1.0
				while b.time < dur:
					stall = stall + 1 if is_equal_approx(b.time, last_t) else 0
					last_t = b.time
					if stall > 40:
						print("STALL ", stage_id, " t=", b.time, " state=", b.state, " offer_kind=", b.offer_kind)
						break
					b.step(Vector2.ZERO, 0.5)
					b.hero.hp = b.hero.max_hp
					b.hero.dead = false
					if b.state == "evolve_cine":
						b.skip_cine()
					elif b.state == "levelup" and not b.offer.is_empty():
						b.choose(0)
					if b.state != "running":
						b.offer = []
						b.offer_kind = ""
						b.state = "running"
					for it in b.interactions:
						var key := str(it.get("pos", Vector2.ZERO)) + String(it.kind)
						if seen.has(key):
							continue
						seen[key] = true
						var k := String(it.kind)
						if k.begins_with("event_") or k == "portal":
							continue
						kinds[k] = int(kinds.get(k, 0)) + 1
						n_inter += 1
						if k == "ampulheta": hg = true
						if k == "ferreiro": smith = true
						if k in ["loja", "ferreiro", "arcanista", "curandeiro"]: svc = true
					for o in b.happenings.objectives:
						objs[String(o.id)] = true
					if mode == "coletor":
						for it in b.interactions:
							if String(it.kind) != "portal" and not String(it.kind).begins_with("event_"):
								it.used = true
				if hg: hg_maps += 1
				if smith: smith_maps += 1
				if svc: svc_maps += 1
				happen += objs.size()
				happen_min = mini(happen_min, objs.size())
				inter_total += n_inter
			print("%s %s: interativos/mapa=%.1f  P(ampulheta)=%.0f%%  P(ferreiro)=%.0f%%  P(servico)=%.0f%%  acontecimentos/mapa=%.1f (min %d)  [%.0f s]  %s" % [stage_id, mode, float(inter_total) / seeds, 100.0 * hg_maps / seeds, 100.0 * smith_maps / seeds, 100.0 * svc_maps / seeds, float(happen) / seeds, happen_min, (Time.get_ticks_msec() - t0) / 1000.0, str(kinds)])
	quit()
