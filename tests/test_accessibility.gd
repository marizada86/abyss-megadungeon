extends RefCounted
## PLAN-ABYSS-QOL-A11Y-P1: escala da interface, contraste alto, daltonismo e duração das falas.

const MIN_DELTA_E := 24.0   # diferença mínima entre duas categorias depois da simulação de daltonismo

# Machado et al. 2009, severidade 1,0, sobre RGB linear.
const SIM := {
	"protanopia": [[0.152286, 1.052583, -0.204868], [0.114503, 0.786281, 0.099216], [-0.003882, -0.048116, 1.051998]],
	"deuteranopia": [[0.367322, 0.860646, -0.227968], [0.280085, 0.672501, 0.047413], [-0.011820, 0.042940, 0.968881]],
	"tritanopia": [[1.255528, -0.076749, -0.178779], [-0.078411, 0.930809, 0.147602], [0.004733, 0.691367, 0.303900]],
}

static func _lin(v: float) -> float:
	return v / 12.92 if v <= 0.04045 else pow((v + 0.055) / 1.055, 2.4)

static func _f(t: float) -> float:
	return pow(t, 1.0 / 3.0) if t > 0.008856 else 7.787 * t + 16.0 / 116.0

static func _lab(rgb: Vector3) -> Vector3:
	var x := (0.4124 * rgb.x + 0.3576 * rgb.y + 0.1805 * rgb.z) / 0.95047
	var y := 0.2126 * rgb.x + 0.7152 * rgb.y + 0.0722 * rgb.z
	var z := (0.0193 * rgb.x + 0.1192 * rgb.y + 0.9505 * rgb.z) / 1.08883
	return Vector3(116.0 * _f(y) - 16.0, 500.0 * (_f(x) - _f(y)), 200.0 * (_f(y) - _f(z)))

## Cor como aparece para quem tem o tipo de daltonismo `mode`, em Lab.
static func perceived(c: Color, mode: String) -> Vector3:
	var lin := Vector3(_lin(c.r), _lin(c.g), _lin(c.b))
	var m: Array = SIM[mode]
	var out := Vector3(
		m[0][0] * lin.x + m[0][1] * lin.y + m[0][2] * lin.z,
		m[1][0] * lin.x + m[1][1] * lin.y + m[1][2] * lin.z,
		m[2][0] * lin.x + m[2][1] * lin.y + m[2][2] * lin.z)
	return _lab(Vector3(clampf(out.x, 0, 1), clampf(out.y, 0, 1), clampf(out.z, 0, 1)))

func _min_pair(table: Dictionary, keys: Array, mode: String) -> float:
	var best := INF
	for i in keys.size():
		for j in range(i + 1, keys.size()):
			best = minf(best, perceived(table[keys[i]], mode).distance_to(perceived(table[keys[j]], mode)))
	return best

