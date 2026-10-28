class_name Catalog
extends RefCounted
## SPEC-165 (MEC-003): catálogo do jogo (inimigos, armas e feitiços, itens únicos) para o menu de pausa.
## Contas puras: desbloqueados aparecem com nome, ícone e detalhe; bloqueados ficam escuros, sem informação ("???").
## A fonte é `profile.codex` (entre runs) e `battle.codex` (o que apareceu nesta run), no mesmo formato.

const CATEGORIES := ["enemies", "weapons", "items"]
const LABELS := {"enemies": "Inimigos", "weapons": "Armas e feitiços", "items": "Itens únicos", "heroes": "Personagens"}
## Códex do Quartel: as três da pausa mais os personagens jogáveis (a pausa não lista heróis).
const QUARTEL_CATEGORIES := ["enemies", "weapons", "items", "heroes"]
const UNKNOWN_NAME := "???"
const UNKNOWN_DETAIL := "[color=#888888]Ainda não descoberto.[/color]"

static func source(category: String) -> Dictionary:
	if category == "items":
		var out := {}
		for u in Data.table("items").uniques:
			out[String(u.id)] = u
		return out
	return Data.table(category)

static func icon_path(category: String, id: String) -> String:
	match category:
		"enemies": return "res://assets/enemies/%s.png" % id
		"weapons": return "res://assets/icons/weapons/%s.png" % id
		"items": return "res://assets/icons/items/%s.png" % id
	return ""

## Entradas da categoria, na ordem dos dados: {id, name, known, seen_run, icon}.
## `known`: já está no perfil ou foi visto nesta run; `seen_run`: apareceu nesta run.
static func entries(category: String, profile_codex: Dictionary, run_codex: Dictionary = {}) -> Array:
	var seen_profile: Dictionary = profile_codex.get(category, {})
	var seen_run: Dictionary = run_codex.get(category, {})
	var out: Array = []
	var src := source(category)
	for id in src:
		if String(id).begins_with("_"):
			continue
		var in_run: bool = bool(seen_run.get(id, false)) if seen_run.has(id) else false
		var known: bool = seen_profile.has(id) or in_run
		out.append({"id": String(id), "name": String(src[id].name) if known else UNKNOWN_NAME, "known": known, "seen_run": in_run,
			"icon": icon_path(category, String(id)) if known else ""})
	return out

## {known, total}: quantos já foram descobertos entre todos.
static func counts(category: String, profile_codex: Dictionary, run_codex: Dictionary = {}) -> Dictionary:
	var known := 0
	var list := entries(category, profile_codex, run_codex)
	for e in list:
		if bool(e.known):
			known += 1
	return {"known": known, "total": list.size()}

## Texto (BBCode) do detalhe; desconhecido não revela nada.
## `profile` só no Quartel: com ele o inimigo ganha a biografia ("quem") e as curiosidades de data/codex_lore.json; a pausa não passa.
static func detail(category: String, id: String, known: bool, profile: Profile = null) -> String:
	if not known:
		return UNKNOWN_DETAIL
	match category:
		"enemies":
			var d: Dictionary = Data.table("enemies").get(id, {})
			if d.is_empty():
				return UNKNOWN_DETAIL
			var lore := enemy_lore(id) if profile != null else {}
			var text := "[b]%s[/b]\nPV %d · CA %d (%d%%) · CAM %d (%d%%) · dano %s · velocidade %.1f\n\n%s\nResistências: %s" % [d.name, d.hp, d.ca, clampi((int(d.ca) - 10) * 3, 0, 30), d.cam, clampi((int(d.cam) - 10) * 3, 0, 30), d.atk, float(d.speed), String(lore.quem) if not lore.is_empty() else d.get("note", ""), resist_text(d)]
			return text + enemy_extra(profile, id, lore) if not lore.is_empty() else text
		"weapons":
			var w: Dictionary = Data.table("weapons").get(id, {})
			if w.is_empty():
				return UNKNOWN_DETAIL
			var school := Weapon.school(w)
			var text := "[b]%s[/b]  [color=#%s][b]%s[/b][/color]\nOrigem: %s\nTipo: %s · dano %s · recarga %.1fs\n%s\n\n%s" % [w.name, Color(school.color).lightened(0.2).to_html(false), school.tag, w.src, w.kind, w.dice if w.dice != "" else "—", float(w.cd), Weapon.school_hint(w), w.desc]
			var wlore := item_lore("weapons", id) if profile != null else {}
			return text + "\n\n[b]História[/b]\n" + String(wlore.quem) + enemy_extra(profile, id, wlore) if not wlore.is_empty() else text
		"items":
			for u in Data.table("items").uniques:
				if String(u.id) == id:
					var ilore := item_lore("items", id) if profile != null else {}
					var itext := "[b]%s[/b] [color=#ff8c26](único · %s)[/color]\n%s\n\n%s" % [u.name, u.slot, Items.mods_text(u.mods), String(ilore.quem) if not ilore.is_empty() else u.get("note", "")]
					return itext + enemy_extra(profile, id, ilore) if not ilore.is_empty() else itext
	return UNKNOWN_DETAIL

