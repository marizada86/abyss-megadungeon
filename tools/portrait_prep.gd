extends SceneTree
## PLAN-ABYSS-HERO-PORTRAITS-20261027: recorta e reduz os retratos gerados do HUD (256x256) e da Ficha (768x432, 16:9).
## Uso: Godot --headless --path . --script tools/portrait_prep.gd -- <id> [ficha_cx ficha_y0 ficha_w]
## Entrada: assets_incoming/hero-portraits-r1/<id>/<id>_hud_v01.png e <id>_ficha_v01.png (1:1 e 3:2).
## Saída: assets/portraits/hud/<id>.png e assets/portraits/ficha/<id>.png. A Ficha recorta um 16:9 de largura ficha_w (padrão 1152; acima da largura da imagem, ex. 1820, usa a altura inteira e espelha as laterais)
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

## Modo "altura inteira": o 16:9 da altura toda da imagem; as laterais que faltam são completadas espelhando a borda do cenário.
func _fit_wide(img: Image) -> Image:
	var h := img.get_height()
	var full_w := h * FICHA_SIZE.x / FICHA_SIZE.y
	var pad := (full_w - img.get_width()) / 2
	var canvas := Image.create(full_w, h, false, Image.FORMAT_RGBA8)
	canvas.blit_rect(img, Rect2i(0, 0, img.get_width(), h), Vector2i(pad, 0))
	var left := img.get_region(Rect2i(0, 0, pad, h))
	left.flip_x()
	canvas.blit_rect(left, Rect2i(0, 0, pad, h), Vector2i(0, 0))
	var right := img.get_region(Rect2i(img.get_width() - pad, 0, pad, h))
	right.flip_x()
	canvas.blit_rect(right, Rect2i(0, 0, pad, h), Vector2i(pad + img.get_width(), 0))
	return canvas

func _ficha(id: String, cx: int, y0: int, w: int) -> int:
	var img := _load("%s%s/%s_ficha_v01.png" % [INCOMING, id, id])
	if img == null:
		push_error("sem %s_ficha_v01.png" % id)
		return 1
	if w > img.get_width():
		img = _fit_wide(img)
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
