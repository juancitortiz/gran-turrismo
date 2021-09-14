extends Control

#var option_scene = preload()

func _ready():
	pass

func _on_StartBtn_pressed():
	print("(Menu) Start")
	# warning-ignore:return_value_discarded
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/StartOptions.tscn"))

func _on_OptionsBtn_pressed():
	print("(Menu) Options")
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/Options.tscn"))

func _on_ExitBtn_pressed():
	print("(Menu) Quit")
	Global.get_tree().quit()
