extends Node2D

var Car = preload("res://scripts/Car.gd")
var road_map = Array()

func _ready():
	road_map = $Road.get_used_cells()
	set_road_map_to_car()
		
func set_road_map_to_car():
	for car in get_tree().get_nodes_in_group("cars"):
		if car is Car:
			car.road_map = road_map
