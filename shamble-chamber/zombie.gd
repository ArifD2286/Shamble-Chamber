extends CharacterBody2D

# Notes/revision:


@export var speed: float = 100.0
@onready var nav: NavigationAgent2D = $NavigationAgent2D
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	nav.target_position = player.global_position
	# [ get_next_path_position() ] returns the next corner on the route,
	# it is then used in the zombie's velocity for the direction when walking
	# and act as the route to the player.
	var next_point := nav.get_next_path_position()
	velocity = global_position.direction_to(next_point) * speed
	look_at(next_point)
	move_and_slide()
