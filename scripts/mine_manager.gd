extends Node2D

var mine := preload("res://scenes/mine_enemy.tscn")
var noise := FastNoiseLite.new()

func _ready()->void:
	randomize()

func _on_player_move(ppos: Vector2):
	var i : int = 0;
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if e is Mine:
			i+=1
	if i >= 200: return
		
	var r: float = 1900 * sqrt(randf())
	var theta: float = randf() * 2 * PI
	var p := Vector2(ppos.x + r * cos(theta),ppos.y + r * sin(theta))
	
	var max_depth: float = $"../Player/Map".check_depth(int(p.x/100+2048), int(p.y/100+2048))
	if (max_depth > -15): return
	var depth: float = randf_range(-5, max(-100, max_depth - 10))
	var m := mine.instantiate()
	m.depth = depth
	m.position = p
	m.add_to_group("Enemies")
	$"..".add_child(m)
	
	
	
