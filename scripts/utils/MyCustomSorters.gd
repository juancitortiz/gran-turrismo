extends Node

class MyCustomSorters:

	static func sort_laps(a, b) -> bool:
		if a[0] > b[0]:
			return true
		return false

	static func sort_check_points(a, b) -> bool:
		return (a[1] > b[1])
