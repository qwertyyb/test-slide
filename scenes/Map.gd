extends Node2D

var RockScene = preload("res://scenes/Rock.tscn")

func reset():
	$Ground/GroundBody/GroundPath.reset()
	
func stop():
	$Ground/GroundBody/GroundPath.stop()


func _on_GroundPath_rock_position_created(position, rotation):
	var rock = RockScene.instance()
	add_child(rock)
	rock.position = position
	rock.rotation = rotation
