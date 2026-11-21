extends CharacterBody2D

# Notes/revision:
# If we have a function with something in the brackets, ex: [ func _physics_process(delta: float) ]
# the [ delta ] is the name whilst [ : class_name ] is the type it is. It is known as 
# the parameter list and they are the values a function needs when something calls it.
# [ -> void ] after the brackets is the return type, void literally means nothing so if ex we have
# [ -> int ] we would get return (integer data type)

@export var data: ZombieData
@onready var nav: NavigationAgent2D = $NavigationAgent2D
var player: Node2D
var health: int
var speed: float
var attack_timer := 0.0
const damage_number = preload("res://damage_number.tscn")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	add_to_group("zombie")
	speed = data.speed
	health = data.health
	modulate = data.tint
	scale = Vector2.ONE * data.size


func _physics_process(delta: float) -> void:
	nav.target_position = player.global_position
	# [ get_next_path_position() ] returns the next corner on the route,
	# it is then used in the zombie's velocity for the direction when walking
	# and act as the route to the player.
	var next_point := nav.get_next_path_position()
	velocity = global_position.direction_to(next_point) * speed
	look_at(next_point)
	move_and_slide()
	# [ get_slide_collision_count() ] counts how many things the zombie
	# had bumped into
	attack_timer -= delta
	for i in get_slide_collision_count():
		var hit: Node = get_slide_collision(i).get_collider()
		if hit.is_in_group("player") and attack_timer <= 0.0:
			hit.take_damage(data.damage)
			attack_timer = data.attack_cooldown


func take_damage(amount: int) -> void:
	health -= amount
	var num := damage_number.instantiate()
	num.text = str(amount)
	get_tree().current_scene.add_child(num)
	num.global_position = global_position + Vector2(randf_range(-20, 20), -30)
	if health <= 0:
		queue_free()
