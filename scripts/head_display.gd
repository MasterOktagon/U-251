extends Control

func _on_depth_change(depth: float)->void:
	$Label.text = str(int(round(abs(depth*10)))) + " m"
