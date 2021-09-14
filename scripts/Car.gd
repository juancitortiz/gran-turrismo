"""
	Tuve ayuda y fue de aquí:
		"https://www.youtube.com/watch?v=mJ1ZfGDTMCY"
		"http://kidscancode.org/godot_recipes/2d/car_steering/"
"""

extends KinematicBody2D

onready var engine = $Engine
onready var transmission = $Transmission
onready var wheels = [$Wheels/WheelFrontLeft, $Wheels/WheelFrontRigth,
					  $Wheels/WheelBackLeft, $Wheels/WheelBackRigth]

var road_map = Array()

export (bool) var automatic = true
export (int) var steer_angle = 30
export (float) var steer_sensivity = 0.5
export (int) var wheel_base = 50
export (int) var batalla = 70
export (float) var friction = -0.7
export (float) var drift_factor = 0.98
var max_speed_reverse = 250
var slip_speed = 90
var slow_speed = 15
export (float) var traction_fast = 0.1
export (float) var traction_slow = 0.7
export (float) var traction_very_slow = 0.9

"""
Acerca de:
	Estos valores los obtuve de este calculador online
	"https://www.boosttown.com/gearbox_differential/speed_calculator.php"
"""
var top_speed_per_gear = [-60.58, 0.0, 60.58, 90.87, 121.16, 181.74, 242.32, 363.47]

var acceleration = Vector2()
var velocity = Vector2()
export (float) var mass = 1200
var rotation_dir
var wheels_acceleration = 0.0

var is_accelerating:bool = false
var is_breaking:bool = false
var is_handbreaking:bool = false
var steer_left:bool = false
var steer_right:bool = false
var gear_up:bool = false
var gear_down:bool = false
var ignite_engine:bool = false

"""
Para Ackermann:
	
	var rear_wheel_left = Vector2()
	var rear_wheel_right = Vector2()
	var front_wheel_left = Vector2()
	var front_wheel_right = Vector2()
	var ackermann_rotation_dir_left = 0.0
	var ackermann_rotation_dir_right = 0.0
		
	Dentro de steering:
		rear_wheel_left = position - (transform.x * wheel_base/2.0 - transform.y * batalla/2.0)
		rear_wheel_right = position - (transform.x * wheel_base/2.0 + transform.y * batalla/2.0)
		front_wheel_left = position + (transform.x * wheel_base/2.0 - transform.y * batalla/2.0)
		front_wheel_right = position + (transform.x * wheel_base/2.0 + transform.y * batalla/2.0)
		
		if(rotation_dir > 0):
			ackermann_rotation_dir_left = rad2deg( atan(batalla / (steer_angle + wheel_base/2.0)) * rotation_dir )
			ackermann_rotation_dir_right = rad2deg( atan(batalla / (steer_angle + wheel_base/2.0)) * rotation_dir)
		elif(rotation_dir < 0):
			ackermann_rotation_dir_left = rad2deg( atan(batalla / (steer_angle + wheel_base/2.0)) * rotation_dir)
			ackermann_rotation_dir_right = rad2deg( atan(batalla / (steer_angle + wheel_base/2.0)) * rotation_dir)
		else:
			ackermann_rotation_dir_left = 0.0
			ackermann_rotation_dir_right = 0.0
"""

func _ready():
	transmission.wheels = wheels
	wheels[0].position = position + (transform.x * batalla/2.0 - transform.y * wheel_base/2.0)
	wheels[1].position = position + (transform.x * batalla/2.0 + transform.y * wheel_base/2.0)
	wheels[2].position = position - (transform.x * batalla/2.0 + transform.y * wheel_base/2.0)
	wheels[3].position = position - (transform.x * batalla/2.0 - transform.y * wheel_base/2.0)
	
