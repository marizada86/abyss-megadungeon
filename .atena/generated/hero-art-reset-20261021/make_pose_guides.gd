extends SceneTree
## Guia de pose (boneco) para a caminhada, contrato r3. Gera um PNG por direção; hoje só `se` (de frente e para a direita da tela).
##   godot --headless --script make_pose_guides.gd -- <pasta_de_saida>
## O guia é referência de POSE, não de personagem. Cores: vermelho = perna do lado da câmera (próxima, desenhada por cima);
## azul = perna do lado oposto (distante, desenhada por baixo). Cinza = tronco, cabeça e braços (ignorar).
## Três figuras na fila (A, P1, P2) em 1536x1024, mesma escala e mesma linha do chão (y = 900), sem texto e sem linha de chão.
## Geometria (px, relativa ao centro da figura cx; y para baixo; altura da figura ~760):
##   A  contato: perna próxima à frente (tornozelo +165), perna distante atrás (-170); afastamento dos pés ~0,45 da altura; quadril em y=520
##   P1 passagem: perna próxima é o apoio (reta, pé plano); perna distante levantada, pé ao lado do tornozelo de apoio na altura da canela (y=785), joelho à frente (+85); quadril em y=495 (corpo no ponto mais alto)
##   P2 passagem: perna distante é o apoio; perna próxima levantada com a mesma geometria, por cima da perna de apoio
const W := 1536
const H := 1024
const GROUND := 900
const RED := Color(0.86, 0.12, 0.12, 1)
const BLUE := Color(0.12, 0.25, 0.9, 1)
const BODY := Color(0.28, 0.28, 0.3, 1)
const ARM := Color(0.5, 0.5, 0.52, 1)
const BG := Color(0.82, 0.82, 0.82, 1)

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var out_dir: String = a[0] if a.size() > 0 else "."
	DirAccess.make_dir_recursive_absolute(out_dir)
	var img := Image.create(W, H, false, Image.FORMAT_RGBA8)
	img.fill(BG)
	var poses := [
		{"cx": 256, "hip": 520, "near": [Vector2(90, 715), Vector2(165, 880), Vector2(225, GROUND)], "far": [Vector2(-60, 715), Vector2(-170, 875), Vector2(-125, GROUND)], "arm_far": Vector2(75, 470)},
		{"cx": 768, "hip": 495, "near": [Vector2(8, 700), Vector2(6, 882), Vector2(66, GROUND)], "far": [Vector2(85, 665), Vector2(-10, 785), Vector2(45, 810)], "arm_far": Vector2(-10, 450)},
		{"cx": 1280, "hip": 495, "near": [Vector2(85, 665), Vector2(-10, 785), Vector2(45, 810)], "far": [Vector2(-8, 700), Vector2(-6, 882), Vector2(54, GROUND)], "arm_far": Vector2(-10, 450)},
	]
	for p in poses:
		_figure(img, p)
	var path := out_dir.path_join("pose_guide_walk_se_A_P1_P2_r3.png")
	img.save_png(path)
	print("guia: ", path)
	quit()

func _figure(img: Image, p: Dictionary) -> void:
	var cx: float = p.cx
	var hip := Vector2(cx, p.hip)
	var shoulder := Vector2(cx + 6, float(p.hip) - 225)
	# braços (neutros): o do lado da câmera pende firme, o distante balança
	_line(img, shoulder, Vector2(cx - 30, float(p.hip) - 50), 26, ARM)
	_line(img, shoulder, Vector2(cx, 0) + p.arm_far, 26, ARM)
	# perna distante (azul) por baixo, depois tronco, depois perna próxima (vermelha) por cima
	_leg(img, hip, p.far, BLUE)
	_line(img, shoulder, hip, 78, BODY)
	_disc(img, shoulder + Vector2(10, -85), 50, BODY)
	_disc(img, shoulder + Vector2(48, -75), 14, BODY)  # nariz: a figura olha para a direita
	_leg(img, hip, p.near, RED)

func _leg(img: Image, hip: Vector2, pts: Array, col: Color) -> void:
	var cx := hip.x
	var knee := Vector2(cx, 0) + Vector2(pts[0].x, pts[0].y)
	var ankle := Vector2(cx, 0) + Vector2(pts[1].x, pts[1].y)
	var toe := Vector2(cx, 0) + Vector2(pts[2].x, pts[2].y)
	_line(img, hip, knee, 44, col)
	_line(img, knee, ankle, 40, col)
	_line(img, ankle, toe, 34, col)
	_disc(img, knee, 24, col)

func _disc(img: Image, c: Vector2, r: int, col: Color) -> void:
	for y in range(int(c.y) - r, int(c.y) + r + 1):
		for x in range(int(c.x) - r, int(c.x) + r + 1):
			if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height() and Vector2(x, y).distance_to(c) <= r:
				img.set_pixel(x, y, col)

func _line(img: Image, a: Vector2, b: Vector2, w: int, col: Color) -> void:
	var n := int(a.distance_to(b))
	for i in range(n + 1):
		_disc(img, a.lerp(b, float(i) / maxf(n, 1)), w / 2, col)
