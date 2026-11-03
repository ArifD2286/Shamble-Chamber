extends CharacterBody2D

# Notes/revision:
# A [ := ] assigns a value to a variable and locks the variable to the data type.
# So instead of declatring the data type explicitly, the game guesses the data type

@onready var shoot_sfx = $"../Shoot"
@onready var reload_sfx = $"../Reload"
@export var bullet_scene: PackedScene
@export var gun: GunData
@export var speed: float = 200.0
var shoot_perm := true
var ammo: int
var is_reloading := false

func _ready() -> void:
	ammo = gun.mag_size

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and shoot_perm and not is_reloading and ammo > 0:
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
	move_and_slide()


func shoot() -> void:
	shoot_perm = false
	ammo -= 1
	shoot_sfx.play()
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
	reload_sfx.play()
	await get_tree().create_timer(gun.reload_time).timeout
	ammo = gun.mag_size
	is_reloading = false
	