func run() -> Array:
	var out: Array = []

	# ---- regras puras
	if not Game.vsync_of({}) or Game.vsync_of({"vsync": false}) or Game.fps_cap_of({}) != 0 or Game.fps_cap_of({"fps_cap": 60}) != 60 or Game.fps_cap_of({"fps_cap": 77}) != 0:
		out.append("0.5.2: VSync padrão ligado e limite de quadros padrão sem limite; valor inválido volta a 0")
	var slot := AbilitySlot.new()
	slot.set_alert(true)
	if not slot._alert:
		out.append("0.5.2: o slot da habilidade deveria aceitar o alerta de conjuração")
	slot.free()
	if Accessibility.ui_scale_of({}) != 100 or Accessibility.ui_scale_of({"ui_scale": 140}) != 100 or Accessibility.ui_scale_of({"ui_scale": 150}) != 150:
		out.append("escala: ausente ou inválida volta a 100; 150 vale")
	if not is_equal_approx(Accessibility.ui_factor({"ui_scale": 125}), 1.25):
		out.append("fator da escala 125 deveria ser 1,25")
	if Accessibility.high_contrast_of({}) or not Accessibility.high_contrast_of({"high_contrast": true}):
		out.append("contraste alto: padrão desligado")
	if Accessibility.color_mode_of({}) != "off" or Accessibility.color_mode_of({"color_mode": "x"}) != "off" or Accessibility.color_mode_of({"color_mode": "tritanopia"}) != "tritanopia":
		out.append("modo de cor: ausente ou inválido volta a off")
	if Accessibility.speech_mode_of({}) != "normal" or Accessibility.speech_mode_of({"speech_time": "longo"}) != "longo" or Accessibility.speech_mode_of({"speech_time": "zzz"}) != "normal":
		out.append("duração das falas: padrão normal")
	if not is_equal_approx(Accessibility.speech_hold("normal", 2.6), 2.6) or not is_equal_approx(Accessibility.speech_hold("longo", 2.6), 6.5) \
			or not is_equal_approx(Accessibility.speech_hold("longo", 20.0), Accessibility.SPEECH_MAX) or not is_equal_approx(Accessibility.speech_hold("proxima", 2.6), Accessibility.SPEECH_MAX):
		out.append("speech_hold: normal 1x, longo 2,5x com teto de 30 s, próxima 30 s")
	if Accessibility.UI_SCALES.size() != Accessibility.UI_SCALE_LABELS.size() or Accessibility.COLOR_MODES.size() != Accessibility.COLOR_LABELS.size() \
			or Accessibility.SPEECH_MODES.size() != Accessibility.SPEECH_LABELS.size():
		out.append("listas de valores e rótulos têm o mesmo tamanho")

	# ---- contraste: texto apagado sobe; vivo, claro e escuro ficam
	var grey := Color(0.62, 0.62, 0.68)
	if Accessibility.luma(Accessibility.lift_text(grey)) <= Accessibility.luma(grey) + 0.1:
		out.append("cinza apagado deveria clarear")
	for keep in [Color(1.0, 0.35, 0.3), Color(0.95, 0.95, 0.95), Color(0.2, 0.2, 0.2)]:
		if not Accessibility.lift_text(keep).is_equal_approx(keep):
			out.append("cor viva, clara ou escura demais não deveria mudar: %s" % keep)

	# ---- daltonismo: com o modo desligado nada muda; ligado, as categorias seguem distinguíveis
	var fallback := Color(0.1, 0.2, 0.3, 0.7)
	if Accessibility.dtype_color("fogo", "off", fallback) != fallback or Accessibility.rarity_color("raro", "off", fallback) != fallback:
		out.append("modo desligado devolve a cor original")
	if not is_equal_approx(Accessibility.dtype_color("fogo", "protanopia", fallback).a, 0.7):
		out.append("a paleta preserva o alfa da cor original")
	if Accessibility.dtype_color("veneno", "protanopia", fallback) != fallback:
		out.append("tipo sem paleta devolve a cor original")
	for mode in SIM:
		var damage: Dictionary = Accessibility.DAMAGE_PALETTE[mode]
		if damage.size() != Accessibility.DTYPES.size():
			out.append("%s: paleta de dano deve cobrir os %d tipos" % [mode, Accessibility.DTYPES.size()])
		var d := _min_pair(damage, Accessibility.DTYPES, mode)
		if d < MIN_DELTA_E:
			out.append("%s: tipos de dano parecidos demais (ΔE %.1f < %.1f)" % [mode, d, MIN_DELTA_E])
		var rarity: Dictionary = Accessibility.RARITY_PALETTE[mode]
		if rarity.size() != Accessibility.RARITIES.size():
			out.append("%s: paleta de raridade deve cobrir as %d raridades" % [mode, Accessibility.RARITIES.size()])
		var r := _min_pair(rarity, Accessibility.RARITIES, mode)
		if r < MIN_DELTA_E:
			out.append("%s: raridades parecidas demais (ΔE %.1f < %.1f)" % [mode, r, MIN_DELTA_E])
	# segunda pista: com o modo ligado todo tipo elemental tem marca própria; desligado, número puro
	var glyphs := {}
	for t in ["fogo", "radiante", "magico"]:
		var g := Accessibility.dtype_glyph(t, "deuteranopia")
		if g == "" or glyphs.has(g):
			out.append("tipo %s sem marca própria" % t)
		glyphs[g] = true
	if Accessibility.damage_text(12, "fogo", "off") != "12" or Accessibility.damage_text(12, "fisico", "protanopia") != "12" \
			or Accessibility.damage_text(12, "fogo", "protanopia") != "▲ 12":
		out.append("texto do dano: puro com o modo desligado e no físico; marca + número nos elementais")

	# ---- perfil: perfil antigo não ganha chave nova; valores inválidos são corrigidos
	var old := Profile.new({"settings": {"volume": 0.5}})
	for key in ["ui_scale", "high_contrast", "color_mode", "speech_time"]:
		if old.data.settings.has(key):
			out.append("perfil antigo não deveria ganhar a chave %s" % key)
	var bad := Profile.new({"settings": {"ui_scale": 3, "high_contrast": "sim", "color_mode": "x", "speech_time": 9}})
	if int(bad.data.settings.ui_scale) != 100 or bad.data.settings.high_contrast != false or bad.data.settings.color_mode != "off" or bad.data.settings.speech_time != "normal":
		out.append("valores inválidos do perfil voltam ao padrão")
	var good := Profile.new({"settings": {"ui_scale": 150, "high_contrast": true, "color_mode": "tritanopia", "speech_time": "proxima"}})
	if int(good.data.settings.ui_scale) != 150 or good.data.settings.high_contrast != true or good.data.settings.color_mode != "tritanopia" or good.data.settings.speech_time != "proxima":
		out.append("valores válidos do perfil são preservados")

	out.append_array(_adapter_checks())
	out.append_array(_game_checks())
	return out

