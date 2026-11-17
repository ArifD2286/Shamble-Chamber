extends Label

# Notes/revision:
# do i even need this? ;_;
# yes i do
# [ create_tween() ] creates a smooth change in property from one value to another
# [ tween_property(node, property, end value, seconds) ] is one animation


func _ready() -> void:
	add_theme_color_override("font_color", Color.RED)
	add_theme_color_override("font_outline_color", Color.hex(454545))
	add_theme_constant_override("outline_size", 4)
	add_theme_font_size_override("font_size", 20)
	modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	# [ "modulate:a" ] means only the opacity (a = alpha) modulate
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.7).set_delay(0.3)
	# [ .as_relative() ] treats -40.0 as 40 pixels up from where it is initially.
	tween.tween_property(self, "position:y", -40.0, 1.0).as_relative()
	# line below just deletes the the label when animation is finished
	tween.finished.connect(queue_free)
