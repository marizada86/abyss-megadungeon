extends SceneTree
var failures: Array = []
var captures: Array = []
var receipts: Array = []
var output: String

class MaskFloor extends Node2D:
	var bounds: Rect2
	func _draw() -> void:
		draw_rect(bounds,Color.WHITE)

func _init() -> void:
	call_deferred("_run")

func _capture(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(name+".png"))
	captures.append(name+".png")

func _mask(art: Node, definition: Dictionary, seed_value: int) -> void:
	var viewport := SubViewport.new()
	viewport.size=Vector2i(1024,512)
	viewport.transparent_bg=true
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var floor_node := MaskFloor.new()
	floor_node.bounds=art.floor_rect
	floor_node.position=Vector2(512,0)
	floor_node.scale=Vector2.ONE*0.25
	var mat: ShaderMaterial=art.floor_material.duplicate()
	mat.set_shader_parameter("debug_top_mask",true)
	floor_node.material=mat
	viewport.add_child(floor_node)
	await process_frame
	await RenderingServer.frame_post_draw
	var img:=viewport.get_texture().get_image()
	img.save_png(output.path_join("mask-%d.png"%seed_value))
	var checked:=0
	var interior_mismatches:=0
	for y in range(2,510,4):
		for x in range(2,1022,4):
			var screen:=(Vector2(x+0.5,y+0.5)-Vector2(512,0))*4.0
			var supported:=TerrainLayout.root_supports(Iso.to_ground(screen),0.0,"raiz_yggdrasil",definition)
			var pixel:=img.get_pixel(x,y).a>0.5
			checked+=1
			if pixel==supported:
				continue
			var boundary:=false
			for delta in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN,Vector2(-1,-1),Vector2(1,1),Vector2(-1,1),Vector2(1,-1)]:
				if TerrainLayout.root_supports(Iso.to_ground(screen+delta*4.0),0.0,"raiz_yggdrasil",definition)!=supported:
					boundary=true
			if not boundary:
				interior_mismatches+=1
	if interior_mismatches>0:
		failures.append("Mask CPU/GPU interior mismatch seed%d: %d"%[seed_value,interior_mismatches])
	receipts.append({"seed":seed_value,"generation":definition.generation,"mask_samples":checked,"interior_mismatches":interior_mismatches})
	viewport.queue_free()
	await process_frame

func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	output=args[args.find("--capture-dir")+1]
	await process_frame
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	var game=root.get_node("Game")
	game.profile=Profile.new({})
	for seed_value in [7502,7503,7504]:
		if not game.start_qa_run({"stage_id":"raiz_yggdrasil","hero_id":"durvall","target_state":"running","seed":seed_value}):
			failures.append("QA launch rejected")
			break
		for i in 6:
			await process_frame
		var scene=current_scene
		scene.set_physics_process(false)
		scene.set_process(false)
		var b: Battle=scene.battle
		var art=scene.stage_root.get_node("YggdrasilArt")
		if art.root_layout!=b.root_layout or scene.stage_root.get_node("Ground").root_layout!=b.root_layout or not art.is_active():
			failures.append("Art/support injection failed")
		var receipt_path: String=game._save_path.get_base_dir().path_join("root-geometry.json")
		if not FileAccess.file_exists(receipt_path):
			failures.append("Missing QA geometry receipt")
		else:
			var receipt: Dictionary=JSON.parse_string(FileAccess.get_file_as_string(receipt_path))
			# JSON numbers are parsed as floats. Compare both sides after the same
			# serialization boundary, retaining every coordinate/width/metadata value.
			var expected: Dictionary=JSON.parse_string(JSON.stringify({"stage_id":b.stage_id,"generation":b.root_layout.generation,"nodes":b.root_layout.nodes,"edges":b.root_layout.edges}))
			if receipt!=expected:
				failures.append("QA geometry receipt differs from battle")
		scene.camera.position=Iso.to_screen(Vector2(30,30))
		scene.camera.zoom=Vector2.ONE*0.3
		for size in [Vector2i(1280,720),Vector2i(1920,1080)]:
			root.size=size
			root.content_scale_size=Vector2i(1280,720)
			root.content_scale_mode=Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			await _capture("yggdrasil-%d-%dx%d-overview"%[seed_value,size.x,size.y])
		await _mask(art,b.root_layout,seed_value)
		if seed_value==7502:
			b.hero.max_hp=1.0e9
			b.hero.hp=b.hero.max_hp
			b.hero.pos=TerrainLayout.root_point(b.root_layout.nodes.C1)
			for i in 40:
				var at:=b._ring_pos()
				b._spawn("cultista_arqueiro" if i%4==0 else "cultista_adaga",at)
			if b._combat_count()!=40:
				failures.append("Combat smoke missing40 enemies")
			for i in 60:
				b.step(Vector2.ZERO,1.0/60.0)
			scene._sync()
			scene.hud.update_stats(b)
			scene.camera.zoom=Vector2.ONE
			scene.camera.position=Iso.to_screen(b.hero.pos)
			await _capture("yggdrasil-7502-combat40")
		scene._return_to_menu()
		for i in 8:
			await process_frame
	root.get_node("Sfx").stop_music(0.0)
	root.get_node("Sfx").stop_ambience(0.0)
	await create_timer(0.25).timeout
	var file:=FileAccess.open(output.path_join("render-result.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"captures":captures,"receipts":receipts,"harness_only":"Camera/HP/frozen process changes are capture fixtures; not human playtest"},"\t"))
	file.close()
	quit(0 if failures.is_empty() else 1)
