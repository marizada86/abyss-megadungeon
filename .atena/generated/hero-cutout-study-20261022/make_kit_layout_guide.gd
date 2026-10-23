extends SceneTree
## Guia de layout do kit de partes (estudo de recortes): 10 células de 307x512 em grade 5x2, com a silhueta cinza de cada parte.
##   godot --headless --script make_kit_layout_guide.gd -- <pasta_de_saida>
## Mostra só QUAL parte vai em QUAL célula e as proporções aproximadas. Partes do lado da câmera (near) em cinza claro, do lado oposto (far) em cinza escuro. Sem texto.
## Escala: a figura montada teria 900 px de altura (cada parte cabe na célula de 512 px de altura).
const W := 1536
const H := 1024
const CW := 307
const CH := 512
const BG := Color(0.82, 0.82, 0.82, 1)
const LIGHT := Color(0.62, 0.62, 0.64, 1)
const DARK := Color(0.36, 0.36, 0.4, 1)
const CELL := Color(0.7, 0.7, 0.72, 1)

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var out: String = a[0] if a.size() > 0 else "."
	DirAccess.make_dir_recursive_absolute(out)
	var img := Image.create(W, H, false, Image.FORMAT_RGBA8)
	img.fill(BG)
	for r in 2:
		for c in 5:
			img.fill_rect(Rect2i(c * CW, r * CH, CW, 2), CELL)
			img.fill_rect(Rect2i(c * CW, r * CH, 2, CH), CELL)
	# linha 1: cabeça, cabelo de trás, tronco, pano da faixa, braço perto com espada
	_ellipse(img, _c(0, 0, 0.5, 0.52), 62, 80, LIGHT)
	_rrect(img, _c(1, 0, 0.5, 0.55), 70, 400, 34, DARK)
	_rrect(img, _c(2, 0, 0.5, 0.55), 190, 280, 40, LIGHT)
	_rrect(img, _c(3, 0, 0.5, 0.52), 50, 220, 10, DARK)
	_rrect(img, _c(4, 0, 0.36, 0.5), 52, 320, 22, LIGHT)
	_line(img, _c(4, 0, 0.4, 0.74), _c(4, 0, 0.78, 0.97), 12, LIGHT)
	# linha 2: braço longe, coxa perto, canela perto, coxa longe, canela longe
	_rrect(img, _c(0, 1, 0.5, 0.5), 52, 320, 22, DARK)
	_rrect(img, _c(1, 1, 0.5, 0.5), 76, 240, 30, LIGHT)
	_rrect(img, _c(2, 1, 0.5, 0.55), 70, 290, 26, LIGHT)
	_rrect(img, _c(3, 1, 0.5, 0.5), 76, 240, 30, DARK)
	_rrect(img, _c(4, 1, 0.5, 0.55), 70, 290, 26, DARK)
	var path := out.path_join("kit_layout_guide_5x2.png")
	img.save_png(path)
	print("guia: ", path)
	quit()

func _c(col: int, row: int, fx: float, fy: float) -> Vector2:
	return Vector2(col * CW + fx * CW, row * CH + fy * CH)

func _ellipse(img: Image, c: Vector2, rx: int, ry: int, col: Color) -> void:
	for y in range(int(c.y) - ry, int(c.y) + ry + 1):
		for x in range(int(c.x) - rx, int(c.x) + rx + 1):
			var dx := float(x - c.x) / rx
			var dy := float(y - c.y) / ry
			if dx * dx + dy * dy <= 1.0:
				img.set_pixel(x, y, col)

func _rrect(img: Image, c: Vector2, w: int, h: int, radius: int, col: Color) -> void:
	for y in range(int(c.y) - h / 2, int(c.y) + h / 2):
		for x in range(int(c.x) - w / 2, int(c.x) + w / 2):
			var lx := x - (int(c.x) - w / 2)
			var ly := y - (int(c.y) - h / 2)
			var dx := maxi(0, maxi(radius - lx, lx - (w - 1 - radius)))
			var dy := maxi(0, maxi(radius - ly, ly - (h - 1 - radius)))
			if dx * dx + dy * dy <= radius * radius:
				img.set_pixel(x, y, col)

func _line(img: Image, a: Vector2, b: Vector2, w: int, col: Color) -> void:
	var n := int(a.distance_to(b))
	for i in range(n + 1):
		var p := a.lerp(b, float(i) / maxf(n, 1))
		for dy in range(-w / 2, w / 2 + 1):
			for dx in range(-w / 2, w / 2 + 1):
				if dx * dx + dy * dy <= (w / 2) * (w / 2):
					img.set_pixel(int(p.x) + dx, int(p.y) + dy, col)