func _physics_process(delta):
	acceleration = Vector2()
	handle_actions()
	#velocity += mass * acceleration * delta
	if(wheels.size() > 0):
		wheels_acceleration = (wheels[0].wheel_acceleration + wheels[1].wheel_acceleration) * 2
		if get_actual_gear() == 0:
			acceleration = (wheels_acceleration * transform.x) * (transmission.gear_ratio.size() / 2)
			if (get_speed() < abs(top_speed_per_gear[get_actual_gear()])):
				velocity += acceleration * delta
		else:
			acceleration = (wheels_acceleration * transform.x) * (transmission.gear_ratio.size() / (get_actual_gear()))
			if (get_speed() < top_speed_per_gear[get_actual_gear()]):
				velocity += acceleration * delta
	if(!is_accelerating):
		if(velocity.length() < 10):
			velocity = Vector2.ZERO
		velocity = velocity.linear_interpolate(Vector2.ZERO, 0.0005)
	kill_orthogonal_velocity()
	calculate_steering(delta)
	velocity = move_and_slide(velocity)
	#print(velocity.length())

func handle_actions():
	handle_steer()
	transmission.gear_up(gear_up)
	transmission.gear_down(gear_down)
	if(engine.is_on):
		transmission.is_clutch_connected = is_accelerating
		engine.handle_accelerate(is_accelerating)
	handle_break()
	handle_handbreak()

func handle_steer():
	var turn = 0
	if(steer_left):
		turn = lerp(turn, -1.0, steer_sensivity)
		#turn = -1
	if(steer_right):
		turn = lerp(turn, 1.0, steer_sensivity)
		#turn = 1
	handle_rotation_dir(turn)
		
func handle_rotation_dir(turn):	
	if(get_speed() < slip_speed):
		rotation_dir = turn * deg2rad(steer_angle)
	else:
		rotation_dir = turn * deg2rad(steer_angle * 0.6)

func handle_break():
	if(is_breaking):
		velocity = velocity.linear_interpolate(Vector2.ZERO, 0.03)
		
func handle_handbreak():
	if(is_handbreaking):
		velocity = velocity.linear_interpolate(Vector2.ZERO, 0.05)

func get_current_rpm():
	if engine.actual_rpm == 0:
		return 0
	else:
		return engine.actual_rpm

func calculate_steering(delta):
	var rear_wheel = position - (transform.x * wheel_base/2.0)
	var front_wheel = position + (transform.x * wheel_base/2.0)
	
	front_wheel += velocity.rotated(rotation_dir) * delta
	rear_wheel += velocity * delta
	wheels[0].rotation_degrees = rad2deg(rotation_dir) + 90
	wheels[1].rotation_degrees = rad2deg(rotation_dir) + 90
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if(velocity.length() > slip_speed):
		traction = traction_fast
	elif(velocity.length() < slow_speed and velocity.length() > 0):
		traction = traction_very_slow
	
	if get_actual_gear() > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	else:
		velocity = velocity.linear_interpolate(-new_heading * velocity.length(), traction)
	rotation = new_heading.angle()
	
"""
Acerca de esta funcion, la info la saque de aqui:
	"https://youtu.be/DVHcOS1E5OQ?list=PLyDa4NP_nvPfmvbC-eqyzdhOXeCyhToko&t=648"
"""
func kill_orthogonal_velocity():
	var forward_velocity = transform.x * transform.x.dot(velocity)
	var right_velocity = transform.y * transform.y.dot(velocity)
	
	velocity = forward_velocity + right_velocity * drift_factor
	
func get_actual_gear():
	return transmission.actual_gear
	
func get_actual_rpm():
	return engine.actual_rpm

func get_speed():
	"""
	La cuenta es la siguiente:
		En Godot, Vector2.length() es la magnitud. La magnitud (en metros) * 3.6
		me da 1km/h. Porque el tamaño de cada cuadro de la grilla es de 128, y
		el auto tiene aprox 128 pixeles de largo, y estimo que tendría un largo
		de 3 metros, por regla de 3 me da que para obtener 1 metro aqui, lo debo
		multiplicar por 0.023. Los resultados son convincentes.
		si 		128 -> 3
		entonces 1 -> x
		
		x = (1*3) / 128
		
		En el siguiente articulo de Wikipedia sale la tabla comparativa donde
		dice que 1m/s equivale a 3.6km/h
		Creo que en Godot pasa lo mismo que en Unity, la magnitud del Vector
		esta en m/s
		"https://es.wikipedia.org/wiki/Metro_por_segundo"
	"""
	return stepify(velocity.length() * 0.023 * 3.6, 0.01)

func _on_InputManager_ignite_engine():
	engine.is_on = !engine.is_on
