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

func _physics_process(delta):
	if sleeping:
		return
	emit_signal("position_changed", position)
	
	var collision = move_and_collide(velocity)
	if collision:
		var newVelocity = velocity - velocity.project(-collision.normal)
		var a = g.project(newVelocity.normalized())
		newVelocity = newVelocity + a * delta
		velocity = newVelocity
		rotation = PI / 2 + collision.normal.angle()
		_last_collision_body = collision.collider
		emitExitedBodyNum = rand_range(1, 10)
		_on_Player_body_entered(_last_collision_body)
	else:
		velocity += g * delta
		if _last_collision_body:
			var curNum = emitExitedBodyNum
			timer = get_tree().create_timer(0.2, false)
			yield(timer, "timeout")
			if curNum == emitExitedBodyNum:
				_on_Player_body_exited(_last_collision_body)
				_last_collision_body = null
		
		
func _unhandled_key_input(event):
	if event.is_action("ui_accept"):
		pass
#		angular_velocity = -6
		
func playerDiedHandler():
	sleeping = true
	$SlideSnowAudio.playing = false
	$SnowTail.visible = false
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
