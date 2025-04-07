extends Node2D

var height_min: float = -255
var height_max: float = 0
var sea_level: float = -42.01
var heightmap: PackedByteArray = preload("res://assets/heightmap/VirginLands.png").get_image().get_data()
var map_size: Vector2i = Vector2i(4096, 4096)
var map_scale: int = 0
const DELETE_RADIUS: float = 2000

func _ready() -> void:
	#heightmap = preload("res://assets/heightmap/test2.png").get_image().get_data()
	#print(heightmap)
	#map_size = Vector2i(10,20)
	#print(check_depth(0,0))
	#print(check_depth(10,0))
	#print(check_depth(0,20))
	#print(check_depth(10,20))
	
	map_scale = int($"../../Terrain".material.get_shader_parameter("map_scale"))
	map_size = $"../../Terrain".material.get_shader_parameter("map").get_size()
	heightmap = $"../../Terrain".material.get_shader_parameter("map").get_image().get_data()
	$"../../Terrain".material.set_shader_parameter("sealevel", sea_level)
	$"../../Terrain".material.set_shader_parameter("heightmin", height_min)
	$"../../Terrain".material.set_shader_parameter("heightmax", height_max)

func _process(_delta: float) -> void:
	update_enemies()

func update_enemies()->void:
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (global_position - e.position).length() > DELETE_RADIUS:
			e.queue_free()

func check_depth(x: int, y: int) -> float:
	var on_map: Vector2i = abs(Vector2i(x,y))
	on_map /= map_scale
	on_map.x = clamp(on_map.x, 0, map_size.x-1)
	on_map.y = clamp(on_map.y, 0, map_size.y-1)
	var depth: float = height_min + (height_max-height_min)*heightmap[(on_map.y*map_size.x+on_map.x)*3]/255.
	#print(height_min + (height_max-height_min)*heightmap[(on_map.y*map_size.x+on_map.x)*3]/255.)
	return depth-sea_level