# ------------------------------------------------------------------ personagens (Quartel)
## Fonte: data/codex_lore.json. Conhecido = herói liberado; curiosidades liberam por `req` (base, bio, hq:<id>).

static func hero_lore(id: String) -> Dictionary:
	return Dictionary(Data.table("codex_lore").get("heroes", {})).get(id, {})

static func hero_entries(profile: Profile) -> Array:
	var out: Array = []
	var src := Data.table("heroes")
	for id in src:
		var known: bool = profile.hero_unlocked(String(id))
		out.append({"id": String(id), "name": String(src[id].name) if known else UNKNOWN_NAME, "known": known, "seen_run": false,
			"icon": "res://assets/portraits/%s.png" % id if known else ""})
	return out

static func hero_counts(profile: Profile) -> Dictionary:
	var known := 0
	var list := hero_entries(profile)
	for e in list:
		if bool(e.known):
			known += 1
	return {"known": known, "total": list.size()}

static func req_met(profile: Profile, hero_id: String, req: String) -> bool:
	if req == "base":
		return profile.hero_unlocked(hero_id)
	if req == "bio":
		return profile.hero_bio_unlocked(hero_id)
	if req.begins_with("hq:"):
		return profile.data.hqs_seen.has(req.substr(3))
	return false

## Pista curta do que falta para liberar (sem revelar o texto).
static func req_hint(req: String) -> String:
	if req == "bio":
		return "vença uma fase com este herói"
	if req.begins_with("hq:"):
		return "veja a HQ «%s»" % String(Data.table("hqs").get(req.substr(3), {}).get("title", req.substr(3)))
	return ""

## {shown: [texto], locked: quantas faltam, hints: [pista sem repetição]}.
static func hero_curiosities(profile: Profile, id: String) -> Dictionary:
	var shown: Array = []
	var hints: Array = []
	var locked := 0
	for c in Array(hero_lore(id).get("curiosities", [])):
		if req_met(profile, id, String(c.req)):
			shown.append(String(c.text))
		else:
			locked += 1
			var h := req_hint(String(c.req))
			if h != "" and not hints.has(h):
				hints.append(h)
	return {"shown": shown, "locked": locked, "hints": hints}

static func hero_unlock_line(id: String) -> String:
	var req := String(Data.table("heroes").get(id, {}).get("unlock", "start"))
	if not req.begins_with("ach:"):
		return ""
	for a in Data.table("achievements").achievements:
		if a.id == req.substr(4):
			return "[color=#e0a040]Bloqueado. Conquista: %s (%s)[/color]" % [a.name, a.desc]
	return "[color=#e0a040]Bloqueado.[/color]"

## Texto (BBCode) da ficha do personagem; bloqueado não revela nada além da pista da conquista.
static func hero_detail(profile: Profile, id: String) -> String:
	var d: Dictionary = Data.table("heroes").get(id, {})
	if d.is_empty():
		return UNKNOWN_DETAIL
	if not profile.hero_unlocked(id):
		var line := hero_unlock_line(id)
		return UNKNOWN_DETAIL if line == "" else UNKNOWN_DETAIL + "\n\n" + line
	var w: Dictionary = Data.table("weapons").get(d.weapon, {})
	var a: Dictionary = d.attrs
	var txt := "[b]%s[/b] — %s\nFOR %d · INT %d · CON %d · CAR %d · PV %d\n[b]Arma inicial:[/b] %s\n[b]Passiva:[/b] %s — %s" % [
		d.name, d.title, a.forca, a.inteligencia, a.constituicao, a.carisma, d.base_hp, w.get("name", d.weapon), d.passive.name, d.passive.desc]
	var bio := String(Data.table("hero_bios").get(id, ""))
	if bio != "":
		if profile.hero_bio_unlocked(id):
			txt += "\n\n[b]Biografia[/b]\n[i]%s[/i]" % bio
		else:
			txt += "\n\n[color=#888888]Biografia bloqueada: vença uma fase com este herói.[/color]"
	var cur := hero_curiosities(profile, id)
	if not Array(cur.shown).is_empty():
		txt += "\n\n[b]Curiosidades[/b]"
		for t in cur.shown:
			txt += "\n• " + String(t)
	if int(cur.locked) > 0:
		var why := ""
		if not Array(cur.hints).is_empty():
			why = ": " + "; ".join(PackedStringArray(cur.hints))
		txt += "\n[color=#888888]%d por descobrir%s.[/color]" % [int(cur.locked), why]
	var titles: Array = []
	var unseen := 0
	for hq_id in Array(hero_lore(id).get("hqs", [])):
		if profile.data.hqs_seen.has(hq_id):
			titles.append(String(Data.table("hqs")[hq_id].title))
		else:
			unseen += 1
	if not titles.is_empty() or unseen > 0:
		txt += "\n\n[b]Nas HQs[/b]\n" + (", ".join(PackedStringArray(titles)) if not titles.is_empty() else "nenhuma vista ainda")
		if unseen > 0 and not titles.is_empty():
			txt += "\n[color=#888888](+%d ainda não vista%s)[/color]" % [unseen, "" if unseen == 1 else "s"]
	return txt

