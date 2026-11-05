extends RefCounted
## A08 (2026-11-04): pedra rúnica como arte das montanhas de Durao. Só apresentação: colisão e posições não mudam.

const FeaturesScript := preload("res://ui/terrain_features.gd")

func run() -> Array[String]:
	var out: Array[String] = []
	var path := "res://assets/props/montanha_runica_01.png"
	if not ResourceLoader.exists(path):
		return ["arte da montanha ausente ou sem importação"]
	var texture := load(path) as Texture2D
	var image := texture.get_image()
	if image.is_compressed():
		image.decompress()
	var box := image.get_used_rect()
	if box.position.x < 3 or box.position.y < 3 or box.end.x > image.get_width() - 3 or box.end.y > image.get_height() - 3:
		out.append("a arte da montanha precisa de margem transparente")
	if image.get_pixel(0, 0).a != 0.0 or image.get_pixel(image.get_width() - 1, 0).a != 0.0:
		out.append("cantos da arte da montanha não são transparentes")
	# a colisão não pode mudar: mesmos círculos de antes
	var expected := [Vector3(7.0, 9.0, 2.2), Vector3(10.0, 30.0, 2.0), Vector3(34.0, 12.0, 2.3), Vector3(34.0, 31.0, 2.1)]
	if FeaturesScript == null or preload("res://core/terrain_layout.gd").MOUNTAINS != expected:
		out.append("as montanhas (posição e raio de colisão) não podem mudar com a arte")
	var features: Node2D = FeaturesScript.new()
	features.terrain_layout_id = "durao"
	features._rebuild()
	var ridges := features.get_children().filter(func(c): return not c.is_queued_for_deletion())
	if ridges.size() != 4:
		out.append("esperava 4 montanhas em Durao, achei %d" % ridges.size())
	var flips := 0
	for r in ridges:
		var rect: Rect2 = r.art_rect()
		var footprint := float(r.radius) * sqrt(2.0) * Iso.TILE_W
		# a largura do embasamento (a arte menos a margem) coincide com a elipse de colisão
		var base_width := rect.size.x * (200.0 / 208.0)
		if absf(base_width - footprint) > 1.0:
			out.append("largura do embasamento %.1f diferente da elipse de colisão %.1f (raio %.1f)" % [base_width, footprint, r.radius])
		if rect.end.y < r.ground_offset:
			out.append("a arte precisa apoiar-se no chão da montanha")
		if r.flip:
			flips += 1
	if flips != 2:
		out.append("a arte deveria alternar espelhada (2 de 4), achei %d" % flips)
	features.free()
	# sem a arte, o desenho antigo continua (fora de Durao nada é criado)
	var other: Node2D = FeaturesScript.new()
	other.terrain_layout_id = "dagruve"
	other._rebuild()
	if other.get_children().filter(func(c): return not c.is_queued_for_deletion()).size() != 0:
		out.append("só Durao tem montanhas")
	other.free()
	return out
