class_name ChapterFlow
extends RefCounted

static func contract() -> Dictionary:
	return Data.table("chapter_flow")

static func initialize(data: Dictionary, source: Dictionary) -> void:
	if source.get("campaign_progress", {}) is Dictionary and int(source.get("campaign_progress", {}).get("version", 0)) == 1:
		_normalize(data)
		return
	var cp := {"version": 1, "milestones": {}, "pending_hqs": [], "presentation_done": {}, "legacy_stage_access": {}, "legacy_hq_access": {}, "next_stage": "docas"}
	var old_stats: Dictionary = source.get("stats", {})
	var legacy := int(source.get("coins", 0)) > 0 or not Dictionary(source.get("cleared", {})).is_empty() or not Dictionary(source.get("achievements", {})).is_empty() or not Dictionary(source.get("hqs_seen", {})).is_empty() or int(old_stats.get("runs", 0)) > 0 or int(old_stats.get("deaths", 0)) > 0 or not Dictionary(old_stats.get("reached", {})).is_empty() or not Dictionary(source.get("upgrades", {})).is_empty() or not Dictionary(old_stats.get("heroes_played", {})).is_empty() or not Dictionary(source.get("codex", {}).get("enemies", {})).is_empty() or not Dictionary(source.get("codex", {}).get("items", {})).is_empty() or not Dictionary(source.get("codex", {}).get("weapons", {})).is_empty()
	if legacy:
		var cleared: Dictionary = source.get("cleared", {}).duplicate(true)
		if cleared.has("dagruve"): cleared["docas"] = true
		for id in contract().legacy_stages:
			var req := String(contract().legacy_stages[id].unlock)
			if req == "start" or cleared.has(req): cp.legacy_stage_access[id] = true
		for id in contract().legacy_hqs:
			var def: Dictionary = contract().legacy_hqs[id]
			var trigger: Dictionary = def.get("trigger", {})
			var stage := String(trigger.get("stage", ""))
			if data.hqs_seen.has(id) or source.get("achievements", {}).has(def.get("achievement", "")) or id == "hqn_01" or (String(trigger.get("type", "")) == "stage_reached" and (cleared.has(stage) or old_stats.get("reached", {}).has(stage))) or (String(trigger.get("type", "")) in ["stage_cleared", "final_victory"] and cleared.has(stage)):
				cp.legacy_hq_access[id] = true
		cp.presentation_done.hqn_01 = "legacy"
		if cleared.has("docas"): cp.milestones.docas_cleared = true
	for id in data.hqs_seen:
		cp.presentation_done[id] = "read"
	data.campaign_progress = cp
	_normalize(data)

static func _normalize(data: Dictionary) -> void:
	var cp: Dictionary = data.campaign_progress
	for key in ["milestones", "presentation_done", "legacy_stage_access", "legacy_hq_access"]:
		if not cp.get(key, null) is Dictionary: cp[key] = {}
	var queue: Array = []
	var found := {}
	if cp.get("pending_hqs", null) is Array:
		for row in cp.pending_hqs:
			if not row is Dictionary: continue
			var id := String(row.get("id", ""))
			if not Data.table("hqs").has(id) or found.has(id) or cp.presentation_done.has(id): continue
			found[id] = true
			queue.append({"id": id, "panel_index": clampi(int(row.get("panel_index", 0)), 0, maxi(0, Data.table("hqs")[id].panels.size() - 1))})
	cp.pending_hqs = queue
	cp.next_stage = "docas" if not cp.milestones.has("docas_cleared") else "reino_abissal" if not cp.milestones.has("reino_abissal_cleared") else "domwieck" if not cp.milestones.has("domwieck_cleared") else "dagruve"

static func stage_allowed(data: Dictionary, id: String) -> bool:
	if not Data.table("stages").has(id): return false
	var cp: Dictionary = data.campaign_progress
	if cp.legacy_stage_access.has(id): return true
	if id == "docas" or (id == "reino_abissal" and cp.milestones.has("docas_cleared")) or (id == "domwieck" and cp.milestones.has("reino_abissal_cleared")):
		return true
	# Depois do capítulo 1 a cadeia antiga segue pelo campo `unlock`: Dagruve abre com Domwieck; o resto, com a fase anterior vencida.
	if not cp.milestones.has("domwieck_cleared") or id in contract().campaign_stages:
		return false
	var req := String(Data.table("stages")[id].get("unlock", "start"))
	return id == "dagruve" or data.cleared.has(req)

static func enqueue(data: Dictionary, ids: Array) -> void:
	var cp: Dictionary = data.campaign_progress
	for id in ids:
		if cp.presentation_done.has(id) or data.hqs_seen.has(id): continue
		if cp.pending_hqs.any(func(row): return row.id == id): continue
		cp.pending_hqs.append({"id": id, "panel_index": 0})

static func prepare_start(data: Dictionary, id: String) -> void:
	if id not in contract().campaign_stages: return
	enqueue(data, ["hqn_01"])
	# Retrospective only when the player explicitly starts the new route.
	if data.campaign_progress.milestones.has("docas_cleared"):
		enqueue(data, ["hqn_02", "hqn_15", "hqn_16", "hqn_17"])

static func clear_stage(data: Dictionary, stage: String) -> void:
	for event in contract().events:
		if event.event == "stage_cleared" and event.stage == stage:
			data.campaign_progress.milestones[stage + "_cleared"] = true
			enqueue(data, event.queue)
	_normalize(data)
	_close_chapter(data)

static func cursor(data: Dictionary, id: String, index: int) -> void:
	for row in data.campaign_progress.pending_hqs:
		if row.id == id: row.panel_index = index

static func resolve(data: Dictionary, id: String, complete: bool) -> void:
	var cp: Dictionary = data.campaign_progress
	if not cp.pending_hqs.any(func(row): return row.id == id): return
	cp.pending_hqs = cp.pending_hqs.filter(func(row): return row.id != id)
	cp.presentation_done[id] = "read" if complete else "dismissed"
	_close_chapter(data)

static func _close_chapter(data: Dictionary) -> void:
	var cp: Dictionary = data.campaign_progress
	if cp.milestones.has("domwieck_cleared") and (cp.presentation_done.has("hqn_03") or data.hqs_seen.has("hqn_03")):
		cp.milestones.chapter1_closed = true
