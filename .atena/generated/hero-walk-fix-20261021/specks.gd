extends SceneTree
## Pontos soltos: componentes conectados de alfa > 16 com área pequena e separados do corpo (somente leitura).
## godot --headless --script specks.gd  (fora do projeto)
const ROOT := "F:/dev/abyss-megadungeon/assets/animations/heroes/"
const OUT := "F:/dev/abyss-megadungeon/.atena/generated/hero-walk-fix-20261021/specks-r1.json"
const GRAY_OUT := "F:/dev/abyss-megadungeon/.atena/generated/hero-walk-fix-20261021/contact-r1/korrak-n-fundo-claro.png"
const WIDE_SRC := ["arlindo", "erik"]
const WIDE := {"durvall": ["move_e","move_se","move_s","move_n","move_ne","move_w","move_sw","move_nw"], "zynara": ["move_n","move_ne"], "leoric": ["move_n","move_ne"]}
const HEROES := ["arlindo","bromnor","brook","durvall","erik","kayron","korrak","leoric","maelor","nyrelia","sylas","zynara"]
const STRIPS := ["move_e","move_se","move_s","move_n","move_ne"]
const SPECK_MAX := 120

func _init() -> void:
	var report := {}
	for hero: String in HEROES:
		var list: Array = STRIPS.duplicate()
		if hero == "durvall":
			list.append_array(["move_w","move_sw","move_nw"])
		var hr := {}
		for name: String in list:
			var img := Image.load_from_file(ROOT + hero + "/" + name + ".png")
			if img == null:
				continue
			img.convert(Image.FORMAT_RGBA8)
			var wide: bool = hero in WIDE_SRC or (WIDE.has(hero) and name in WIDE[hero])
			var cw := 512 if wide else 256
			var frames := int(img.get_width() / cw)
			var out := []
			for f in frames:
				out.append(_specks(img, f * cw, cw, img.get_height()))
			hr[name] = out
		report[hero] = hr
	var fa := FileAccess.open(OUT, FileAccess.WRITE)
	fa.store_string(JSON.stringify(report))
	fa.close()
	# Korrak de costas sobre fundo claro, quadro 0, escala 1:1.
	var k := Image.load_from_file(ROOT + "korrak/move_n.png")
	k.convert(Image.FORMAT_RGBA8)
	var bg := Image.create(256 * 3, 384, false, Image.FORMAT_RGBA8)
	bg.fill(Color(0.72, 0.72, 0.7, 1))
	for i in 3:
		bg.blend_rect(k, Rect2i(i * 256, 0, 256, 384), Vector2i(i * 256, 0))
	bg.save_png(GRAY_OUT)
	quit()

func _specks(img: Image, x0: int, w: int, h: int) -> Array:
	var seen := PackedByteArray()
	seen.resize(w * h)
	var comps := []
	for y in h:
		for x in w:
			var idx := y * w + x
			if seen[idx] == 1 or img.get_pixel(x0 + x, y).a8 <= 16:
				continue
			var stack := [idx]
			seen[idx] = 1
			var area := 0
			var sx := 0; var sy := 0
			while not stack.is_empty():
				var cur: int = stack.pop_back()
				var cx := cur % w
				var cy := cur / w
				area += 1
				sx += cx; sy += cy
				for d in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]:
					var nx: int = cx + d.x
					var ny: int = cy + d.y
					if nx < 0 or ny < 0 or nx >= w or ny >= h:
						continue
					var ni := ny * w + nx
					if seen[ni] == 0 and img.get_pixel(x0 + nx, ny).a8 > 16:
						seen[ni] = 1
						stack.append(ni)
			comps.append([area, sx / area, sy / area])
	comps.sort_custom(func(a, b): return a[0] > b[0])
	var small := []
	for c in comps.slice(1):
		if c[0] <= SPECK_MAX:
			small.append(c)
	return [comps[0][0] if not comps.is_empty() else 0, small.size(), small.slice(0, 4)]
