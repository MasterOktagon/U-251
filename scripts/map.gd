extends Node2D

var heightmap : PackedColorArray = []#PackedColorArray(preload("res://assets/heightmap/VirginLands.png").get_image().get_data())

func _ready() -> void:
	pass
	
	
func get_height(x: int, y: int) -> int:
	return heightmap[y*4096+x].r-150
