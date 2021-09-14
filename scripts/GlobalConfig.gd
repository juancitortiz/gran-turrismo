extends Node2D

var laps := 3
var player_name := "Player"
var is_auto_transmission = true

func _ready():
	pass

func check_change_scene_status(change_scene):
	return print("Error: change scene status: ", change_scene) if change_scene != OK else print("Change scene status ", change_scene)
