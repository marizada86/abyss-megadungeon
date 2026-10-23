extends SceneTree
## Montador de "boneco de recortes" para a caminhada (estudo da opção 3). Somente leitura das partes; escreve só quadros PNG na pasta de saída.
##   godot --headless --script rig_walk_preview.gd -- <kit.json> <pasta_de_saida> [amplitude=1.0] [ciclos=4]
## Esqueleto fixo: raiz (quadril) -> torso, coxa_perto, coxa_longe; torso -> cabeça, cabelo_atrás, faixa, braço_perto (com a espada), braço_longe;
## coxa_X -> canela_X (com a bota). Cada parte tem pivô e encaixe no kit.json.
## Ciclo de 4 quadros com TROCA DE PERNAS por construção: A (perna perto à frente), P1 (a perna longe passa), B (perna longe à frente), P2 (a perna perto passa).
## Ângulos em graus; positivo = sentido horário na tela (y para baixo): a perna que vai para a frente (direita da tela) tem ângulo negativo.
## O pé de apoio é plantado automaticamente: a raiz sobe ou desce para o ponto mais baixo das canelas tocar o chão.
## Cada quadro de saída tem 2 painéis: a figura a 300 px e como o jogo mostra (64 px, ampliada 4x sem suavizar).

const PW := 380
const PH := 360
const GROUND := 335
const SHOW_H := 300.0
const GAME_H := 64.0
const PARENT_OF := {"torso": "root", "thigh_near": "root", "thigh_far": "root", "head": "torso", "hair_back": "torso", "sash": "torso", "arm_near": "torso", "arm_far": "torso", "shin_near": "thigh_near", "shin_far": "thigh_far"}

var kit := {}
var images := {}

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() < 2:
		printerr("uso: -- <kit.json> <pasta_de_saida> [amplitude] [ciclos]")
		quit(2)
		return
	var kit_path := a[0]
	var out_dir := a[1]
	var amp := float(a[2]) if a.size() > 2 else 1.0
	var cycles := int(a[3]) if a.size() > 3 else 4
	kit = JSON.parse_string(FileAccess.get_file_as_string(kit_path))
	var base := kit_path.get_base_dir()
	for name in kit.parts:
		var img := Image.load_from_file(base.path_join(String(kit.parts[name].file)))
		if img == null:
			printerr("não abriu a parte ", name)
			quit(2)
			return
		img.convert(Image.FORMAT_RGBA8)
		images[name] = img
	DirAccess.make_dir_recursive_absolute(out_dir)
	var seq := ["A", "P1", "B", "P2"]
	var n := 0
	for c in cycles:
		for key in seq:
			var frame := _render_frame(key, amp)
			frame.save_png(out_dir.path_join("frame-%02d.png" % n))
			n += 1
	print("quadros: ", n)
	quit()

func _pose(key: String, amp: float) -> Dictionary:
	# graus, antes de multiplicar pela amplitude; bob em px (negativo = corpo sobe)
	var p := {}
	match key:
		"A":
			p = {"thigh_near": -22, "shin_near": 8, "thigh_far": 20, "shin_far": 22, "arm_near": -4, "arm_far": -18, "bob": 5}
		"P1":
			p = {"thigh_near": 0, "shin_near": 0, "thigh_far": -26, "shin_far": 58, "arm_near": 0, "arm_far": 0, "bob": -8}
		"B":
			p = {"thigh_near": 20, "shin_near": 22, "thigh_far": -22, "shin_far": 8, "arm_near": 6, "arm_far": 18, "bob": 5}
		"P2":
			p = {"thigh_near": -26, "shin_near": 58, "thigh_far": 0, "shin_far": 0, "arm_near": 0, "arm_far": 0, "bob": -8}
	var out := {}
	for k in p:
		out[k] = float(p[k]) * amp
	return out

