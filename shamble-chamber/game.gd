extends CharacterBody2D

# Notes/revision:
# 

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	look_at(get_global_mouse_position())
	move_and_slide()
