extends Node2D

var race_stat = "on course"
onready var number_of_laps = 1
export (bool) var free_mode = false
onready var players = Array()

signal update_stats(laps, position, speed, rpm, gear)
signal update_finish_race(visible, msg)

func _ready():
	number_of_laps = Global.laps
	_set_players_list()
	for player in players:
		if !player.bot:
			player.car.automatic = Global.is_auto_transmission
		player.curve_points = _set_player_curve_points()
	emit_signal("update_finish_race", false, "")
	if free_mode:
		print("(Main) Free mode!")

func _set_players_list():
	"""
	Esta obtención la saqué de aquí:
		"https://godotengine.org/qa/55185/easy-way-to-get-certain-type-of-children"
	"""
	players = get_tree().get_nodes_in_group("players")

func _set_player_curve_points():
	var array = Array()
	for i in range($Terrain/Lap.curve.get_point_count()):
		array.append($Terrain/Lap.curve.get_point_position(i))
	
	return array

func _process(_delta):
	var actual_speed = $Player/Car.get_speed()
	emit_signal("update_stats",
				str($Player.current_lap),
				str(0), str(actual_speed),
				str($Player/Car.get_current_rpm()),
				str($Player/Car.get_actual_gear()))
	if race_stat != "finished" and !free_mode:
		_check_lap_state()
		_check_positions()

func _check_lap_state():
	if($Player.current_lap == number_of_laps):
		"""
		Nota message:
			De momento va a tener este mensaje, la idea es cambiarlo 
			una vez tenga hecho lo de las posiciones
		"""
		var message = "You finished!"
		emit_signal("update_finish_race", true, str(message))
		race_stat = "finished"
		yield(get_tree().create_timer(3.0), "timeout")
		_exit_level()

func _check_positions():
	
	pass

func _exit_level():
	$Player.queue_free()
	$Terrain.queue_free()
	$"Control UI".queue_free()
	$".".queue_free()
	print("(Main) change scene to Menu")
	Global.check_change_scene_status(get_tree().change_scene("res://scenes/Menu.tscn"))
