extends SceneTree

var failures: Array = []
var captures: Array = []

func _init() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var output := args[args.find("--capture-dir")+1]
	await process_frame
	await process_frame
	var game = root.get_node("Game")
	root.get_node("Playtest").call("_close_guide_modal")
	game.profile = Profile.new({"coins":123})
	var original: Dictionary = game.profile.data.duplicate(true)
	var source_profile: Profile = game.profile
	var source_signature: Dictionary = game.real_save_signature()
	for stage_id in ["reino_abissal","domwieck"]:
		_check(game.start_qa_run({"stage_id":stage_id,"hero_id":"durvall","target_state":"running","seed":7202}),"QA entry failed")
		for i in 6:
			await process_frame
		var scene = current_scene
		_check(scene != null and scene.get("battle") != null,"Run failed to load")
		if scene == null or scene.get("battle") == null:
			quit(1)
			return
		scene.set_physics_process(false)
		scene.set_process(false)
		var battle: Battle = scene.battle
		_check(not battle.hero.dead and battle.hero.can_stand(battle.hero.pos),"Invalid root arrival")
		for size in [Vector2i(1280,720),Vector2i(1920,1080)]:
			root.size = size
			root.content_scale_size = Vector2i(1280,720)
			root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			for phase in ["arrival","edge","target","junction_w","junction_l","combat"]:
				battle.hero.pos = {"arrival":Vector2(30,45),"edge":Vector2(16.8,22),"target":Vector2(30,15),"junction_w":Vector2(15,30),"junction_l":Vector2(45,30),"combat":Vector2(30,30)}[phase]
				battle.time = 0.0 if phase != "target" else float(battle.stage.duration)
				if phase == "combat":
					for i in 50:
						battle._spawn("cultista_adaga",battle.hero.pos+Vector2.from_angle(float(i)*TAU/50.0)*(1.0+float(i%4)))
					for i in 6:
						battle._drop("gold" if i%2==0 else "xp",battle.hero.pos+Vector2(float(i)-2.5,4.3),5,"art-qa")
				scene._sync()
				scene.hud.update_stats(battle)
				scene.camera.position = Iso.to_screen(battle.hero.pos)
				await process_frame
				await RenderingServer.frame_post_draw
				var file := output.path_join("%s-%dx%d-%s.png" % [stage_id,size.x,size.y,phase])
				_check(root.get_texture().get_image().save_png(file) == OK,"Capture failed")
				captures.append(file)
				if stage_id == "reino_abissal" and phase in ["edge","combat"]:
					# Diagnostic rendering only: no source bitmap is altered.
					var layer:=CanvasLayer.new()
					layer.layer=100
					var gray:=ColorRect.new()
					gray.size=Vector2(root.size)
					var shader:=Shader.new()
					shader.code="shader_type canvas_item; uniform sampler2D source_screen:hint_screen_texture,filter_nearest; void fragment(){vec3 c=texture(source_screen,SCREEN_UV).rgb;float l=dot(c,vec3(0.2126,0.7152,0.0722));COLOR=vec4(vec3(l),1.0);}"
					var mat:=ShaderMaterial.new()
					mat.shader=shader
					gray.material=mat
					layer.add_child(gray)
					root.add_child(layer)
					await process_frame
					await RenderingServer.frame_post_draw
					var gray_file:=output.path_join("reino_abissal-%dx%d-%s-gray.png"%[size.x,size.y,phase])
					_check(root.get_texture().get_image().save_png(gray_file)==OK,"Grayscale capture failed")
					captures.append(gray_file)
					layer.queue_free()
					await process_frame
		if stage_id == "reino_abissal":
			# One overview documents all four holes and the connected network.
			scene.camera.zoom = Vector2(0.42,0.42)
			scene.camera.position = Iso.to_screen(Vector2(30,30))
			await process_frame
			await RenderingServer.frame_post_draw
			var file := output.path_join("root-network-overview.png")
			_check(root.get_texture().get_image().save_png(file) == OK,"Overview failed")
			captures.append(file)
		_check(original == source_profile.data and source_signature == game.real_save_signature(),"QA changed source profile")
		scene._return_to_menu()
		for i in 6:
			await process_frame
	var report := FileAccess.open(output.path_join("smoke-result.json"),FileAccess.WRITE)
	report.store_string(JSON.stringify({"failures":failures,"captures":captures,"profile_unchanged":original==source_profile.data and source_signature==game.real_save_signature(),"user_data_dir":OS.get_user_data_dir()},"\t"))
	report.close()
	print("ROOT_SMOKE failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
