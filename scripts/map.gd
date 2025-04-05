extends Node2D

var heightmap : PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()

func _ready() -> void:
	#print(heightmap.size())
	#print(4096*2048*3)
	#print(check_depth(1024, 2048))
	pass

func check_depth(x: int, y: int) -> int:
	#return -150
	return heightmap[(y*4095+x)*3]-150
