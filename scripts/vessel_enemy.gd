extends Enemy

var speed: float = 2
var shot_cd: float = 2

func _ready() -> void:
	blib.texture = preload("res://assets/vessel/svp_warship.png")
	dmg = 20

func _process(delta: float) -> void:
	z_index = int(depth)
	if state == States.DEAD:
		return
	
	update_target_pos()
	update_target_vel()
	update_target_depth()
	detect_player()
	if state==States.ALERTED:
		attack()
	move()

func change_health(_amount: float) -> void:
	state = States.DEAD
	queue_free()

func detect_player() -> void:
	var dist_diff: float = (target_pos-global_position).length()
	var depth_diff: float = abs(depth-target_depth)*10
	var dist_certainty: float = 1- clamp(remap(dist_diff, 100, 1000, 0, 1), 0, 1)
	var depth_certainty: float = 1- clamp(remap(depth_diff, 10, 200,  0, 1), 0, 1)
	var sound_certainty: float = remap(target_vel.length(), 0, 1.8, 0.3, 1)
	var certainty: float = clamp((dist_certainty+depth_certainty+sound_certainty)/2, 0, 1.5)
	print(certainty)
	if (certainty)>0.5:
		get_tree().call_group("Enemies","alert", certainty)
	else:
		$AlertLabel.hide()
		state = States.ALIVE

func attack() -> void:
	if $ShotCooldown.time_left == 0.0:
		var shot: Enemy = preload("res://scenes/torpedo_enemy.tscn").instantiate()
		get_parent().add_child(shot,true)
		shot.dmg = dmg
		shot.global_transform.origin = self.global_transform.origin
		var est_pos: Vector2 = target_pos + target_pos*uncertainty_diviation
		var est_vel: Vector2 = target_vel + target_vel*uncertainty_diviation
		var distance: float = (est_pos+est_vel - shot.global_position).length()
		var shot_dir: Vector2 = ((est_pos+est_vel*distance/shot.speed)-shot.global_position).normalized()
		shot.look_at(global_position+shot_dir)
		shot.target_depth = target_depth
		$ShotCooldown.start(shot_cd)

func move() -> void:
	pass

func alert(certainty: float) -> void:
	state = States.ALERTED
	uncertainty_diviation = (1-certainty)*randf_range(-1,1)
	#print(uncertainty_diviation)
	$AlertLabel.show()
