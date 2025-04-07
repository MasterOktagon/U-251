class_name Vessel
extends Enemy

var speed: float = 0.3
var shot_cd: float = 4
var chopper_cd: float = 5
var exp_i: int = 0

func _ready() -> void:
	blib.texture = preload("res://assets/vessel/svp_warship.png")
	state = States.ALIVE
	type = Types.WAHRSHIP
	dmg = 20
	add_to_group("Vessels")

func _process(_delta: float) -> void:
	z_index = int(depth)
	if state == States.DEAD:
		return
	
	update_target_pos()
	update_target_vel()
	update_target_depth()
	detect_player()
	if state==States.ALERTED:
		var est_pos: Vector2 = target_pos + max_deviation_pos*uncertainty_diviation
		var est_vel: Vector2 = target_vel + max_deviation_vel*uncertainty_diviation
		var est_dist: float = (est_pos+est_vel - global_position).length()
		if (est_dist < 1200): attack(est_pos, est_vel, est_dist)
		if est_dist > 200 and (target_pos - position).length() < 1500: move_attack(est_pos, est_vel, est_dist)
	move_patrol()

func change_health(_amount: float) -> void:
	state = States.DEAD
	print("Warship killed!")
	#queue_free()

func detect_player() -> void:
	var dist_diff: float = (target_pos-global_position).length()
	var depth_diff: float = abs(depth-target_depth)*10
	var dist_certainty: float = 1- clamp(remap(dist_diff, 100, 1000, 0, 1), 0, 1)
	var depth_certainty: float = 1- clamp(remap(depth_diff, 10, 200,  0, 1), 0, 1)
	var sound_certainty: float = remap(target_vel.length(), 0, 1.8, 0.3, 1)
	var cert: float = clamp((dist_certainty+depth_certainty+sound_certainty)/2, 0, 1.5)
	if (cert)>0.5:
		if cert>certainty:
			certainty = cert
		get_tree().call_group("Enemies","alert", certainty)
	else:
		$AlertLabel.hide()
		state = States.ALIVE

func attack(est_pos:Vector2, est_vel:Vector2, est_dist: float) -> void:
	if $ShotCooldown.time_left == 0.0:
		var shot: Enemy = preload("res://scenes/torpedo_enemy.tscn").instantiate()
		get_parent().add_child(shot)
		shot.dmg = dmg
		shot.global_transform.origin = self.global_transform.origin
		shot.depth = 0
		var shot_dir: Vector2 = ((est_pos+est_vel*est_dist/shot.max_speed)-shot.global_position).normalized()
		shot.look_at(global_position+shot_dir)
		shot.target_depth = target_depth
		$ShotCooldown.start(shot_cd)
		Vector2(0,0).normalized()
	
	# if chopper is back and alert ships send chopper after cd

func move_patrol() -> void:
	pass

func move_attack(est_pos:Vector2, est_vel:Vector2, est_dist: float) -> void:
	var dir: Vector2 = ((est_pos+est_vel*est_dist/speed)-global_position).normalized()
	var angle: float = dir.angle_to(Vector2.from_angle(self.rotation+PI))
	self.global_rotation = move_toward(self.global_rotation, self.global_rotation+angle, 0.01)
	move_local_x(speed)
	var bow_pos = self.global_position + Vector2($Sprite2D.get_rect().size.x/2,$Sprite2D.get_rect().size.x/2)*Vector2.from_angle(self.global_rotation)*sign(speed)
	if $"../Map".check_depth(bow_pos.x, bow_pos.y)>=0:
		move_local_x(-speed)
		state = States.ALIVE
	
	if type == Types.SUBMARINE:
		depth = move_toward(depth, target_depth, 0.2)

func alert(cert: float) -> void:
	state = States.ALERTED
	uncertainty_diviation = Vector2((1-cert)*randf_range(-1,1), (1-cert)*randf_range(-1,1))
	#print(uncertainty_diviation)
	$AlertLabel.show()
	
func _on_explosion_timeout() -> void:
	if state == States.DEAD:
		$AlertLabel.hide()
		if exp_i < 25:
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
