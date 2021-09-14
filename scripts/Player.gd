extends Node2D

export (bool) var bot = false
onready var _input_manager
onready var car = $Car
var current_point = Vector2()
var curve_points = Array()
var current_point_in = 0
var current_lap = 0


func _ready():
	set_process(true)
	if !bot:
		_input_manager = $InputManager
		_input_manager.car = $Car
	if bot:
		$Camera2D.current = false
		if !$Car/Engine.is_on:
			$Car/Engine.is_on = true

func _process(_delta):
	if !bot and _input_manager:
		_input_manager.handle_inputs()
	if bot or $Car.automatic:
		handle_gears()
	if(curve_points != null and curve_points.size() > 0):
		_handle_current_point()
		if bot:
			turn_towards_target()

func _handle_current_point():
	current_point = curve_points[current_point_in]
	#current_point = get_viewport().get_mouse_position()
	var proximity = current_point - $Car.get_global_position()
	if(proximity.length() < 500):
		if(current_point_in == curve_points.size() - 1):
			current_point_in = 0
			current_lap += 1
			#print("(Player) changed lap to: ", current_lap)
		else:
			current_point_in += 1
		current_point = curve_points[current_point_in]
		#print("(Player) changed point to: index ", current_point_in)
		#print("(Player) current point: ", current_point)

func turn_towards_target():
	#var angle_to_target = $Car.position.angle_to(current_point)
	var angle_to_target = (current_point - $Car.global_position).normalized().angle()
	#print("(Player) angle_to_target: ", angle_to_target)
	$Car.rotation = lerp_angle($Car.rotation, angle_to_target, 0.3)
	go_towards_target(angle_to_target)
	"""var turn = clamp(angle_to_target, -1.0, 1.0)
	if turn > 0.1:
		$Car.steer_right = true
		$Car.steer_left = false
		$Car.handle_rotation_dir(turn)
	elif turn < -0.1:
		$Car.steer_right = false
		$Car.steer_left = true
		$Car.handle_rotation_dir(turn)
	else:
		$Car.steer_right = false
		$Car.steer_left = false"""
	
func go_towards_target(angle_to_target):
	if(abs(angle_to_target) < 45):
		$Car.is_accelerating = true
	else:
		$Car.is_accelerating = false
	
	
func handle_gears():
	$Car.gear_up = false
	$Car.gear_down = false
	if($Car.get_actual_gear() == 1):
		$Car.gear_up = true
	else:
		if($Car.get_actual_rpm() >= 5500):
			$Car.gear_up = true
		elif($Car.get_speed() < $Car.top_speed_per_gear[$Car.get_actual_gear()-1]):
			$Car.gear_down = true
