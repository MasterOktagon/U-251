extends RefCounted
class_name Level

var height_min: float = -255
var height_max: float = 0
var sea_level: float = -220
var map_resource: String = "res://assets/heightmap/VirginLands.png"
var heightmap: PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()
var map_size: Vector2i = Vector2i(4096, 4096)
var map_scale: int = 0
var delete_radius: float = 8000
var start_pos := Vector2(0,0)
var start_rot: float = 0
var checkpoint_pos: Array[Vector2] = []
var checkpoint_names : Array[String] = []
var checkpoints: Array[Sprite2D] = []
var depth_scale = 1

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
	
func load_skagerrak():
	height_min = -255
	height_max = 0
	sea_level = -155.
	map_resource = "res://assets/heightmap/skagerrak.png"
	heightmap = preload("res://assets/heightmap/skagerrak.png").get_image().get_data()
	map_size = Vector2i(3636, 3636)
	map_scale = 15
	start_pos = Vector2i(1450, 2816)
	start_rot = 0*PI
	checkpoint_pos = [Vector2(1500,2800), Vector2(1550,2610), Vector2(1506,2348), Vector2(1710,1616), Vector2(1534, 709)]
	checkpoint_names = ["Kieler Bay", "Fehmarnsund", "Nakskov", "Kattegat", "Skagerrak"]
	depth_scale = 3

func load_channel():
	height_min = -255
	height_max = 0
	sea_level = -78.
	map_resource = "res://assets/heightmap/channel.png"
	heightmap = preload("res://assets/heightmap/channel.png").get_image().get_data()
	map_size = Vector2i(3636, 3636)
	map_scale = 10
	start_pos = Vector2i(3240, 1200)
	start_rot = -0.5*PI
	checkpoint_pos = [Vector2(2450,2500), Vector2(1154,3150), Vector2(1720,280), Vector2(520,3500), Vector2(107, 1440)]
	checkpoint_names = ["English Channel", "Celtic Sea", "Orkney Islands", "Atlantic", "Atlantic"]
	depth_scale = 6
