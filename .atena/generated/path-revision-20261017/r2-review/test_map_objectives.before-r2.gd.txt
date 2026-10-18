extends RefCounted

const Scenery := preload("res://ui/scenery_layout.gd")
const Prop := preload("res://ui/prop.gd")

func _battle(seed_value: int = 4301, stage_key: String = "reino_abissal") -> Battle:
	var b := Battle.new(seed_value, "durvall", stage_key)
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = Vector2(30, 45)
	b.hero.weapons.clear()
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b._fog_rules_off = true
	return b

func _advance(b: Battle, seconds: float) -> void:
	for i in int(round(seconds * 100.0)):
		b.step(Vector2.ZERO, 0.01)

func run() -> Array:
	var out: Array = []
	_catalog(out)
	for stage_key in ["reino_abissal", "domwieck"]:
		_timing(out, stage_key)
		_cleanup(out, stage_key)
		_director(out, stage_key)
		_geometry(out, stage_key)
		_full_run(out, stage_key)
	_legacy_bosses(out)
	return out

func _catalog(out: Array) -> void:
	var released: Dictionary = Data.table("stages")
	for sid in ["reino_abissal", "domwieck"]:
		if not released.has(sid) or bool(released[sid].get("qa_only", false)) or String(released[sid].completion.kind) != "timed_reach":
			out.append("objetivo integrado ausente: " + sid)
	if not Battle.stage_definition("stage_unknown_qa").is_empty(): out.append("ID desconhecido")

func _full_run(out: Array, stage_key: String) -> void:
	var b := Battle.new(4306, "durvall", stage_key)
	b.map_size = Vector2(60,60)
	b.hero.map_size = b.map_size
	b.hero.pos = Vector2(30,45)
	b.hero.weapons.clear()
	b.hero.max_hp = 1.0e9
	b.hero.hp = b.hero.max_hp
	b._fog_rules_off = true
	var max_population := 0
	var duration := float(b.stage.duration)
	for i in int((duration + 10.0) * 10.0):
		if b.time >= duration:
			b.hero.pos = b.objective_target()
		b.step(Vector2.ZERO, 0.1)
		max_population = maxi(max_population, b._combat_count())
		b.events.clear()
		if b.stage_cleared:
			break
	if not b.stage_cleared or b.time < duration + 3.0 - 0.001 or b.time > duration + 3.2:
		out.append("%s: simulação integral não concluiu após tempo + presença: %.2f, %s" % [stage_key,b.time,b.state])
	if max_population > int(b.stage.cap) or b.stats.bosses != 0:
		out.append("simulação integral excedeu cap ou criou chefe")

func _timing(out: Array, stage_key: String) -> void:
	var b := _battle(4301, stage_key)
	var duration := float(b.stage.duration)
	b.hero.pos = b.objective_target()
	b.time = duration - 1.0
	_advance(b, 1.0)
	if b.stage_cleared or b.objective_presence > 0.00001:
		out.append("chegar antes/exatamente em 360 s não pode antecipar presença")
	_advance(b, 1.0)
	if absf(b.objective_presence - 1.0) > 0.001:
		out.append("presença deveria contar apenas depois do tempo")
	b._hurt_hero(1.0, "teste")
	if absf(b.objective_presence - 1.0) > 0.001:
		out.append("dano não deve reiniciar presença")
	b.state = "levelup"
	var paused_time := b.time
	_advance(b, 2.0)
	if b.time != paused_time or absf(b.objective_presence - 1.0) > 0.001:
		out.append("pausa de oferta deve congelar relógio e presença")
	b.state = "running"
	b.hero.pos = b.objective_target() + Vector2(2.01, 0)
	_advance(b, 0.01)
	if b.objective_presence != 0.0:
		out.append("sair do raio deve reiniciar a presença")
	b.hero.pos = b.objective_target() + Vector2(2, 0)
	_advance(b, 2.9)
	if b.stage_cleared:
		out.append("retorno ao limite do raio precisa completar os três segundos")
	_advance(b, 0.1)
	if not b.stage_cleared or b.objective_presence != 3.0:
		out.append("três segundos no limite do raio deveriam concluir o protótipo")
	if b.complete_stage("objective") or b.stats.stages_cleared != 1 or b.stats.cleared_ids != [stage_key]:
		out.append("callback duplicado não pode duplicar conclusão")
	if b.events.filter(func(ev): return ev.type == "objective_completed").size() != 1:
		out.append("objetivo deve emitir um evento de conclusão")
	var cross := _battle(4301, stage_key)
	cross.hero.pos = cross.objective_target()
	cross.time = duration - 0.5
	cross.step(Vector2.ZERO, 1.0)
	if absf(cross.objective_presence - 0.5) > 0.001:
		out.append("passo que cruza 360 s só deve contar sua fração posterior")
	var far := _battle(4301, stage_key)
	far.time = duration + 140.0
	_advance(far, 4.0)
	if far.stage_cleared:
		out.append("tempo sozinho não conclui objetivo longe do ritual")
	for terminal in ["dead", "revive_offer", "won"]:
		var dead := _battle(4301, stage_key)
		dead.time = duration + 40.0
		dead.hero.pos = dead.objective_target()
		dead.state = terminal
		dead.hero.dead = true
		_advance(dead, 4.0)
		if dead.stage_cleared or dead.complete_stage("objective"):
			out.append("morte/estado terminal não concede objetivo: %s" % terminal)
	var abandoned := _battle(4301, stage_key)
	abandoned.death_reason = "abandoned"
	abandoned.state = "dead"
	abandoned.hero.dead = true
	_advance(abandoned, 4.0)
	if abandoned.result().stages_cleared != 0:
		out.append("abandono não concede conclusão")
	var no_cheat := _battle(4301, stage_key)
	if no_cheat.complete_stage("objective") or no_cheat.complete_stage("boss"):
		out.append("conclusão não pode ser forçada sem cumprir contrato")

