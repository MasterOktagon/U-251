extends Area2D
class_name Enemy

enum States{
	ALIVE,
	ALERTED,
	DEAD,
	DEFAULT
}
var state: States = States.ALIVE
var blib: TextureRect = TextureRect.new()

var depth: float = 0
var dmg: float = 0

var target_pos:= Vector2(0,0)
var target_vel:= Vector2(0,0)
var target_depth: float = 0

func update_target_pos() -> void:
	target_pos = $"../Player".global_position

func update_target_vel() -> void:
	target_vel = $"../Player".get_velocity()

func update_target_depth() -> void:
	target_depth = $"../Player".depth
