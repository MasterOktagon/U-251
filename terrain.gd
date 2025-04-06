extends Sprite2D

func _process(delta: float) -> void:
	var m := get_viewport_rect().size
	scale = Vector2(max(m.x,m.y), max(m.x,m.y)) * 2.1#/100
	#scale = scale / $"../Player/MainCamera".zoom
	var player_pos: Vector2 = $"../Player".global_position#/100
	var on_map: Vector2 = floor(abs(player_pos))
	on_map.x = clamp(on_map.x, 0, 4095)
	on_map.y = clamp(on_map.y, 0, 4095)
	#print((position/2. + Vector2(2048,2048) - scale/2.) / (4096. * 2.))
	#print(Vector2(max(m.x,m.y), max(m.x,m.y)))
	material.set_shader_parameter("offset", on_map)
	material.set_shader_parameter("size", scale)
	#material.set_shader_parameter("sizePx", Vector2(max(m.x,m.y), max(m.x,m.y)) * 2.1)
	material.set_shader_parameter("zoom", $"../Player/MainCamera".zoom)
	if Input.is_key_pressed(KEY_1):
		$"../Sprite2D".show()
	if Input.is_key_pressed(KEY_2):
		$"../Sprite2D".hide()
	if Input.is_key_pressed(KEY_UP):
		material.set_shader_parameter("sealevel", (material.get_shader_parameter("sealevel")+1))
		print(material.get_shader_parameter("sealevel"))
	if Input.is_key_pressed(KEY_DOWN):
		material.set_shader_parameter("sealevel", (material.get_shader_parameter("sealevel")-1))
		print(material.get_shader_parameter("sealevel"))
