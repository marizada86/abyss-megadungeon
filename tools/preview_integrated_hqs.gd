extends SceneTree
## Synthetic review session; no campaign events or real profile are used.
var reader: Control
var next_index := 0
const IDS := ["hqn_21", "hqn_04"]

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var game := root.get_node("Game")
	game.profile.data.name = "Conferencia HQ21 e HQ04"
	game.profile.data.welcome_seen = true
	reader = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(reader)
	reader.closed.connect(func(): call_deferred("_next"))
	_next()

func _next() -> void:
	if next_index >= IDS.size():
		quit()
		return
	reader.start_hq(Data.table("hqs")[IDS[next_index]])
	next_index += 1