# ------------------------------------------------------------------ inimigos (Quartel)
## Fonte: data/codex_lore.json, chave `enemies`. `igual_a` aponta para outra entrada; `req` das curiosidades: base (visto),
## boss (este chefe já foi derrotado) ou hq:<id> (HQ já vista).

static func enemy_lore(id: String) -> Dictionary:
	var all: Dictionary = Dictionary(Data.table("codex_lore").get("enemies", {}))
	var entry: Dictionary = all.get(id, {})
	if entry.has("igual_a"):
		entry = all.get(String(entry.igual_a), {})
	return entry

static func enemy_req_met(profile: Profile, id: String, req: String) -> bool:
	if req == "base":
		return true
	if req == "boss":
		return int(profile.data.stats.boss_kills.get(id, 0)) > 0
	if req.begins_with("hq:"):
		return profile.data.hqs_seen.has(req.substr(3))
	return false

static func enemy_req_hint(req: String) -> String:
	if req == "boss":
		return "derrote este chefe"
	return req_hint(req)

## Curiosidades, pistas do que falta e "Onde aparece" (nomes das fases).
static func enemy_extra(profile: Profile, id: String, lore: Dictionary) -> String:
	var shown: Array = []
	var hints: Array = []
	var locked := 0
	for c in Array(lore.get("curiosities", [])):
		if enemy_req_met(profile, id, String(c.req)):
			shown.append(String(c.text))
		else:
			locked += 1
			var h := enemy_req_hint(String(c.req))
			if h != "" and not hints.has(h):
				hints.append(h)
	var txt := ""
	if not shown.is_empty():
		txt += "\n\n[b]Curiosidades[/b]"
		for t in shown:
			txt += "\n• " + String(t)
	if locked > 0:
		txt += "\n[color=#888888]%d por descobrir%s.[/color]" % [locked, (": " + "; ".join(PackedStringArray(hints))) if not hints.is_empty() else ""]
	var places: Array = []
	for sid in Array(lore.get("onde", [])):
		places.append(String(Data.table("stages").get(sid, {}).get("name", sid)))
	if not places.is_empty():
		txt += "\n\n[b]Onde aparece[/b]\n" + ", ".join(PackedStringArray(places))
	return txt

## "Resistências" legível: os dados guardam o multiplicador de dano recebido por tipo (0.5 = recebe 50%; 0 = imune).
const DAMAGE_LABELS := {"fisico": "físico", "magico": "mágico", "fogo": "fogo", "raio": "raio", "frio": "frio", "acido": "ácido", "veneno": "veneno",
	"psiquico": "psíquico", "radiante": "radiante", "necrotico": "necrótico", "trovao": "trovão"}

static func resist_text(d: Dictionary) -> String:
	var r: Variant = d.get("resist", null)
	if not (r is Dictionary) or Dictionary(r).is_empty():
		return "nenhuma"
	var parts: Array = []
	for k in r:
		parts.append("%s %d%%" % [DAMAGE_LABELS.get(String(k), String(k)), roundi(float(r[k]) * 100.0)])
	return "dano recebido: " + " · ".join(PackedStringArray(parts))

# ------------------------------------------------------------------ armas e itens únicos (Quartel)
## Fonte: data/codex_lore.json, chaves `items` (por id do único) e `weapons`. Uma arma pode ter `igual_a` apontando para um item único.

static func item_lore(section: String, id: String) -> Dictionary:
	var all: Dictionary = Dictionary(Data.table("codex_lore").get(section, {}))
	var entry: Dictionary = all.get(id, {})
	if entry.has("igual_a"):
		entry = Dictionary(Data.table("codex_lore").get("items", {})).get(String(entry.igual_a), {})
	return entry
