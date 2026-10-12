extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var directory := OS.get_user_data_dir().replace("\\", "/")
	if not directory.contains("NottgardSplitQA/20261012/"):
		printerr("isolamento de save não confirmado")
		quit(1)
		return
	var failures: Array = load("res://tests/test_platform_contract.gd").new().run()
	for failure in failures:
		printerr("FALHA ", failure)
	print("platform contract: %d falha(s); save sintético confirmado; --mobile-controls ignorado" % failures.size())
	quit(1 if not failures.is_empty() else 0)
