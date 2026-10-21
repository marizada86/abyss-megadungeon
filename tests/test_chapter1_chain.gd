extends RefCounted
## Plano CHAPTER1-MAPS-STANDARD r2 (lotes A e B): a cadeia Docas -> Reino -> Domwieck -> Dagruve -> ... -> Pilares,
## os 180 s dos três primeiros mapas e a vitória de Domwieck com portal em vez de fim de run.

const FIRST_THREE := ["docas", "reino_abissal", "domwieck"]
const EXPECTED_CHAIN := ["docas", "reino_abissal", "domwieck", "dagruve", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]

func run() -> Array[String]:
	var out: Array[String] = []
	_chain(out)
	_durations(out)
	_permissions(out)
	_victory(out)
	_docas_compensation(out)
	return out

func _chain(out: Array[String]) -> void:
	var stages: Dictionary = Data.table("stages")
	var seen: Array = []
	var id := "docas"
	while id != "" and not seen.has(id):
		seen.append(id)
		id = String(stages[id].get("next", ""))
	if seen != EXPECTED_CHAIN or id != "":
		out.append("cadeia de descida inesperada (laço ou salto): %s" % str(seen))
	var flow: Dictionary = Data.table("chapter_flow").stage_definitions
	for sid in FIRST_THREE:
		if String(flow[sid].next) != String(stages[sid].next):
			out.append("%s: next diverge entre chapter_flow e stages" % sid)

func _durations(out: Array[String]) -> void:
	var stages: Dictionary = Data.table("stages")
	var flow: Dictionary = Data.table("chapter_flow").stage_definitions
	var events: Dictionary = Data.table("stage_events")
	for sid in FIRST_THREE:
		var st: Dictionary = stages[sid]
		if float(st.duration) != 180.0 or float(flow[sid].duration) != 180.0:
			out.append("%s: duração deveria ser 180 s (stages %s, contrato %s)" % [sid, st.duration, flow[sid].duration])
		for w in st.waves:
			if float(w.t0) < 0.0 or float(w.t1) > 180.0 or float(w.t0) >= float(w.t1):
				out.append("%s: onda %s fora de 0-180 s (%s-%s)" % [sid, w.id, w.t0, w.t1])
		for e in st.elites:
			if float(e.at) <= 0.0 or float(e.at) >= 180.0:
				out.append("%s: elite %s fora da fase (%s)" % [sid, e.id, e.at])
		for ev in events.get(sid, []):
			if float(ev.at) + float(ev.get("warning", 0.0)) >= 180.0:
				out.append("%s: evento %s não cabe nos 180 s (%s)" % [sid, ev.id, ev.at])
		if sid != "docas" and float(st.completion.hold_seconds) != 3.0:
			out.append("%s: a presença de 3 s do objetivo não deveria mudar" % sid)
	if int(stages.dagruve.duration) != 300:
		out.append("Dagruve deve ficar como está (decisão D5)")

func _permissions(out: Array[String]) -> void:
	var p := Profile.new()
	ChapterFlow.clear_stage(p.data, "docas")
	ChapterFlow.clear_stage(p.data, "reino_abissal")
	if p.stage_unlocked("dagruve") or p.stage_unlocked("shedaklah"):
		out.append("Dagruve não abre antes de vencer Domwieck")
	ChapterFlow.clear_stage(p.data, "domwieck")
	if not p.stage_unlocked("dagruve") or p.stage_unlocked("shedaklah"):
		out.append("vencer Domwieck abre Dagruve, mas não Shedaklah")
	if String(p.data.campaign_progress.next_stage) != "dagruve":
		out.append("o próximo da campanha depois do capítulo 1 deveria ser Dagruve")
	p.data.cleared["dagruve"] = true
	if not p.stage_unlocked("shedaklah") or p.stage_unlocked("molor"):
		out.append("Dagruve vencida abre Shedaklah, e só ela")
	p.data.cleared["shedaklah"] = true
	if not p.stage_unlocked("molor"):
		out.append("a cadeia deveria seguir pelo campo unlock")
	var fresh := Profile.new()
	fresh.data.cleared["dagruve"] = true
	if fresh.stage_unlocked("shedaklah"):
		out.append("Dagruve vencida sozinha não fura a campanha nova")

func _victory(out: Array[String]) -> void:
	var b := Battle.new(4310, "durvall", "domwieck")
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.weapons.clear()
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b._fog_rules_off = true
	b.hero.pos = b.objective_target()
	b.time = float(b.stage.duration) + 0.5
	for i in 400:
		b.step(Vector2.ZERO, 0.01)
		if b.stage_cleared:
			break
	if not b.stage_cleared:
		out.append("Domwieck não concluiu o objetivo")
		return
	if b.state == "won":
		out.append("vencer Domwieck não pode encerrar a run: falta a opção de continuar")
	if not b.interactions.any(func(i): return i.kind == "portal"):
		out.append("Domwieck deveria abrir o portal de continuação")
	if not b.events.any(func(ev): return ev.type == "toast" and String(ev.text).contains("Dagruve")):
		out.append("o aviso de vitória deveria citar Dagruve")
	b.enter_next_stage()
	if b.stage_id != "dagruve" or b.descent_depth != 1:
		out.append("o portal de Domwieck deveria levar a Dagruve (profundidade 1): %s, %d" % [b.stage_id, b.descent_depth])
	b.stage_cleared = true
	b.enter_next_stage()
	if b.stage_id != "shedaklah":
		out.append("depois de Dagruve a descida segue para Shedaklah: %s" % b.stage_id)
	var x := Battle.new(4311, "durvall", "domwieck")
	x.map_size = Vector2(60, 60)
	x.hero.pos = x.objective_target()
	x.time = float(x.stage.duration) + 4.0
	x.objective_presence = 3.0
	x.hero.weapons.clear()
	if not x.complete_stage("objective") or x.state == "won":
		out.append("conclusão de Domwieck mantém a run viva")
	x.extract()
	if not x.extracted or x.state != "won":
		out.append("extrair (X) depois da vitória deveria fechar a run como vitória")

## Docas em 180 s chega ao chefe com ~3 níveis a menos: o plano compensa com XP e vida do mapa (bots: 18/24 -> 24/24).
func _docas_compensation(out: Array[String]) -> void:
	var stages: Dictionary = Data.table("stages")
	if not is_equal_approx(float(stages.docas.get("xp_mult", 1.0)), 1.5) or not is_equal_approx(float(stages.docas.hp_mult), 1.5):
		out.append("Docas deveria ter xp_mult 1,5 e hp_mult 1,5 (compensação dos 180 s)")
	for sid in stages:
		if sid != "docas" and stages[sid].has("xp_mult"):
			out.append("%s: xp_mult é exclusivo de Docas neste plano (Reino e Domwieck aguardam o playtest)" % sid)
	var plain := Battle.new(4330, "durvall", "dagruve")
	var boosted := Battle.new(4330, "durvall", "docas")
	plain.hero.xp = 0.0
	boosted.hero.xp = 0.0
	plain._collect("xp", 1.0)
	boosted._collect("xp", 1.0)
	if plain.hero.xp <= 0.0 or not is_equal_approx(boosted.hero.xp / plain.hero.xp, 1.5):
		out.append("o xp_mult do mapa deveria multiplicar o XP coletado (%s vs %s)" % [boosted.hero.xp, plain.hero.xp])
