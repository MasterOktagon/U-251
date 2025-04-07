extends AnimatedSprite2D

func _ready() -> void:
	randomize()
	$AudioStreamPlayer2D.stream = load("res://assets/sounds/WaterSurfaceExplosion0" + str(randi_range(1,8)) + ".ogg")
	$AudioStreamPlayer2D.play()

func _on_animation_finished() -> void:
	hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
