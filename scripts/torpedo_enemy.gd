extends Enemy

const IGNORE_LAYER: int = (1<<3) | (1<<4) | (1<<5) # ignoring player torpedos, enemies, enemy weapons
const TARGET_LAYER: int = (1<<0) | (1<<1) | (1<<2) # hitting world, player, player diversion

var speed: float = 3
var dmg: float = 20
var lifetime: float = 10

func _ready() -> void:
	$LifeTimer.start(lifetime)

func _physics_process(delta: float) -> void:
	if $LifeTimer.time_left == 0:
		queue_free()
	if state == States.DEAD:
		return
	move_local_x(speed)

func _on_body_entered(body: Node2D) -> void:
	if (body.collision_layer & IGNORE_LAYER):
		return
	elif body.collision_layer & TARGET_LAYER:
		if body.get_parent().has_method("change_health"):
			body.get_parent().change_health(-dmg)
	state = States.DEAD
	queue_free()
