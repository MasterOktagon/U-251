extends Node2D

signal health_changed(val: float)
signal max_health_changed(val: float)
signal depth_changed(depth: float)
signal air_changed(val: float)
signal moved(pos: Vector2)
signal died()

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

var time : float = 0.
var exp_i : int = 0

const invincible := false

func _ready() -> void:
	randomize()
	health = max_health
	speed = 0
	max_health_changed.emit(max_health)
	health_changed.emit(health)
	self.global_position = Vector2(0,0)
	depth_changed.emit(0)
	
func min_abs(a: float, b: float)->float:
	if abs(a) < abs(b): return a
	return b
	
func surfaced()->bool:
	return abs(depth) < 2

func _process(delta: float) -> void:
	time += delta
	if (time >= 2*PI): time -= 2*PI
	var sway_amp := 1.
	if (state != States.DEAD):
		$PlayerSprite.offset.x = sin(time) * 5 * sway_amp
		$PlayerSprite.offset.y = cos(time) * 7 * sway_amp
		$PlayerSprite.rotation = cos(time) * 0.05 * sway_amp
	$Trail.emitting = abs(speed) > 0
	
	z_index = round(depth)
	$AudioStreamPlayer.volume_db = remap(speed, 0, max_speed, -40, -4)
	
	if state == States.DEAD:
		speed = 0
		return
		
		
	if surfaced():
		air = min(air + 10*delta, max_air)
		z_index = 1
	else:
		air = max(0, air - delta)
		if air == 0:
			change_health(-delta)
		# play "sound air pressure low"
	emit_signal("air_changed", air)
	
	var max_depth: int = $"../Map".check_depth(self.global_position.x, self.global_position.y)
	
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
		
	elif Input.is_key_pressed(KEY_D):
		speed = move_toward(speed, 0.0, 0.005)
		rotation += delta*rotation_speed*speed
	
	if Input.is_key_pressed(KEY_PAGEUP):
		$MainCamera.zoom = clamp($MainCamera.zoom*0.99,Vector2(0.005,0.005), Vector2(2,2))
	
	if Input.is_key_pressed(KEY_PAGEDOWN):
		$MainCamera.zoom = clamp($MainCamera.zoom*1.01,Vector2(0.5,0.5), Vector2(2,2))
	
	#print("max_depth", max_depth)
	if depth<=max_depth:
		depth = max_depth
		# play sound "kiel auf grund"
		change_health(-0.2)
	
	if Input.is_key_pressed(KEY_Q):
		depth = move_toward(depth, 0, 0.03)
		emit_signal("depth_changed", depth)
	
	if Input.is_key_pressed(KEY_E) and !(depth <= max_depth):
		depth = move_toward(depth, -150, 0.03)
		emit_signal("depth_changed", depth)
		
	if Input.is_key_pressed(KEY_SPACE) and $NoisemakerCooldown.time_left == 0:
		var nm := preload("res://scenes/noise_maker.tscn").instantiate()
		nm.position = position
		$"..".add_child(nm)
		$NoisemakerCooldown.start()
	
	#print(depth)
	move_local_y(-speed)
	var bow_pos = self.global_position + Vector2(-$PlayerSprite.get_rect().size.y/2,-$PlayerSprite.get_rect().size.y/2)*Vector2.from_angle(self.global_rotation-PI/2)*sign(-speed)
	if $"../Map".check_depth(bow_pos.x, bow_pos.y)>=0:
		move_local_y(speed)
		speed = 0
		change_health(-10)
	if (abs(speed) > 0): emit_signal("moved", position)
	if depth > 0: depth = 0

func change_health(amount: float) -> void:
	if invincible:
		return
	health += amount
	if health <= 0:
		state = States.DEAD
		health = 0
	if health > max_health:
		health = max_health
	health_changed.emit(health)

func change_max_health(amount: float) -> void:
	max_health += amount
	if max_health <= 0:
		state = States.DEAD
	max_health_changed.emit(max_health)

func get_velocity() -> Vector2:
	return Vector2.from_angle(self.rotation-PI/2)*speed


func _on_explosion_timeout() -> void:
	if state == States.DEAD:
		if exp_i < 25:
			$DirectionSprite.hide()
			exp_i+=1
			var explosion := preload("res://scenes/explosion.tscn").instantiate()
			explosion.position = position + Vector2(randf_range(-7,7), randf_range(-45,45))
			explosion.autoplay = "default"
			explosion.z_index = depth+3
			$"..".add_child(explosion)
			modulate = modulate.darkened(0.05)
		else:
			depth = max(depth - 1, $"../Map".check_depth(self.global_position.x, self.global_position.y))
			if (depth <= max(-20, $"../Map".check_depth(self.global_position.x, self.global_position.y))):
				emit_signal("died")
