extends SceneTree
const Art=preload("res://ui/yggdrasil_art.gd")
var failures: Array=[]
var captures: Array=[]
var output: String

func _init() -> void:
	call_deferred("_run")

func _frame() -> void:
	await process_frame
	await RenderingServer.frame_post_draw

func _capture(name: String) -> void:
	await _frame()
	var p:=output.path_join(name+".png")
	if root.get_texture().get_image().save_png(p)!=OK:
		failures.append("Capture failed "+name)
	captures.append(p)

func _distance(p: Vector2) -> float:
	var d:=TerrainLayout.root_definition("raiz_yggdrasil")
	var best:=INF
	for node: Array in d.nodes.values():
		best=minf(best,p.distance_to(TerrainLayout.root_point(node))-float(node[2]))
	for edge: Array in d.edges:
		var a:=TerrainLayout.root_point(d.nodes[edge[0]])
		var b:=TerrainLayout.root_point(d.nodes[edge[1]])
		best=minf(best,p.distance_to(Geometry2D.get_closest_point_to_segment(p,a,b))-TerrainLayout.root_edge_width(d,edge)*0.5)
	return best

func _mask() -> Dictionary:
	var view:=SubViewport.new()
	view.size=Vector2i(1280,720)
	view.transparent_bg=true
	view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var art:=Art.new()
	if not art.prepare():
		failures.append("Art preparation failed")
	var floor_node:=Art.FloorLayer.new()
	floor_node.composer=art
	floor_node.material=art.floor_material
	floor_node.position=Vector2(640,-70)
	floor_node.scale=Vector2(0.42,0.42)
	view.add_child(floor_node)
	art.floor_material.set_shader_parameter("debug_top_mask",true)
	await _frame()
	await _frame()
	var image:=view.get_texture().get_image()
	image.save_png(output.path_join("support-mask.png"))
	var probes:=0
	var mismatches:=0
	for x in range(14,108):
		for y in range(10,116):
			var p:=Vector2(float(x)*0.5,float(y)*0.5)
			if absf(_distance(p))<0.18:
				continue
			var pixel:=floor_node.position+Iso.to_screen(p)*floor_node.scale
			if pixel.x<0 or pixel.y<0 or pixel.x>=1280 or pixel.y>=720:
				continue
			var actual:=image.get_pixel(int(pixel.x),int(pixel.y)).a>0.9
			if actual!=TerrainLayout.root_supports(p,0.0,"raiz_yggdrasil"):
				mismatches+=1
			probes+=1
	art.floor_material.set_shader_parameter("debug_top_mask",false)
	await _frame()
	image=view.get_texture().get_image()
	image.save_png(output.path_join("art-only.png"))
	var escaped:=0
	for x in range(14,108):
		for y in range(10,116):
			var p:=Vector2(float(x)*0.5,float(y)*0.5)
			var pixel:=floor_node.position+Iso.to_screen(p)*floor_node.scale
			if pixel.x<0 or pixel.y<0 or pixel.x>=1280 or pixel.y>=720 or image.get_pixel(int(pixel.x),int(pixel.y)).a<0.02:
				continue
			var allowed:=false
			for n in 29:
				if _distance(p-Vector2.ONE*(28.0/32.0)*float(n)/28.0)<0.18:
					allowed=true
					break
			if not allowed:
				escaped+=1
	if mismatches or escaped:
		failures.append("Mask mismatch/escaped art %d/%d"%[mismatches,escaped])
	view.queue_free()
	art.free()
	await process_frame
	return {"probes":probes,"mismatches":mismatches,"escaped":escaped,"boundary_exclusion_ground_units":0.18}

func _regression() -> Dictionary:
	var report: Dictionary={}
	for id in ["reino_abissal","domwieck"]:
		var view:=SubViewport.new()
		view.size=Vector2i(1280,720)
		view.transparent_bg=true
		view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
		root.add_child(view)
		var images: Array=[]
		for source in ["res://ui/ground.gd","res://.atena/generated/yggdrasil-art-20261017/s004-before/ui__ground.gd"]:
			var g=load(source).new()
			g.map_size=Vector2i(60,60)
			g.terrain_layout_id=id
			g.scale=Vector2(0.42,0.42)
			g.position=Vector2(640,-70)
			view.add_child(g)
			await _frame()
			await _frame()
			var image:=view.get_texture().get_image()
			image.save_png(output.path_join(id+"-ground-"+str(images.size())+".png"))
			images.append(image.get_data())
			g.free()
		var same: bool=images[0]==images[1]
		report[id]={"ground_pixels_identical":same}
		if not same:
			failures.append("Other map ground changed "+id)
		view.queue_free()
		await process_frame
	return report

func _start(enabled: bool) -> Node:
	var game=root.get_node("Game")
	if not game.start_qa_run({"stage_id":"raiz_yggdrasil","hero_id":"durvall","target_state":"running","seed":7504}):
		failures.append("QA entry failed")
	for i in 6:
		await process_frame
	var scene=current_scene
	scene.set_physics_process(false)
	scene.set_process(false)
	paused=false
	scene.stage_root.get_node("Ground").use_yggdrasil_art=enabled
	scene.stage_root.get_node("Ground").queue_redraw()
	var b: Battle=scene.battle
	b.hero.max_hp=1.0e9
	b.hero.hp=b.hero.max_hp
	b.stage.waves=[]
	b.stage.elites=[]
	b._inter_t=99999.0
	b._breakable_t=99999.0
	b._fog_rules_off=true
	return scene

