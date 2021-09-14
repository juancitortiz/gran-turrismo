extends Node2D

var actual_rpm = 0
export (int) var engine_power = 500
export (int) var max_rpm = 6000
export (int) var min_rpm = 1000
var rpm_refs = [1000, 1300, 1700, 2200, 2700, 3300, 3800, 4300, 4800, 5200, 6000]
var torque_refs = [116, 135, 148, 157, 165, 172, 178, 184, 188, 183, 171]
var actual_torque = 0.0
export (float) var fleewheel = 0.01

export (bool) var is_on = true

func _ready():
	actual_rpm = 0
	actual_torque = 0.0
	
func _process(_delta):
	if is_on:
		actual_torque = _calculate_current_torque()
	else:
		_desaccelerate()

func _calculate_current_torque():
	var result = 0.0
	if(actual_rpm <= 0):
		pass
	elif(actual_rpm <= rpm_refs[0]):
		result = (torque_refs[0] * actual_rpm) / rpm_refs[0]
	else:
		for x in range(1, rpm_refs.size()):
			if(x == rpm_refs.size() - 1):
				result = torque_refs[x]
				break
			if(actual_rpm <= rpm_refs[x]):
				result = (torque_refs[x] * actual_rpm) / rpm_refs[x]
				break
		
	return result

func handle_accelerate(is_accelerating):
	if(is_on):
		if(is_accelerating):
			_accelerate()
		else:
			_desaccelerate()
		
func _accelerate():
	if(actual_rpm < max_rpm):
		actual_rpm = lerp(actual_rpm, max_rpm, fleewheel)
	else:
		actual_rpm = max_rpm
		actual_rpm -= 50
		
func _desaccelerate():
	if(!is_on):
		if(actual_rpm > 0):
			actual_rpm -= 100
		else:
			actual_rpm = 0
	else:
		if(actual_rpm > min_rpm):
			actual_rpm -= 100
		else:
			actual_rpm = min_rpm
			actual_rpm += 50
