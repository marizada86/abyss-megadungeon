class_name RootPathGenerator
extends RefCounted
## Local LCG; never consumes combat RNG or retains another battle's geometry.
const VERSION := "path-r1-lcg32"
const LIMIT := 16
var _state: int

func _sample() -> float:
	_state = (1664525 * _state + 1013904223) & 0xffffffff
	return float(_state) / 4294967296.0

func _quarter(value: float) -> float:
	return floor(value * 4.0 + 0.5) / 4.0

func generate(base: Dictionary, seed_value: int) -> Dictionary:
	_state = (seed_value + 24691) & 0xffffffff
	for attempt in LIMIT:
		var d := base.duplicate(true)
		d.erase("_support_cells") # Derived bounds must follow the new candidate.
		for id: String in d.nodes:
			if id in ["E", "G"]:
				continue
			d.nodes[id][0] += _quarter((_sample() * 2.0 - 1.0) * 1.5)
			d.nodes[id][1] += _quarter((_sample() * 2.0 - 1.0) * 1.5)
		for i in d.edges.size():
			d.edges[i][2] = _quarter((7.0 if i < 3 else 4.5) + _sample())
		var omit := int(floor(_sample() * 5.0))
		if omit < 4:
			d.edges.remove_at(13 + omit)
		if valid(d):
			d.generation = {"version":VERSION,"seed":seed_value,"attempts":attempt+1,"fallback":false}
			return d
	var fallback := base.duplicate(true)
	fallback.generation = {"version":VERSION,"seed":seed_value,"attempts":LIMIT,"fallback":true}
	# Never substitute an unvalidated floor, including a malformed local base.
	return fallback if valid(fallback) else {}

static func valid(d: Dictionary) -> bool:
	if not d.has_all(["nodes","edges","arrival","target"]) or d.nodes.size() != 12 or d.edges.size() < 16 or d.edges.size() > 17:
		return false
	var neighbors: Dictionary = {}
	for id: String in d.nodes:
		var n: Array = d.nodes[id]
		if n.size() != 3 or float(n[2]) < 1.2 or float(n[0])-float(n[2]) < 0 or float(n[1])-float(n[2]) < 0 or float(n[0])+float(n[2]) > 60 or float(n[1])+float(n[2]) > 60:
			return false
		neighbors[id] = []
	for e: Array in d.edges:
		if e.size() != 3 or not neighbors.has(e[0]) or not neighbors.has(e[1]) or e[0] == e[1] or float(e[2]) < 4.5 or float(e[2]) > 8.0 or neighbors[e[0]].has(e[1]):
			return false
		if TerrainLayout.root_point(d.nodes[e[0]]).distance_squared_to(TerrainLayout.root_point(d.nodes[e[1]])) < 0.01:
			return false
		neighbors[e[0]].append(e[1])
		neighbors[e[1]].append(e[0])
	var ids: Array = d.nodes.keys()
	for i in ids.size():
		for j in range(i+1,ids.size()):
			if not neighbors[ids[i]].has(ids[j]) and TerrainLayout.root_point(d.nodes[ids[i]]).distance_to(TerrainLayout.root_point(d.nodes[ids[j]])) < 6.5:
				return false
	for i in d.edges.size():
		var e: Array = d.edges[i]
		for j in range(i+1,d.edges.size()):
			var f: Array = d.edges[j]
			if e[0] in [f[0],f[1]] or e[1] in [f[0],f[1]]:
				continue
			if Geometry2D.segment_intersects_segment(TerrainLayout.root_point(d.nodes[e[0]]),TerrainLayout.root_point(d.nodes[e[1]]),TerrainLayout.root_point(d.nodes[f[0]]),TerrainLayout.root_point(d.nodes[f[1]])) != null:
				return false
	var seen := {"E":true}
	var queue: Array = ["E"]
	var cursor := 0
	while cursor < queue.size():
		var id: String = queue[cursor]
		cursor += 1
		for other: String in neighbors[id]:
			if not seen.has(other):
				seen[other] = true
				queue.append(other)
	# Each eroded capsule contains its centerline and meets its endpoint disks
	# for all four contracted body radii (max 1.2 < half of min width 4.5).
	# Thus a connected graph proves connected support for every such radius.
	if seen.size() != ids.size() or d.edges.size()-ids.size()+1 < 5:
		return false
	for radius in [0.3,0.4,0.8,1.2]:
		if not TerrainLayout.root_supports(TerrainLayout.root_point(d.arrival),radius,"raiz_yggdrasil",d) or not TerrainLayout.root_supports(TerrainLayout.root_point(d.target),radius,"raiz_yggdrasil",d):
			return false
	var fraction := occupied_fraction(d)
	return fraction >= 0.24 and fraction <= 0.38

static func occupied_fraction(d: Dictionary) -> float:
	# Rasterize only primitive bounds, with the documentary half-unit grid.
	var cells := PackedByteArray()
	cells.resize(120*120)
	for n: Array in d.nodes.values():
		var p := TerrainLayout.root_point(n)
		var r := float(n[2])-0.3
		_mark(cells,p,p,r)
	for e: Array in d.edges:
		_mark(cells,TerrainLayout.root_point(d.nodes[e[0]]),TerrainLayout.root_point(d.nodes[e[1]]),float(e[2])*0.5-0.3)
	var count := 0
	for cell in cells:
		count += cell
	return float(count)/14400.0

static func _mark(cells: PackedByteArray, a: Vector2, b: Vector2, radius: float) -> void:
	var lo := (a.min(b)-Vector2.ONE*radius)*2.0
	var hi := (a.max(b)+Vector2.ONE*radius)*2.0
	for y in range(maxi(0,int(ceil(lo.y))),mini(119,int(floor(hi.y)))+1):
		for x in range(maxi(0,int(ceil(lo.x))),mini(119,int(floor(hi.x)))+1):
			if cells[y*120+x] != 0:
				continue
			var p := Vector2(x,y)*0.5
			var closest := a if a == b else Geometry2D.get_closest_point_to_segment(p,a,b)
			if p.distance_squared_to(closest) <= radius*radius:
				cells[y*120+x] = 1
