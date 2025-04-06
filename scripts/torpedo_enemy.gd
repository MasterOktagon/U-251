extends Enemy

const IGNORE_LAYER: int = (1<<3) | (1<<4) | (1<<5) # ignoring player torpedos, enemies, enemy weapons
const TARGET_LAYER: int = (1<<0) | (1<<1) | (1<<2) # hitting world, player, player diversion

var speed: float = 1
var lifetime: float = 30
var max_speed: float = 5

func _ready() -> void:
	blib.texture = preload("res://assets/torpedo/svp_torpedo.png")
	state = States.ALIVE
	type = Types.TORPEDO
	$LifeTimer.start(lifetime)
	update_target_depth()
	print("Torpedo created at ", position, " | ", depth, " target ", target_depth)

func _physics_process(delta: float) -> void:
	update_target_pos()
	#update_target_depth()
	z_index = int(depth)
	if $LifeTimer.time_left == 0:
		state == States.DEAD
		queue_free()
	if state == States.DEAD:
		return
	depth = move_toward(depth, target_depth, max(0.07, min(1, abs(target_depth - depth) / 30))) # delta anpassen
	if (depth <= 0):
		speed = min(speed+0.02, max_speed)
		move_local_x(speed)
		if (target_pos-position).length() < 150:
			var test_rot  := position.angle_to_point(target_pos)
			rotation = rotate_toward(rotation, test_rot, 0.01)
	$Trail.emitting = depth <= 0

func _on_body_entered(body: Node2D) -> void:
	if (body.collision_layer & IGNORE_LAYER):
		return
	elif body.collision_layer & TARGET_LAYER:
		if abs(body.depth - depth) > 6:
			return
		if body.has_method("change_health"):
			body.change_health(-dmg)
			var explosion := preload("res://scenes/explosion.tscn").instantiate()
			explosion.position = position
			explosion.autoplay = "default"
			explosion.z_index = depth+3
			$"..".add_child(explosion)
	state = States.DEAD
	queue_free()