func _adapter_checks() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var theme := ThemeDB.get_project_theme()
	var theme_before: int = theme.default_font_size if theme != null else 0
	var adapter := UiAdapter.new()
	adapter.install(tree)
	var holder := Control.new()
	tree.root.add_child(holder)
	var sized := Label.new()
	sized.add_theme_font_size_override("font_size", 14)
	sized.add_theme_color_override("font_color", Color(0.62, 0.62, 0.68))
	var plain := Label.new()
	var world := Label.new()
	world.add_theme_font_size_override("font_size", 16)
	world.set_meta(UiAdapter.META_SKIP, true)
	var rich := RichTextLabel.new()
	rich.add_theme_font_size_override("normal_font_size", 16)
	for n in [sized, plain, world, rich]:
		holder.add_child(n)

	adapter.configure(1.5, false)
	if sized.get_theme_font_size("font_size") != 21:
		out.append("tamanho 14 a 150%% deveria virar 21 (veio %d)" % sized.get_theme_font_size("font_size"))
	if rich.get_theme_font_size("normal_font_size") != 24:
		out.append("RichTextLabel 16 a 150%% deveria virar 24")
	if world.get_theme_font_size("font_size") != 16:
		out.append("nó com META_SKIP não deve ser escalado")
	if theme != null and theme.default_font_size != 30:
		out.append("tamanho padrão do tema a 150%% deveria ser 30 (veio %d)" % theme.default_font_size)
	if plain.has_theme_font_size_override("font_size"):
		out.append("controle sem tamanho próprio segue o tema, sem override")
	# reaplicar não acumula
	adapter.configure(1.5, false)
	if sized.get_theme_font_size("font_size") != 21:
		out.append("reaplicar a mesma escala não pode acumular")
	# outra escala parte da base, não do valor já escalado
	adapter.configure(1.25, false)
	if sized.get_theme_font_size("font_size") != 18:
		out.append("14 a 125%% deveria ser 18 (veio %d)" % sized.get_theme_font_size("font_size"))
	# alguém reescreve o tamanho depois da escala: o valor novo vira a base
	sized.add_theme_font_size_override("font_size", 20)
	adapter.configure(1.5, false)
	if sized.get_theme_font_size("font_size") != 30:
		out.append("tamanho reescrito (20) a 150%% deveria virar 30 (veio %d)" % sized.get_theme_font_size("font_size"))
	# voltar a 100% devolve a base e limpa as marcas
	adapter.configure(1.0, false)
	if sized.get_theme_font_size("font_size") != 20 or rich.get_theme_font_size("normal_font_size") != 16:
		out.append("100%% devolve os tamanhos pedidos pelo código")
	if theme != null and theme.default_font_size != theme_before:
		out.append("100%% devolve o tamanho padrão do tema")

	# contraste alto: texto apagado clareia, contorno aparece, tudo volta ao desligar
	var before := Color(0.62, 0.62, 0.68)
	sized.add_theme_color_override("font_color", before)
	adapter.configure(1.0, true)
	var lifted := sized.get_theme_color("font_color")
	if Accessibility.luma(lifted) <= Accessibility.luma(before) + 0.1:
		out.append("contraste alto deveria clarear o texto apagado")
	if sized.get_theme_constant("outline_size") != Accessibility.HC_OUTLINE_SIZE:
		out.append("contraste alto deveria pôr contorno no rótulo")
	var own_outline := Label.new()
	own_outline.add_theme_constant_override("outline_size", 6)
	holder.add_child(own_outline)
	adapter.configure(1.0, true)
	if own_outline.get_theme_constant("outline_size") != 6:
		out.append("contorno do próprio código não pode ser trocado")
	adapter.configure(1.0, false)
	if not sized.get_theme_color("font_color").is_equal_approx(before) or sized.has_theme_constant_override("outline_size"):
		out.append("desligar o contraste devolve cor e contorno")
	if own_outline.get_theme_constant("outline_size") != 6:
		out.append("desligar o contraste mantém o contorno do código")
	if sized.has_meta(UiAdapter.META_BASE) and not (sized.get_meta(UiAdapter.META_BASE) as Dictionary).keys().all(func(k): return String(k).begins_with("color:") or String(k).begins_with("size:")):
		out.append("marcas do adaptador com formato inesperado")

	adapter.uninstall()
	holder.free()
	return out

