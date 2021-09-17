#extends Line2D
extends Node2D

var point
var points = []

func _ready():
	set_as_toplevel(true)

func _physics_process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	point = get_parent().global_position
	points.append(point)
	if point.length() > 100:
		points.remove(0)
	update()
	

func _draw():
	if(points.size() > 1):
		for x in range(points.size()-1):
			draw_line(points[x] ,points[x+1], Color.black, 10)
