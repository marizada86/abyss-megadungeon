extends SceneTree
## Roda um tests/test_*.gd isolado: godot --headless --path . -s tools/run_one_test.gd -- test_nome
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var name := ""
	for a in OS.get_cmdline_user_args():
		name = a
	var previous_orphans := Node.get_orphan_node_ids()
	var scr = load("res://tests/%s.gd" % name)
	if scr == null or not scr.can_instantiate():
		printerr("FALHA %s: script não compila ou não existe" % name)
		print("%s: 1 falha(s)" % name)
		quit(1)
		return
	var res = scr.new().run()
	# Standalone fixtures may allocate Nodes without adding them to the tree.
	# Free only new orphan fixtures; preserve autoloads and prior orphan nodes.
	for id in Node.get_orphan_node_ids():
		if previous_orphans.has(id):
			continue
		var node := instance_from_id(id)
		if node is Node and node.get_parent() == null:
			node.free()
	await process_frame
	for m in res:
		printerr("FALHA ", m)
	print("%s: %d falha(s)" % [name, res.size()])
	quit(1 if res.size() > 0 else 0)
