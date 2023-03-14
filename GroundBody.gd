extends CollisionPolygon2D

onready var GroundPath = get_node("./GroundPath")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	draw_polygon(polygon, [Color(1, 1, 1)])


func _on_PathTest_points_changed(points):
	polygon = points
