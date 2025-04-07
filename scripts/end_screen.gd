extends Control


func _on_map_final_checkpoint(mission: Map.Missions) -> void:
	$"../../Postprocessing".hide()
	get_tree().paused = true
	$ColorRect.show()
	$CenterContainer.show()
	$"CenterContainer/VBoxContainer/Status".text = "SUCCESS"
	match mission:
		Map.Missions.DEFAULT:
			$"CenterContainer/VBoxContainer/Label".text = "SUCCESS"
		Map.Missions.SKAGERRAK:
			$"CenterContainer/VBoxContainer/Label".text = "You have succesfuly moved through Skagerrak,\nthe most dangerous section of your voyage,\nbut communications from Berlin have stopped.\n\nIts only the Crew, your ship\nand 1000s of kilometers of Water until antarctica"
		Map.Missions.SKAGERRAK:
			$"CenterContainer/VBoxContainer/Label".text = "You have succesfuly moved through Skagerrak,\nthe most dangerous section of your voyage,\nbut communications from Berlin have stopped.\n\nIts only the Crew, your ship\nand 1000s of kilometers of Water until antarctica"


func _on_player_died() -> void:
	$"../../Postprocessing".hide()
	get_tree().paused = true
	$ColorRect.show()
	$CenterContainer.show()
	$"CenterContainer/VBoxContainer/Status".text = "FAILURE"
	$"CenterContainer/VBoxContainer/Label".text = "How did we fail our emperor again?!"


func _on_button_pressed() -> void:
	var menu := preload("res://lore.tscn")
	Global.skip_menu = true
	get_tree().paused = false
	
	get_tree().change_scene_to_packed(menu)
