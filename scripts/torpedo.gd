extends Area2D

var speed: float = 3
var dmg: float = 20
var lifetime: float = 10

var hit := false

func _ready() -> void:
	$LifeTimer.start(lifetime)

func _physics_process(delta: float) -> void:
	if $LifeTimer.time_left == 0:
		queue_free()
	if hit:
		return
	move_local_x(speed)
