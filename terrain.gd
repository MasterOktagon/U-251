@tool
extends Sprite2D



func _process(delta: float) -> void:
	scale = get_viewport_rect().size * 2.1
	#scale = scale / $"../Player/MainCamera".zoom
	position = $"../Player".position
	material.set_shader_parameter("offset", position + Vector2(1024, 2024))
	material.set_shader_parameter("size", scale)
	material.set_shader_parameter("zoom", $"../Player/MainCamera".zoom)
	
