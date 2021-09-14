extends Control

onready var laps_input = $VBoxContainer/HBoxContainerLaps/LapsInput
onready var name_input = $VBoxContainer/HBoxContainerName/NameInput
onready var trans_type_input = $VBoxContainer/HBoxContainerTrans/TransmissionInput

func _ready():
	laps_input.value = Global.laps
	name_input.text = Global.player_name
	if trans_type_input:
		trans_type_input.pressed = Global.is_auto_transmission


func _on_Button_pressed():
	if laps_input.value == null:
		laps_input.value = 0
	Global.laps = laps_input.value
	Global.player_name = name_input.text
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/Menu.tscn"))

func _on_BackBtn_pressed():
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/Menu.tscn"))

func _on_PlayBtn_pressed():
	if laps_input.value == null:
		laps_input.value = 0
	Global.laps = laps_input.value
	Global.player_name = name_input.text
	Global.is_auto_transmission = trans_type_input.pressed
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/Main.tscn"))
