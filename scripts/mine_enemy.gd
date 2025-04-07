class_name Mine
extends Enemy

const IGNORE_LAYER: int = (1<<3) | (1<<4) | (1<<5) # ignoring player torpedos, enemies, enemy weapons
const TARGET_LAYER: int = (1<<1) | (1<<2) # hitting player, player diversion

func _ready() -> void:
	blib.texture = preload("res://assets/mine/icon_minefield.png")
	state = States.ALIVE
	type = Types.MINE
	#depth = -130
	z_index = int(depth)
	dmg = 50
	add_to_group("Mines")

func _process(_delta: float) -> void:
	if self.overlaps_body($"../Player"):
		_on_body_entered($"../Player")

func _on_body_entered(body: Node2D) -> void:
	if (body.collision_layer & IGNORE_LAYER):
		return
	elif body.collision_layer & TARGET_LAYER:
		if abs(body.depth - depth) > 5:
			return
		if body.has_method("change_health"):
			body.change_health(-dmg)
	state = States.DEAD
	queue_free()
