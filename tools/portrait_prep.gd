extends SceneTree
## PLAN-ABYSS-HERO-PORTRAITS-20261027: recorta e reduz os retratos gerados do HUD (256x256) e da Ficha (768x432, 16:9).
## Uso: Godot --headless --path . --script tools/portrait_prep.gd -- <id> [ficha_cx ficha_y0 ficha_w]
## Entrada: assets_incoming/hero-portraits-r1/<id>/<id>_hud_v01.png e <id>_ficha_v01.png (1:1 e 3:2).
## Saída: assets/portraits/hud/<id>.png e assets/portraits/ficha/<id>.png. A Ficha recorta um 16:9 de largura ficha_w (padrão 1152)
## centrado em ficha_cx (padrão: meio) e começando em ficha_y0 (padrão: centrado).
const INCOMING := "res://assets_incoming/hero-portraits-r1/"
const OUT := "res://assets/portraits/"
const HUD_SIZE := Vector2i(256, 256)
const FICHA_SIZE := Vector2i(768, 432)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		push_error("uso: -- <id> [ficha_cx ficha_y0 ficha_w]")
		quit(1)
		return
	var id := String(args[0])
	var fail := 0
	fail += _hud(id)
	fail += _ficha(id, int(args[1]) if args.size() > 1 else -1, int(args[2]) if args.size() > 2 else -1, int(args[3]) if args.size() > 3 else 1152)
	quit(1 if fail > 0 else 0)

func _load(path: String) -> Image:
	var img := Image.load_from_file(ProjectSettings.globalize_path(path))
	if img != null:
		img.convert(Image.FORMAT_RGBA8)
	return img

func _save(img: Image, path: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path).get_base_dir())
	img.save_png(ProjectSettings.globalize_path(path))
	print("portrait_prep: ", path, " ", img.get_size())

func _hud(id: String) -> int:
	var img := _load("%s%s/%s_hud_v01.png" % [INCOMING, id, id])
	if img == null:
		push_error("sem %s_hud_v01.png" % id)
		return 1
	var side := mini(img.get_width(), img.get_height())
	var crop := img.get_region(Rect2i((img.get_width() - side) / 2, (img.get_height() - side) / 2, side, side))
	crop.resize(HUD_SIZE.x, HUD_SIZE.y, Image.INTERPOLATE_LANCZOS)
	_save(crop, "%shud/%s.png" % [OUT, id])
	return 0

func _ficha(id: String, cx: int, y0: int, w: int) -> int:
	var img := _load("%s%s/%s_ficha_v01.png" % [INCOMING, id, id])
	if img == null:
		push_error("sem %s_ficha_v01.png" % id)
		return 1
	w = mini(w, img.get_width())
	var h := w * FICHA_SIZE.y / FICHA_SIZE.x
	h = mini(h, img.get_height())
	w = h * FICHA_SIZE.x / FICHA_SIZE.y
	if cx < 0:
		cx = img.get_width() / 2
	if y0 < 0:
		y0 = (img.get_height() - h) / 2
	var x0 := clampi(cx - w / 2, 0, img.get_width() - w)
	y0 = clampi(y0, 0, img.get_height() - h)
	var crop := img.get_region(Rect2i(x0, y0, w, h))
	crop.resize(FICHA_SIZE.x, FICHA_SIZE.y, Image.INTERPOLATE_LANCZOS)
	_save(crop, "%sficha/%s.png" % [OUT, id])
	return 0
