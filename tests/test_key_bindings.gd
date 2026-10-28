extends RefCounted
## 0.5.2 (QoL Q3): teclas remapeáveis. Regras puras (KeyBindings) e efeito no InputMap (Game.apply_keybinds), sem tocar o save real.

func _has_key(action: StringName, code: int) -> bool:
	for e in InputMap.action_get_events(action):
		if e is InputEventKey and (e as InputEventKey).physical_keycode == code:
			return true
	return false

func run() -> Array:
	var out: Array = []
	# ---- regras puras
	for a in KeyBindings.ACTIONS:
		if KeyBindings.code_of({}, String(a.id)) != int(a.default):
			out.append("%s: sem ajuste grava o padrão" % a.id)
		if not KeyBindings.is_assignable(int(a.default)):
			out.append("%s: o padrão deveria poder ser atribuído" % a.id)
	if KeyBindings.is_assignable(KEY_ESCAPE) or KeyBindings.is_assignable(KEY_1) or KeyBindings.is_assignable(KEY_LEFT) or KeyBindings.is_assignable(KEY_NONE):
		out.append("Esc, 1-9, setas e nenhuma tecla são reservados")
	if KeyBindings.code_of({"keybinds": {"hero_active": KEY_ESCAPE}}, "hero_active") != KEY_Q:
		out.append("tecla reservada gravada no perfil deve voltar ao padrão")
	if KeyBindings.code_of({"keybinds": 7}, "hero_active") != KEY_Q:
		out.append("keybinds malformado deve voltar ao padrão")
	var diff := KeyBindings.rebind({}, "hero_active", KEY_G)
	if diff != {"hero_active": KEY_G}:
		out.append("rebind simples: só a ação mudada entra (%s)" % diff)
	var swap := KeyBindings.rebind({"keybinds": diff}, "run_interact", KEY_G)   # G está em hero_active: as duas trocam
	if int(swap.get("run_interact", -1)) != KEY_G or int(swap.get("hero_active", -1)) != KEY_E:
		out.append("rebind com conflito deveria trocar as duas ações (%s)" % swap)
	if not KeyBindings.rebind({}, "hero_active", KEY_ESCAPE).is_empty() or not KeyBindings.rebind({}, "nao_existe", KEY_G).is_empty():
		out.append("rebind inválido não deve mudar nada")
	if not KeyBindings.rebind({"keybinds": diff}, "hero_active", KEY_Q).is_empty():
		out.append("voltar ao padrão deveria zerar as diferenças")
	var seen := {}
	for id in KeyBindings.ids():
		var code := KeyBindings.code_of({"keybinds": swap}, String(id))
		if seen.has(code):
			out.append("duas ações na mesma tecla após a troca: %s e %s" % [seen[code], id])
		seen[code] = id
	# ---- InputMap
	var settings: Dictionary = Game.profile.data.settings
	var saved_path: String = Game._save_path
	Game._save_path = "user://test_key_bindings_profile.json"   # nunca grava no save real
	var was: Variant = settings.get("keybinds", null)
	Game.set_keybinds({"hero_active": KEY_G, "key_move_left": KEY_J})
	if not _has_key(&"hero_active", KEY_G) or _has_key(&"hero_active", KEY_Q):
		out.append("hero_active deveria passar de Q para G")
	if not _has_key(&"key_move_left", KEY_J) or _has_key(&"key_move_left", KEY_A):
		out.append("key_move_left deveria passar de A para J")
	if Game.key_hint("hero_active") != "G":
		out.append("a dica de tecla deveria mostrar G (%s)" % Game.key_hint("hero_active"))
	if KeyBindings.active_hint("hero_active") != "G":
		out.append("o núcleo (sem autoload) deveria ler a tecla ativa G (%s)" % KeyBindings.active_hint("hero_active"))
	var mouse_kept := false
	for e in InputMap.action_get_events(&"hero_active"):
		if e is InputEventMouseButton:
			mouse_kept = true
	if not mouse_kept:
		out.append("remapear o teclado não pode tirar o botão direito da habilidade")
	Game.ensure_input_actions()   # reaplicar controles (troca de botão do controle) não pode trazer o Q de volta
	if _has_key(&"hero_active", KEY_Q) or not _has_key(&"hero_active", KEY_G):
		out.append("ensure_input_actions deveria manter as teclas remapeadas")
	Game.set_keybinds({"run_interact": KEY_T})   # T era segunda tecla de velocidade: sai de lá
	if _has_key(&"run_speed", KEY_T) or not _has_key(&"run_interact", KEY_T):
		out.append("T atribuído a outra ação não pode continuar como alias de velocidade")
	Game.set_keybinds({})
	if not _has_key(&"hero_active", KEY_Q) or not _has_key(&"run_speed", KEY_T) or not _has_key(&"run_speed", KEY_F):
		out.append("restaurar deveria voltar Q e as teclas de velocidade F e T")
	if was == null:
		settings.erase("keybinds")
	else:
		settings["keybinds"] = was
	for p in [Game._save_path, Game.profile_backup_path(Game._save_path), Game.profile_temp_path(Game._save_path)]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	Game._save_path = saved_path
	Game.apply_keybinds()
	return out
