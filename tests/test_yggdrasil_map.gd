extends RefCounted

func _check(out: Array, ok: bool, message: String) -> void:
	if not ok:
		out.append(message)

func _battle() -> Battle:
	var b := Battle.new(7502,"durvall","raiz_yggdrasil",{"qa_sandbox":true})
	b.hero.blockers.clear()
	b.hero.weapons.clear()
	b.hero.max_hp=1.0e9
	b.hero.hp=b.hero.max_hp
	return b

func run() -> Array:
	var out: Array=[]
	var b := _battle()
	_check(out,not Data.table("stages").has("raiz_yggdrasil") and bool(b.stage.qa_only),"Prototype leaked into normal catalogue")
	_check(out,int(b.stage.duration)==240 and int(b.stage.cap)==40 and b.stage.boss=="" and b.stage.elites.is_empty(),"Prototype timing/cap/boss contract")
	var stage: Node2D = load("res://ui/stages/raiz_yggdrasil.tscn").instantiate()
	_check(out,stage.get_node("Ground").map_size==Vector2i(60,60) and stage.get_node("Sorted").y_sort_enabled,"Invalid stage contract")
	_check(out,Iso.to_ground(stage.get_node("Sorted/Hero").position)==Vector2(30,48),"Scene arrival mismatch")
	_check(out,SceneryLayout.expanded_props("raiz_yggdrasil",Vector2(30,48),Vector2(60,60)).is_empty(),"Unexpected blocking props")
	stage.free()
	b._spawn_random_interaction()
	b._spawn_random_breakable()
	_check(out,b.interactions.is_empty() and b.enemies.is_empty(),"Disabled prototype content appeared")
	for i in 41:
		b._spawn("cultista_adaga",TerrainLayout.root_point(b.root_layout.nodes.C1))
	_check(out,b._combat_count()==40,"Admission exceeded strict cap")
	b.time=240.0
	b.enemies.clear()
	_check(out,b._spawn("cultista_adaga",TerrainLayout.root_point(b.root_layout.nodes.C1)).dead and b.enemies.is_empty(),"Offensive admission continued after 240s")
	b.hero.pos=b.objective_target()
	b.time=239.99
	b._update_stage_objective(1.0)
	_check(out,b.objective_presence==0.0 and not b.stage_cleared,"Early arrival credited presence")
	b.time=240.25
	b._update_stage_objective(0.5)
	_check(out,is_equal_approx(b.objective_presence,0.25),"Threshold-crossing step counted too much time")
	b.hero.pos=Vector2(30,16)
	b._update_stage_objective(0.5)
	_check(out,b.objective_presence==0.0,"Exit did not reset presence")
	b.hero.pos=b.objective_target()
	b.state="levelup"
	b._update_stage_objective(5.0)
	_check(out,b.objective_presence==0.0,"Non-running state counted presence")
	b.state="running"
	b.time=243.0
	var kills: int = b.stats.kills
	var gold := b.hero.gold
	for i in 3:
		b._update_stage_objective(1.0)
	_check(out,b.stage_cleared and b.state=="won" and b.stats.kills==kills and b.hero.gold==gold,"Completion or clean reward contract failed")
	_check(out,not b.complete_stage("objective"),"Objective completion not idempotent")
	var boundary := _battle()
	boundary.hero.pos=boundary.objective_target()
	boundary.time=240.0
	boundary._update_stage_objective(1.0)
	_check(out,boundary.objective_presence==0.0,"Exact threshold credited presence")
	boundary.time=241.0
	boundary._update_stage_objective(1.0)
	boundary._hurt_hero(1.0,"test")
	_check(out,boundary.objective_presence==1.0,"Damage reset presence")
	boundary.state="levelup"
	boundary.step(Vector2.ZERO,5.0)
	_check(out,boundary.time==241.0 and boundary.objective_presence==1.0,"Pause advanced time/presence")
	for terminal in ["dead","revive_offer","won"]:
		var failed := _battle()
		failed.hero.pos=failed.objective_target()
		failed.time=250.0
		failed.hero.dead=true
		failed.state=terminal
		failed.step(Vector2.ZERO,4.0)
		_check(out,not failed.stage_cleared and not failed.complete_stage("objective"),"Death/terminal awarded objective")
	var abandoned := _battle()
	abandoned.death_reason="abandoned"
	abandoned.state="dead"
	abandoned.hero.dead=true
	abandoned.step(Vector2.ZERO,4.0)
	_check(out,abandoned.result().stages_cleared==0,"Abandon awarded stage completion")
	var capped := _battle()
	var summoner := capped._spawn("cultista_adaga",TerrainLayout.root_point(b.root_layout.nodes.C1))
	for i in 39:
		capped._spawn("cultista_adaga",TerrainLayout.root_point(b.root_layout.nodes.C1))
	capped._use_ability(summoner,0,{"t":"summon","id":"notivago","cap":99,"n":8},0.0,Vector2.ZERO)
	_check(out,capped._combat_count()==40,"Summon bypassed cap")
	summoner.split_id="notivago"
	capped._kill(summoner)
	_check(out,capped._combat_count()==40,"Split bypassed cap")
	# The director counts registered bodies until the frame removes dead ones.
	capped.enemies=capped.enemies.filter(func(e): return not e.dead)
	capped.time=240.0
	var late_split: Enemy=capped.enemies.back()
	late_split.split_id="notivago"
	capped._kill(late_split)
	_check(out,capped._combat_count()==39,"Post-threshold split admitted offspring")
	capped._use_ability(capped.enemies.back(),0,{"t":"summon","id":"notivago","cap":99,"n":8},0.0,Vector2.ZERO)
	_check(out,capped._combat_count()==39,"Post-threshold summon admitted enemy")
	for enemy in capped.enemies:
		_check(out,capped.hero.can_stand(enemy.pos,enemy.radius),"Split/summon unsupported")
	var cleanup := _battle()
	cleanup._spawn("cultista_adaga",Vector2(30,12))
	cleanup.projectiles=[{"owner":"enemy"}]
	cleanup.zones=[{"owner":"enemy"}]
	cleanup.time=250.0
	cleanup.hero.pos=cleanup.objective_target()
	cleanup.objective_presence=3.0
	_check(out,cleanup.complete_stage("objective") and cleanup.enemies.is_empty() and cleanup.projectiles.is_empty() and cleanup.zones.is_empty() and cleanup.pickups.is_empty() and cleanup.stats.kills==0 and cleanup.hero.gold==0,"Cleanup generated kill/loot or retained hazards")
	var full := _battle()
	var max_count := 0
	for i in 2460:
		if full.time>=240.0:
			full.hero.pos=full.objective_target()
		full.step(Vector2.ZERO,0.1)
		max_count=maxi(max_count,full._combat_count())
		full.events.clear()
		if full.stage_cleared:
			break
	_check(out,full.stage_cleared and full.time>=242.99 and full.time<243.3,"Full prototype run failed objective timing")
	_check(out,max_count<=40 and full.stats.bosses==0 and full.interactions.is_empty(),"Full prototype run violated cap/boss/content contract")
	return out
