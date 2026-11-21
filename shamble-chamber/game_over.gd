extends Label


func _process(delta: float) -> void:
	if visible and Input.is_key_pressed(KEY_R):
		get_tree().paused = false
		get_tree().reload_current_scene()
