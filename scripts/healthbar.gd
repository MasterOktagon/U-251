extends Control

func _ready():
	$ProgressBar.value = $ProgressBar.max_value


func update_health(health: float = 0):
	$ProgressBar.value = health

func update_max_health(max_health: float = 0):
	$ProgressBar.max_value = max_health
