extends Control


func _process(_delta: float) -> void:
	var pos: Vector2 = $"../../Player".position
	var depth: float = abs($"../../Player/Map".check_depth(int(pos.x), int(pos.y)))
	var p_depth: float = abs($"../../Player".depth)
	
	var rel_depth: float = depth/150
	var patch_size: Vector2 = $Panel/NinePatchRect.size - Vector2(0, 60)
	var show_depth: float = rel_depth * (patch_size.y)
	
	$Panel/NinePatchRect/Depth.offset_top = show_depth
	$Panel/NinePatchRect/Depth.offset_bottom = show_depth+2
	
	$Panel/NinePatchRect/Waterline/Boat.offset_top = p_depth/150 * patch_size.y - 20
	$Panel/NinePatchRect/Waterline/Boat.offset_bottom = p_depth/150 * patch_size.y + 20
	$Panel/NinePatchRect/Depth/Label.text = str(int(round(depth*10))) + " m"
