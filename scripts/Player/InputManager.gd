extends Node2D

var car
signal ignite_engine

func _ready():
	pass

func handle_inputs():
	handle_accelerate()
	car.is_breaking = Input.is_action_pressed("ui_down")
	car.steer_left = Input.is_action_pressed("ui_left")
	car.steer_right = Input.is_action_pressed("ui_right")
	car.gear_up = Input.is_action_pressed("ui_home")
	car.gear_down = Input.is_action_pressed("ui_end")
	car.is_handbreaking = Input.is_action_pressed("ui_select")
	if Input.is_action_just_pressed("ui_ignite"):
		emit_signal("ignite_engine")

func handle_accelerate():
	if car.engine.is_on:
		car.is_accelerating = Input.is_action_pressed("ui_up")
