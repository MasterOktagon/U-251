extends Node2D

var mine := preload("res://scenes/mine_enemy.tscn")
var noise := FastNoiseLite.new()

func _ready()->void:
	randomize()

func _on_player_move(ppos: Vector2):
	var i : int = get_tree().get_node_count_in_group("Mines")
	if i>=200:
		return
		
	var r: float = 1000 + randi_range(0, 900)
	var theta: float = randf() * 2 * PI
	var p := Vector2(ppos.x + r * cos(theta),ppos.y + r * sin(theta))
	
	var max_depth: float = $"../Map".check_depth(int(p.x), int(p.y))
	if (max_depth > -2 or max_depth < -120): return
	var depth: float = randf_range(max(-5, max_depth), max(-100, max_depth))
	var m := mine.instantiate()
	m.depth = depth
	m.position = p
	m.add_to_group("Enemies")
	$"..".add_child(m)
	
	
	
