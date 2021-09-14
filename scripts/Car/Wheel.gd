extends KinematicBody2D

var wheel_force = 0.0
var wheel_acceleration = 0.0
var wheel_desacceleration = 0.0
var friction_torque = 0.0
var velocity = Vector2()
export (float) var radius = 0.34
export (float) var weigth = 1.00
export (float) var friction_static = 0.6
export (float) var friction_kinematic = 0.4
var car_mass = 0


func _ready():
	car_mass = get_parent().get_parent().mass / 4
	friction_torque = car_mass * friction_static
	wheel_desacceleration = friction_torque / car_mass

func calculate_wheel_force(transmission_torque):
	wheel_force = (transmission_torque) / (2 * radius)
	wheel_force *= 100
	calculate_wheel_acceleration(transmission_torque)
	apply_friction()

func calculate_wheel_acceleration(transmission_torque):
	if abs(transmission_torque) <= 1.0:
		wheel_acceleration = lerp(wheel_acceleration, 0, friction_kinematic)
	else:
		wheel_acceleration = wheel_force / car_mass

func apply_friction():
	var friction_force = wheel_acceleration * friction_static
	if abs(wheel_acceleration) <= 1.0:
		wheel_acceleration = 0
	else:
		wheel_acceleration += friction_force

func apply_velocity(vel):
	velocity = move_and_slide(vel)
