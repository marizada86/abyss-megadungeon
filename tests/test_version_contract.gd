extends RefCounted
## A versão do jogo e a dos três presets de exportação não podem divergir (core/version.gd é a fonte).

func run() -> Array:
	var out: Array = []
	var rx := RegEx.new()
	rx.compile("^[0-9]+[.][0-9]+[.][0-9]+$")
	if rx.search(Version.VERSION) == null:
		out.append("VERSION fora do formato major.minor.patch: %s" % Version.VERSION)
	var presets := FileAccess.get_file_as_string("res://export_presets.cfg")
	var expected := Version.VERSION + ".0"
	var seen := 0
	for key in ["application/file_version", "application/product_version"]:
		for line in presets.split("\n"):
			if line.begins_with(key + "="):
				seen += 1
				if line.strip_edges() != '%s="%s"' % [key, expected]:
					out.append("preset diverge de %s: %s" % [expected, line.strip_edges()])
	if seen != 6:
		out.append("esperava 6 campos de versão (3 presets × 2), achei %d" % seen)
	return out
