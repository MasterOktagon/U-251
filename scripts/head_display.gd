extends Control

func _on_depth_change(depth: float)->void:
	if abs(depth) < 2: $Label.text = "Surfaced"
	else: $Label.text = str(int(round(abs(depth*10)))) + " m"
