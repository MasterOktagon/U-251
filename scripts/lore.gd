extends Control

var texts : Array[String] = [
	"The year is 1945.","The war has been lost.",
	"You have been tasked to transport\nthe imperial Gold treasure into safety,\nto a secret base in antarctica."
]

var current: int = 0
var idx: int = 0

func  _ready() -> void:
	pass

func _on_new_char_timeout() -> void:
	if idx == 3: return
	if current == 0:
		var l := Label.new()
		l.text = ""
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		$CenterContainer/VBoxContainer.add_child(l)
		$CenterContainer/VBoxContainer.move_child(l, len($CenterContainer/VBoxContainer.get_children())-2)
	
	if current < len(texts[idx]):
		var c := texts[idx][current]
		if (c == '\n'):
			var l := Label.new()
			l.text = ""
			l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			$CenterContainer/VBoxContainer.add_child(l)
			$CenterContainer/VBoxContainer.move_child(l, len($CenterContainer/VBoxContainer.get_children())-2)
		else:
			$CenterContainer/VBoxContainer.get_children()[len($CenterContainer/VBoxContainer.get_children())-2].text += c
	current += 1
	if current - 20 > len(texts[idx]):
		current = 0
		idx += 1


func _on_button_pressed() -> void:
	$CenterContainer.hide()
	$LevelSelection.show()
