extends Node2D
## Presentation only: no enemy, damage, blocker or independent encounter clock.

func _ready() -> void:
	var layer:=CanvasLayer.new()
	layer.layer=3
	add_child(layer)
	var label:=Label.new()
	label.position=Vector2(870,628)
	label.size=Vector2(390,54)
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	label.text="ENSAIO QA — Thalion no contexto narrativo\nCultistas: substitutos provisórios"
	label.add_theme_font_size_override("font_size",16)
	label.add_theme_color_override("font_color",Color("d4c7ab"))
	label.add_theme_color_override("font_shadow_color",Color.BLACK)
	label.add_theme_constant_override("shadow_outline_size",4)
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	layer.add_child(label)

func _draw() -> void:
	var p:=Iso.to_screen(Vector2(30,18))
	draw_line(p+Vector2(-10,-28),p+Vector2(0,-18),Color("c3b9a4"),2.0)
	draw_line(p+Vector2(0,-18),p+Vector2(10,-28),Color("c3b9a4"),2.0)
