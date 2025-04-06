extends Node2D

var heightmap : PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()

func _ready() -> void:
	#print(heightmap.size())
	#print(4096*2048*3)
	#print(check_depth(1024, 2048))
	pass

func check_depth(x: int, y: int) -> int:
	if 0 <= x and x < 4096 and 0 <= y and y < 4096:
		return heightmap[(y*4096+x)*3]-150
	return -150