func _close(scene: Node) -> void:
	scene._return_to_menu()
	for i in 6:
		await process_frame

func _views() -> void:
	var scene=await _start(true)
	var b: Battle=scene.battle
	var targets: Dictionary={"arrival":Vector2(30,48),"center":Vector2(30,32),"west":Vector2(16,28),"east":Vector2(44,28),"edge":Vector2(24.4,40),"target":Vector2(30,12),"combat":Vector2(30,32)}
	for size in [Vector2i(1280,720),Vector2i(1920,1080)]:
		root.size=size
		root.content_scale_size=Vector2i(1280,720)
		root.content_scale_mode=Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		for phase in targets:
			b.enemies.clear()
			b.pickups.clear()
			b.hero.pos=targets[phase]
			b.time=240.1 if phase=="target" else 0.0
			if phase=="combat":
				for i in 40:
					b._spawn("cultista_adaga",b.hero.pos+Vector2.from_angle(float(i)*TAU/40.0)*(1.0+float(i%4)))
				for i in 8:
					b._drop("gold" if i%2==0 else "xp",b.hero.pos+Vector2(float(i)-3.5,3),5,"art-qa")
				b.step(Vector2.ZERO,1.0/60.0)
			scene._sync()
			scene.hud.update_stats(b)
			scene.camera.position=Iso.to_screen(b.hero.pos)
			await _capture("yggdrasil-%dx%d-%s"%[size.x,size.y,phase])
			if phase in ["edge","combat"]:
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
				await _capture("yggdrasil-%dx%d-%s-gray"%[size.x,size.y,phase])
				layer.queue_free()
				await process_frame
	root.size=Vector2i(1280,720)
	scene.camera.zoom=Vector2(0.36,0.36)
	scene.camera.position=Iso.to_screen(Vector2(30,32))
	await _capture("yggdrasil-overview")
	scene.stage_root.get_node("Ground").use_yggdrasil_art=false
	await _frame()
	await _capture("yggdrasil-overview-fallback")
	await _close(scene)

func _percentiles(samples: Array) -> Dictionary:
	var ordered:=samples.duplicate()
	ordered.sort()
	return {"median_ms":float(ordered[ordered.size()/2])/1000.0,"p95_ms":float(ordered[int(ordered.size()*0.95)])/1000.0,"max_ms":float(ordered[-1])/1000.0}

func _perf(enabled: bool) -> Dictionary:
	var scene=await _start(enabled)
	var b: Battle=scene.battle
	b.hero.weapons.clear()
	for i in 40:
		b._spawn("cultista_adaga",b._ring_pos())
	scene.camera.position=Iso.to_screen(b.hero.pos)
	var cpu: Array=[]
	var frame: Array=[]
	for i in 630:
		var start:=Time.get_ticks_usec()
		b.step(Vector2.ZERO,1.0/60.0)
		var simulation:=Time.get_ticks_usec()-start
		scene._sync()
		scene.hud.update_stats(b)
		b.events.clear()
		await _frame()
		if i>=30:
			cpu.append(simulation)
			frame.append(Time.get_ticks_usec()-start)
	await _capture("perf-art-"+str(enabled))
	var result: Dictionary={"enabled":enabled,"seed":7504,"population":b.enemies.size(),"frames":600,"warmup":30,"dt":1.0/60.0,"simulation":_percentiles(cpu),"frame_loop":_percentiles(frame)}
	await _close(scene)
	return result

func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	output=args[args.find("--capture-dir")+1]
	await process_frame
	await process_frame
	root.get_node("Playtest").call("_close_guide_modal")
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var game=root.get_node("Game")
	game.profile=Profile.new({"coins":123})
	var original: Profile=game.profile
	var snapshot: Dictionary=original.data.duplicate(true)
	var signature: Dictionary=game.real_save_signature()
	var mask: Dictionary=await _mask()
	var regression: Dictionary=await _regression()
	await _views()
	var baseline: Dictionary=await _perf(false)
	var candidate: Dictionary=await _perf(true)
	var profile_unchanged: bool=snapshot==original.data and signature==game.real_save_signature()
	if not profile_unchanged:
		failures.append("QA changed synthetic source profile")
	var report: Dictionary={"failures":failures,"mask":mask,"regression":regression,"captures":captures,"baseline":baseline,"candidate":candidate,"median_ratio":candidate.frame_loop.median_ms/maxf(0.001,baseline.frame_loop.median_ms),"p95_ratio":candidate.frame_loop.p95_ms/maxf(0.001,baseline.frame_loop.p95_ms),"profile_unchanged":profile_unchanged,"user_dir":OS.get_user_data_dir(),"measurement":"Offscreen OpenGL loop including CPU/sync/scheduling/dispatch; not GPU timestamps or certified gameplay FPS"}
	var f:=FileAccess.open(output.path_join("render-result.json"),FileAccess.WRITE)
	f.store_string(JSON.stringify(report,"\t"))
	f.close()
	print("YGGDRASIL_RENDER ",JSON.stringify(report))
	quit(0 if failures.is_empty() else 1)
