extends RefCounted

func _check(out: Array, ok: bool, message: String) -> void:
	if not ok:
		out.append(message)

func _battle() -> Battle:
	return Battle.new(7603,"durvall","dagruve",{"qa_sandbox":true,"encounter_id":"dagruve_thalion_r1"})

func run() -> Array:
	var out: Array=[]
	var source: Dictionary=Data.table("stages").dagruve.duplicate(true)
	var definitions: Dictionary=Data.table("prototype_stages").duplicate(true)
	var standard:=Battle.new(7603,"durvall","dagruve")
	var b:=_battle()
	_check(out,Battle.stage_definition("dagruve_thalion_r1").is_empty(),"Overlay incorrectly admitted as standalone stage")
	_check(out,b.is_dagruve_encounter() and b.stage_id=="dagruve" and b.stage.qa_only,"Variant not isolated on original stage id")
	_check(out,standard.stage==source and standard.stage.duration==300 and standard.stage.boss=="sacerdote_mente_derretida" and not standard.stage_rule.is_empty(),"Standard Dagruve changed")
	_check(out,b.has_reach_objective() and b.stage.duration==180 and b.stage.cap==32 and b.stage.boss=="" and b.stage.elites.is_empty() and b.stage.next=="","Variant contract mismatch")
	_check(out,b.stage.completion.get("target_label","")=="Área marcada","QA objective inherited legacy Ritual label")
	_check(out,b.stage_rule.is_empty() and b.stage_events.is_empty() and b.edge_band_tiles()==0.0 and b.place_scenery()==0 and b.interactions.is_empty() and b.ecos.is_empty(),"Legacy event/fog/scenery content leaked")
	b._spawn_random_interaction()
	b._spawn_random_breakable()
	_check(out,b.interactions.is_empty() and b.enemies.is_empty(),"Random content leaked")
	var neutral:=Battle.new(7603,"durvall","dagruve",{"qa_sandbox":true,"encounter_id":"dagruve_thalion_r1","meta_mods":{"max_hp":9999},"difficulty":9.0,"abyss_marks":{"horda":3}})
	_check(out,neutral.hero.max_hp==b.hero.max_hp and neutral.difficulty==1.0 and neutral._mk_density==1.0,"Reference build inherited meta/difficulty/marks")
	b.qa_prepare({"target_state":"victory","level":20})
	_check(out,b.state=="running" and b.hero.level==1 and not b.stage_cleared,"QA shortcut bypassed encounter")
	var bad:=Battle.new(7603,"durvall","dagruve",{"encounter_id":"dagruve_thalion_r1"})
	_check(out,bad.hero.dead and bad.state=="dead" and not bad.qa_encounter_error.is_empty() and not bad.is_dagruve_encounter(),"Non-QA encounter not rejected")
	# Direct and indirect callers share the admission cap and safe-location policy.
	for i in 40:
		b._spawn("cultista_adaga",Vector2(40,30))
	_check(out,b._combat_count()==32,"Direct spawn exceeded strict cap32")
	b.enemies.clear()
	_check(out,b._spawn("sacerdote_mente_derretida",Vector2(40,30)).dead and b.enemies.is_empty(),"Legacy boss admitted")
	_check(out,b._spawn("cultista_adaga",Vector2(30,30)).dead and b._spawn("cultista_adaga",b.objective_target()).dead,"Arrival/target clearing admitted enemy")
	for i in 90:
		var p:=b._ring_pos()
		_check(out,p.is_finite() and b._dagruve_spawn_valid(p,0.4),"Reference ring spawn invalid")
	# Wave phases are exclusive, use exact approved cadence and do not double at90s.
	b.time=0.0
	b._director(3.99)
	_check(out,b.enemies.is_empty(),"Adaga spawned before4s")
	b._director(0.01)
	_check(out,b.enemies.size()==2,"Opening cadence not4s/two")
	b.enemies.clear()
	b._acc.clear()
	b.time=90.0
	b._director(3.0)
	_check(out,b.alive("cultista_adaga")==2 and b.alive("cultista_arqueiro")==0,"90s phase overlap/cadence")
	b.time=180.0
	b.enemies.clear()
	_check(out,b._spawn("cultista_adaga",Vector2(40,30)).dead,"Late admission allowed")
	b._director(10.0)
	_check(out,b.enemies.is_empty() and not b.boss_spawned,"Post-timer director admitted bodies/boss")
	b.hero.pos=b.objective_target()
	b.time=179.99
	b._update_stage_objective(1.0)
	_check(out,b.objective_presence==0.0,"Presence before180s")
	b.time=180.25
	b._update_stage_objective(0.5)
	_check(out,is_equal_approx(b.objective_presence,0.25),"Threshold fraction wrong")
	b.hero.pos=Vector2(30,23)
	b._update_stage_objective(1.0)
	_check(out,b.objective_presence==0.0,"Exit failed to reset")
	b.hero.pos=b.objective_target()
	b.state="levelup"
	b._update_stage_objective(5.0)
	_check(out,b.objective_presence==0.0,"Paused presence credited")
	b.state="running"
	b.time=183.0
	var kills:=int(b.stats.kills)
	var gold:=b.hero.gold
	var xp:=b.hero.xp
	var bosses:=int(b.stats.bosses)
	b.projectiles.append({"life":1.0})
	b.zones.append({"life":1.0})
	for i in 3:
		b._update_stage_objective(1.0)
	_check(out,b.stage_cleared and b.state=="won" and not b.boss_dead and b.stats.bosses==bosses and b.stats.kills==kills and b.hero.gold==gold and b.hero.xp==xp,"Completion gave kill/rewards or missed goal")
	_check(out,b.enemies.is_empty() and b.projectiles.is_empty() and b.zones.is_empty() and b.interactions.is_empty() and not b.complete_stage("objective"),"Completion not clean/idempotent")
	for terminal in ["dead","won","revive_offer"]:
		var failed:=_battle()
		failed.hero.pos=failed.objective_target()
		failed.time=190.0
		failed.hero.dead=true
		failed.state=terminal
		failed._update_stage_objective(10.0)
		_check(out,not failed.stage_cleared,"Terminal state credited objective")
	b.stage.waves.clear()
	b.load_stage("dagruve")
	_check(out,b.stage.waves.size()==4 and b.stage_rule.is_empty(),"Variant reload mutated/cumulated config")
	_check(out,Data.table("stages").dagruve==source and Data.table("prototype_stages")==definitions,"Global data cache mutated")
	var scene: Node2D=load("res://ui/stages/dagruve_thalion_qa.tscn").instantiate()
	_check(out,scene.get_node("Ground").map_size==Vector2i(60,60) and scene.get_node("Sorted/Hero").position==Iso.to_screen(Vector2(30,30)) and scene.get_node_or_null("EncounterMarker")!=null,"Inherited scene contract mismatch")
	scene.free()
	return out
