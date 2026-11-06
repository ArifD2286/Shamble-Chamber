extends CharacterBody2D

# Notes/revision:
# A [ := ] assigns a value to a variable and locks the variable to the data type.
# So instead of declatring the data type explicitly, the game guesses the data type

@onready var gun_shoot_sfx: AudioStreamPlayer = $"../Shoot"
@onready var gun_reload_sfx: AudioStreamPlayer = $"../Reload"
@onready var empty_shot_sfx: AudioStreamPlayer = $"../EmptyShot"
@onready var live_ammo = $"../CanvasLayer/Label"
@export var bullet_scene: PackedScene
@export var speed: float = 200.0
@export var slot_guns: Array[GunData] = [null, null, null]
var shoot_perm := true
var ammo: int
var is_reloading := false
var slot_ammo: Array[int] = [0, 0, 0]
var current_slot := 0
var reload_id := 0
var gun: GunData

func _ready() -> void:
	for i in slot_guns.size():
		if slot_guns[i] != null:
			slot_ammo[i] = slot_guns[i].mag_size
	equip(0)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and shoot_perm and not is_reloading and ammo > 0:
		shoot()
	if Input.is_action_pressed("shoot") and shoot_perm and not is_reloading and ammo == 0:
		empty_shot_sfx.play()
	if Input.is_action_just_pressed("reload"):
		reload()
	if Input.is_action_just_pressed("slot_1"):
		equip(0)
	if Input.is_action_just_pressed("slot_2"):
		equip(1)
	if Input.is_action_just_pressed("slot_3"):
		equip(2)
	if is_reloading:
		live_ammo.text = gun.gun_name + " Reloading"
	else:
	# [ %d ] is a placeholder for a whole number and [ %s ] is for text. They get filled in order from
	# the list on the right
		live_ammo.text = "%s %d / %d" % [gun.gun_name, ammo, gun.mag_size]
	move_and_slide()


func shoot() -> void:
	shoot_perm = false
	ammo -= 1
	gun_shoot_sfx.play()
	for i in gun.pallets:
		var bullet = bullet_scene.instantiate()
		# [randf_range()] takes a random number 
		var angle = rotation + deg_to_rad(randf_range(-gun.spread_degrees, gun.spread_degrees))
		bullet.direction = Vector2.RIGHT.rotated(angle)
		bullet.speed = gun.bullet_speed
		bullet.damage = gun.damage
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = $Muzzle.global_position
	await get_tree().create_timer(gun.fire_rate).timeout
	shoot_perm = true



func reload() -> void:
	if is_reloading or ammo == gun.mag_size:
		return
	is_reloading = true
	var my_id := reload_id
	gun_reload_sfx.play()
	await get_tree().create_timer(gun.reload_time).timeout
	if my_id != reload_id:
		return
	ammo = gun.mag_size
	is_reloading = false


func equip(slot: int) -> void:
	if slot_guns[slot] == null:
		return
	# before we swtich the gun, the live ammo from the gun is saved.
	# the [ gun != null ] check is only there for the very first call during startup when there
	# isn't any gun to start with
	if gun != null:
		slot_ammo[current_slot] = ammo
	current_slot = slot
	gun = slot_guns[slot]
	gun_shoot_sfx.stream = gun.shoot_sound
	gun_reload_sfx.stream = gun.reload_sound
	empty_shot_sfx.stream = gun.empty_shot_sound
	ammo = slot_ammo[slot]
	reload_id += 1
	gun_reload_sfx.stop()
	is_reloading = false
