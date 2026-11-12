extends HBoxContainer

# Notes/revision:
# The reason we use [ get_child ] instead of [ @onready ] is because the player's [ _ready() ]
# runs before the canvaslayer's children finish getting ready,
# if we do this the function works no matter what.

func refresh(guns: Array[GunData], selected: int) -> void:
	for i in get_child_count():
		# the line below gets the amount of children hboxcontainer has, it only gets the panel
		# and not the children of the panel
		var slot := get_child(i)
		var icon: TextureRect = slot.get_node("ItemIcon")
		if guns[i] != null:
			icon.texture = guns[i].gun_texture
		else:
			icon.texture = null
		# [ self_modulate ] only tints that one node 
		slot.self_modulate = Color.WHITE if i == selected else Color(1, 1, 1)
