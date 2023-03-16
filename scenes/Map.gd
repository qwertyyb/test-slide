extends Node2D


func reset():
	$Ground/GroundBody/GroundPath.reset()
	
func stop():
	$Ground/GroundBody/GroundPath.stop()
