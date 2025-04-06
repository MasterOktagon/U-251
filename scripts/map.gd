extends Node2D

var heightmap : PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()
const DELETE_RADIUS: float = 2000;

func _ready() -> void:
	#print(heightmap.size())
	#print(4096*2048*3)
	#print(check_depth(1024, 2048))
	pass
func _process(delta: float) -> void:
	update_enemies()
	
func update_enemies()->void:
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (global_position - e.position).length() > DELETE_RADIUS:
			e.queue_free()

func check_depth(x: int, y: int) -> int:
	if 0 <= x and x < 4096 and 0 <= y and y < 4096:
		return heightmap[(y*4096+x)*3]-150
	return -150
