extends SceneTree
## Prévia das folhas preparadas dos avisos comuns: tinge a folha neutra como o jogo fará (cor * folha * alfa, mistura aditiva) pelos tipos de
## dano e pelos modos de daltonismo (`DangerFeedback.WARN_COLORS`, `Accessibility.DAMAGE_PALETTE`), sobre preto e sobre um trecho de chão.
## Só lê e grava a imagem de saída. Cores copiadas do código; se mudarem lá, atualizar aqui.
## Uso: godot --headless --path <projeto> -s tools/telegraph_preview_comuns.gd -- <saida.png> <atlas.png> <ground.png> [<atlas2> ...] (caminhos absolutos)

const TINTS := [
	["fisico", Color(1.0, 0.27, 0.18)],
	["magico", Color(0.68, 0.38, 1.0)],
	["fogo", Color(1.0, 0.5, 0.1)],
	["radiante", Color(1.0, 0.85, 0.4)],
	["magico (protanopia/deuteranopia)", Color(0.35, 0.7, 0.93)],
	["magico (tritanopia)", Color(0.2, 0.55, 0.25)],
]

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var ground := Image.load_from_file(String(args[2]))
	ground.convert(Image.FORMAT_RGBA8)
	var sheets: Array = []
	for k in range(1, args.size()):
		if k == 2:
			continue
		var img := Image.load_from_file(String(args[k]))
		img.convert(Image.FORMAT_RGBA8)
		sheets.append(img)
	var cols := 0
	for s in sheets:
		cols = maxi(cols, (s as Image).get_width() / 256)
	var rows_per := TINTS.size() + 1
	var cell := 256
	var out := Image.create(cols * cell, rows_per * cell * sheets.size(), false, Image.FORMAT_RGBA8)
	out.fill(Color.BLACK)
	for si in sheets.size():
		var sheet: Image = sheets[si]
		var n := sheet.get_width() / 256
		for row in rows_per:
			var ground_row := row == TINTS.size()
			var tint: Color = TINTS[0][1] if ground_row else TINTS[row][1]
			var oy := (si * rows_per + row) * cell
			for c in n:
				for y in cell:
					for x in cell:
						var px := sheet.get_pixel(c * 256 + x, y)
						var base := Color.BLACK
						if ground_row:
							base = ground.get_pixel(x % ground.get_width(), y % ground.get_height())
						var a := px.a
						var rgb := Color(px.r * tint.r * a, px.g * tint.g * a, px.b * tint.b * a)
						out.set_pixel(c * cell + x, oy + y, Color(minf(base.r + rgb.r, 1.0), minf(base.g + rgb.g, 1.0), minf(base.b + rgb.b, 1.0), 1.0))
	out.save_png(String(args[0]))
	print("gravou ", args[0], " ", out.get_size())
	quit()
