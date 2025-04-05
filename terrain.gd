@tool
extends Sprite2D



func _process(delta: float) -> void:
	scale = get_viewport_rect().size
	position = $"../Player".position
	material.set_shader_parameter("offset", position)
	material.set_shader_parameter("size", scale)
