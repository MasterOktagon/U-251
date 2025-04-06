extends Node2D

signal health_changed(val: float)
signal max_health_changed(val: float)
signal depth_changed(depth: float)
signal air_changed(val: float)

enum States{
	ALIVE,
	DEAD,
	DEFAULT
}
var state: States = States.ALIVE

var max_health: float = 100
var health: float = 0

var max_air: float = 100
var air: float = 100

var max_speed: float = 2
var speed: float = 0
var rotation_speed: float = 0.3

var depth: float = 0

var noisemaker_cd: float = 2
var noisemaker_reload: float = 30

func _ready() -> void:
	health = max_health
	speed = 0
	max_health_changed.emit(max_health)
	health_changed.emit(health)
	#position = Vector2i(-500, -500)
	
func min_abs(a: float, b: float)->float:
	if abs(a) < abs(b): return a
	return b
	
func surfaced()->bool:
	return abs(depth) < 2

func _process(delta: float) -> void:
	#position.x = int(position.x + 1000*delta) % 100000
	#position.y = int(position.x + 1000*delta) % 100000
	#print(position)
	if state == States.DEAD:
		return
		
		
	if surfaced():
		air = min(air + 10*delta, max_air)
		z_index = 1
	else:
		z_index = round(depth)
		air = max(0, air - delta)
		if air == 0:
			change_health(-delta)
		# play "sound air pressure low"
	emit_signal("air_changed", air)
	
	var max_depth: int = $Map.check_depth(self.global_position.x/100+2048, self.global_position.y/100+2048)
	if Input.is_key_pressed(KEY_W):
		#if !(depth <= max_depth):
		speed = move_toward(speed, max_speed, 0.01)
		
	elif Input.is_key_pressed(KEY_S):
		#if !(depth <= max_depth):
		speed = move_toward(speed, -max_speed, 0.01)
		
	if not (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S)):
		speed = move_toward(speed, 0.0, 0.01)
		# if motionless add drift
		
	if Input.is_key_pressed(KEY_A):
		speed = move_toward(speed, 0.0, 0.005)
		rotation -= delta*rotation_speed*speed
		$DirectionSprite.rotation = min_abs($DirectionSprite.rotation - 0.5*delta, -1)
		
	elif Input.is_key_pressed(KEY_D):
		speed = move_toward(speed, 0.0, 0.005)
		rotation += delta*rotation_speed*speed
		$DirectionSprite.rotation = min_abs($DirectionSprite.rotation + 0.5*delta, 1)
	
	else:
		$DirectionSprite.rotation = $DirectionSprite.rotation * 0.7
	
	if Input.is_key_pressed(KEY_PAGEUP):
		$MainCamera.zoom = clamp($MainCamera.zoom*0.99,Vector2(0.5,0.5), Vector2(2,2))
	
	if Input.is_key_pressed(KEY_PAGEDOWN):
		$MainCamera.zoom = clamp($MainCamera.zoom*1.01,Vector2(0.5,0.5), Vector2(2,2))
	
	if depth<=max_depth:
		depth = max_depth
		# play sound "kiel auf grund"
		change_health(-0.2)
		depth = max_depth
	
	if Input.is_key_pressed(KEY_Q):
		depth = move_toward(depth, 0, 0.03)
		emit_signal("depth_changed", depth)
	
	if Input.is_key_pressed(KEY_E) and !(depth <= max_depth):
		depth = move_toward(depth, -150, 0.03)
		emit_signal("depth_changed", depth)
	
	#print(speed)
	move_local_y(-speed)

func change_health(amount: float) -> void:
	health += amount
	if health <= 0:
		state = States.DEAD
		health = 0
	if health > max_health:
		health = max_health
	print(health)
	health_changed.emit(health)

func change_max_health(amount: float) -> void:
	max_health += amount
	if max_health <= 0:
		state = States.DEAD
	max_health_changed.emit(max_health)

func get_velocity() -> Vector2:
	return Vector2.from_angle(self.rotation-PI/2)*speed
