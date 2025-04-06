extends Node2D

var vessel := preload("res://scenes/vessel_enemy.tscn")

var i : int = 0
var ppos: Vector2

func _ready() -> void:
	randomize()

func _on_player_move(ppos: Vector2):
	self.ppos = ppos

func _on_timer_timeout() -> void:
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if e is Vessel:
			i+=1
	if i >= 10: return

	var r: float = 1900 * sqrt(randf())
	var theta: float = randf() * 2 * PI
	var p := Vector2(ppos.x + r * cos(theta),ppos.y + r * sin(theta))
	
	var max_depth: float = $"../Player/Map".check_depth(int(p.x/100+2048), int(p.y/100+2048))
	if (max_depth > -15): return
	var m := vessel.instantiate()
	m.depth = 0
	m.position = p
	m.add_to_group("Enemies")
	$"..".add_child(m)
