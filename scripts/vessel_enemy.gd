extends Enemy

var speed: float = 2
var shot_cd: float = 2

func _ready() -> void:
	blib.texture = preload("res://assets/vessel/svp_warship.png")

func _process(delta: float) -> void:
	if state == States.DEAD:
		return
	
	update_target_pos()
	detect_player()
	if state==States.ALERTED:
		update_target_vel()
		update_target_depth()
		attack()
	move()

func change_health(amount: float) -> void:
	state = States.DEAD
	queue_free()

func detect_player() -> void:
	if (target_pos-global_position).length()<500:
		get_tree().call_group("Enemies","alert")
	else:
		state = States.ALIVE

func attack() -> void:
	if $ShotCooldown.time_left == 0.0:
		var shot: Enemy = preload("res://scenes/torpedo_enemy.tscn").instantiate()
		get_parent().add_child(shot,true)
		shot.dmg = dmg
		shot.global_transform.origin = self.global_transform.origin
		shot.transform.origin.distance_to(target_pos)
		var distance: float = (target_pos+target_vel - shot.global_position).length()
		var shot_dir: Vector2 = ((target_pos+target_vel*distance/shot.speed)-shot.global_position).normalized()
		shot.look_at(global_position+shot_dir)
		shot.target_depth = target_depth
		$ShotCooldown.start(shot_cd)

func move() -> void:
	pass

func alert() -> void:
	state = States.ALERTED
