extends CanvasLayer


func _ready():
	pass

func _input(_event):
	if (Input.is_action_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			$PausePopup.show()
		elif !get_tree().paused:
			$PausePopup.hide()


func _on_ContinueBtn_pressed():
	print("(ControlUI) Continue")
	get_tree().paused = !get_tree().paused
	$PausePopup.hide()


func _on_OptionsBtn_pressed():
	print("(ControlUI) Options")
	pass # Replace with function body.


func _on_ExitBtn_pressed():
	print("(ControlUI) Exit Menu")
	get_tree().paused = !get_tree().paused
	get_tree().change_scene("res://scenes/Menu.tscn")
