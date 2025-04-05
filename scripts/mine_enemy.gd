extends Enemy

const IGNORE_LAYER: int = (1<<3) | (1<<4) | (1<<5) # ignoring player torpedos, enemies, enemy weapons
const TARGET_LAYER: int = (1<<1) | (1<<2) # hitting player, player diversion

func _ready() -> void:
	blib.texture = preload("res://assets/mine/icon_minefield.png")
	depth = -130

func _on_body_entered(body: Node2D) -> void:
	if (body.collision_layer & IGNORE_LAYER):
		return
	elif body.collision_layer & TARGET_LAYER:
		if abs(body.depth - depth) > 5:
			return
		if body.get_parent().has_method("change_health"):
			body.get_parent().change_health(-dmg)
	state = States.DEAD
	queue_free()
