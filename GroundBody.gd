tool
extends CollisionPolygon2D

onready var GroundPath = get_node("./PathTest")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	polygon = GroundPath.getPoints()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	draw_polygon(polygon, [Color(1, 1, 1)])
