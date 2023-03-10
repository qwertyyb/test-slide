extends RigidBody2D

onready var PointsLabel = get_node("../InfoLayer/PointsLabel")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	PointsLabel.text = "%sm" % ceil(position.x / 100)
