extends Path2D

func _ready():
	print("(LapSystem) Curve point count: ",curve.get_point_count())
	for i in range(0, curve.get_point_count()):
		print("(LapSystem) Curve point pos: ",curve.get_point_position(i))

func get_next_point(current_pos):
	return curve.get_closest_point(current_pos)

