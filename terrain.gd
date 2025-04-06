extends Sprite2D



func _process(delta: float) -> void:
	var m := get_viewport_rect().size
	scale = Vector2(max(m.x,m.y), max(m.x,m.y)) * 2.1
	#scale = scale / $"../Player/MainCamera".zoom
	position = $"../Player".position
	#print((position/2. + Vector2(2048,2048) - scale/2.) / (4096. * 2.))
	#print(Vector2(max(m.x,m.y), max(m.x,m.y)))
	material.set_shader_parameter("offset", position)
	material.set_shader_parameter("size", scale)
	#material.set_shader_parameter("sizePx", Vector2(max(m.x,m.y), max(m.x,m.y)) * 2.1)
	material.set_shader_parameter("zoom", $"../Player/MainCamera".zoom)
	
