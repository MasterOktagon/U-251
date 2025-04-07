extends Label

func _process(_delta: float) -> void:
	text = str($"../../Player".global_position)
