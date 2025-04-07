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
var checkpoint_pos: Array[Vector2] = []
var checkpoint_names : Array[String] = []
var checkpoints: Array[Sprite2D] = []

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
	checkpoint_pos = [Vector2(100,100), Vector2(200,200), Vector2(350,100)]

func load_atlantic():
	height_min = -255
	height_max = 0
	sea_level = -42.01
	map_resource = "res://assets/heightmap/atlantic.png"
	heightmap = preload("res://assets/heightmap/atlantic.png").get_image().get_data()
	map_size = Vector2i(6150, 6150)
	map_scale = 15
	start_pos = Vector2i(3700, 800)
	start_rot = 0*PI
	checkpoint_pos = [Vector2(100,100), Vector2(3750,790), Vector2(350,100), Vector2(3249, 5815)]
	checkpoint_names = ["Ärmelkanal", "Skagerag", "Orkney", "Southpole base"]
