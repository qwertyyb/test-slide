extends KinematicBody2D

signal position_changed(position)
signal died

var sleeping = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const g = Vector2(0, 9.8)		# 重力加速度
var velocity = Vector2(0, 10)		# 初始速度

var _last_collision_body = null

var timer = null

var emitExitedBodyNum = 0
var _rotation_tween

func _physics_process(delta):
	if sleeping:
		return
	emit_signal("position_changed", position)
	print(get_node("Camera2D").get_camera_screen_center())
	print(get_canvas_transform())
	
	var collision = move_and_collide(velocity)
	if collision:
		# 处理速度
		var newVelocity = velocity - velocity.project(-collision.normal)
		var a = g.project(newVelocity.normalized())
		newVelocity = newVelocity + a * delta
		velocity = newVelocity
		
		# 处理旋转
		var target_rotation = PI / 2 + collision.normal.angle()
		if _rotation_tween:
			_rotation_tween.kill()
		_rotation_tween = create_tween()
		_rotation_tween.tween_property(self, "rotation", target_rotation, 0.17)
		_rotation_tween.play()
		
		# 处理碰撞
		_last_collision_body = collision.collider
		emitExitedBodyNum = rand_range(1, 10)
		_on_Player_body_entered(_last_collision_body)
	else:
		# 没有碰撞，计算仅重力作用下的新的速度
		velocity += g * delta

		if _last_collision_body:
			# 如果0.17s(10帧)内没有发生新的碰撞，则认为碰撞已结束
			var curNum = emitExitedBodyNum
			timer = get_tree().create_timer(0.17, false)
			yield(timer, "timeout")
			if curNum == emitExitedBodyNum:
				_on_Player_body_exited(_last_collision_body)
				_last_collision_body = null
				
	velocity.x = min(10, velocity.x)
		
func _unhandled_key_input(event):
	if event.is_action("ui_accept"):
		pass
#		angular_velocity = -6
		
func playerDiedHandler():
	sleeping = true
	$SlideSnowAudio.playing = false
	$SnowTail.visible = false
	if _rotation_tween:
		_rotation_tween.kill()
		_rotation_tween = null
	emit_signal("died")
	
func reborn():
	position = Vector2.ZERO
	velocity = Vector2(0, 10)
	_last_collision_body = null
	sleeping = false
	rotation = 0
	$SnowTail.visible = false

func _on_Player_body_entered(body):
	# 播放音频
	if not $SlideSnowAudio.playing:
		$SlideSnowAudio.playing = true
	
	$SnowTail.visible = true

	# 碰撞时检测角度，如果是背部发生碰撞，则玩家死亡
	if body.has_meta("bodyType"):
		if body.get_meta("bodyType") == "Ground":
			var r = (round(rotation_degrees) as int) % 360
			if r > 90 || r < -90:
				playerDiedHandler()
		elif body.get_meta("bodyType") == "Hole":
			playerDiedHandler()


func _on_Player_body_exited(body):
	if $SlideSnowAudio.playing:
		$SlideSnowAudio.playing = false
	$SnowTail.visible = false
