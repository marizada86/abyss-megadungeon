from pathlib import Path
p=Path('ui/run.gd'); t=p.read_text(encoding='utf-8')
t=t.replace('var _result_shown := false','var _result_shown := false\nvar _hq_draining := false\nvar _campaign_ready := false',1)
t=t.replace('\tvar rumor := String(Data.table("stage_story").get(battle.stage_id, {}).get("rumor", ""))','\tif not Game.qa_sandbox:\n\t\tChapterFlow.prepare_start(Game.profile.data, battle.stage_id)\n\t\tGame.save()\n\t\tawait _drain_campaign_hqs()\n\t_campaign_ready = true\n\tvar rumor := String(Data.table("stage_story").get(battle.stage_id, {}).get("rumor", ""))',1)
t=t.replace('func _physics_process(delta: float) -> void:', 'func _physics_process(delta: float) -> void:\n\tif not _campaign_ready or _hq_draining: return',1)
# Discover actual signature rather than assuming a physics callback name.
if 'if not _campaign_ready or _hq_draining: return' not in t:
    import re
    match=re.search(r'func _physics_process\([^\n]+\n',t); assert match
    t=t[:match.end()]+'\tif not _campaign_ready or _hq_draining: return\n'+t[match.end():]
t=t.replace('\tif battle.stage_cleared and not _stage_clear_events_seen.has(battle.stage_id):','\tif battle.stage_cleared and not _stage_clear_events_seen.has(battle.stage_id):',1)
a=t.index('func _record_stage_cleared('); z=t.index('# ------------------------------------------------------------------ efeitos',a)
t=t[:a]+'''func _record_stage_cleared(stage_id: String, event_type: String) -> void:
	battle.run_record.checkpoint(battle, "stage_cleared", {"event": event_type})
	Game.profile.mark_stage_reached(stage_id)
	Game.profile.mark_stage_cleared(stage_id)
	ChapterFlow.clear_stage(Game.profile.data, stage_id)
	Game.save()
	await _drain_campaign_hqs()

func _drain_campaign_hqs() -> void:
	if Game.qa_sandbox or _hq_draining: return
	_hq_draining = true
	while not Game.profile.data.campaign_progress.pending_hqs.is_empty():
		var row: Dictionary = Game.profile.data.campaign_progress.pending_hqs[0]
		await _present_hq(String(row.id), int(row.panel_index), true)
	_hq_draining = false

func _present_hqs(hq_ids: Array[String]) -> void:
	if Game.qa_sandbox: return
	ChapterFlow.enqueue(Game.profile.data, hq_ids)
	Game.save()
	await _drain_campaign_hqs()

func _present_hq(hq_id: String, resume_index: int = 0, campaign: bool = false) -> void:
	var hq: Dictionary = Data.table("hqs").get(hq_id, {})
	if hq.is_empty(): return
	var screen = HQ_SCREEN.instantiate()
	screen.process_mode = Node.PROCESS_MODE_ALWAYS
	hud.add_child(screen)
	var prior_pause := get_tree().paused
	get_tree().paused = true
	if campaign:
		screen.panel_changed.connect(func(index):
			ChapterFlow.cursor(Game.profile.data, hq_id, index)
			Game.save())
	screen.call_deferred("start_hq", hq, resume_index)
	while not bool(screen.get("is_closed")):
		await get_tree().process_frame
	var completed := bool(screen.get("completed"))
	get_tree().paused = prior_pause
	screen.queue_free()
	if completed: Game.profile.mark_hq_seen(hq_id)
	if campaign: ChapterFlow.resolve(Game.profile.data, hq_id, completed)
	Game.save()

'''.replace('\n+','\n')+t[z:]
t=t.replace('\thud.show_result(res, Game.last_summary)','\tif battle.stage_id == "domwieck" and Game.profile.data.campaign_progress.milestones.has("chapter1_closed"):\n\t\thud.toast("Capítulo 1 concluído")\n\thud.show_result(res, Game.last_summary)',1)
p.write_text(t,encoding='utf-8')
p=Path('ui/menu.gd'); t=p.read_text(encoding='utf-8')
t=t.replace('hq_list.add_item(String(hq.get("title", hq_id)))','hq_list.add_item(("Complementar: " if hq_id == "hqn_14" else "Arquivo histórico: " if hq_id in ["hqn_11", "hqn_12", "hqn_13"] else "") + String(hq.get("title", hq_id)))')
t=t.replace('Data.table("stages")[d.unlock].name','Data.table("stages").get(d.unlock, {}).get("name", "avanço da campanha")')
t=t.replace('Bloqueada: derrote o chefe de %s.','Bloqueada: avance pela campanha até %s.')
t=t.replace('\tscreen.call_deferred("start_hq", hq)','\tvar cursor := 0\n\tvar pending := false\n\tfor row in Game.profile.data.campaign_progress.pending_hqs:\n\t\tif row.id == hq_id:\n\t\t\tcursor = int(row.panel_index)\n\t\t\tpending = true\n\tif pending:\n\t\tscreen.panel_changed.connect(func(index):\n\t\t\tChapterFlow.cursor(Game.profile.data, hq_id, index)\n\t\t\tGame.save())\n\tscreen.call_deferred("start_hq", hq, cursor)',1)
t=t.replace('\tvar completed := bool(screen.get("completed"))','\tvar completed := bool(screen.get("completed"))\n\tif pending:\n\t\tChapterFlow.resolve(Game.profile.data, hq_id, completed)\n\t\tGame.save()',1)
p.write_text(t,encoding='utf-8')
print('Runtime wired; queue, cursor, pause and diary.')
