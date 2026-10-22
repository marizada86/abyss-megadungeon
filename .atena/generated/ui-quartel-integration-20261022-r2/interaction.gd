extends SceneTree

var checks: Array = []

func _init() -> void:
	call_deferred("_run")

func _frames() -> void:
	for i in 4:
		await process_frame

func _check(id: String, passed: bool) -> void:
	checks.append({"id":id, "passed":passed})
	print("UI_CHECK ", id, ": ", "PASS" if passed else "FAIL")

func _key(code: Key) -> void:
	for pressed in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.physical_keycode = code
		event.pressed = pressed
		root.push_input(event, true)
		await _frames()

func _joy(code: JoyButton) -> void:
	for pressed in [true, false]:
		var event := InputEventJoypadButton.new()
		event.device = 0
		event.button_index = code
		event.pressed = pressed
		root.push_input(event, true)
		await _frames()

func _run() -> void:
	var game := root.get_node("Game")
	game.profile = Profile.new({"name":"Synthetic interaction", "welcome_seen":true})
	var menu = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	await _frames()
	menu.hero_list.select(0)
	menu.hero_list.grab_focus()
	await _key(KEY_DOWN)
	_check("keyboard_selects_next_hero", menu.hero_list.get_selected_items() == PackedInt32Array([1]) and game.run_hero == menu.heroes[1])
	var locked_index := 0
	for i in menu.heroes.size():
		if not game.profile.hero_unlocked(menu.heroes[i]):
			locked_index = i
			break
	menu.hero_list.select(locked_index)
	menu.hero_list.ensure_current_is_visible()
	menu._refresh_hero()
	await _frames()
	_check("locked_hero_disables_play", menu.play_btn.disabled)
	menu._refresh_all()
	_check("refresh_preserves_selection", menu.hero_list.get_selected_items() == PackedInt32Array([locked_index]))
	var last: int = menu.heroes.size() - 1
	menu.hero_list.select(last)
	menu.hero_list.ensure_current_is_visible()
	menu._refresh_hero()
	await _frames()
	var list: ItemList = menu.hero_list
	var position := list.get_global_rect().position + list.get_theme_stylebox("panel").get_offset() + list.get_item_rect(last).get_center() - Vector2(0, list.get_v_scroll_bar().value)
	for pressed in [true, false]:
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.position = position
		click.pressed = pressed
		root.push_input(click, true)
		await _frames()
	_check("mouse_selects_last_scrolled_card", menu.hero_list.get_selected_items() == PackedInt32Array([last]))
	game.controls._held.clear()
	game.controls._blocked.clear()
	game.controls.active_device = 0
	game.controls.method = "controller"
	game.controls.disconnected = false
	game.controls.focused = true
	menu.hero_list.grab_focus()
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	_check("controller_right_moves_to_stages", root.gui_get_focus_owner() == menu.stage_list)
	await _joy(JOY_BUTTON_DPAD_LEFT)
	_check("controller_left_returns_to_heroes", root.gui_get_focus_owner() == menu.hero_list)
	_check("qa_stages_excluded", menu.stages.all(func(id): return not bool(Data.table("stages")[id].get("qa_only", false))))
	menu.free()
	var hud = load("res://ui/hud.tscn").instantiate()
	root.add_child(hud)
	var battle := Battle.new(421, "durvall", "dagruve")
	var result := battle.result()
	result.time = 125.0
	result.level = 12
	result.kills = 234
	result.bosses = 2
	result.descent_depth = 3
	hud.show_result(result, {"earned":123,"coins":4567,"reward_rate":0.3,"achievements":[]})
	await _frames()
	var plain: String = hud.result_text.get_parsed_text()
	_check("result_values_and_partial_reward_preserved", plain.contains("Tempo 02:05") and plain.contains("Nível 12") and plain.contains("Abates 234") and plain.contains("Chefes 2") and plain.contains("Profundidade 3") and plain.contains("+123 moedas (30% da tentativa) (total 4567)"))
	_check("result_has_six_icons", hud.result_text.text.count("[img=") == 6)
	_check("timer_does_not_overlap_stage", hud.timer_label.get_global_rect().end.y < hud.stage_label.get_global_rect().position.y)
	hud.free()
	await _frames()
	var failures := checks.filter(func(c): return not c.passed).size()
	print("UI_INTERACTION_FAILURES=", failures)
	quit(0 if failures == 0 else 1)
