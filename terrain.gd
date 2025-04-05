@tool
extends Sprite2D



func _process(delta: float) -> void:
	scale = get_viewport_rect().size * 1.1
	#scale = scale / $"../Player/MainCamera".zoom
	position = $"../Player".position
	material.set_shader_parameter("offset", position)
	material.set_shader_parameter("size", scale)
	material.set_shader_parameter("zoom", $"../Player/MainCamera".zoom)
	
