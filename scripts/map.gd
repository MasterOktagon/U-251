extends Node2D

var level: Level = Level.new()
var player_pos: Vector2

enum Missions{
	TEST,
	VIRGIN,
	ATLANTIC,
	DEFAULT
}

func _ready() -> void:
	load_level(Missions.ATLANTIC)

func load_level(mission: Missions = Missions.DEFAULT):
	match mission:
		Missions.VIRGIN:
			level.load_VirginLands()
		Missions.ATLANTIC:
			level.load_atlantic()
		var err:
			print("couldn´t load level: ", err)
	
	# setting shader
	$Terrain.material.set_shader_parameter("map_scale", level.map_scale)
	$Terrain.material.set_shader_parameter("map", load(level.map_resource))
	$Terrain.material.set_shader_parameter("sealevel", level.sea_level)
	$Terrain.material.set_shader_parameter("heightmin", level.height_min)
	$Terrain.material.set_shader_parameter("heightmax", level.height_max)
	$Terrain.scale = level.map_size*level.map_scale
	
	$"../Player".global_position = level.start_pos*level.map_scale
	
	# loading checkpoints
	for i in range(len(level.checkpoint_pos)):
		level.checkpoints.append(Sprite2D.new())
		level.checkpoints[i].global_position = level.checkpoint_pos[i]*level.map_scale
		level.checkpoints[i].texture = preload("res://assets/heightmap/test2.png")
		level.checkpoints[i].scale = level.checkpoints[i].texture.get_size()
		level.checkpoints[i].z_index = 0
		add_child(level.checkpoints[i])
		print(level.checkpoints[i])

func _process(_delta: float) -> void:
	player_pos = $"../Player".global_position
	var on_map: Vector2 = floor(abs(player_pos))
	update_enemies()
	
	on_map.x = clamp(on_map.x, 0, self.global_scale.x-1)
	on_map.y = clamp(on_map.y, 0, self.global_scale.y-1)
	$Terrain.material.set_shader_parameter("offset", on_map)
	$Terrain.material.set_shader_parameter("size", scale)
	
	# chechpoint check
	for i in range(len(level.checkpoints)):
		# direction arrow look at
		if abs((player_pos-level.checkpoints[i].global_position).length())<100:
			print("chechpoint reached: ", level.checkpoint_names[i])
			var del: Array[Sprite2D] = level.checkpoints.slice(0,i+1)
			level.checkpoints = level.checkpoints.slice(i+1,len(level.checkpoints))
			level.checkpoint_names = level.checkpoint_names.slice(i+1,len(level.checkpoint_names))
			for d in del:
				d.queue_free()
			break

func update_enemies()->void:
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (player_pos - e.position).length() > level.delete_radius:
			e.queue_free()

func check_depth(x: int, y: int) -> float:
	var on_map: Vector2i = abs(Vector2i(x,y))
	on_map /= level.map_scale
	on_map.x = clamp(on_map.x, 0, level.map_size.x-1)
	on_map.y = clamp(on_map.y, 0, level.map_size.y-1)
	var depth: float = level.height_min + (level.height_max-level.height_min)*level.heightmap[(on_map.y*level.map_size.x+on_map.x)*3]/255.
	return depth-level.sea_level
