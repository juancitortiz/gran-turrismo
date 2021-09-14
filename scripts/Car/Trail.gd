extends Line2D

var point

func _ready():
	#set_as_toplevel(true)
	pass

func _physics_process(_delta):
	point = get_parent().global_position
	add_point(point)
	if point.length() > 100:
		remove_point(0)
