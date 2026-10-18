extends SceneTree
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	var script:=GDScript.new()
	script.source_code=FileAccess.get_file_as_string("res://.atena/generated/path-revision-20261017/r2-review/test_map_objectives.gd.candidate.txt")
	if script.reload()!=OK:
		quit(1)
		return
	var failures: Array=script.new().run()
	var args:=OS.get_cmdline_user_args()
	var output:=args[args.find("--capture-dir")+1]
	var file:=FileAccess.open(output.path_join("r2-preview.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"status":"DRAFT_TEST_PREVIEW_ONLY","failures":failures,"live_test_modified":false,"not_an_approved_suite_result":true},"\t"))
	file.close()
	quit(0 if failures.is_empty() else 1)
