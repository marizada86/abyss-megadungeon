extends SceneTree
## Quadros da prévia animada de uma caminhada (somente leitura das fontes). Roda fora do projeto, sem --path:
##   godot --headless --script walk_preview_frames.gd -- <imagem.png> <grid|row3> <sequencia ex. 0,1,2,3> <pasta_de_saida> [ciclos]
## grid = grade 2x2 em ordem de leitura; row3 = fila de 3. A sequência indexa as figuras (0 = primeira).
## Cada quadro tem 3 painéis, da esquerda para a direita:
##   1) figura a 300 px alinhada pela CAIXA da figura (como a prévia antiga fazia: a passada larga desloca o corpo)
##   2) figura a 300 px alinhada pelo TRONCO (centróide horizontal da faixa de 15% a 50% da altura): o corpo anda em linha reta
##   3) como o jogo mostra: figura a 64 px alinhada pelo tronco, ampliada 4x sem suavizar
## Os quadros saem como PNG; make_walk_preview.ps1 converte em GIF e monta a animação.

const TH := 300.0
const PW := 380
const PH := 360
const GROUND := 335
const GAME_H := 64.0

func opaque(c: Color) -> bool:
	var d := maxf(maxf(1.0 - c.r, c.g), 1.0 - c.b)
	return d > 0.22 * 1.6

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() < 4:
		printerr("uso: -- <imagem> <grid|row3> <sequencia> <pasta_de_saida> [ciclos]")
		quit(2)
		return
	var img := Image.load_from_file(a[0])
	if img == null:
		printerr("não abriu ", a[0])
		quit(2)
		return
	img.convert(Image.FORMAT_RGBA8)
	var layout := a[1]
	var seq := []
	for s in a[2].split(","):
		seq.append(int(s))
	var out_dir := a[3]
	var cycles := int(a[4]) if a.size() > 4 else 4
	DirAccess.make_dir_recursive_absolute(out_dir)
	var rects := []
	if layout == "grid":
		rects = [Rect2i(0, 0, 768, 512), Rect2i(768, 0, 768, 512), Rect2i(0, 512, 768, 512), Rect2i(768, 512, 768, 512)]
	else:
		rects = [Rect2i(0, 0, 512, 1024), Rect2i(512, 0, 512, 1024), Rect2i(1024, 0, 512, 1024)]
	var figs := []
	for r in rects:
		figs.append(_extract(img, r))
	# escala comum: a figura de calibração é a de índice 1 (P1)
	var cal: Dictionary = figs[1]
	var scale := TH / float(cal.h)
	var cells := []
	for f in figs:
		var im: Image = f.img.duplicate()
		var w := int(round(im.get_width() * scale))
		var h := int(round(im.get_height() * scale))
		im.resize(w, h, Image.INTERPOLATE_LANCZOS)
		var tx := int(round(f.torso_x * scale))
		var gm: Image = f.img.duplicate()
		var gscale := GAME_H / float(cal.h)
		gm.resize(maxi(1, int(round(gm.get_width() * gscale))), maxi(1, int(round(gm.get_height() * gscale))), Image.INTERPOLATE_LANCZOS)
		var gtx := int(round(f.torso_x * gscale))
		cells.append({"im": im, "tx": tx, "gm": gm, "gtx": gtx})
	var n := 0
	for cyc in cycles:
		for idx in seq:
			var c: Dictionary = cells[idx]
			var frame := Image.create(PW * 3, PH, false, Image.FORMAT_RGBA8)
			frame.fill(Color(0.42, 0.42, 0.46, 1))
			for p in 3:
				frame.fill_rect(Rect2i(p * PW, GROUND, PW, 1), Color(1, 0.9, 0.1, 0.8))
			var im: Image = c.im
			# painel 1: centro da caixa
			frame.blend_rect(im, Rect2i(0, 0, im.get_width(), im.get_height()), Vector2i(PW / 2 - im.get_width() / 2, GROUND - im.get_height()))
			# painel 2: tronco
			frame.blend_rect(im, Rect2i(0, 0, im.get_width(), im.get_height()), Vector2i(PW + PW / 2 - c.tx, GROUND - im.get_height()))
			# painel 3: tamanho de jogo, tronco, 4x
			var gm: Image = c.gm.duplicate()
			var gw: int = gm.get_width()
			var gh: int = gm.get_height()
			gm.resize(gw * 4, gh * 4, Image.INTERPOLATE_NEAREST)
			frame.blend_rect(gm, Rect2i(0, 0, gm.get_width(), gm.get_height()), Vector2i(2 * PW + PW / 2 - c.gtx * 4, GROUND - gm.get_height()))
			frame.save_png(out_dir.path_join("frame-%02d.png" % n))
			n += 1
	print("quadros: ", n, " em ", out_dir)
	quit()

func _extract(img: Image, r: Rect2i) -> Dictionary:
	var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1
	for y in range(r.position.y, r.position.y + r.size.y):
		for x in range(r.position.x, r.position.x + r.size.x):
			if opaque(img.get_pixel(x, y)):
				minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
	var w := maxx - minx + 1
	var h := maxy - miny + 1
	var out := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var sum := 0.0
	var cnt := 0
	for y in range(miny, maxy + 1):
		for x in range(minx, maxx + 1):
			var c := img.get_pixel(x, y)
			if opaque(c):
				out.set_pixel(x - minx, y - miny, Color(c.r, c.g, c.b, 1))
				var rel := float(y - miny) / float(h)
				if rel >= 0.15 and rel <= 0.50:
					sum += float(x - minx)
					cnt += 1
	return {"img": out, "w": w, "h": h, "torso_x": sum / maxf(float(cnt), 1.0)}
