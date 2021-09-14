extends CanvasLayer


func _ready():
	pass

func _input(event):
	if (Input.is_action_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			$PausePopup.show()
		elif !get_tree().paused:
			$PausePopup.hide()
