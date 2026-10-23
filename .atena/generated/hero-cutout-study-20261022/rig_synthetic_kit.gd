extends SceneTree
## Kit sintético de partes (formas simples) para validar a mecânica do montador de recortes, sem nenhuma geração de arte.
##   godot --headless --script rig_synthetic_kit.gd -- <pasta_de_saida>
## Escreve 10 PNGs de partes + kit.json (pivôs e encaixes). A perna do lado da câmera (near) é mais clara e tem joelheira; a distante (far) é mais escura:
## assim, na prévia, dá para ver qual perna é qual e que as pernas se trocam por construção. Escala de referência: figura montada com 900 px de altura.

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var out: String = a[0] if a.size() > 0 else "."
	DirAccess.make_dir_recursive_absolute(out)
	var dark := Color(0.22, 0.22, 0.27, 1)
	_save(out, "torso", _rect(220, 260, dark, 28))
	_save(out, "head", _head())
	_save(out, "hair_back", _rect(120, 420, Color(0.9, 0.9, 0.85, 1), 40))
	_save(out, "sash", _rect(70, 200, Color(0.75, 0.1, 0.12, 1), 12))
	_save(out, "arm_near", _arm_with_sword())
	_save(out, "arm_far", _rect(60, 300, Color(0.3, 0.3, 0.35, 1), 24))
	_save(out, "thigh_near", _rect(90, 230, Color(0.38, 0.38, 0.45, 1), 30))
	_save(out, "shin_near", _shin(Color(0.42, 0.42, 0.5, 1), true))
	_save(out, "thigh_far", _rect(90, 230, Color(0.16, 0.16, 0.2, 1), 30))
	_save(out, "shin_far", _shin(Color(0.18, 0.18, 0.23, 1), false))
	# pivôs (px na imagem da parte) e encaixes (px, no sistema local do pai, a partir do pivô do pai); o quadril é a origem da raiz
	var kit := {
		"H": 900,
		"parts": {
			"hair_back": {"file": "hair_back.png", "pivot": [60, 10], "parent": "torso", "attach": [-20, -235], "z": 0},
			"arm_far": {"file": "arm_far.png", "pivot": [30, 20], "parent": "torso", "attach": [95, -225], "z": 1},
			"thigh_far": {"file": "thigh_far.png", "pivot": [45, 20], "parent": "root", "attach": [22, 0], "z": 2},
			"shin_far": {"file": "shin_far.png", "pivot": [40, 20], "parent": "thigh_far", "attach": [0, 205], "z": 3},
			"thigh_near": {"file": "thigh_near.png", "pivot": [45, 20], "parent": "root", "attach": [-22, 0], "z": 4},
			"shin_near": {"file": "shin_near.png", "pivot": [40, 20], "parent": "thigh_near", "attach": [0, 205], "z": 5},
			"torso": {"file": "torso.png", "pivot": [110, 250], "parent": "root", "attach": [0, 0], "z": 6},
			"sash": {"file": "sash.png", "pivot": [35, 10], "parent": "torso", "attach": [20, -28], "z": 7},
			"head": {"file": "head.png", "pivot": [55, 140], "parent": "torso", "attach": [8, -232], "z": 8},
			"arm_near": {"file": "arm_near.png", "pivot": [30, 20], "parent": "torso", "attach": [-95, -225], "z": 9},
		},
	}
	var f := FileAccess.open(out.path_join("kit.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(kit, "  "))
	f.close()
	print("kit sintético em ", out)
	quit()

func _save(dir: String, name: String, img: Image) -> void:
	img.save_png(dir.path_join(name + ".png"))

func _rect(w: int, h: int, col: Color, radius: int) -> Image:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var dx := maxi(0, maxi(radius - x, x - (w - 1 - radius)))
			var dy := maxi(0, maxi(radius - y, y - (h - 1 - radius)))
			if dx * dx + dy * dy <= radius * radius:
				img.set_pixel(x, y, col)
	return img

func _head() -> Image:
	var img := Image.create(110, 150, false, Image.FORMAT_RGBA8)
	for y in 150:
		for x in 110:
			var c := Vector2(55, 80)
			if Vector2(x, y).distance_to(c) <= 52:
				img.set_pixel(x, y, Color(0.55, 0.6, 0.72, 1) if y > 55 else Color(0.92, 0.92, 0.88, 1))
	return img

func _arm_with_sword() -> Image:
	var img := Image.create(120, 440, false, Image.FORMAT_RGBA8)
	var arm := _rect(50, 300, Color(0.28, 0.28, 0.33, 1), 20)
	img.blit_rect(arm, Rect2i(0, 0, 50, 300), Vector2i(5, 0))
	# lâmina descendo em diagonal a partir da mão (parte de baixo do braço)
	for i in 140:
		var x := 30 + int(i * 0.55)
		var y := 280 + i
		for dx in range(-5, 6):
			if x + dx >= 0 and x + dx < 120 and y < 440:
				img.set_pixel(x + dx, y, Color(0.78, 0.82, 0.9, 1))
	return img

func _shin(col: Color, knee_guard: bool) -> Image:
	var img := Image.create(80, 270, false, Image.FORMAT_RGBA8)
	var shin := _rect(70, 215, col, 24)
	img.blit_rect(shin, Rect2i(0, 0, 70, 215), Vector2i(5, 0))
	var boot := _rect(80, 60, Color(0.08, 0.08, 0.1, 1), 14)
	img.blit_rect(boot, Rect2i(0, 0, 80, 60), Vector2i(0, 210))
	if knee_guard:
		for y in range(10, 70):
			for x in range(10, 70):
				if absi(x - 40) + absi(y - 40) < 28:
					img.set_pixel(x, y, Color(0.85, 0.85, 0.92, 1))
	return img
