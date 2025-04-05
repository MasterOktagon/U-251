extends Node2D

var heightmap : PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()

func _ready() -> void:
	print(heightmap.size())
	print(4096*2048*3)
	print(get_height(1024, 2048))
	
	
func get_height(x: int, y: int) -> int:
	return heightmap[(y*4096+x)*3]-150
