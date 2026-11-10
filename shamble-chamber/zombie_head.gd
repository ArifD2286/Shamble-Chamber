extends Node2D

# Notes/revision:


func _ready() -> void:
	add_to_group("zombie")


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("000000"))
	draw_circle(Vector2.ZERO, 15.0, Color("5D7152"))
