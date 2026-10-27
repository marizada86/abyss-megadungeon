class_name Accessibility
extends RefCounted
## PLAN-ABYSS-QOL-A11Y-P1 (SPEC-ABYSS-QOL-ACCESSIBILITY-20261027): regras puras das opções de acessibilidade do P1.
## Escala da interface, contraste alto, modos para daltonismo (paleta + segunda pista) e duração das falas.
## Tudo é lido de `profile.data.settings` com padrão: um perfil sem as chaves novas se comporta como antes.

const UI_SCALES: Array[int] = [100, 125, 150]
const UI_SCALE_LABELS: Array[String] = ["Normal (100%)", "Grande (125%)", "Muito grande (150%)"]

static func ui_scale_of(settings: Dictionary) -> int:
	var value := int(settings.get("ui_scale", 100))
	return value if value in UI_SCALES else 100

static func ui_factor(settings: Dictionary) -> float:
	return float(ui_scale_of(settings)) / 100.0

## Botão direito sobre um objeto interativo ao alcance interage (padrão ligado).
static func rmb_interact_of(settings: Dictionary) -> bool:
	return bool(settings.get("rmb_interact", true))

static func high_contrast_of(settings: Dictionary) -> bool:
	return bool(settings.get("high_contrast", false))

# ------------------------------------------------------------------ contraste alto

const HC_WINDOW_ALPHA := 1.0   # janelas opacas (o padrão é UiKit.WINDOW_ALPHA)
const HC_DIM_ALPHA := 0.78     # escurecimento atrás das janelas (o padrão é UiKit.DIM_ALPHA)
const HC_OUTLINE_SIZE := 4
const HC_OUTLINE_COLOR := Color(0.02, 0.02, 0.04, 1.0)
const HC_LUMA_MIN := 0.3
const HC_LUMA_MAX := 0.82
const HC_CHROMA_MAX := 0.4
const HC_LIFT := 0.5

static func luma(c: Color) -> float:
	return 0.299 * c.r + 0.587 * c.g + 0.114 * c.b

## Texto apagado (cinza, dourado fosco) sobe em direção ao branco; cores vivas (vermelho de dano, verde de cura) e textos claros ficam como estão.
static func lift_text(c: Color) -> Color:
	var chroma := maxf(c.r, maxf(c.g, c.b)) - minf(c.r, minf(c.g, c.b))
	var l := luma(c)
	if l < HC_LUMA_MIN or l > HC_LUMA_MAX or chroma > HC_CHROMA_MAX:
		return c
	return c.lerp(Color(1, 1, 1, c.a), HC_LIFT)

# ------------------------------------------------------------------ daltonismo

const COLOR_MODES: Array[String] = ["off", "protanopia", "deuteranopia", "tritanopia"]
const COLOR_LABELS: Array[String] = ["Desligado", "Protanopia (vermelho)", "Deuteranopia (verde)", "Tritanopia (azul)"]
const DTYPES: Array[String] = ["fisico", "fogo", "radiante", "magico"]
const RARITIES: Array[String] = ["comum", "magico", "incomum", "raro", "unico"]

## Paletas substitutas por tipo de dano. Protanopia e deuteranopia confundem vermelho e verde: o par usa laranja-avermelhado, amarelo e azul.
## Tritanopia confunde azul e amarelo: o par usa vermelho, ciano e verde. A diferença de luminância também conta (ver tests/test_accessibility.gd).
const DAMAGE_PALETTE := {
	"protanopia": {"fisico": Color(0.86, 0.86, 0.9), "fogo": Color(0.84, 0.37, 0.0), "radiante": Color(0.97, 0.92, 0.28), "magico": Color(0.35, 0.7, 0.93)},
	"deuteranopia": {"fisico": Color(0.86, 0.86, 0.9), "fogo": Color(0.84, 0.37, 0.0), "radiante": Color(0.97, 0.92, 0.28), "magico": Color(0.35, 0.7, 0.93)},
	"tritanopia": {"fisico": Color(0.86, 0.86, 0.9), "fogo": Color(0.92, 0.25, 0.2), "radiante": Color(0.55, 0.95, 0.9), "magico": Color(0.2, 0.55, 0.25)},
}
const RARITY_PALETTE := {
	"protanopia": {"comum": Color(0.8, 0.8, 0.82), "magico": Color(0.35, 0.7, 0.93), "incomum": Color(0.0, 0.62, 0.45), "raro": Color(0.97, 0.92, 0.28), "unico": Color(0.84, 0.37, 0.0)},
	"deuteranopia": {"comum": Color(0.8, 0.8, 0.82), "magico": Color(0.35, 0.7, 0.93), "incomum": Color(0.0, 0.62, 0.45), "raro": Color(0.97, 0.92, 0.28), "unico": Color(0.84, 0.37, 0.0)},
	"tritanopia": {"comum": Color(0.8, 0.8, 0.82), "magico": Color(0.55, 0.95, 0.9), "incomum": Color(0.2, 0.55, 0.25), "raro": Color(1.0, 0.75, 0.8), "unico": Color(0.92, 0.25, 0.2)},
}
## Segunda pista que não depende de cor, ao lado do número de dano. Físico é a base e fica sem marca.
const DAMAGE_GLYPH := {"fogo": "▲", "radiante": "●", "magico": "◆"}

## Modo em vigor, espelhado pelo Game: scripts de `core/` não podem citar o autoload `Game` (não compilam antes dele).
static var active_color_mode := "off"

static func color_mode_of(settings: Dictionary) -> String:
	var mode := str(settings.get("color_mode", "off"))
	return mode if mode in COLOR_MODES else "off"

## Com o modo desligado devolve `fallback` (a cor que o código já usava); assim o visual padrão não muda.
static func dtype_color(dtype: String, mode: String, fallback: Color) -> Color:
	if mode == "off" or not DAMAGE_PALETTE.has(mode):
		return fallback
	var table: Dictionary = DAMAGE_PALETTE[mode]
	if not table.has(dtype):
		return fallback
	var c: Color = table[dtype]
	return Color(c.r, c.g, c.b, fallback.a)

static func rarity_color(rarity: String, mode: String, fallback: Color) -> Color:
	if mode == "off" or not RARITY_PALETTE.has(mode):
		return fallback
	var table: Dictionary = RARITY_PALETTE[mode]
	return table[rarity] if table.has(rarity) else fallback

static func dtype_glyph(dtype: String, mode: String) -> String:
	if mode == "off":
		return ""
	return String(DAMAGE_GLYPH.get(dtype, ""))

## "▲ 12" com o modo ligado; o número puro com ele desligado.
static func damage_text(amount: int, dtype: String, mode: String) -> String:
	var glyph := dtype_glyph(dtype, mode)
	return "%s %d" % [glyph, amount] if glyph != "" else str(amount)

# ------------------------------------------------------------------ falas e avisos

const SPEECH_MODES: Array[String] = ["normal", "longo", "proxima"]
const SPEECH_LABELS: Array[String] = ["Normal", "Longa (2,5x)", "Até a próxima (máx. 30 s)"]
const SPEECH_LONG_FACTOR := 2.5
const SPEECH_MAX := 30.0

static func speech_mode_of(settings: Dictionary) -> String:
	var mode := str(settings.get("speech_time", "normal"))
	return mode if mode in SPEECH_MODES else "normal"

## Quanto tempo uma fala ou aviso fica na tela, em segundos, a partir do tempo normal `base`.
static func speech_hold(mode: String, base: float) -> float:
	match mode:
		"longo": return minf(base * SPEECH_LONG_FACTOR, SPEECH_MAX)
		"proxima": return SPEECH_MAX
	return base
