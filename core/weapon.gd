class_name Weapon
extends RefCounted
## Arma equipada na run: definição base + deltas por nível.

const MAX_LEVEL := 5

var id := ""
var level := 1
var timer := 0.0
var def: Dictionary
var granted := false   # veio de um item (não ocupa slot)

static func make(weapon_id: String, lvl: int = 1) -> Weapon:
	var w := Weapon.new()
	w.id = weapon_id
	w.def = Data.table("weapons")[weapon_id]
	w.level = lvl
	w.timer = 0.4
	return w

## SPEC-149 (MEC-041): magia é o que o Arcanista melhora; arma é o que o ferreiro melhora. `spell` explícito no JSON manda;
## sem ele, é magia tudo que não é corpo a corpo e todo ataque de dano mágico (inclui a Estocada Mística).
static func is_spell(d: Dictionary) -> bool:
	if d.has("spell"):
		return bool(d.spell)
	return String(d.get("kind", "melee")) != "melee" or String(d.get("dtype", "")) == "magico"

## Escola da arma, para o jogador entender o que escala com o quê. Regra do jogo:
##   Física  = dano físico (a CA evita)  + escala com Força;
##   Mágica  = dano mágico (a CAM evita) + escala com Inteligência.
## Fogo e Radiante são tipos elementais próprios e mostram o atributo que de fato escala. Física ou Mágica com outro atributo
## (Constituição, Carisma) é exceção de classe declarada em SCHOOL_EXCEPTIONS: o tipo continua o mesmo e a etiqueta mostra o atributo real.
const DTYPE_LABELS := {"fisico": "Física", "magico": "Mágica", "fogo": "Fogo", "radiante": "Radiante"}
const DTYPE_GUARD := {"fisico": "evitado pela CA", "magico": "evitado pela CAM", "fogo": "evitado pela CAM", "radiante": "evitado pela CAM"}
const STANDARD_ATTR := {"fisico": "forca", "magico": "inteligencia"}
const ATTR_ABBR := {"forca": "FOR", "inteligencia": "INT", "constituicao": "CON", "carisma": "CAR"}
## Cor por atributo (a mesma da ficha e do painel do herói): Força vermelha, Inteligência amarela, Constituição azul, Carisma violeta.
const ATTR_COLORS := {"forca": Color(0.92, 0.42, 0.38), "inteligencia": Color(0.96, 0.86, 0.42), "constituicao": Color(0.45, 0.66, 0.96), "carisma": Color(0.78, 0.56, 0.96)}
## Armas Física/Mágica cujo atributo não é o padrão (Física→Força, Mágica→Inteligência). Decisão consciente: são das classes
## Paladino, Devoto, Bardo e Dominação; trocar o atributo mudaria o dano desses heróis. Novas armas fora da regra precisam entrar aqui.
const SCHOOL_EXCEPTIONS := ["golpe_atordoante", "chicote_avarento", "estocada_mistica", "dominar_pessoa", "dominio_coletivo",
	"cajado_dos_desejos", "dominio_da_vontade", "memoria_alterada"]

## {dtype, attr, label (tipo), attr_name, tag ("Física · Força"), tag_short ("Física · FOR", cartão compacto), color, exception, guard}. `d` é a definição da arma.
static func school(d: Dictionary) -> Dictionary:
	var dtype := String(d.get("dtype", "fisico"))
	var attr := String(d.get("attr", "forca"))
	var label := String(DTYPE_LABELS.get(dtype, dtype.capitalize()))
	var attr_name := String(ATTR_FULL.get(attr, attr))
	return {"dtype": dtype, "attr": attr, "label": label, "attr_name": attr_name, "tag": "%s · %s" % [label, attr_name], "tag_short": "%s · %s" % [label, ATTR_ABBR.get(attr, attr_name)],
		"color": ATTR_COLORS.get(attr, Color(0.8, 0.8, 0.8)), "exception": STANDARD_ATTR.has(dtype) and STANDARD_ATTR[dtype] != attr,
		"guard": String(DTYPE_GUARD.get(dtype, "evitado pela CAM"))}

## Frase que explica a etiqueta: "Mágica: dano mágico (evitado pela CAM), escala com Inteligência."
static func school_hint(d: Dictionary) -> String:
	var s := school(d)
	var kind := String({"fisico": "dano físico", "magico": "dano mágico", "fogo": "dano de fogo", "radiante": "dano radiante"}.get(s.dtype, "dano"))
	return "%s: %s (%s), escala com %s%s." % [s.label, kind, s.guard, s.attr_name, " — exceção da classe" if bool(s.exception) else ""]

func max_level() -> int:
	return MAX_LEVEL if not def.get("levels", []).is_empty() else 1

## Parâmetros efetivos no nível atual.
func params() -> Dictionary:
	var p: Dictionary = def.duplicate()
	var lv: Array = def.get("levels", [])
	for i in mini(level - 1, lv.size()):
		for k in lv[i]:
			if k == "dice":
				p["dice"] = lv[i][k]
			else:
				p[k] = float(p.get(k, 0.0)) + float(lv[i][k])
	return p

func can_evolve() -> bool:
	return def.has("evolve") and level >= MAX_LEVEL

const ATTR_FULL := {"forca": "Força", "inteligencia": "Inteligência", "constituicao": "Constituição", "carisma": "Carisma"}

## SPEC-174: mínimo de atributo para evoluir ({} = sem exigência). Chave = atributo, valor = mínimo efetivo.
func evolve_min_attr() -> Dictionary:
	var ev: Dictionary = def.get("evolve", {})
	return ev.get("min_attr", {})

## SPEC-174: atributos que ainda faltam, como [{attr, need, have}]; vazio quando o herói cumpre (ou não há exigência).
## `h` é o Hero: usa o atributo efetivo (base + passivas + itens + bênçãos).
func missing_attrs(h) -> Array:
	var out: Array = []
	var req := evolve_min_attr()
	for a in req:
		var have: int = h.attr(String(a))
		if have < int(req[a]):
			out.append({"attr": String(a), "need": int(req[a]), "have": have})
	return out

func display_name() -> String:
	return "%s %s" % [String(def.name), ("Nv %d" % level) if max_level() > 1 else "★"]
