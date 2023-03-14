extends Path2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func addPoints():
	var minLength = 100
	var maxLength = 200
	for i in range(30):
		var length = curve.get_baked_points().size()
		var lastPoint = curve.get_baked_points()[length - 1]
		var lastSecPoint = curve.get_baked_points()[length - 2]
		var lastDirection = (lastPoint - lastSecPoint).normalized()
		
		var cPoint = lastPoint + lastDirection * rand_range(minLength, maxLength)
		if rand_range(0, 1) < 0.5:
			curve.add_point(lastPoint + lastDirection * rand_range(minLength, maxLength) * rand_range(3, 8))
			continue

		var pMinAngle = 0
		var pMaxAngle = 0
		var pPoint = Vector2.ZERO
		
		if lastDirection.angle() < PI / 6:
			pMinAngle = PI / 6 - lastDirection.angle()
			pMaxAngle = PI / 2 - lastDirection.angle()  - PI / 6
			var finalAngle = rand_range(pMinAngle, pMaxAngle)
			pPoint = cPoint + lastDirection.rotated(finalAngle) * rand_range(minLength, maxLength)
		else:
			pMinAngle = -lastDirection.angle()
			pMaxAngle = -PI / 6
			var finalAngle = rand_range(pMinAngle, pMaxAngle)
			pPoint = cPoint + lastDirection.rotated(pMinAngle) * rand_range(minLength, maxLength)
		
		curve.add_point(pPoint, cPoint - pPoint)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	addPoints()
	

func getPoints():
	var points = curve.tessellate()
	
	var maxPoint = Vector2.ZERO
	var minPoint = Vector2.ZERO
	for i in range(points.size()):
		maxPoint.x = max(maxPoint.x, points[i].x)
		maxPoint.y = max(maxPoint.y, points[i].y)
		
		minPoint.x = min(minPoint.x, points[i].x)
		minPoint.y = min(minPoint.y, points[i].y)
	
	points.append(Vector2(maxPoint.x, maxPoint.y + 500))
	points.append(Vector2(minPoint.x, maxPoint.y + 500))
	points.append(minPoint)
	return points
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
