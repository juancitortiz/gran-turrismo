extends Node2D

"""
Info util:
	Aun me falta terminar de definir el concepto. De todas formas, aca encontre
	videos de yutub que vienen al rescate.
	Conceptos clave: RPM, Torque, Gear Ratio, lo q crea necesario

	videos e info gral:
		RPM: 
			"https://en.wikipedia.org/wiki/Revolutions_per_minute"
		Transmision manual: 
			"https://www.youtube.com/watch?v=bgGgH0j0KQE"
		Torque, Horsepower:
			"https://www.youtube.com/watch?v=u-MH4sf5xkY"
			"https://www.youtube.com/watch?v=9ceehhMrIms"
			"https://www.youtube.com/watch?v=MBXpB4bDp_o"
			"https://www.youtube.com/watch?v=gC2-JKO0c2I"
		Gears/ Gear Ratio:
			"https://www.youtube.com/watch?v=8VEc3zhGaro"
			"https://www.youtube.com/watch?v=txQs3x-UN34"
"""
onready var engine = get_parent().get_node("Engine")
var wheels

"""
Acerca de los valores de los radios:
	Los saque de aqui
	"https://www.youtube.com/watch?v=bgGgH0j0KQE"
"""
var gear_ratio = [-3.0, 0.0, 3.0, 2.0, 1.5, 1.0, 0.75, 0.5]
var final_drive_gear_ratio = 3.5
var actual_gear = 1
var torque_differential = 0.0
export (float) var gear_cool_down = 0.0
var is_clutch_connected = true

func _ready():
	pass
	
func _process(delta):
	is_clutch_connected = false if (actual_gear == 1)  else true
	handle_gear_cooldown()
	_handle_transmission_circuit(delta)
	if(wheels):
		wheels[0].calculate_wheel_force(torque_differential)
		wheels[1].calculate_wheel_force(torque_differential)

func handle_gear_cooldown():
	if(gear_cool_down > 0):
		gear_cool_down -= 0.1
	else:
		gear_cool_down = 0.0
		
func gear_up(gear_up):
	if(gear_up and gear_cool_down == 0):
		if(actual_gear < gear_ratio.size() - 1):
			actual_gear += 1
			gear_cool_down = 2.0
			get_parent().is_accelerating = false
			engine.actual_rpm -= 3400

func gear_down(gear_down):
	if(gear_down and gear_cool_down == 0):
		if(actual_gear > 0):
			actual_gear -= 1
			gear_cool_down = 2.0
			get_parent().is_accelerating = false
			engine.actual_rpm -= 2000

func _handle_transmission_circuit(_delta):
	if(is_clutch_connected && engine.is_on):
		"""
		Acerca de este cálculo y demases:
			Este tuto:
			"https://x-engineer.org/automotive-engineering/chassis/vehicle-dynamics/calculate-wheel-torque-engine/"
		"""
		torque_differential = engine.actual_torque * (1/final_drive_gear_ratio) * (1/gear_ratio[actual_gear])
	else:
		torque_differential = lerp(torque_differential, 0, 0.5)
