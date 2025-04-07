extends Node2D

var vessel := preload("res://scenes/vessel_enemy.tscn")

var i : int = 0
var ppos: Vector2

func _ready() -> void:
	randomize()

func _on_player_move(pos: Vector2):
	self.ppos = pos

func _on_timer_timeout() -> void:
	i = get_tree().get_node_count_in_group("Vessels")
	if i >= 20: return

	var r: float = 1000 + randi_range(0, 900)
	var theta: float = randf() * 2 * PI
	var p := Vector2(ppos.x + r * cos(theta),ppos.y + r * sin(theta))

	var max_depth: float = $"../Map".check_depth(int(p.x), int(p.y))
	if (max_depth > -10): return
	for e: Vessel in get_tree().get_nodes_in_group("Vessels"):
		if (e.position-p).length() < 200: return
	var m := vessel.instantiate()
	m.depth = 0
	m.position = p
	$"..".add_child(m)
