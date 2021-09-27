extends Control

func _ready():
	pass

func _on_Main_update_stats(laps, position, speed, rpm, gear):
	$CanvasLayer/LapsLabel.text = "Laps: " + laps
	$CanvasLayer/CarPosLabel.text = "Position: " + position
	$CanvasLayer/SpeedLabel.text = "Speed: " + speed
	$CanvasLayer/RPMLabel.text = "RPM: " + rpm
	$CanvasLayer/GearLabel.text = "GEAR: " + gear

func _on_Main_update_finish_race(visible, msg):
	$CanvasLayer/WonMessageLabel.set_visible(visible)
	$CanvasLayer/WonMessageLabel.text = msg