func _render_frame(key: String, amp: float) -> Image:
	var pose := _pose(key, amp)
	var xf := {}
	# transformações-mundo (raiz na origem; o deslocamento vertical entra depois)
	var order := ["torso", "thigh_near", "thigh_far", "head", "hair_back", "sash", "arm_near", "arm_far", "shin_near", "shin_far"]
	for name in order:
		var part: Dictionary = kit.parts[name]
		var parent_name: String = PARENT_OF[name]
		var parent_xf: Transform2D = Transform2D.IDENTITY if parent_name == "root" else xf[parent_name]
		var rot: float = deg_to_rad(float(pose.get(name, 0.0)))
		var attach := Vector2(float(part.attach[0]), float(part.attach[1]))
		var local := Transform2D(rot, attach)
		xf[name] = parent_xf * local
	# plantar o pé: ponto mais baixo das canelas
	var lowest := -99999.0
	for name in ["shin_near", "shin_far"]:
		var img: Image = images[name]
		var pivot := Vector2(float(kit.parts[name].pivot[0]), float(kit.parts[name].pivot[1]))
		for corner in [Vector2(0, img.get_height()), Vector2(img.get_width(), img.get_height())]:
			lowest = maxf(lowest, (xf[name] * (corner - pivot)).y)
	var shift := -lowest + float(pose.bob)
	var scale := SHOW_H / float(kit.H)
	var canvas := Image.create(PW, PH, false, Image.FORMAT_RGBA8)
	var zlist := []
	for name in kit.parts:
		zlist.append([int(kit.parts[name].z), name])
	zlist.sort_custom(func(a, b): return a[0] < b[0])
	var origin := Vector2(PW / 2.0, float(GROUND)) / scale + Vector2(0, shift)
	for zn in zlist:
		_draw_part(canvas, String(zn[1]), xf[zn[1]], origin, scale)
	var frame := Image.create(PW * 2, PH, false, Image.FORMAT_RGBA8)
	frame.fill(Color(0.42, 0.42, 0.46, 1))
	frame.fill_rect(Rect2i(0, GROUND, PW * 2, 1), Color(1, 0.9, 0.1, 0.8))
	frame.blend_rect(canvas, Rect2i(0, 0, PW, PH), Vector2i(0, 0))
	# painel do jogo: reduz a figura para 64 px e amplia 4x
	var small: Image = canvas.duplicate()
	var gs := GAME_H / SHOW_H
	small.resize(maxi(1, int(round(PW * gs))), maxi(1, int(round(PH * gs))), Image.INTERPOLATE_LANCZOS)
	var gw := small.get_width()
	var gh := small.get_height()
	small.resize(gw * 4, gh * 4, Image.INTERPOLATE_NEAREST)
	var gground := int(round(float(GROUND) * gs)) * 4
	frame.blend_rect(small, Rect2i(0, 0, small.get_width(), small.get_height()), Vector2i(PW, GROUND - gground))
	return frame

func _draw_part(canvas: Image, name: String, world: Transform2D, origin: Vector2, scale: float) -> void:
	var img: Image = images[name]
	var pivot := Vector2(float(kit.parts[name].pivot[0]), float(kit.parts[name].pivot[1]))
	# caixa de destino
	var minp := Vector2(99999, 99999)
	var maxp := Vector2(-99999, -99999)
	for corner in [Vector2(0, 0), Vector2(img.get_width(), 0), Vector2(0, img.get_height()), Vector2(img.get_width(), img.get_height())]:
		var wpos: Vector2 = (origin + world * (corner - pivot)) * scale
		minp = Vector2(minf(minp.x, wpos.x), minf(minp.y, wpos.y))
		maxp = Vector2(maxf(maxp.x, wpos.x), maxf(maxp.y, wpos.y))
	var inv := world.affine_inverse()
	for y in range(maxi(0, int(minp.y) - 1), mini(PH, int(maxp.y) + 2)):
		for x in range(maxi(0, int(minp.x) - 1), mini(PW, int(maxp.x) + 2)):
			var wp := Vector2(float(x) + 0.5, float(y) + 0.5) / scale - origin
			var lp := inv * wp + pivot
			var ix := int(floor(lp.x))
			var iy := int(floor(lp.y))
			if ix < 0 or iy < 0 or ix >= img.get_width() or iy >= img.get_height():
				continue
			var c := img.get_pixel(ix, iy)
			if c.a > 0.5:
				canvas.set_pixel(x, y, Color(c.r, c.g, c.b, 1))
