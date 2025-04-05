extends Enemy

var speed: float = 2
var depth: float = 0
var shot_cd: float = 2

func _process(delta: float) -> void:
	if state == States.DEAD:
		return
	
	update_target_pos()
	update_target_vel()
	attack()
	move()

func change_health(amount: float) -> void:
	state = States.DEAD
	queue_free()

func attack() -> void:
	if $ShotCooldown.time_left == 0.0:
		var shot: Enemy = preload("res://scenes/torpedo_enemy.tscn").instantiate()
		get_parent().add_child(shot,true)
		shot.dmg = dmg
		shot.global_transform.origin = self.global_transform.origin
		shot.transform.origin.distance_to(target_pos)
		var distance: float = (target_pos+target_vel - shot.global_position).length()
		$ShotCooldown.start(shot_cd)

func move() -> void:
	pass