func _game_checks() -> Array:
	var out: Array = []
	var s: Dictionary = Game.profile.data.settings
	var saved := {}
	for key in ["ui_scale", "high_contrast", "color_mode", "speech_time"]:
		saved[key] = s.get(key)
	Game.set_ui_scale(125)
	Game.set_ui_scale(133)   # inválido: ignorado
	Game.set_high_contrast(true)
	Game.set_color_mode("deuteranopia")
	Game.set_color_mode("nada")
	Game.set_speech_time("longo")
	if int(s.ui_scale) != 125 or s.high_contrast != true or s.color_mode != "deuteranopia" or s.speech_time != "longo":
		out.append("os setters do Game gravam valores válidos e ignoram inválidos")
	if not Game.high_contrast() or Game.color_mode() != "deuteranopia" or Game.speech_time() != "longo":
		out.append("os acessores do Game leem o perfil")
	if not is_equal_approx(Game.ui_adapter.factor, 1.25) or not Game.ui_adapter.high_contrast:
		out.append("o adaptador do Game segue escala e contraste do perfil")
	if not is_equal_approx(UiKit.window_alpha(), Accessibility.HC_WINDOW_ALPHA) or not is_equal_approx(UiKit.dim_alpha(), Accessibility.HC_DIM_ALPHA):
		out.append("contraste alto: janela opaca e escurecimento maior")
	if Items.rarity_color("raro") != Accessibility.RARITY_PALETTE["deuteranopia"]["raro"]:
		out.append("a raridade usa a paleta do modo")
	var panel := OptionsPanel.new()
	panel.refresh()
	if panel.ui_scale.selected != 1 or not panel.high_contrast.button_pressed or panel.color_mode.selected != 2 or panel.speech.selected != 1:
		out.append("o painel de opções reflete o perfil")
	panel.free()
	# restaura o perfil sintético
	for key in saved:
		if saved[key] == null:
			s.erase(key)
		else:
			s[key] = saved[key]
	Game.apply_accessibility()
	Game.save()
	if UiKit.window_alpha() != UiKit.WINDOW_ALPHA or UiKit.dim_alpha() != UiKit.DIM_ALPHA:
		out.append("sem contraste alto valem as constantes originais")
	return out
