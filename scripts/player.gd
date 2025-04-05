extends Node2D

enum States{
	ALIVE,
	DEAD,
	DEFAULT
}
var state: States = States.ALIVE

var max_health: float = 100
var health: float = 0

var max_speed: float = 10
var speed: float = 0
var rotation_speed: float = 0.5

var player_rotation := Vector2(0,0)

func _ready() -> void:
	health = max_health
	player_rotation.limit_length(1.0)

func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	if health <= 0.0:
		state = States.DEAD
		queue_free()
	
	if Input.is_key_pressed(KEY_W):
		speed = move_toward(speed, max_speed, 0.1)
	if Input.is_key_pressed(KEY_S):
		speed = move_toward(speed, -max_speed, 0.1)
	if Input.is_key_pressed(KEY_A):
		rotation -= delta*rotation_speed
	if Input.is_key_pressed(KEY_D):
		rotation += delta*rotation_speed
	move_local_x(speed)
