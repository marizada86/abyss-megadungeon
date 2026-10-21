extends RefCounted
## Nidhogg (Sessão 15, nome decidido pelo dono em 2026-10-21): inimigo imóvel de elite e o acontecimento da Raiz de Yggdrasil.

func run() -> Array:
	var out: Array = []
	var enemies: Dictionary = Data.table("enemies")
	if not enemies.has("nidhogg"):
		return ["inimigo nidhogg ausente em enemies.json"]
	var def := {}
	for d in Data.table("stage_events").get("raiz_yggdrasil", []):
		if String(d.id) == "nidhogg_mordida":
			def = d.duplicate(true)
	if def.is_empty():
		return ["acontecimento nidhogg_mordida ausente na Raiz de Yggdrasil"]
	if String(def.kind) != "invasion" or String(def.enemy_id) != "nidhogg":
		out.append("nidhogg_mordida deveria ser uma invasão de nidhogg")
	if float(enemies.nidhogg.speed) != 0.0 or not (enemies.nidhogg.flags as Array).has("elite_only"):
		out.append("Nidhogg deveria ser imóvel e só aparecer como elite de acontecimento")
	if not FileAccess.file_exists("res://assets/enemies/nidhogg.png"):
		out.append("arte estática de Nidhogg ausente")
	var b := Battle.new(7, "durvall", "raiz_yggdrasil")
	b.happenings.fire(b, def)
	var tagged := b.enemies.filter(func(e): return e.event_tag != "" and not e.dead)
	if tagged.size() != 1 or String(tagged[0].id) != "nidhogg":
		out.append("a invasão deveria gerar exatamente um Nidhogg marcado (veio %d)" % tagged.size())
	return out
