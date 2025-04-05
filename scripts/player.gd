extends Node2D

signal health_changed(val: float)
signal max_health_changed(val: float)

enum States{
	ALIVE,
	DEAD,
	DEFAULT
}
var state: States = States.ALIVE

var max_health: float = 100
var health: float = 0

var max_speed: float = 2
var speed: float = 0
var rotation_speed: float = 0.3

var depth: float = 0

var noisemaker_cd: float = 2
var noisemaker_reload: float = 30

func _ready() -> void:
	health = max_health
	speed = 0

func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	if state == States.DEAD:
		return
	
	if Input.is_key_pressed(KEY_W):
		speed = move_toward(speed, max_speed, 0.01)
		
	if Input.is_key_pressed(KEY_S):
		speed = move_toward(speed, -max_speed, 0.01)
		
	if not (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S)):
		speed = move_toward(speed, 0.0, 0.01)
		
	if Input.is_key_pressed(KEY_A):
		speed = move_toward(speed, 0.0, 0.005)
		rotation -= delta*rotation_speed*speed
		
	if Input.is_key_pressed(KEY_D):
		speed = move_toward(speed, 0.0, 0.005)
		rotation += delta*rotation_speed*speed
	
	if Input.is_key_pressed(KEY_PAGEUP):
		$MainCamera.zoom = clamp($MainCamera.zoom*0.99,Vector2(0.5,0.5), Vector2(2,2))
	
	if Input.is_key_pressed(KEY_PAGEDOWN):
		$MainCamera.zoom = clamp($MainCamera.zoom*1.01,Vector2(0.5,0.5), Vector2(2,2))
	
	if Input.is_key_pressed(KEY_Q):
		depth = move_toward(depth, 0, 1)
	
	if Input.is_key_pressed(KEY_E):
		depth = move_toward(depth, -150, 1)
	
	#print(speed)
	move_local_y(-speed)

func change_health(amount: float):
	health += amount
	if health <= 0:
		state = States.DEAD
		health = 0
	if health > max_health:
		health = max_health
	health_changed.emit(health)

func change_max_health(amount: float):
	max_health += amount
	if max_health <= 0:
		state = States.DEAD
	max_health_changed.emit(max_health)
