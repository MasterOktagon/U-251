class_name Aircraft
extends Enemy

var speed: float
var ammo: int = 3
var torpedo := preload("res://scenes/torpedo_enemy.tscn")

func _ready() -> void:
	state = States.ALIVE
	type = Types.PLANE
	look_at($"../Player".position)
	speed = 7
	depth = 20
	$Reload.start()

func _physics_process(delta: float) -> void:
	$Sprite2D.offset = to_local(global_position + Vector2(-50, 0))
	move_local_x(speed)
	if (ammo > -1): update_target_pos()

	var test_rot  := position.angle_to_point(target_pos)
	rotation = rotate_toward(rotation, test_rot, 0.05)
	
	if (position-target_pos).length() < 200 and ammo > 0 and position.angle_to_point(target_pos) < PI and $Reload.time_left == 0:
		var t := torpedo.instantiate()
		t.position = position
		t.depth = depth
		t.target_depth = target_depth
		t.rotation = rotation
		$"..".add_child(t)
		ammo -= 1
		$Reload.start()
	
	print("Plane: ",abs(rotation - test_rot) < PI)
	if (ammo == 0):
		var r: float = 1900 * sqrt(randf())
		var theta: float = randf() * 2 * PI
		var p := Vector2(target_pos.x + r * cos(theta),target_pos.y + r * sin(theta))
		
		target_pos = p
		ammo = -1
		
	elif (ammo == -1 and (position-target_pos).length() < 100):
		queue_free()
