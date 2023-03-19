extends Node2D

var RockScene = preload("res://scenes/Rock.tscn")

func _removeAllRocks():
	for node in get_tree().get_nodes_in_group("rocks"):
		node.get_parent().remove_child(node)
		node.queue_free()

func reset():
	_removeAllRocks()
	$Ground/GroundBody/GroundPath.reset()
	
func stop():
	$Ground/GroundBody/GroundPath.stop()


func _on_GroundPath_rock_position_created(position, rotation):
	var rock = RockScene.instance()
	add_child(rock)
	rock.position = position
	rock.rotation = rotation
