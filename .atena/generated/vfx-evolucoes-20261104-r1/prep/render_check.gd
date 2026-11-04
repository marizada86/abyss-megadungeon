extends SceneTree
## Verificação visual sintética: desenha os 7 VFX novos (e os equivalentes da base) em posições isométricas e salva um quadro.
func _init() -> void:
	call_deferred("_run")
func _run() -> void:
	root.size = Vector2i(1400, 800)
	var bg := ColorRect.new()
	bg.color = Color(0.09, 0.08, 0.11)
	bg.size = Vector2(1400, 800)
	root.add_child(bg)
	var world := Node2D.new()
	world.position = Vector2(140, 80)
	root.add_child(world)
	var col := 0
	var specs := [["selo_da_retidao", "radiante"], ["cajado_dos_desejos_realizados", "magico"], ["lamina_do_eclipse", "magico"], ["memoria_reescrita", "magico"]]
	for s in specs:
		var pr := {"owner": "hero", "pos": Vector2.ZERO, "dir": Vector2(1, 0), "life": 1.0, "p": {"id": s[0], "dtype": s[1]}}
		var f := ProjectileVfx.create_flight(pr, Color.WHITE)
		f.position = Vector2(col * 300, 0)
		f.rotation = 0.0
		world.add_child(f)
		var fam := ProjectileVfx.visual_family_for(pr)
		var im := ProjectileVfx.create_impact(fam, Vector2.ZERO, Color.WHITE)
		im.position = Vector2(col * 300 + 130, 0)
		world.add_child(im)
		col += 1
	await create_timer(0.15).timeout
	# áreas: pulso, ampulheta, zona (laço) — tamanho lógico real
	var ev1 := RadiantPulseVfx.create_effect({"type": "nova", "weapon": "vigilia_perpetua", "dtype": "radiante", "pos": Vector2.ZERO, "radius": 3.6}, Color.WHITE)
	ev1.position = Vector2(220, 330); world.add_child(ev1)
	var ev2 := HourglassVfx.create_effect({"type": "nova", "weapon": "ampulheta_do_tempo_parado", "dtype": "magico", "pos": Vector2.ZERO, "radius": 6.5}, Color.WHITE)
	ev2.position = Vector2(700, 330); world.add_child(ev2)
	var zone := {"owner": "hero", "kind": "zone", "radius": 4.2, "pos": Vector2.ZERO, "life": 6.0, "p": {"id": "abraco_dos_tentaculos", "dtype": "magico"}}
	var ent := TentacleVfx.create_zone(zone)
	ent.sprite.position = Vector2(1100, 330)
	ent.sprite.modulate.a = 0.95
	world.add_child(ent.sprite)
	var zone_old := {"owner": "hero", "kind": "zone", "radius": 3.3, "pos": Vector2.ZERO, "life": 6.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico"}}
	var ent2 := TentacleVfx.create_zone(zone_old)
	ent2.sprite.position = Vector2(1100, 600)
	ent2.sprite.modulate.a = 0.95
	world.add_child(ent2.sprite)
	await create_timer(0.30).timeout
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://tmp/evo_vfx/quadro_a.png"))
	await create_timer(0.55).timeout
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://tmp/evo_vfx/quadro_b.png"))
	quit()
