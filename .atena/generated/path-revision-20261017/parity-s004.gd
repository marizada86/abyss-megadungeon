extends SceneTree
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	var args:=OS.get_cmdline_user_args()
	var output:=args[args.find("--capture-dir")+1]
	var reference:=GDScript.new()
	reference.source_code=FileAccess.get_file_as_string("res://.atena/generated/path-revision-20261017/s004-opt-before/core/terrain_layout.gd").replace("class_name TerrainLayout","")
	if reference.reload()!=OK:
		quit(1)
		return
	var checked:=0
	var mismatches:=0
	var cached_base:=TerrainLayout.root_definition("raiz_yggdrasil")
	TerrainLayout.root_supports(Vector2(30,30),0.4,"raiz_yggdrasil")
	for seed_value in [7502,7503,7504]:
		var d:=RootPathGenerator.new().generate(cached_base,seed_value)
		for radius in [0.0,0.3,0.4,0.8,1.2]:
			for y in 120:
				for x in 120:
					var p:=Vector2(x,y)*0.5
					if TerrainLayout.root_supports(p,radius,"raiz_yggdrasil",d)!=reference.root_supports(p,radius,"raiz_yggdrasil",d):
						mismatches+=1
					checked+=1
	var abyss:=TerrainLayout.root_definition("reino_abissal")
	for radius in [0.0,0.3,0.4,0.8,1.2]:
		for y in 120:
			for x in 120:
				var p:=Vector2(x,y)*0.5
				if TerrainLayout.root_supports(p,radius,"reino_abissal",abyss)!=reference.root_supports(p,radius,"reino_abissal",abyss):
					mismatches+=1
				checked+=1
	var file:=FileAccess.open(output.path_join("parity.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks":checked,"mismatches":mismatches,"cached_base_generation_exercised":true,"reference":"Unmodified pre-optimization support implementation; same current geometry"},"\t"))
	file.close()
	quit(0 if mismatches==0 else 1)
