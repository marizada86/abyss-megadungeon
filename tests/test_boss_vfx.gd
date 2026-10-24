extends RefCounted
## Lote 2, série G: arte das mecânicas de chefe. Só apresentação: geometria, dano e tempo ficam em BossMechanics.

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _boss_battle(stage_id: String) -> Battle:
	var b := Battle.new(21, "durvall", stage_id, {"meta_mods": {"hp": 50000.0}})
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.hp = b.hero.max_hp
	b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.1})
	for _i in 12:
		b.step(Vector2.ZERO, 0.05)
		if b.boss != null:
			break
	return b

func _sheet(out: Array[String]) -> void:
	for sheet in BossVfx.SHEETS:
		var cells := 8 if BossVfx.EIGHT_CELL.has(sheet) else 6
		var texture := VfxAtlas.texture(BossVfx.path_for(sheet), cells)
		if texture == null:
			out.append("atlas ausente ou com geometria errada: " + sheet)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for cell in cells:
			var box := image.get_region(Rect2i(cell * 256, 0, 256, 256)).get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s célula %d vazia ou sem margem" % [sheet, cell])

func run() -> Array[String]:
	var out: Array[String] = []
	_sheet(out)
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	if cfg.is_empty():
		return ["data/difficulty.json deveria ter o bloco boss_mech"]
	var was: bool = bool(cfg.get("enabled", false))
	var l4_was: bool = bool(Data.table("difficulty").get("l4", {}).get("enabled", false))
	_cfg(["l4", "enabled"], false)
	_cfg(["boss_mech", "enabled"], true)
	var b := _boss_battle("dagruve")
	var m: BossMechanics = b.boss_mech
	if m == null or b.boss == null:
		_cfg(["boss_mech", "enabled"], was)
		_cfg(["l4", "enabled"], l4_was)
		return ["não foi possível montar o chefe com mecânicas"]
	m._verbs.clear()
	var rng_state := b.rng.state
	# descrição de cada verbo, sem mutar o estado
	m.sweep = {"origin": b.boss.pos, "a": 0.5, "a0": 0.5, "sign": 1.0, "arc": 1.0, "warn": 1.0, "dur": 1.0, "t": 0.2, "len": 6.0, "dice": "1d4", "offsets": [0.0, PI]}
	m.quad = {"center": b.boss.pos, "sectors": [0, 2], "t": 0.5, "total": 1.5, "radius": 9.0, "dice": "1d4", "puddle": false}
	m.mark = {"pos": b.hero.pos, "follow": 2.0, "lock": 1.0, "t": 2.5, "radius": 3.0, "dice": "1d4", "slow": 0.0, "puddle": false}
	m.cast = {"name": "Teste", "t": 1.0, "total": 2.5, "dice": "1d4", "stun": 2.0, "effect": "heavy", "armor_s": 6.0}
	var sweep_before := m.sweep.duplicate(true)
	var quad_before := m.quad.duplicate(true)
	var mark_before := m.mark.duplicate(true)
	var cast_before := m.cast.duplicate(true)
	var descs := BossVfx.describe(m)
	var kinds := {}
	for d in descs: kinds[String(d.key)] = d
	for key in ["sweep:0", "sweep:1", "quad", "mark", "cast"]:
		if not kinds.has(key): out.append("sem descrição para " + key)
	if kinds.has("sweep:0") and String(kinds["sweep:0"].sheet) != "boss_varredura_aviso": out.append("varredura em aviso deveria usar a folha de aviso")
	m.sweep.t = 1.5
	if String(BossVfx.describe(m)[0].sheet) != "boss_varredura_feixe": out.append("varredura ativa deveria usar a folha do feixe")
	m.sweep.t = 0.2
	if kinds.has("mark") and not bool(kinds["mark"].locked): out.append("marca travada deveria estar travada")
	if kinds.has("quad") and absf(float(kinds["quad"].ratio) - (1.0 - 0.5 / 1.5)) > 0.001: out.append("razão do quadrante")
	if m.sweep != sweep_before or m.quad != quad_before or m.mark != mark_before or m.cast != cast_before: out.append("describe alterou o estado do chefe")
	# nós: cria e atualiza sem alterar nada
	for d in descs:
		var node := BossVfx.build(d)
		if node == null:
			out.append("sem nó para " + String(d.key))
			continue
		BossVfx.update(node, d, 1234)
		if not node.is_in_group(&"boss_vfx"): out.append("nó fora do grupo")
		node.free()
	if m.sweep != sweep_before or m.quad != quad_before or m.mark != mark_before or m.cast != cast_before: out.append("build/update alterou o estado do chefe")
	# esticamento da barra: o comprimento acompanha a distância na tela
	var beam_desc := BossVfx.describe(m)[0]
	var beam := BossVfx.build(beam_desc) as BossVfx.BeamNode
	BossVfx.update(beam, beam_desc, 0)
	var expected := (Iso.to_screen(beam_desc["from"]) + Vector2(0, -8)).distance_to(Iso.to_screen(beam_desc["to"]) + Vector2(0, -8))
	if beam == null or absf(beam.length - expected) > 0.01: out.append("comprimento da barra não acompanha a varredura")
	if beam != null: beam.free()
	# totens, armadura e imunidade acendem o domo e o apagam
	m.sweep.clear(); m.quad.clear(); m.mark.clear(); m.cast.clear()
	if BossVfx.shield_active(m): out.append("domo aceso sem blindagem")
	m.armor_t = 3.0
	var dome := BossVfx.describe(m)
	if dome.size() != 1 or String(dome[0].kind) != "dome": out.append("armadura deveria acender o domo")
	m.armor_t = 0.0
	if not BossVfx.describe(m).is_empty(): out.append("domo deveria apagar")
	# eventos de detonação com metadado visual
	m.quad = {"center": b.boss.pos, "sectors": [1, 3], "t": 0.0, "total": 1.5, "radius": 9.0, "dice": "1d4", "puddle": false}
	b.events.clear()
	m._step_quad(0.05)
	var burst: Dictionary = {}
	for e in b.events:
		if String(e.get("type", "")) == "telegraph_burst": burst = e
	if String(burst.get("verb", "")) != "quad" or (burst.get("sectors", []) as Array) != [1, 3] or float(burst.get("radius", 0.0)) != 9.0: out.append("evento do quadrante sem metadado")
	m.mark = {"pos": b.hero.pos + Vector2(10, 0), "follow": 0.0, "lock": 0.0, "t": 0.0, "radius": 3.0, "dice": "1d4", "slow": 0.0, "puddle": false}
	b.events.clear()
	m._step_mark(0.05)
	burst = {}
	for e in b.events:
		if String(e.get("type", "")) == "telegraph_burst": burst = e
	if String(burst.get("verb", "")) != "mark" or float(burst.get("radius", 0.0)) != 3.0: out.append("evento da marca sem metadado")
	m.cast = {"name": "Teste", "t": 0.01, "total": 2.5, "dice": "1d4", "stun": 2.0, "effect": "armor", "armor_s": 1.0}
	b.events.clear()
	m._step_cast(0.05)
	burst = {}
	for e in b.events:
		if String(e.get("type", "")) == "telegraph_burst": burst = e
	if String(burst.get("verb", "")) != "cast": out.append("evento da conjuração sem metadado")
	m.cast = {"name": "Teste", "t": 1.0, "total": 2.5, "dice": "1d4", "stun": 2.0, "effect": "heavy", "armor_s": 1.0}
	b.events.clear()
	m.on_hero_active()
	var interrupted := false
	for e in b.events:
		if String(e.get("type", "")) == "cast_interrupt": interrupted = true
	if not interrupted: out.append("interrupção sem evento visual")
	# explosões pontuais
	var at := Vector2(10, 10)
	var quad_burst := BossVfx.create_burst({"verb": "quad", "pos": at, "sectors": [0, 1], "radius": 5.0})
	if quad_burst == null or not (quad_burst as BossVfx.SectorNode).burst: out.append("detonação do quadrante")
	if quad_burst != null: quad_burst.free()
	for verb in ["mark", "cast"]:
		var shot := BossVfx.create_burst({"verb": verb, "pos": at, "radius": 3.0}, 1.5)
		if shot == null: out.append("detonação sem efeito: " + verb)
		else: shot.free()
	if BossVfx.create_burst({"verb": "quad", "pos": at, "sectors": [], "radius": 5.0}) != null: out.append("quadrante sem fatias não deveria detonar")
	if BossVfx.create_burst({"verb": "desconhecido", "pos": at}) != null: out.append("verbo desconhecido não deveria detonar")
	for node in [BossVfx.create_interrupt(at, 1.2), BossVfx.create_phase_burst(at, 1.2), BossVfx.create_shield_break(at, 1.2)]:
		if node == null: out.append("efeito pontual ausente")
		else: node.free()
	for reduced_node in [BossVfx.create_burst({"verb": "mark", "pos": at, "radius": 3.0}, 1.0, true), BossVfx.create_interrupt(at, 1.0, true), BossVfx.create_phase_burst(at, 1.0, true), BossVfx.create_shield_break(at, 1.0, true)]:
		if reduced_node != null: out.append("impacto reduzido ignorado")
	# câmera lenta e flash só sem impacto reduzido
	if not BossVfx.cinematic_allowed(false) or BossVfx.cinematic_allowed(true): out.append("câmera lenta deveria respeitar o impacto reduzido")
	if BossVfx.SLOWMO_SCALE <= 0.0 or BossVfx.SLOWMO_SCALE >= 1.0 or absf(BossVfx.SLOWMO_SECONDS - 0.5) > 0.001: out.append("câmera lenta aprovada: 0,5 s abaixo do tempo normal")
	var flash := BossVfx.make_flash()
	if flash.mouse_filter != Control.MOUSE_FILTER_IGNORE or flash.color.a <= 0.0: out.append("flash deveria ignorar o mouse e ter alfa")
	flash.free()
	if Engine.time_scale != 1.0: out.append("a escala de tempo do motor deveria estar normal")
	# o contorno de perigo continua desenhado por BossMechanics.draw_fx, independente da arte
	var source := FileAccess.get_file_as_string("res://core/boss_mechanics.gd")
	for needle in ["ci.draw_polyline(pts, Color(1.0, 0.35, 0.2", "ci.draw_line(origin, tip, col", "ci.draw_polyline(ring, mcol"]:
		if not source.contains(needle): out.append("o contorno de perigo mudou: " + needle)
	if absf(BossVfx.fit(3.0) - BossVfx.SCALE_MAX) > 0.001 or absf(BossVfx.fit(0.2) - BossVfx.SCALE_MIN) > 0.001 or absf(BossVfx.fit(1.2) - 1.2) > 0.001: out.append("escala da arte do chefe deveria ficar entre 0,8 e 1,6")
	if b.rng.state != rng_state:
		out.append("RNG alterado")
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out