func _cleanup(out: Array, stage_key: String) -> void:
	var b := _battle(4301, stage_key)
	b.time = float(b.stage.duration) + 5.0
	b.hero.pos = b.objective_target()
	var survivor := b.spawn_for_test("cultista_adaga", Vector2(45,45) if stage_key == "reino_abissal" else Vector2(50,50))
	if survivor.dead:
		out.append("fixture de limpeza deve criar sobrevivente válido")
	survivor.speed = 0.0
	b.projectiles.append({"test": true})
	b.zones.append({"test": true})
	b.decoys.append({"test": true})
	b._shielders.append(survivor)
	var xp := b.hero.xp
	var gold: float = b.stats.gold
	b.objective_presence = 3.0
	if not b.complete_stage("objective"):
		out.append("objetivo válido deveria concluir")
	if not b.enemies.is_empty() or not b.projectiles.is_empty() or not b.zones.is_empty() or not b.decoys.is_empty() or not b._shielders.is_empty():
		out.append("objetivo deve remover inimigos e perigos")
	if survivor.dead or b.stats.kills != 0 or b.hero.xp != xp or b.stats.gold != gold or not b.pickups.is_empty():
		out.append("limpeza não pode matar/pagar XP, ouro ou drops")
	if b.stats.bosses != 0 or not b.stats.boss_ids.is_empty() or b.boss_dead or b.boss_spawned or b.final_victory or b.fog_state != "inactive":
		out.append("objetivo não equivale a chefe ou vitória dos Pilares")
	if b.interactions.any(func(i): return i.kind == "boss_chest"):
		out.append("protótipo não cria baú de chefe nem portal para cena ausente")
	for target in ["boss", "boss_70", "boss_35", "portal"]:
		var qa := _battle(4301, stage_key)
		qa.qa_prepare({"target_state": target})
		if qa.boss != null or qa.boss_spawned or qa.stage_cleared:
			out.append("QA não deve inventar chefe para cenário %s" % target)

func _director(out: Array, stage_key: String) -> void:
	var b := Battle.new(4302, "durvall", stage_key)
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = Vector2(30, 45)
	b.time = float(b.stage.duration) - 0.01
	b._director(10.0)
	if b.enemies.is_empty():
		out.append("diretor precisa gerar pressão antes de 360 s")
	var count := b.enemies.size()
	b.time = float(b.stage.duration)
	b._director(1000.0)
	if b.enemies.size() != count or b.boss_spawned:
		out.append("em 360 s cessam ondas/elites sem remover sobreviventes ou gerar chefe")
	b.time = float(b.stage.duration) + 340.0
	b._director(1000.0)
	if b.enemies.size() != count:
		out.append("não pode haver reforços infinitos após o tempo")
	var cap := Battle.new(4303, "durvall", stage_key)
	cap.map_size = Vector2(60, 60)
	cap.hero.map_size = cap.map_size
	cap.hero.pos = Vector2(30, 45)
	cap.time = 240.0
	for i in int(cap.stage.cap) - 1:
		cap.spawn_for_test("cultista_adaga", Vector2(30, 30) if stage_key == "reino_abissal" else Vector2(10,10))
	if cap._combat_count() != int(cap.stage.cap) - 1:
		out.append("fixture de cap deve admitir 49 criaturas")
	cap._director(20.0)
	if cap._combat_count() > int(cap.stage.cap) or cap.horde_active():
		out.append("mapa por objetivo preserva cap 50 e não acrescenta horda implícita")

