extends RefCounted
## Avisos de golpe dos inimigos comuns (T20 faixa, T21 mira, T22 círculo): folhas preparadas, quadro congelado, fatias da faixa, fallback e a
## ligação com o Overlay. Só apresentação: geometria, dano e tempo do golpe ficam em Battle.

const Overlay := preload("res://ui/overlay.gd")

func _image(texture: Texture2D) -> Image:
	var image := texture.get_image()
	if image.is_compressed():
		image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	return image

## Geometria, borda transparente, margem e cor neutra (a cor vem do jogo, não do arquivo).
func _sheets(out: Array[String]) -> void:
	for kind in TelegraphArt.KINDS:
		var cells := int(TelegraphArt.KINDS[kind].cells)
		var texture := TelegraphArt.load_sheet(TelegraphArt.path_for(kind), cells)
		if texture == null:
			out.append("folha ausente ou com geometria errada: " + String(kind))
			continue
		var image := _image(texture)
		for cell in cells:
			var part := image.get_region(Rect2i(cell * 256, 0, 256, 256))
			var box := part.get_used_rect()
			if not box.has_area() or box.position.x < 21 or box.position.y < 21 or box.end.x > 235 or box.end.y > 235:
				out.append("%s célula %d vazia ou sem margem" % [kind, cell])
			var border := 0.0
			for k in 256:
				border = maxf(border, maxf(part.get_pixel(k, 0).a, maxf(part.get_pixel(k, 255).a, maxf(part.get_pixel(0, k).a, part.get_pixel(255, k).a))))
			if border > 0.0:
				out.append("%s célula %d com alfa na borda" % [kind, cell])
			var data := part.get_data()
			for i in 256 * 256:
				if int(data[i * 4 + 3]) >= 26 and mini(int(data[i * 4]), mini(int(data[i * 4 + 1]), int(data[i * 4 + 2]))) < 250:
					out.append("%s célula %d não é neutra (a folha deve ser branca; quem tinge é o jogo)" % [kind, cell])
					break

func _frames(out: Array[String]) -> void:
	for kind in TelegraphArt.KINDS:
		var spec: Dictionary = TelegraphArt.KINDS[kind]
		var cells := int(spec.cells)
		if int(spec.freeze) < 0 or int(spec.freeze) >= cells:
			out.append("quadro de repouso fora da folha: " + String(kind))
		for now in [0, 777, 123456]:
			if TelegraphArt.frame_for(kind, now, true) != int(spec.freeze):
				out.append("Impacto reduzido deveria parar no quadro de repouso: " + String(kind))
		var seen := {}
		for i in cells:
			var frame := TelegraphArt.frame_for(kind, i * int(spec.frame_ms), false)
			seen[frame] = true
			if frame < 0 or frame >= cells:
				out.append("quadro fora da folha: " + String(kind))
		if seen.size() != cells:
			out.append("o ciclo deveria passar por todos os quadros: " + String(kind))
	if TelegraphArt.frame_for("inexistente", 500, false) != 0 or TelegraphArt.path_for("inexistente") != "":
		out.append("tipo desconhecido deveria cair em quadro 0 e caminho vazio")

func _slices(out: Array[String]) -> void:
	for pair in [[5.0, 0.9], [3.0, 0.9], [1.0, 0.9], [4.0, 0.5]]:
		var length: float = pair[0]
		var slices := TelegraphArt.lane_slices(length, float(pair[1]))
		if slices.size() != 3:
			out.append("a faixa deveria ter três fatias")
			continue
		var edge := 0.0
		for s in slices:
			if absf(float(s.d0) - edge) > 0.0001:
				out.append("fatias da faixa não são contínuas (comprimento %s)" % length)
			if float(s.d1) < float(s.d0) - 0.0001:
				out.append("fatia com comprimento negativo (comprimento %s)" % length)
			edge = float(s.d1)
		if absf(edge - length) > 0.0001:
			out.append("as fatias deveriam somar o comprimento da faixa (%s)" % length)
	var long_lane := TelegraphArt.lane_slices(6.0, 0.9)
	var short_lane := TelegraphArt.lane_slices(1.0, 0.9)
	if float(long_lane[1].d1) - float(long_lane[1].d0) <= 0.0:
		out.append("faixa longa deveria ter miolo esticado")
	if float(short_lane[1].d1) - float(short_lane[1].d0) > 0.0001:
		out.append("faixa curta deveria ter só as duas pontas, encolhidas")
	var cap_long := float(long_lane[0].d1) - float(long_lane[0].d0)
	var cap_short := float(short_lane[0].d1) - float(short_lane[0].d0)
	if cap_short >= cap_long:
		out.append("as pontas deveriam encolher quando o trajeto é curto")

func _fallback(out: Array[String]) -> void:
	if TelegraphArt.load_sheet("res://assets/vfx/aviso_comum_inexistente.png", 6) != null:
		out.append("arquivo ausente deveria devolver nulo (o Overlay cai no desenho por código)")
	if TelegraphArt.load_sheet(TelegraphArt.path_for("faixa"), 4) != null:
		out.append("folha com a geometria errada deveria ser recusada")
	if TelegraphArt.has_sheet("inexistente"):
		out.append("tipo desconhecido não tem folha")

func _node(out: Array[String]) -> void:
	var art := TelegraphArt.new()
	if not (art.material is CanvasItemMaterial) or (art.material as CanvasItemMaterial).blend_mode != CanvasItemMaterial.BLEND_MODE_ADD:
		out.append("a arte dos avisos deveria usar mistura aditiva")
	if not art.show_behind_parent:
		out.append("a arte deveria desenhar atrás do Overlay (preenchimento e realces por cima)")
	art.lane(Vector2.ZERO, Vector2.RIGHT, 3.0, 0.9, Color.WHITE, 0)
	art.aim(Vector2.ZERO, Vector2(80, 0), 0.5, Color.WHITE, 0)
	art.ring(Vector2.ZERO, 1.5, Color.WHITE, 0)
	art.lane(Vector2.ZERO, Vector2.RIGHT, 3.0, 0.9, Color.WHITE, 0, 0.6)   # com progresso: feixe inteiro fraco + parte carregada forte
	if art.command_count() != 4:
		out.append("os quatro comandos deveriam entrar na fila")
	art.reset()
	if art.command_count() != 0:
		out.append("reset deveria esvaziar a fila")
	art.free()
	var overlay := Overlay.new()
	var made := overlay._telegraph_art()
	if made == null or overlay._telegraph_art() != made or overlay.get_child_count() != 1:
		out.append("o Overlay deveria criar a arte uma vez e reaproveitá-la")
	elif made.show_behind_parent:
		out.append("na camada de cima a mira deveria ficar NA FRENTE do Overlay, para o alvo aparecer sobre o herói")
	overlay.free()
	var under := Overlay.new()
	under.mode = "under"
	if not under._telegraph_art().show_behind_parent:
		out.append("na camada de baixo o anel e a faixa deveriam ficar atrás, no chão")
	under.free()

func run() -> Array[String]:
	var out: Array[String] = []
	_sheets(out)
	_frames(out)
	_slices(out)
	_fallback(out)
	_node(out)
	return out
