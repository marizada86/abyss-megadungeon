extends RefCounted
## Mantém honesto o registro de adiamentos de tests/stage_contracts.gd: só mapas de objetivo sem chefe, só enquanto o
## conteúdo realmente não existe, e a falta continua tolerada em runtime.

const StageContracts := preload("res://tests/stage_contracts.gd")

func run() -> Array:
	var out: Array = []
	var stages: Dictionary = Data.table("stages")
	var manifest: Dictionary = Data.table("audio_manifest")
	var chronicles: Dictionary = Data.table("chronicles")
	for stage_id in StageContracts.DEFERRED:
		if not stages.has(stage_id):
			out.append("%s: adiamento registrado para fase que não existe em stages.json" % stage_id)
			continue
		var stage: Dictionary = stages[stage_id]
		if String(stage.get("completion", {}).get("kind", "boss")) != "timed_reach" or String(stage.get("boss", "")) != "":
			out.append("%s: só mapas de objetivo sem chefe podem adiar conteúdo" % stage_id)
		for topic in StageContracts.DEFERRED[stage_id]:
			if not StageContracts.TOPICS.has(topic):
				out.append("%s: tópico de adiamento desconhecido %s" % [stage_id, topic])
		if StageContracts.deferred(stage_id, "music") and manifest.get("music", {}).has(stage_id):
			out.append("%s: já tem música; remova o adiamento 'music'" % stage_id)
		if StageContracts.deferred(stage_id, "ambience") and manifest.get("ambience", {}).has(stage_id):
			out.append("%s: já tem ambiência; remova o adiamento 'ambience'" % stage_id)
		if StageContracts.deferred(stage_id, "chronicle") and chronicles.has(stage_id):
			out.append("%s: já tem crônica; remova o adiamento 'chronicle'" % stage_id)
		if StageContracts.deferred(stage_id, "decals") and Data.table("ground_decals").has(stage_id):
			out.append("%s: já tem decais; remova o adiamento 'decals'" % stage_id)
		if StageContracts.deferred(stage_id, "random_events"):
			for kind in RandomEvents.KINDS:
				if float(stage.get("interactions", {}).get(kind, 0.0)) > 0.0:
					out.append("%s: já tem peso para %s; remova o adiamento 'random_events'" % [stage_id, kind])
					break
		# tolerância em runtime: sem entrada, nada deve quebrar
		var battle := Battle.new(3, "durvall", stage_id)
		if battle.stage_id != stage_id or battle.hero == null:
			out.append("%s: a fase deveria iniciar mesmo sem o conteúdo adiado" % stage_id)
	return out
