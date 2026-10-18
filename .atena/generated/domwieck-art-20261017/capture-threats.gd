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
	for stage_id in ["domwieck"]:
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
			for phase in ["combat_garden"]:
				# Reset diagnostic views directly; death animations would otherwise linger between captures.
				for view in scene.enemy_nodes.values():
					view.queue_free()
				scene.enemy_nodes.clear()
				battle.enemies.clear()
				battle.pickups.clear()
				battle.projectiles.clear()
				battle.zones.clear()
				battle.hero.pos = {"arrival":Vector2(30,45),"plaza":Vector2(30,33),"target":Vector2(30,15),"garden":Vector2(30,7),"side_w":Vector2(15,30),"side_l":Vector2(45,30),"behind_building":Vector2(7,19.5),"tree_near":Vector2(30,12.4),"combat_garden":Vector2(30,15),"combat":Vector2(30,30)}[phase]
				if stage_id == "reino_abissal" and phase in ["garden","tree_near","behind_building"]:
					battle.hero.pos=Vector2(30,15)
				battle.time = 0.0 if phase != "target" else float(battle.stage.duration)
				if phase in ["combat","combat_garden"]:
					for i in (54 if stage_id == "domwieck" else 50):
						battle._spawn("cultista_adaga",battle.hero.pos+Vector2.from_angle(float(i)*TAU/54.0)*(1.0+float(i%4)))
					for i in 6:
						battle._drop("gold" if i%2==0 else "xp",battle.hero.pos+Vector2(float(i)-2.5,4.3),5,"art-qa")
				for i in 8:
					battle.projectiles.append({"owner":"enemy" if i%2 else "hero","pos":battle.hero.pos+Vector2.from_angle(TAU*float(i)/8.0)*5.0,"dir":Vector2.RIGHT,"speed":0.0,"life":99.0,"p":{}})
				battle.zones.append({"owner":"enemy","kind":"telegraph","pos":battle.hero.pos+Vector2(3.8,-1.5),"radius":1.4,"delay":0.5,"total":1.2,"life":99.0})
				scene._sync()
				scene.queue_redraw()
				scene.hud.update_stats(battle)
				scene.camera.position = Iso.to_screen(battle.hero.pos)
				await process_frame
				await RenderingServer.frame_post_draw
				var file := output.path_join("%s-%dx%d-%s.png" % [stage_id,size.x,size.y,phase])
				_check(root.get_texture().get_image().save_png(file) == OK,"Capture failed")
				captures.append(file)
				if stage_id == "domwieck" and phase in ["target","combat_garden"]:
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
					var gray_file:=output.path_join("domwieck-%dx%d-%s-gray.png"%[size.x,size.y,phase])
					_check(root.get_texture().get_image().save_png(gray_file)==OK,"Grayscale capture failed")
					captures.append(gray_file)
					layer.queue_free()
					await process_frame
		if stage_id == "domwieck":
			# One overview documents all four holes and the connected network.
			scene.camera.zoom = Vector2(0.42,0.42)
			scene.camera.position = Iso.to_screen(Vector2(30,30))
			await process_frame
			await RenderingServer.frame_post_draw
			var file := output.path_join("domwieck-overview.png")
			_check(root.get_texture().get_image().save_png(file) == OK,"Overview failed")
			captures.append(file)
		_check(original == source_profile.data and source_signature == game.real_save_signature(),"QA changed source profile")
		scene._return_to_menu()
		for i in 6:
			await process_frame
	var report := FileAccess.open(output.path_join("smoke-result.json"),FileAccess.WRITE)
	report.store_string(JSON.stringify({"failures":failures,"captures":captures,"profile_unchanged":original==source_profile.data and source_signature==game.real_save_signature(),"user_data_dir":OS.get_user_data_dir()},"\t"))
	report.close()
	print("DOMWIECK_SMOKE failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
