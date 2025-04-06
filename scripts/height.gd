extends Control


func _process(_delta: float) -> void:
	var pos: Vector2 = $"../../Player".position
	var depth: float = -($"../../Player/Map".check_depth(int(pos.x/100+2048), int(pos.y/100+2048)))
	#print(depth)
	#print(int(pos.x/1+2048), "\t", int(pos.y/1+2048))
	var p_depth: float = abs($"../../Player".depth)
	
	var rel_depth: float = depth/150
	var patch_size: Vector2 = $Panel/NinePatchRect.size - Vector2(0, 100)
	var show_depth: float = rel_depth * (patch_size.y)
	
	$Panel/NinePatchRect/Depth.offset_top = show_depth
	$Panel/NinePatchRect/Depth.offset_bottom = show_depth+2
	
	$Panel/NinePatchRect/Waterline/Boat.offset_top = p_depth/150 * patch_size.y - 20
	$Panel/NinePatchRect/Waterline/Boat.offset_bottom = p_depth/150 * patch_size.y + 20
	$Panel/NinePatchRect/Depth/Label.text = str(int(round(depth*10))) + " m"
	
	for n: Node in $Panel/NinePatchRect/EnemiesNear.get_children():
		$Panel/NinePatchRect/EnemiesNear.remove_child(n)
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (pos - e.position).length() <= 500:
			e.blib.offset_top = abs(e.depth/150) * patch_size.y - 20
			e.blib.offset_bottom = abs(e.depth/150) * patch_size.y + 20
			e.blib.offset_left = 50
			$Panel/NinePatchRect/EnemiesNear.add_child(e.blib)
	
