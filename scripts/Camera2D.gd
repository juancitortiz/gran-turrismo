extends Camera2D

onready var car = get_node("../Car")

func _ready():
	set_process(true)

func _process(_delta):
	$".".position.x = car.position.x
	$".".position.y = car.position.y
