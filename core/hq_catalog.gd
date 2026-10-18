extends RefCounted
## Resolve acesso, marcos e apresentação inicial das HQs.

const ORDER := [
	"hqn_01", "hqn_02", "hqn_15", "hqn_16", "hqn_17", "hqn_18", "hqn_03", "hqn_14",
	"hqn_19", "hqn_20", "hqn_21", "hqn_04", "hqn_05", "hqn_06", "hqn_07", "hqn_08", "hqn_09", "hqn_10", "hqn_11", "hqn_12", "hqn_13"
]

static func unlocked_ids(profile_data: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for hq_id in ORDER:
		if is_unlocked(profile_data, hq_id):
			out.append(hq_id)
	return out

static func is_unlocked(profile_data: Dictionary, hq_id: String) -> bool:
	var hq: Dictionary = Data.table("hqs").get(hq_id, {})
	if hq.is_empty():
		return false
	if hq_id == "hqn_21" and (Dictionary(profile_data.get("hqs_seen", {})).has(hq_id) or Dictionary(profile_data.get("campaign_progress", {}).get("legacy_hq_access", {})).has(hq_id)):
		return true
	# Chapter 2 artwork is admitted; campaign scheduling has a separate contract.
	if String(hq.get("trigger", {}).get("type", "")) == "chapter2_content":
		if Game.qa_sandbox:
			return true
		return bool(profile_data.get("campaign_progress", {}).get("milestones", {}).get(String(hq.trigger.milestone), false))
	if profile_data.has("campaign_progress"):
		var cp: Dictionary = profile_data.campaign_progress
		if cp.legacy_hq_access.has(hq_id) or Dictionary(profile_data.get("hqs_seen", {})).has(hq_id): return true
		if hq_id in ["hqn_11", "hqn_12", "hqn_13"]: return false
		if cp.presentation_done.has(hq_id) or cp.pending_hqs.any(func(row): return row.id == hq_id): return true
		if hq_id == "hqn_14": return cp.milestones.has("docas_cleared")
		if hq_id in ["hqn_02", "hqn_15", "hqn_16", "hqn_17"]: return cp.milestones.has("docas_cleared")
		if hq_id == "hqn_18": return cp.milestones.has("reino_abissal_cleared")
		if hq_id == "hqn_03": return cp.milestones.has("domwieck_cleared")
		return false
	var achievements: Dictionary = profile_data.get("achievements", {})
	var achievement_id := String(hq.get("achievement", ""))
	if achievement_id != "" and achievements.has(achievement_id):
		return true
	if Dictionary(profile_data.get("hqs_seen", {})).has(hq_id):
		return true
	var trigger: Dictionary = hq.get("trigger", {})
	var stats: Dictionary = profile_data.get("stats", {})
	var reached: Dictionary = stats.get("reached", {})
	var cleared: Dictionary = profile_data.get("cleared", {})
	var stage_id := String(trigger.get("stage", ""))
	match String(trigger.get("type", "")):
		"first_run":
			return _has_campaign_progress(profile_data)
		"stage_reached":
			return reached.has(stage_id) or cleared.has(stage_id)
		"stage_cleared", "final_victory":
			return cleared.has(stage_id)
	return false

static func newly_triggered_ids(profile_data: Dictionary, event_type: String, stage_id: String = "") -> Array[String]:
	var out: Array[String] = []
	if profile_data.has("campaign_progress"):
		for event in Data.table("chapter_flow").events:
			if (event.event == event_type or (event.event == "campaign_first_start" and event_type == "first_run")) and (event_type == "first_run" or event.stage == stage_id):
				for id in event.get("queue", []):
					if not profile_data.campaign_progress.presentation_done.has(id) and not profile_data.get("hqs_seen", {}).has(id): out.append(id)
		return out
	var hqs: Dictionary = Data.table("hqs")
	for hq_id in ORDER:
		var hq: Dictionary = hqs.get(hq_id, {})
		if hq.is_empty() or is_unlocked(profile_data, hq_id):
			continue
		var trigger: Dictionary = hq.get("trigger", {})
		if String(trigger.get("type", "")) != event_type:
			continue
		if event_type != "first_run" and String(trigger.get("stage", "")) != stage_id:
			continue
		out.append(hq_id)
	return out

static func newly_earned_ids(achievement_ids: Array) -> Array[String]:
	var out: Array[String] = []
	# Historical achievement grants are frozen on migration, never reactivated.
	return out

static func _has_campaign_progress(profile_data: Dictionary) -> bool:
	var stats: Dictionary = profile_data.get("stats", {})
	var reached: Dictionary = stats.get("reached", {})
	var heroes_played: Dictionary = stats.get("heroes_played", {})
	var codex: Dictionary = profile_data.get("codex", {})
	return int(stats.get("runs", 0)) > 0 \
		or int(stats.get("deaths", 0)) > 0 \
		or int(profile_data.get("coins", 0)) > 0 \
		or not Dictionary(profile_data.get("upgrades", {})).is_empty() \
		or not Dictionary(profile_data.get("cleared", {})).is_empty() \
		or not reached.is_empty() \
		or not heroes_played.is_empty() \
		or not Dictionary(codex.get("enemies", {})).is_empty() \
		or not Dictionary(codex.get("items", {})).is_empty() \
		or not Dictionary(codex.get("weapons", {})).is_empty() \
		or not Dictionary(profile_data.get("achievements", {})).is_empty()
