extends Enemy

const IGNORE_LAYER: int = (1<<3) | (1<<5) # ignoring player torpedos, enemy weapons
const TARGET_LAYER: int = (1<<0) | (1<<1) | (1<<2) | (1<<4) # hitting world, player, player diversion, enemies

var speed: float = 2

func _ready() -> void:
	blib.texture = preload("res://assets/torpedo/torpedo.png")
	state = States.ALIVE
	type = Types.BOMB
	z_index = 1
	$Trail.emitting = true


func _physics_process(_delta: float) -> void:
	if state == States.DEAD:
		return
	
	move_local_x(speed)
	if (target_pos-self.global_position).length()<5:
		for hits in self.get_overlapping_areas():
			if hits.has_method("change_health"):
				hits.change_health(-dmg)
		for hits in self.get_overlapping_bodies():
			if hits.has_method("change_health"):
				dmg = dmg + hits.depth
				hits.change_health(-dmg)

		var explosion := preload("res://scenes/explosion.tscn").instantiate()
		explosion.position = position
		explosion.autoplay = "default"
		explosion.z_index = depth+3
		$"..".add_child(explosion)
		state = States.DEAD
		queue_free()
		
