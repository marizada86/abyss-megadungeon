extends RefCounted
## Âncora de chão dos efeitos (VfxAtlas.GROUND_ROW): o centro do anel da arte tem de cair sobre o ponto do chão.
## O erro que isto evita: ancorar na borda de baixo da célula (linha 196) levantava o anel 14-38 px acima do alvo
## (aura da Maré, Colar dos Tentáculos, poção, subida de nível, detonações, mortes).
const TOLERANCE := 10.0
## Folhas cujo anel é a feição mais larga do quadro de pico: a tabela precisa bater com a linha medida na arte.
const MEASURED := ["mare_aura", "pocao_coleta", "subida_de_nivel_v2", "detonacao_magica", "tentaculos_laco", "tentaculos_emergem", "boss_fase_estouro"]

func _widest_row(sheet: String) -> int:
	var texture := VfxAtlas.texture("res://assets/vfx/%s.png" % sheet)
	if texture == null:
		return -1
	var image := texture.get_image()
	if image.is_compressed():
		image.decompress()
	var best_cell := 0
	var best_sum := -1.0
	for cell in 6:
		var sum := 0.0
		for y in range(0, 256, 2):
			for x in range(0, 256, 2):
				sum += image.get_pixel(cell * 256 + x, y).a
		if sum > best_sum:
			best_sum = sum
			best_cell = cell
	var widest := 0
	var row := -1
	for y in 256:
		var low := 999
		var high := -1
		for x in 256:
			if image.get_pixel(best_cell * 256 + x, y).a > 0.25:
				low = mini(low, x)
				high = maxi(high, x)
		if high >= 0 and high - low + 1 > widest:
			widest = high - low + 1
			row = y
	return row

func run() -> Array[String]:
	var out: Array[String] = []
	for sheet in VfxAtlas.GROUND_ROW:
		if not ResourceLoader.exists("res://assets/vfx/%s.png" % sheet):
			out.append("folha %s da tabela de âncoras não existe" % sheet)
	for sheet in MEASURED:
		if not VfxAtlas.GROUND_ROW.has(sheet):
			out.append("folha %s sem entrada em VfxAtlas.GROUND_ROW" % sheet)
			continue
		var measured := _widest_row(sheet)
		if measured < 0:
			out.append("folha %s ausente ou fora de 1536x256" % sheet)
		elif absf(float(VfxAtlas.GROUND_ROW[sheet]) - float(measured)) > TOLERANCE:
			out.append("%s: âncora %d longe do anel medido na arte (linha %d)" % [sheet, int(VfxAtlas.GROUND_ROW[sheet]), measured])
	# os nós criados usam a tabela, não um literal
	var aura := PickupVfx.create_tide_aura()
	if aura == null or not is_equal_approx(aura.offset.y, VfxAtlas.ground_offset_y("mare_aura")): out.append("aura da Maré fora da âncora da tabela")
	if aura != null: aura.free()
	var potion := PickupVfx.create_collect("potion", Vector2(5, 5), false, 0, 900000)
	if potion == null or not is_equal_approx((potion.get_child(0) as AnimatedSprite2D).offset.y, VfxAtlas.ground_offset_y("pocao_coleta")): out.append("poção fora da âncora da tabela")
	if potion != null: potion.free()
	var level := PickupVfx.create_levelup(Vector2(5, 5))
	if level == null or not is_equal_approx((level.get_child(0) as AnimatedSprite2D).offset.y, VfxAtlas.ground_offset_y("subida_de_nivel_v2")): out.append("subida de nível fora da âncora da tabela")
	if level != null: level.free()
	var magic := DetonationVfx.create_effect(2.0, Vector2(5, 5), "magico")
	if magic == null or not is_equal_approx((magic.get_child(0) as AnimatedSprite2D).offset.y, VfxAtlas.ground_offset_y("detonacao_magica")): out.append("detonação mágica fora da âncora da tabela")
	if magic != null: magic.free()
	# nenhum efeito volta a ancorar com a borda de baixo (196) escrita à mão
	var dir := DirAccess.open("res://core")
	for file in dir.get_files():
		if not file.ends_with("_vfx.gd"):
			continue
		var text := FileAccess.get_file_as_string("res://core/%s" % file)
		for line in text.split("\n"):
			var code := line.split("#")[0]
			if code.contains("196") or code.contains("BASE_ANCHOR"):
				out.append("%s ancora com a borda 196 à mão; use VfxAtlas.ground_offset_y(folha)" % file)
				break
	return out