func _geometry(out: Array, stage_key: String) -> void:
	var old_scale := TerrainLayout.scale
	TerrainLayout.scale = 1.5
	var scene: PackedScene = load("res://ui/stages/%s.tscn" % stage_key)
	var stage := scene.instantiate()
	var ground: Node2D = stage.get_node("Ground")
	var start := Iso.to_ground(stage.get_node("Sorted/Hero").position)
	if Vector2(ground.map_size) != Vector2(60, 60) or start != Vector2(30, 45):
		out.append("cena deve ter 60×60 e entrada do contrato")
	var sorted: Node2D = stage.get_node("Sorted")
	Scenery.apply(sorted, stage_key, start, Vector2(60, 60))
	var b := _battle(4301, stage_key)
	for child in sorted.get_children():
		if child is Prop:
			var at := Iso.to_ground(child.position)
			b.hero.blockers.append(Vector3(at.x, at.y, child.block_radius))
			if at.distance_to(start) < 6.4 or at.distance_to(b.objective_target()) < 4.4:
				out.append("prop invade folga da entrada/alvo")
			if child.kind != "carga":
				out.append("protótipo deve usar somente família de props conferida")
	if b.hero.blockers.size() != (4 if stage_key == "reino_abissal" else 6):
		out.append("layout deve preservar somente props admitidos na superfície")
	for x in range(1, 60):
		for y in range(1, 60):
			var point := Vector2(x, y)
			var expected := TerrainLayout.MATERIAL_ABYSS_ROOT if stage_key == "reino_abissal" else TerrainLayout.MATERIAL_DOMWIECK_STONE
			var blocked := not TerrainLayout.root_supports(point) if stage_key == "reino_abissal" else false
			if TerrainLayout.material_at(stage_key, point) != expected or TerrainLayout.is_blocked(stage_key, point) != blocked or TerrainLayout.is_styx_water(stage_key, point):
				out.append("%s: material/apoio incompatível com malha, sem Estige" % stage_key)
	# Test actual prop-expanded collision geometry through the production reach grid.
	b.hero.terrain_id = stage_key
	var reach := b._reach_grid()
	for destination in [Vector2(30,15), Vector2(15,30), Vector2(45,30), Vector2(15,15), Vector2(45,45)]:
		if not b._reach_has(reach, destination):
			out.append("destino inacessível pela geometria real: %s" % destination)
	for x in (range(28, 33) if stage_key == "reino_abissal" else range(27, 34)):
		for y in (range(15, 46) if stage_key == "reino_abissal" else range(11, 52)):
			if not b.hero.can_stand(Vector2(x, y), 0.4):
				out.append("eixo central deve ter seis unidades livres")
	if stage_key == "domwieck":
		for side_x in [15,45]:
			for x in range(side_x - 2, side_x + 3):
				for y in range(15,46):
					if not b.hero.can_stand(Vector2(x,y),0.4):
						out.append("Domwieck: rua lateral deve ter quatro unidades livres")
		for plaza in [Vector2(30,33),Vector2(15,30),Vector2(45,30)]:
			for blocker in b.hero.blockers:
				if plaza.distance_to(Vector2(blocker.x,blocker.y)) < 6.0 + float(blocker.z):
					out.append("Domwieck: prop invade bolsão de combate")
	var spawn_origins := [Vector2(15,15),Vector2(45,45),Vector2(15,45),start,Vector2(45,30)] if stage_key == "reino_abissal" else [Vector2(1,1),Vector2(59,59),Vector2(1,59),start,Vector2(52,36)]
	for pos in spawn_origins:
		b.hero.pos = pos
		for i in 16:
			var spawn := b._ring_pos()
			if not b.hero.can_stand(spawn, 0.4) or spawn.distance_to(Vector2(30,45)) < 6.4 or spawn.distance_to(pos) < 8.0 or spawn.x < 1.0 or spawn.y < 1.0 or spawn.x > 59.0 or spawn.y > 59.0:
				out.append("spawn de onda inválido perto de borda/obstáculo")
	stage.free()
	TerrainLayout.scale = old_scale

func _legacy_bosses(out: Array) -> void:
	var b := Battle.new(4304, "durvall", "docas")
	b._fog_rules_off = false
	var boss := b.spawn_for_test("guardiao_verdadeiro", Vector2(20, 20))
	b.boss = boss
	b.boss_spawned = true
	b._on_boss_dead(boss)
	var drops := b.pickups.size()
	b._on_boss_dead(boss)
	if not b.stage_cleared or b.stats.bosses != 1 or b.stats.stages_cleared != 1 or b.pickups.size() != drops or b.fog_state != "grace":
		out.append("Docas preserva chefe/Maré e não duplica conclusão/drops")
	if not b.interactions.any(func(i): return i.kind == "boss_chest") or not b.interactions.any(func(i): return i.kind == "portal"):
		out.append("chefe real preserva baú e portal")
	var pillars := Battle.new(4305, "durvall", "pilares")
	for i in 2:
		var repeat := pillars.spawn_for_test("sintese_abissal", Vector2(20,20))
		pillars._on_boss_dead(repeat)
	if pillars.stats.bosses != 2 or not pillars.final_victory or pillars.stats.cleared_ids != ["pilares"]:
		out.append("Pilares deve preservar chefes repetidos e vitória final única")
