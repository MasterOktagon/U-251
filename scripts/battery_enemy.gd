class_name Battery
extends Enemy

var shot_cd: float = 8

func _ready() -> void:
	blib.texture = preload("res://assets/vessel/svp_warship.png")
	state = States.ALIVE
	type = Types.BATTERY
	dmg = 20
	z_index = 10

func _process(_delta: float) -> void:
	if state == States.DEAD:
		return
	
	update_target_pos()
	update_target_vel()
	update_target_depth()
	detect_player()
	if state==States.ALERTED:
		var est_pos: Vector2 = target_pos + target_pos*uncertainty_diviation
		#print("Est_pos",est_pos)
		var est_vel: Vector2 = target_vel + target_vel*uncertainty_diviation
		var est_dist: float = (est_pos+est_vel - self.global_position).length()
		if (est_dist < 1200): attack(est_pos, est_vel, est_dist)

func change_health(_amount: float) -> void:
	state = States.DEAD
	queue_free()

func detect_player() -> void:
	var dist_diff: float = (target_pos-global_position).length()
	var depth_diff: float = abs(depth-target_depth)*10
	var dist_certainty: float = 1- clamp(remap(dist_diff, 100, 1000, 0, 1), 0, 1)
	var depth_certainty: float = 1- clamp(remap(depth_diff, 10, -$"../Map".level.height_min,  0, 1), 0, 1)
	var sound_certainty: float = remap(target_vel.length(), 0, 1.8, 0.3, 1)
	var cert: float = clamp((dist_certainty+depth_certainty/10+sound_certainty)/2, 0, 1.5)
	if (cert)>0.5:
		if cert>certainty:
			certainty = cert
		get_tree().call_group("Enemies","alert", certainty)
	else:
		$AlertLabel.hide()
		state = States.ALIVE

func attack(est_pos:Vector2, est_vel:Vector2, est_dist: float) -> void:
	if $ShotCooldown.time_left == 0.0:
		var shot: Enemy = preload("res://scenes/bomb_enemy.tscn").instantiate()
		get_parent().add_child(shot)
		shot.dmg = dmg
		shot.global_position = self.global_position
		var shot_dir: Vector2 = ((est_pos+est_vel*est_dist/shot.speed)-shot.global_position).normalized()
		shot.look_at(shot.global_position+shot_dir)
		shot.target_pos = ((est_pos+est_vel*est_dist/shot.speed))
		if (shot.target_pos-self.global_position).length()>4000:
			shot.queue_free()
			return
		$ShotCooldown.start(shot_cd)

func alert(cert: float) -> void:
	state = States.ALERTED
	uncertainty_diviation = 5*Vector2((1-cert)*randf_range(-1,1), (1-cert)*randf_range(-1,1))/$"../Map".level.map_size.x/$"../Map".level.map_scale
	#print(uncertainty_diviation)
	$AlertLabel.show()
