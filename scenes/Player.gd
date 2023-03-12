extends RigidBody2D

signal position_changed(position)
signal died

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	pass

func _physics_process(delta):
	emit_signal("position_changed", position)
		
func _unhandled_key_input(event):
	if event.is_action("ui_accept"):
		angular_velocity = -6
		
func playerDiedHandler():
	sleeping = true
	mode = MODE_STATIC
	$SlideSnowAudio.playing = false
	$SnowTail.visible = false
	emit_signal("died")
	
func reborn():
	position = Vector2.ZERO
	mode = MODE_RIGID
	sleeping = false
	rotation = 0
	$SnowTail.visible = false

func _on_Player_body_entered(body):
	# 播放音频
	if not $SlideSnowAudio.playing:
		$SlideSnowAudio.playing = true
	
#	$SnowTail.visible = true

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
