extends Node2D

var aircraft := preload("res://scenes/aircraft_enemy.tscn")

var i : int = 0
var ppos: Vector2

func _ready() -> void:
	randomize()

func _on_player_move(ppos: Vector2):
	self.ppos = ppos

func _on_timer_timeout() -> void:
	var r: float = 2200 * sqrt(randf())
	var theta: float = randf() * 2 * PI
	var p := Vector2(ppos.x + r * cos(theta),ppos.y + r * sin(theta))
	
	var max_depth: float = $"../Player/Map".check_depth(int(p.x), int(p.y))
	if (max_depth > -15): return
	if $"../Player".depth < -80: return
	var m := aircraft.instantiate()
	m.position = p
	m.add_to_group("Enemies")
	$"..".add_child(m)
