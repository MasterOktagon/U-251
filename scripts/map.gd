extends Node2D

var level: Level = Level.new()

func _ready() -> void:
	level.load_atlantic()
	
	# detting shader
	$Terrain.material.set_shader_parameter("map_scale", level.map_scale)
	$Terrain.material.set_shader_parameter("map", load(level.map_resource))
	$Terrain.material.set_shader_parameter("sealevel", level.sea_level)
	$Terrain.material.set_shader_parameter("heightmin", level.height_min)
	$Terrain.material.set_shader_parameter("heightmax", level.height_max)
	$Terrain.scale = level.map_size*level.map_scale
	
	# loading checkpoints

func _process(_delta: float) -> void:
	update_enemies()
	
	var player_pos: Vector2 = $"../Player".global_position
	var on_map: Vector2 = floor(abs(player_pos))
	on_map.x = clamp(on_map.x, 0, self.global_scale.x-1)
	on_map.y = clamp(on_map.y, 0, self.global_scale.y-1)
	$Terrain.material.set_shader_parameter("offset", on_map)
	$Terrain.material.set_shader_parameter("size", scale)

func update_enemies()->void:
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (global_position - e.position).length() > level.delete_radius:
			e.queue_free()

func check_depth(x: int, y: int) -> float:
	var on_map: Vector2i = abs(Vector2i(x,y))
	on_map /= level.map_scale
	on_map.x = clamp(on_map.x, 0, level.map_size.x-1)
	on_map.y = clamp(on_map.y, 0, level.map_size.y-1)
	var depth: float = level.height_min + (level.height_max-level.height_min)*level.heightmap[(on_map.y*level.map_size.x+on_map.x)*3]/255.
	return depth-level.sea_level
