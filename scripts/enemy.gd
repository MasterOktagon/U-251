extends Area2D
class_name Enemy

enum States{
	ALIVE,
	ALERTED,
	DEAD,
	DEFAULT
}
var state: States = States.DEFAULT

enum Types{
	MINE,
	TORPEDO,
	BOMB,
	SONARBOYE,
	PLANE,
	CHOPPER,
	WAHRSHIP,
	SUBMARINE,
	DEFAULT
}
var type: Types = Types.DEFAULT

var blib: TextureRect = TextureRect.new()

var depth: float = 0
var dmg: float = 0

var target_pos:= Vector2(0,0)
var target_vel:= Vector2(0,0)
var target_depth: float = 0
var certainty: float = 0
var uncertainty_diviation: Vector2 = Vector2(0,0)

func update_target_pos() -> void:
	for e: NoiseMaker in get_tree().get_nodes_in_group("NoiseMaker"):
		if e != null and (e.position-position).length() < 300:
			target_pos = e.position
			return
	target_pos = $"../Player".global_position

func update_target_vel() -> void:
	target_vel = $"../Player".get_velocity()

func update_target_depth() -> void:
	target_depth = $"../Player".depth
