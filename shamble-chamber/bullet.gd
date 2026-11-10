extends Area2D

# Notes/revision:


var speed: float = 1000.0
var damage: int = 10
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	# Line below deletes the bullet after 1 second
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	# The line below makes an exception for the player's Col.shape2d so that the bullet never despawns incase
	# it touches the player's Col.shape2d (prob impossible but hey be prepared lol)
	if body.is_in_group("player"):
		return
	queue_free()
