extends RefCounted

func run() -> Array:
	var failures: Array = []
	if Game.touch_controls_enabled():
		failures.append("os controles mobile foram reativados")
	for path in ["res://ui/mobile_controls.gd", "res://ui/touch_ui.gd"]:
		if ResourceLoader.exists(path):
			failures.append("recurso mobile ainda empacotado: " + path)
	var presets := FileAccess.get_file_as_string("res://export_presets.cfg")
	var web := presets.contains('platform="Web"')
	if web == presets.contains('platform="Windows Desktop"'):
		failures.append("o projeto precisa de um único alvo de export")
	var playtest := FileAccess.get_file_as_string("res://core/playtest.gd")
	var leaderboard := FileAccess.get_file_as_string("res://ui/leaderboard.gd")
	if not web and (playtest.contains("JavaScriptBridge") or leaderboard.contains("JavaScriptBridge")):
		failures.append("PC ainda depende da bridge de navegador")
	if web and (playtest.contains("ZIPPacker") or leaderboard.contains("OS.shell_open")):
		failures.append("web ainda oferece funcionalidade nativa exclusiva")
	var options := OptionsPanel.new()
	if web and (not options.resolution.disabled or options.display_mode.item_count != 2):
		failures.append("opções web precisam acompanhar o navegador")
	options.free()
	return failures
