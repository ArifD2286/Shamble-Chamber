extends Node2D

# Notes/revision:


@export var zombie_scene: PackedScene
@export var amt_per_rounds: int = 8
@export var max_zombies: int = 24
@export var zombie_types: Array[ZombieData]
@onready var spawn_points: Array[Node] = $SpawnPoints.get_children()

func _on_timer_timeout() -> void:
	for i in amt_per_rounds:
		if get_tree().get_nodes_in_group("zombie").size() >= max_zombies:
			return
		var zombie := zombie_scene.instantiate()
		zombie.data = zombie_types.pick_random()
		add_child(zombie)
		zombie.global_position = spawn_points.pick_random().global_position
		# the line below makes a cooldown between each zombie so that they don't 
		# stack and get stuck in each other
		await get_tree().create_timer(0.5).timeout
