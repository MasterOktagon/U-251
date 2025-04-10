extends Control

var depth_max: float = 0

func _ready() -> void:
	depth_max = abs($"../../Map".level.height_min)

func _process(_delta: float) -> void:
	var pos: Vector2 = $"../../Player".position
	var depth: float = - ($"../../Map".check_depth(pos.x, pos.y))
	var p_depth: float = - $"../../Player".depth
	
	var rel_depth: float = depth/depth_max
	var patch_size: Vector2 = $Panel/NinePatchRect.size - Vector2(0, 100)
	var show_depth: float = rel_depth * (patch_size.y)
	
	$Panel/NinePatchRect/Depth.offset_top = show_depth
	$Panel/NinePatchRect/Depth.offset_bottom = show_depth+2
	
	$Panel/NinePatchRect/Waterline/Boat.offset_top = p_depth/depth_max * patch_size.y - 20
	$Panel/NinePatchRect/Waterline/Boat.offset_bottom = p_depth/depth_max * patch_size.y + 20
	$Panel/NinePatchRect/Depth/Label.text = str(abs(int(round(depth*10)))) + " m"
	for n: Node in $Panel/NinePatchRect/EnemiesNear.get_children():
		$Panel/NinePatchRect/EnemiesNear.remove_child(n)
	for e: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if (pos - e.position).length() <= 500:
			if (e.blib.texture == null): continue
			var height: float = e.depth
			#if e is Mine: height = e.depth*-1
			e.blib.offset_top = -(height/depth_max) * patch_size.y - e.blib.texture.get_size().y/2
			e.blib.offset_bottom = -(height/depth_max) * patch_size.y + e.blib.texture.get_size().y/2
			e.blib.offset_left = 50 + 20 * int(e is Mine)
			$Panel/NinePatchRect/EnemiesNear.add_child(e.blib)
	
