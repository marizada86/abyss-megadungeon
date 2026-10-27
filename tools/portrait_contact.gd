extends SceneTree
## PLAN-ABYSS-HERO-PORTRAITS-20261027: folha de contato dos retratos integrados (painel do HUD acima, retrato da Ficha abaixo, 3 heróis por linha).
## Uso: Godot --headless --path . --script tools/portrait_contact.gd -- <tag> <id> [<id> ...]
## Lê captures/hud-painel-<id>-<tag>.png e captures/ficha-retrato-<id>-<tag>.png; grava captures/contato-<tag>.png.
const DIR := "res://.atena/generated/hero-portraits-20261027-r1/captures/"
const CELL := Vector2i(404, 424)
const PER_ROW := 3

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("uso: -- <tag> <id> [<id> ...]")
		quit(1)
		return
	var tag := String(args[0])
	var ids := args.slice(1)
	var rows := ceili(ids.size() / float(PER_ROW))
	var sheet := Image.create(CELL.x * mini(ids.size(), PER_ROW), CELL.y * rows, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.07, 0.07, 0.09))
	var missing := 0
	for i in ids.size():
		var origin := Vector2i((i % PER_ROW) * CELL.x + 8, (i / PER_ROW) * CELL.y + 8)
		for part in [["hud-painel", 0], ["ficha-retrato", 205]]:
			var img := Image.load_from_file(ProjectSettings.globalize_path("%s%s-%s-%s.png" % [DIR, part[0], ids[i], tag]))
			if img == null:
				missing += 1
				push_error("sem %s-%s-%s.png" % [part[0], ids[i], tag])
				continue
			img.convert(Image.FORMAT_RGBA8)
			sheet.blend_rect(img, Rect2i(Vector2i.ZERO, img.get_size()), origin + Vector2i(0, part[1]))
	var out := ProjectSettings.globalize_path("%scontato-%s.png" % [DIR, tag])
	sheet.save_png(out)
	print("portrait_contact: ", out, " ", sheet.get_size())
	quit(1 if missing > 0 else 0)
