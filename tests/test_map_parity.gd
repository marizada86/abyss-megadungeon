extends RefCounted
## Plano CHAPTER1-MAPS-STANDARD r2 (lote C): todo mapa jogável entra com as entradas de ambiente e de interação dos mapas antigos.
## Crônicas, segredos (Ecos), decalques e música dependem de arte/canon (lote D) e ficam fora desta matriz.

func run() -> Array[String]:
	var out: Array[String] = []
	var stages: Dictionary = Data.table("stages")
	var atmosphere: Dictionary = Data.table("atmosphere")
	var reference: Array = stages.docas.interactions.keys()
	reference.sort()
	for sid in stages:
		if bool(stages[sid].get("qa_only", false)):
			continue
		if not atmosphere.has(sid):
			out.append("%s: sem perfil de atmosfera" % sid)
		var kinds: Array = stages[sid].get("interactions", {}).keys()
		kinds.sort()
		if kinds != reference:
			out.append("%s: interações diferentes do conjunto padrão (%s)" % [sid, str(kinds)])
		for kind in stages[sid].get("interactions", {}):
			if float(stages[sid].interactions[kind]) <= 0.0:
				out.append("%s: peso de %s não positivo" % [sid, kind])
	for sid in ["reino_abissal", "domwieck"]:
		var spec: Dictionary = Data.table("scenery").get(sid, {})
		var wanted: Array = spec.get("destrutiveis", [])
		if wanted.size() < 6:
			out.append("%s: poucos destrutíveis fixos (%d)" % [sid, wanted.size()])
		var b := Battle.new(4320, "durvall", sid)
		b.map_size = Vector2(60, 60)
		b.hero.map_size = b.map_size
		b.hero.pos = TerrainLayout.root_point(b.root_layout.arrival) if TerrainLayout.has_roots(sid) else Vector2(30, 45)
		var placed := b.place_scenery()
		if placed < wanted.size() - 2:
			out.append("%s: só %d de %d destrutíveis encontraram chão livre" % [sid, placed, wanted.size()])
		for e in b.enemies:
			if e.has_flag("quebravel") and not Data.table("enemies").has(e.id):
				out.append("%s: destrutível desconhecido %s" % [sid, e.id])
	return out
