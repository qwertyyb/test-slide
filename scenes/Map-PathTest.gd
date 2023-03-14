extends Path2D

signal points_changed(points)

var leftTopPoint = Vector2.ZERO
var rightBottomPoint = Vector2.ZERO

func addPoints():
	var angleEdge = { "min": 100, "max": 200 }
	var line = { "min": 300, "max": 300 }
	var width = abs(get_viewport_rect().size.x)
	var viewportOrigin = transform.origin - get_viewport_transform().origin
	while(rightBottomPoint.x < viewportOrigin.x + 3 * width):
		var length = curve.get_baked_points().size()
		var lastPoint = curve.get_baked_points()[length - 1]
		var lastSecPoint = curve.get_baked_points()[length - 2]
		var lastDirection = (lastPoint - lastSecPoint).normalized()
		
		if rand_range(0, 1) < 0.4:
			curve.add_point(lastPoint + lastDirection * rand_range(line.min, line.max))
			continue
		
		var cPoint = lastPoint + lastDirection * rand_range(angleEdge.min, angleEdge.max)
		var pMinAngle = 0
		var pMaxAngle = 0
		var pPoint = Vector2.ZERO
		
		if lastDirection.angle() < PI / 6:
			pMinAngle = PI / 6 - lastDirection.angle()
			pMaxAngle = PI / 2 - lastDirection.angle()  - PI / 6
			var finalAngle = rand_range(pMinAngle, pMaxAngle)
			pPoint = cPoint + lastDirection.rotated(finalAngle) * rand_range(angleEdge.min, angleEdge.max)
		else:
			pMinAngle = -lastDirection.angle()
			pMaxAngle = -PI / 6
			var finalAngle = rand_range(pMinAngle, pMaxAngle)
			pPoint = cPoint + lastDirection.rotated(finalAngle) * rand_range(angleEdge.min, angleEdge.max)
	
		rightBottomPoint.x = max(rightBottomPoint.x, pPoint.x)
		rightBottomPoint.y = max(rightBottomPoint.y, pPoint.y)
		
		curve.add_point(pPoint, cPoint - pPoint)
	emitEvent()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	leftTopPoint = curve.get_point_position(0)
	rightBottomPoint = curve.get_point_position(curve.get_point_count() - 1)
	addPoints()

var _lastClearX = 0
func _process(delta):
	var viewportOrigin = transform.origin - get_viewport_transform().origin
	if viewportOrigin.x - _lastClearX > abs(get_viewport_rect().size.x):
		clearOutdatePoints()
		addPoints()
		_lastClearX = viewportOrigin.x

func reset():
	pass

func emitEvent():
	var points = curve.tessellate()

	# 插入右下角、左下角和左上角三个点，使其闭合
	var height = abs(get_viewport_rect().size.x)
	points.append(Vector2(rightBottomPoint.x, rightBottomPoint.y + height))
	points.append(Vector2(leftTopPoint.x, rightBottomPoint.y + height))
	points.append(leftTopPoint)

	emit_signal("points_changed", points)

func clearOutdatePoints():
	var viewportOrigin = transform.origin - get_viewport_transform().origin
	var safeWidth = abs(get_viewport_rect().size.x)
	var minX = viewportOrigin.x - safeWidth
	var i = 0
	while(i < curve.get_point_count() - 1):
		var point = curve.get_point_position(i)
		var nextPoint = curve.get_point_position(i + 1)
		if point.x <= minX && nextPoint.x <= minX:
			curve.remove_point(i)
			i -= 1
		i += 1
	leftTopPoint = curve.get_point_position(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
