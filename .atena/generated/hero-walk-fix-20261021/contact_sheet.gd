extends SceneTree
## Folha de contato das passadas como o jogo as mostra (somente leitura; roda fora do projeto: godot --headless --script contact_sheet.gd).
## Linhas: e, se, s, sw, w, nw, n, ne. Barra laranja no topo da linha = virada por espelho de leste/sudeste/nordeste (como em ui/hero_view.gd).
## Linha amarela = base dos pés do idle (HERO_FEET_Y). Colunas = quadros da tira (6; Erik move_e 7).
const ROOT := "F:/dev/abyss-megadungeon/assets/animations/heroes/"
const OUT := "F:/dev/abyss-megadungeon/.atena/generated/hero-walk-fix-20261021/contact-r1/"
const FEET := {"korrak":350,"kayron":376,"sylas":376,"maelor":364,"nyrelia":368,"durvall":376,"zynara":376,"bromnor":364,"leoric":368,"brook":368,"arlindo":448,"erik":448}
const WIDE_STRIPS := {"durvall":["move_e","move_se","move_s","move_n","move_ne","move_w","move_sw","move_nw"],"zynara":["move_n","move_ne"],"leoric":["move_n","move_ne"]}
const WIDE_SRC := ["arlindo","erik"]
const REAL_WEST := {"durvall":["move_w","move_sw","move_nw"]}
const MIRROR := {"move_w":"move_e","move_nw":"move_ne","move_sw":"move_se"}
const DIRS := ["e","se","s","sw","w","nw","n","ne"]
const TILE := Vector2i(384, 400)
const TILE_FEET := 376
const MAXCOLS := 7

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	var overview := {}
	for hero: String in FEET.keys():
		var sheet := _hero_sheet(hero)
		sheet.save_png(OUT + hero + ".png")
		overview[hero] = sheet
	_overview(overview, ["arlindo","bromnor","brook","durvall","erik","kayron"], "overview-1.png")
	_overview(overview, ["korrak","leoric","maelor","nyrelia","sylas","zynara"], "overview-2.png")
	quit()

func _cell(hero: String, name: String) -> Vector2i:
	if hero in WIDE_SRC or (WIDE_STRIPS.has(hero) and name in WIDE_STRIPS[hero]):
		return Vector2i(512, 512)
	return Vector2i(256, 384)

func _feet_in_cell(hero: String, cell: Vector2i) -> int:
	if cell.y == 512 and not hero in WIDE_SRC:
		return FEET[hero] + 64
	return FEET[hero]

func _hero_sheet(hero: String) -> Image:
	var full := Image.create(TILE.x * MAXCOLS, TILE.y * DIRS.size(), false, Image.FORMAT_RGBA8)
	full.fill(Color(0.13, 0.13, 0.16, 1))
	for row in DIRS.size():
		var name: String = "move_" + DIRS[row]
		var mirrored := false
		var src_name := name
		if MIRROR.has(name) and not (REAL_WEST.has(hero) and name in REAL_WEST[hero]):
			mirrored = true
			src_name = MIRROR[name]
		var img := Image.load_from_file(ROOT + hero + "/" + src_name + ".png")
		if img == null:
			continue
		img.convert(Image.FORMAT_RGBA8)
		var cell := _cell(hero, src_name)
		var count := int(img.get_width() / cell.x)
		var feet := _feet_in_cell(hero, cell)
		for col in count:
			if col >= MAXCOLS:
				break
			var tile := Image.create(TILE.x, TILE.y, false, Image.FORMAT_RGBA8)
			tile.fill(Color(0.13, 0.13, 0.16, 1) if (row + col) % 2 == 0 else Color(0.15, 0.15, 0.19, 1))
			tile.fill_rect(Rect2i(0, TILE_FEET, TILE.x, 1), Color(1, 0.9, 0.1, 0.8))
			var frame := img.get_region(Rect2i(col * cell.x, 0, cell.x, cell.y))
			if mirrored:
				frame.flip_x()
			# centro horizontal da célula no centro do ladrilho, base do idle na linha TILE_FEET
			tile.blend_rect(frame, Rect2i(0, 0, cell.x, cell.y), Vector2i(TILE.x / 2 - cell.x / 2, TILE_FEET - feet))
			if mirrored:
				tile.fill_rect(Rect2i(0, 0, TILE.x, 8), Color(1, 0.55, 0.1, 1))
			full.blit_rect(tile, Rect2i(0, 0, TILE.x, TILE.y), Vector2i(col * TILE.x, row * TILE.y))
	full.resize(full.get_width() / 2, full.get_height() / 2, Image.INTERPOLATE_LANCZOS)
	return full

func _overview(sheets: Dictionary, heroes: Array, file: String) -> void:
	# Um quadro (o 2º) de cada direção, 6 heróis por imagem; ladrilho de 192x200 vindo da folha por herói.
	var tw := TILE.x / 2
	var th := TILE.y / 2
	var out := Image.create(tw * DIRS.size(), th * heroes.size(), false, Image.FORMAT_RGBA8)
	out.fill(Color(0.1, 0.1, 0.12, 1))
	for r in heroes.size():
		var sheet: Image = sheets[heroes[r]]
		for d in DIRS.size():
			out.blit_rect(sheet, Rect2i(1 * tw, d * th, tw, th), Vector2i(d * tw, r * th))
	out.save_png(OUT + file)
