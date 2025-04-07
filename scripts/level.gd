extends RefCounted
class_name Level

var height_min: float = -255
var height_max: float = 0
var sea_level: float = -220
var map_resource: String = "res://assets/heightmap/VirginLands.png"
var heightmap: PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()
var map_size: Vector2i = Vector2i(4096, 4096)
var map_scale: int = 0
var delete_radius: float = 2000
var start_pos := Vector2(0,0)
var start_rot: float = 0
var checkpoints: Array[Vector2] = []

func load_VirginLands():
	height_min = -255
	height_max = 0
	sea_level = -220
	map_resource = "res://assets/heightmap/VirginLands.png"
	heightmap = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()
	map_size = Vector2i(4096, 4096)
	map_scale = 2
	start_pos = Vector2(500,500)
	start_rot = PI
	checkpoints = [Vector2(100,100), Vector2(200,200), Vector2(350,100)]

func load_atlantic():
	height_min = -255
	height_max = 0
	sea_level = -42.01
	map_resource = "res://assets/heightmap/atlantic.png"
	heightmap = preload("res://assets/heightmap/atlantic.png").get_image().get_data()
	map_size = Vector2i(6150, 6150)
	map_scale = 15
	start_pos = Vector2i(3700, 800)*map_scale
	start_rot = 0*PI
	checkpoints = [Vector2(100,100), Vector2(200,200), Vector2(350,100)]
