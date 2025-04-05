extends Area2D
class_name Enemy

enum States{
	ALIVE,
	ALERTED,
	DEAD,
	DEFAULT
}
var state: States = States.ALIVE

var target_pos:= Vector2(0,0)
var target_vel:= Vector2(0,0)

func update_target_pos(pos: Vector2) -> void:
	target_pos = pos

func update_target_vel(vel: Vector2) -> void:
	target_vel = vel
