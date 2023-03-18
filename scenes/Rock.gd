extends StaticBody2D

func _ready():
	set_meta("bodyType", "rock")

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
