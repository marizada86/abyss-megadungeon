extends SceneTree
## Auditoria somente leitura das tiras de caminhada dos heróis (nenhum arquivo do projeto é aberto para escrita).
const ROOT := "F:/dev/abyss-megadungeon/assets/animations/heroes/"
const OUT := "C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-abyss-megadungeon/f26217b1-b95a-4683-b059-94b7264285fe/scratchpad/walk_audit.json"
const FEET := {"korrak":350,"kayron":376,"sylas":376,"maelor":364,"nyrelia":368,"durvall":376,"zynara":376,"bromnor":364,"leoric":368,"brook":368,"arlindo":448,"erik":448}
const IDLE_H := {"korrak":267,"kayron":316,"sylas":304,"maelor":299,"nyrelia":352,"durvall":231,"zynara":368,"bromnor":241,"leoric":224,"brook":259,"arlindo":290,"erik":300}
const WIDE := {"durvall":["move_e","move_se","move_s","move_n","move_ne","move_w","move_sw","move_nw"],"zynara":["move_n","move_ne"],"leoric":["move_n","move_ne"]}
const WIDE_SRC := ["arlindo","erik"]
const DIRS := ["e","se","s","sw","w","nw","n","ne"]

func _init() -> void:
	var report := {}
	for hero: String in FEET.keys():
		var hr := {}
		var idle := _frames(ROOT + hero + "/idle.png", _cell(hero, "idle"), 4)
		hr["idle"] = _summ(idle)
		for d: String in DIRS:
			var name: String = "move_" + d
			var path: String = ROOT + hero + "/" + name + ".png"
			if not FileAccess.file_exists(path):
				hr[name] = {"missing": true}
				continue
			var cell := _cell(hero, name)
			var img := Image.load_from_file(path)
			var n := 6
			if hero == "erik" and name == "move_e":
				n = 7
			var info := _summ(_frames(path, cell, n))
			info["sheet"] = [img.get_width(), img.get_height()]
			info["cell"] = [cell.x, cell.y]
			info["expected_w"] = n * cell.x
			info["width_matches"] = img.get_width() == n * cell.x
			info["height_matches"] = img.get_height() == cell.y
			hr[name] = info
		report[hero] = hr
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(report, "  "))
	f.close()
	quit()

func _cell(hero: String, name: String) -> Vector2i:
	if hero in WIDE_SRC:
		return Vector2i(512, 512)
	if WIDE.has(hero) and name in WIDE[hero]:
		return Vector2i(512, 512)
	return Vector2i(256, 384)

func _frames(path: String, cell: Vector2i, count: int) -> Array:
	var img := Image.load_from_file(path)
	var out := []
	if img == null:
		return out
	img.convert(Image.FORMAT_RGBA8)
	var n := int(img.get_width() / cell.x)
	if n <= 0:
		n = count
	for i in n:
		var minx := 99999; var maxx := -1; var miny := 99999; var maxy := -1; var cnt := 0; var sx := 0.0
		var hsh := 0
		var x0 := i * cell.x
		for y in cell.y:
			for x in cell.x:
				if x0 + x >= img.get_width() or y >= img.get_height():
					continue
				var a := img.get_pixel(x0 + x, y).a8
				if a > 16:
					cnt += 1
					sx += x
					minx = mini(minx, x); maxx = maxi(maxx, x); miny = mini(miny, y); maxy = maxi(maxy, y)
		var region := img.get_region(Rect2i(x0, 0, cell.x, cell.y))
		hsh = hash(region.get_data())
		out.append({"empty": cnt == 0, "minx": minx, "maxx": maxx, "miny": miny, "maxy": maxy, "h": maxy - miny + 1, "w": maxx - minx + 1, "px": cnt, "cx": (sx / maxf(cnt, 1)), "hash": hsh,
			"clip_l": minx <= 0, "clip_r": maxx >= cell.x - 1, "clip_t": miny <= 0, "clip_b": maxy >= cell.y - 1})
	return out

func _summ(fr: Array) -> Dictionary:
	if fr.is_empty():
		return {"frames": 0}
	var hs := []; var bs := []; var cxs := []; var pxs := []
	var dup := 0; var empty := 0; var clip := 0
	for i in fr.size():
		var q: Dictionary = fr[i]
		if q.empty:
			empty += 1
			continue
		hs.append(q.h); bs.append(q.maxy); cxs.append(q.cx); pxs.append(q.px)
		if q.clip_l or q.clip_r or q.clip_t or q.clip_b:
			clip += 1
		if i > 0 and fr[i - 1].hash == q.hash:
			dup += 1
	return {"frames": fr.size(), "empty": empty, "clipped_frames": clip, "duplicate_consecutive": dup,
		"h_min": hs.min() if not hs.is_empty() else 0, "h_max": hs.max() if not hs.is_empty() else 0,
		"base_min": bs.min() if not bs.is_empty() else 0, "base_max": bs.max() if not bs.is_empty() else 0,
		"cx_min": snappedf(cxs.min(), 0.1) if not cxs.is_empty() else 0, "cx_max": snappedf(cxs.max(), 0.1) if not cxs.is_empty() else 0,
		"px_min": pxs.min() if not pxs.is_empty() else 0, "px_max": pxs.max() if not pxs.is_empty() else 0,
		"h_per_frame": hs, "base_per_frame": bs}
